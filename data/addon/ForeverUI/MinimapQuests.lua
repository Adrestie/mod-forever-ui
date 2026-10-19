-- Tracked quests on the minimap: 3.3.5 shows none (quest POIs reached the minimap in 4.0).
-- For each tracked quest with a POI on the player's map: its POI (the tracker's number or ?)
-- on the minimap while in range, else an arrow on the minimap's edge pointing at it; and its
-- area (the world map's blue quest blob). Hovering an area, a POI or an arrow shows the quest's
-- progress,
-- as the world map does (WorldMapQuestPOI_SetTooltip).
-- Positions: the client gives map fractions (GetPlayerMapPosition, QuestPOIGetIconInfo, both on
-- the map the world map shows, the player's when it is closed); MapSizes.lua turns them into
-- yards, and the minimap's zoom into yards per minimap unit.
-- Areas: a QuestPOIFrame draws the blobs of the shown map over its whole rectangle, and in game
-- neither a ScrollFrame (the area was squeezed into the visible part) nor its texture's
-- coordinates (the area drew past the minimap) crop it. So it is not shown: an invisible one holds
-- the tracked quests' blobs and answers, point by point, whether a point of the map is in one
-- (UpdateMouseOverTooltip, the world map's hover test). A grid of cells over the round minimap
-- shows those inside, in the world map's colours (WorldMapBlobFrame_OnLoad: UI-QuestBlob-Inside,
-- a plain blue, at fill alpha 128; UI-QuestBlob-Outside, a lighter blue rim, at 192). Cells on an
-- area's edge are read again in four, and the rim is drawn on those quarters: the edge follows
-- the area twice as finely, and the minimap's own edge, where an area is only cut, has no rim.
-- The areas show only inside the circle, as the player comes near them, and turn with the
-- minimap.

local Q = {}
ForeverUI.MinimapQuests = Q

local wipe = table.wipe or wipe or function(t) for k in pairs(t) do t[k] = nil end return t end
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end

-- Minimap diameter in yards by zoom (0 to 5), outdoors and indoors (the client's fixed values)
local OUTDOOR = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 }
local INDOOR = { [0] = 300, 240, 180, 120, 80, 50 }

local GRID = 28                  -- cells across the minimap's diameter (each in four on an edge)
local FILL = { 56 / 255, 108 / 255, 248 / 255, 128 / 255 }    -- UI-QuestBlob-Inside, fill alpha
local RIM = { 101 / 255, 185 / 255, 248 / 255, 192 / 255 }    -- UI-QuestBlob-Outside, border alpha
local AREA_WAIT = 0.1            -- the grid is read again at most ten times a second
local PROBE_ALPHA = 1            -- out of 255
local AREA_IDLE = 0.5            -- and twice a second without moving
local POI_SCALE = 0.5            -- QuestPOITemplate is 32 x 32
local POI_INSET = 6              -- a POI closer than this to the edge becomes an arrow
local ARROW_SIZE = 18
local ARROW_RADIUS_INSET = 7
local ARROW_TEXTURE = "Interface\\Minimap\\ROTATING-MINIMAPGUIDEARROW"
local HOVER_RADIUS = 7           -- a POI or an arrow under the cursor, in minimap units
local PARENT = "ForeverUIMinimapQuests"

local holder, probe, arrows = nil, nil, {}
local cells = {}                 -- { texture, x, y, row, col }, x and y from the minimap's center
local quarters = {}              -- textures of the quarter cells, made as needed
local cellSide
-- POI buttons shown on the minimap: hidden here, not by QuestPOI_HideAllButtons, which errors on
-- a number never created (a POI out of range leaves its number unshown)
local shownPOIs, keptPOIs = {}, {}

local function hidePOIs(keep)
	for b in pairs(shownPOIs) do
		if not (keep and keep[b]) then
			b:Hide()
			shownPOIs[b] = nil
		end
	end
end
local markers = {}               -- { questId, questIndex, type, index, x, y, complete }
local indoors = false
local drawnKey

local function minimapReady()
	return Minimap and Minimap.GetZoom and Minimap:GetWidth() and Minimap:GetWidth() > 0
end

-- The map shown (the player's while the world map is closed) and its size in yards
local function mapSize()
	local sizes = ForeverUI.MapSizes
	local id = GetCurrentMapAreaID and GetCurrentMapAreaID()
	local s = sizes and id and sizes[id]
	if s and s.floors then
		s = s.floors[(GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel()) or 1]
	end
	return s and s[1], s and s[2]
end

-- Indoors or out: the minimap keeps one zoom for each (CVars minimapZoom and
-- minimapInsideZoom) and uses the one of where the player is. When both are equal the zoom is
-- moved one step and back to tell them apart.
local reading = false
local function readIndoors()
	if reading or not (GetCVar and Minimap.SetZoom) then return end
	local zoom = Minimap:GetZoom()
	local outside, inside = tonumber(GetCVar("minimapZoom")), tonumber(GetCVar("minimapInsideZoom"))
	if outside ~= inside then
		indoors = inside == zoom
		return
	end
	-- the zoom moves and back: its MINIMAP_UPDATE_ZOOM events are ignored meanwhile
	reading = true
	local step = zoom < 5 and 1 or -1
	Minimap:SetZoom(zoom + step)
	indoors = tonumber(GetCVar("minimapInsideZoom")) == Minimap:GetZoom()
	Minimap:SetZoom(zoom)
	reading = false
end

-- Minimap units per yard: the diameters are those of the minimap's 140 units, whatever its scale
local function unitsPerYard()
	local diameter = (indoors and INDOOR or OUTDOOR)[Minimap:GetZoom() or 0] or OUTDOOR[0]
	return Minimap:GetWidth() / diameter
end

local function rotating()
	return GetCVar and GetCVar("rotateMinimap") == "1"
end

-- Turns a texture's image by angle (radians, counterclockwise) around its center
local function rotateTexture(t, angle)
	local c, s = math.cos(angle), math.sin(angle)
	local function p(x, y)
		return 0.5 + x * c - y * s, 0.5 + x * s + y * c
	end
	local ulx, uly = p(-0.5, -0.5)
	local llx, lly = p(-0.5, 0.5)
	local urx, ury = p(0.5, -0.5)
	local lrx, lry = p(0.5, 0.5)
	t:SetTexCoord(ulx, uly, llx, lly, urx, ury, lrx, lry)
end

-- ---------------------------------------------------------------- frames

local function build()
	if holder or not minimapReady() then return holder end
	holder = CreateFrame("Frame", PARENT, Minimap)
	holder:SetAllPoints(Minimap)
	holder:SetFrameLevel(Minimap:GetFrameLevel() + 2)

	-- The probe: an invisible QuestPOIFrame (made from Lua; without it, no areas: the POIs and
	-- arrows stay)
	local ok, frame = pcall(CreateFrame, "QuestPOIFrame", nil, holder)
	if ok and frame then
		-- drawn, but too faint to see: the engine lays its areas out at the frame's size and may
		-- skip what it does not draw (placed on the map's rectangle in update). The frame's alpha
		-- does not reach the areas: their own alphas (0 to 255) do.
		probe = frame
		if probe.SetFillTexture then
			probe:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside")
			probe:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside")
			probe:SetFillAlpha(PROBE_ALPHA)
			probe:SetBorderAlpha(PROBE_ALPHA)
		end
	end

	-- The cells: a grid over the minimap, only those inside its circle
	local radius = Minimap:GetWidth() / 2
	local side = Minimap:GetWidth() / GRID
	cellSide = side
	for row = 1, GRID do
		for col = 1, GRID do
			local x, y = -radius + (col - 0.5) * side, radius - (row - 0.5) * side
			if x * x + y * y <= (radius - side / 2) ^ 2 then
				local cell = holder:CreateTexture(nil, "BORDER")
				cell:SetWidth(side)
				cell:SetHeight(side)
				cell:SetPoint("CENTER", holder, "CENTER", x, y)
				cell:Hide()
				cells[#cells + 1] = { texture = cell, x = x, y = y, row = row, col = col }
			end
		end
	end
	return holder
end

local function arrow(i)
	local a = arrows[i]
	if not a then
		a = holder:CreateTexture(nil, "OVERLAY")
		a:SetTexture(ARROW_TEXTURE)
		a:SetWidth(ARROW_SIZE)
		a:SetHeight(ARROW_SIZE)
		arrows[i] = a
	end
	return a
end

-- ---------------------------------------------------------------- the quests

-- The tracked quests on the shown map, with the tracker's numbers: the objective tracker
-- (ObjectiveTracker.lua) numbers its POIs as WatchFrame does, in WatchFrameLines
local function collect(readAgain)
	wipe(markers)
	if not (QuestPOIGetIconInfo and GetQuestIndexForWatch) then return end
	-- the POIs as they are now: an objective done moves its quest's POI, a quest done turns it
	-- into its turn-in (WatchFrame_GetCurrentMapQuests does the same before reading them)
	-- Not on QUEST_POI_UPDATE or WORLD_MAP_UPDATE: reading them again may fire those.
	if readAgain then
		if QuestMapUpdateAllQuests then QuestMapUpdateAllQuests() end
		if QuestPOIUpdateIcons then QuestPOIUpdateIcons() end
	end
	for i = 1, (GetNumQuestWatches and GetNumQuestWatches()) or 0 do
		local index = GetQuestIndexForWatch(i)
		if index then
			local _, _, _, _, _, _, isComplete, _, questId = GetQuestLogTitle(index)
			local _, x, y = QuestPOIGetIconInfo(questId)
			if questId and x and y and (not CURRENT_MAP_QUESTS or CURRENT_MAP_QUESTS[questId]) then
				markers[#markers + 1] = { questId = questId, questIndex = index, x = x, y = y,
					complete = isComplete and isComplete > 0 }
			end
		end
	end
	-- the tracker's number, else one in watch order
	local numbered, inside = 0, 0
	for _, m in ipairs(markers) do
		if m.complete then
			inside = inside + 1
			m.type, m.index = QUEST_POI_COMPLETE_IN, inside
		else
			numbered = numbered + 1
			m.type, m.index = QUEST_POI_NUMERIC, numbered
		end
		for _, t in ipairs({ QUEST_POI_NUMERIC, QUEST_POI_COMPLETE_IN }) do
			for n = 1, 25 do
				local b = _G["poiWatchFrameLines" .. t .. "_" .. n]
				if not b then break end
				if b:IsShown() and b.questId == m.questId then
					m.type, m.index = t, n
				end
			end
		end
	end
end

-- The probe's blobs, drawn again when the quests or the map change
local areaKey
local function drawBlobs(key)
	if key == drawnKey or not probe then return end
	drawnKey = key
	areaKey = nil
	if probe.DrawNone then probe:DrawNone() end
	for _, m in ipairs(markers) do
		if not m.complete and probe.DrawQuestBlob then
			probe:DrawQuestBlob(m.questId, true)
		end
	end
end

-- A point of the minimap (units from its center, y up) on the shown map (fractions), the
-- minimap's turn undone
local function toMap(ux, uy, v)
	if v.rotate then
		ux, uy = ux * v.c - uy * v.s, ux * v.s + uy * v.c
	end
	return v.px + ux / (v.w * v.k), v.py - uy / (v.h * v.k)
end

-- The quest whose area holds a point of the map, or nil
local function areaAt(fx, fy)
	if not (probe and probe.UpdateMouseOverTooltip) or fx < 0 or fx > 1 or fy < 0 or fy > 1 then
		return nil
	end
	local index = probe:UpdateMouseOverTooltip(fx, fy)
	return index
end

-- The grid. Each cell is read at its center; a cell whose four neighbours do not all agree is on
-- an edge and is read again in four quarters (half rows and columns, "fine" coordinates). A cell
-- or quarter inside an area shows in the fill colour; a quarter inside with a quarter outside next
-- to it shows the rim. Past the minimap's circle counts as inside: no rim where an area is cut.
local inside, fine = {}, {}
local areaWait, areaIdle = 0, 0
local function key(row, col) return row * 1000 + col end

local function quarter(i)
	local q = quarters[i]
	if not q then
		q = holder:CreateTexture(nil, "BORDER")
		q:SetWidth(cellSide / 2)
		q:SetHeight(cellSide / 2)
		quarters[i] = q
	end
	return q
end

local function paint(texture, color)
	texture:SetTexture(color[1], color[2], color[3], color[4])
	texture:Show()
end

local function showAreas(v, elapsed)
	-- Read again when the view moves (ten times a second at most) and twice a second anyway: the
	-- engine lays areas out when it draws, so right after DrawQuestBlob the probe finds none yet
	areaWait = areaWait - (elapsed or AREA_WAIT)
	areaIdle = areaIdle - (elapsed or AREA_IDLE)
	local k = string.format("%s:%.4f:%.4f:%.2f:%.3f", tostring(drawnKey), v.px, v.py, v.rotate and v.facing or 0, v.k)
	if areaWait > 0 or (k == areaKey and areaIdle > 0) then return end
	areaKey, areaWait, areaIdle = k, AREA_WAIT, AREA_IDLE

	wipe(inside)
	wipe(fine)
	local present = {}
	for _, cell in ipairs(cells) do
		present[key(cell.row, cell.col)] = true
		inside[key(cell.row, cell.col)] = areaAt(toMap(cell.x, cell.y, v)) ~= nil
	end
	local function cellIn(r, c)
		local id = key(r, c)
		if not present[id] then return nil end
		return inside[id]
	end
	-- a quarter: fine row and column, 1 to 2 x GRID
	local function fineIn(fr, fc)
		local r, c = math.ceil(fr / 2), math.ceil(fc / 2)
		local id = key(r, c)
		if not present[id] then return true end          -- past the circle: no rim
		local f = fine[key(fr, fc)]
		if f ~= nil then return f end
		return inside[id]
	end

	local used = 0
	local any = false
	local half = cellSide / 2
	for _, cell in ipairs(cells) do
		local r, c = cell.row, cell.col
		local here = inside[key(r, c)]
		local edge = false
		for _, n in ipairs({ { r - 1, c }, { r + 1, c }, { r, c - 1 }, { r, c + 1 } }) do
			local there = cellIn(n[1], n[2])
			if there ~= nil and there ~= here then edge = true end
		end
		cell.edge = edge
		if edge then
			cell.texture:Hide()
			for dr = 0, 1 do
				for dc = 0, 1 do
					local qx, qy = cell.x + (dc - 0.5) * half, cell.y - (dr - 0.5) * half
					fine[key(2 * r - 1 + dr, 2 * c - 1 + dc)] = areaAt(toMap(qx, qy, v)) ~= nil
				end
			end
		elseif here then
			any = true
			paint(cell.texture, FILL)
		else
			cell.texture:Hide()
		end
	end
	-- the quarters of the edge cells
	for _, cell in ipairs(cells) do
		if cell.edge then
			local r, c = cell.row, cell.col
			for dr = 0, 1 do
				for dc = 0, 1 do
					local fr, fc = 2 * r - 1 + dr, 2 * c - 1 + dc
					if fine[key(fr, fc)] then
						any = true
						used = used + 1
						local q = quarter(used)
						q:ClearAllPoints()
						q:SetPoint("CENTER", holder, "CENTER", cell.x + (dc - 0.5) * half, cell.y - (dr - 0.5) * half)
						local rim = not (fineIn(fr - 1, fc) and fineIn(fr + 1, fc) and fineIn(fr, fc - 1) and fineIn(fr, fc + 1))
						paint(q, rim and RIM or FILL)
					end
				end
			end
		end
	end
	for i = used + 1, #quarters do quarters[i]:Hide() end
	Q.areaCells = any
end

local function hideAll()
	if not holder then return end
	holder:Hide()
	for _, a in ipairs(arrows) do a:Hide() end
	for _, cell in ipairs(cells) do cell.texture:Hide() end
	for _, q in ipairs(quarters) do q:Hide() end
	areaKey = nil
	hidePOIs()
end

-- ---------------------------------------------------------------- each frame

local function update(elapsed)
	if not build() then return end
	local px, py = GetPlayerMapPosition("player")
	local w, h = mapSize()
	if not px or (px == 0 and py == 0) or not w or #markers == 0 then
		hideAll()
		return
	end
	holder:Show()
	local k = unitsPerYard()
	local radius = Minimap:GetWidth() / 2
	local rotate = rotating()
	local facing = rotate and GetPlayerFacing and GetPlayerFacing() or 0
	local c, s = math.cos(facing), math.sin(facing)

	-- POIs and arrows
	wipe(keptPOIs)
	local shownArrows = 0
	for _, m in ipairs(markers) do
		-- map y grows southward; minimap y grows up
		local sx, sy = (m.x - px) * w * k, -(m.y - py) * h * k
		if rotate then
			sx, sy = sx * c + sy * s, -sx * s + sy * c
		end
		local d = math.sqrt(sx * sx + sy * sy)
		m.sx, m.sy, m.inRange = sx, sy, d <= radius - POI_INSET
		if m.inRange then
			local b = QuestPOI_DisplayButton(PARENT, m.type, m.index, m.questId)
			b:SetScale(POI_SCALE)
			b:EnableMouse(false)
			b:ClearAllPoints()
			b:SetPoint("CENTER", holder, "CENTER", sx / POI_SCALE, sy / POI_SCALE)
			shownPOIs[b], keptPOIs[b] = true, true
		else
			shownArrows = shownArrows + 1
			local a = arrow(shownArrows)
			local r = radius - ARROW_RADIUS_INSET
			m.ax, m.ay = sx / d * r, sy / d * r
			a:ClearAllPoints()
			a:SetPoint("CENTER", holder, "CENTER", m.ax, m.ay)
			-- the image points up: turned to the POI's direction
			rotateTexture(a, atan2(sy, sx) - math.pi / 2)
			a:Show()
		end
	end
	for i = shownArrows + 1, #arrows do arrows[i]:Hide() end
	hidePOIs(keptPOIs)

	-- the probe on the map's rectangle at the minimap's scale, its corner placed from the player
	if probe then
		local mw, mh = w * k, h * k
		probe:SetWidth(mw)
		probe:SetHeight(mh)
		probe:ClearAllPoints()
		probe:SetPoint("TOPLEFT", holder, "CENTER", -px * mw, py * mh)
	end
	Q.view = { px = px, py = py, w = w, h = h, k = k, rotate = rotate, facing = facing, c = c, s = s }
	showAreas(Q.view, elapsed)
end

-- ---------------------------------------------------------------- tooltip

local owned = false

-- WorldMapQuestPOI_SetTooltip, on GameTooltip: the title, then what is left to do
local function questTooltip(m, blob)
	local index = m.questIndex
	GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR")
	GameTooltip:SetText((GetQuestLogTitle(index)))
	if m.complete then
		GameTooltip:AddLine("- " .. (GetQuestLogCompletionText(index) or ""), 1, 1, 1, 1)
	else
		local drops = GetNumQuestItemDrops and GetNumQuestItemDrops(index)
		if drops and drops > 0 then
			for i = 1, drops do
				local text, _, finished = GetQuestLogItemDrop(i, index)
				if text and not finished then
					GameTooltip:AddLine("- " .. WorldMapFrame_ReverseQuestObjective(text), 1, 1, 1, 1)
				end
			end
		else
			local count = GetNumQuestLeaderBoards(index)
			local poiTips = blob and blob.GetNumTooltips and blob:GetNumTooltips()
			for i = 1, count do
				local text, _, finished
				if poiTips and poiTips == count and GetQuestPOILeaderBoard then
					text, _, finished = GetQuestPOILeaderBoard(blob:GetTooltipIndex(i), index)
				else
					text, _, finished = GetQuestLogLeaderBoard(i, index)
				end
				if text and not finished then
					GameTooltip:AddLine("- " .. WorldMapFrame_ReverseQuestObjective(text), 1, 1, 1, 1)
				end
			end
		end
	end
	GameTooltip:Show()
	owned = true
end

local function hover()
	if not (holder and holder:IsShown() and Q.view and Minimap:IsMouseOver()) then
		if owned then
			owned = false
			if GameTooltip:GetOwner() == Minimap then GameTooltip:Hide() end
		end
		return
	end
	local x, y = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	local cx, cy = Minimap:GetCenter()
	local ux, uy = x / scale - cx, y / scale - cy
	-- a POI or an arrow under the cursor
	for _, m in ipairs(markers) do
		local x, y = m.sx, m.sy
		if not m.inRange then x, y = m.ax, m.ay end
		if x and (x - ux) ^ 2 + (y - uy) ^ 2 <= HOVER_RADIUS ^ 2 then
			questTooltip(m)
			return
		end
	end
	-- an area: the probe answers for the point of the map under the cursor
	local radius = Minimap:GetWidth() / 2
	if ux * ux + uy * uy <= radius * radius then
		local index = areaAt(toMap(ux, uy, Q.view))
		if index then
			for _, m in ipairs(markers) do
				if m.questIndex == index then
					questTooltip(m, probe)
					return
				end
			end
		end
	end
	if owned then
		owned = false
		if GameTooltip:GetOwner() == Minimap then GameTooltip:Hide() end
	end
end

-- ---------------------------------------------------------------- events

local function refresh(readAgain)
	collect(readAgain)
	local key = {}
	for _, m in ipairs(markers) do key[#key + 1] = m.questId .. (m.complete and "c" or "") end
	drawBlobs((GetCurrentMapAreaID and GetCurrentMapAreaID() or 0) .. ":" ..
		((GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel()) or 0) .. ":" .. table.concat(key, ","))
	update()
end
Q.refresh = refresh

-- the grid read again on the next update, whatever moved
Q.redrawAreas = function() areaKey = nil end
Q.update = update

local watcher = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE", "QUEST_POI_UPDATE",
	"WORLD_MAP_UPDATE", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA",
	"MINIMAP_UPDATE_ZOOM", "CVAR_UPDATE" }) do
	watcher:RegisterEvent(event)
end
watcher:SetScript("OnEvent", function(_, event)
	if reading or not minimapReady() then return end
	if event ~= "QUEST_LOG_UPDATE" and event ~= "QUEST_POI_UPDATE" and event ~= "WORLD_MAP_UPDATE" then
		readIndoors()
	end
	-- the map of the player's zone while the world map is closed (WatchFrame does the same)
	if event == "ZONE_CHANGED_NEW_AREA" and WorldMapFrame and not WorldMapFrame:IsShown()
		and SetMapToCurrentZone then
		SetMapToCurrentZone()
	end
	refresh(event == "QUEST_LOG_UPDATE")
end)

-- Quest watches change without an event of their own
if hooksecurefunc then
	for _, name in ipairs({ "AddQuestWatch", "RemoveQuestWatch" }) do
		if _G[name] then hooksecurefunc(name, function() if minimapReady() then refresh() end end) end
	end
end

-- Once a second the quests are read again: the client does not always say when a POI moves
local RECHECK = 1
local wait = RECHECK
watcher:SetScript("OnUpdate", function(_, elapsed)
	wait = wait - elapsed
	if wait <= 0 then
		wait = RECHECK
		if minimapReady() and (#markers > 0 or (GetNumQuestWatches and GetNumQuestWatches() > 0)) then
			refresh(true)
		end
	end
	if #markers > 0 then
		update(elapsed)
		hover()
	end
end)
Q.watcher = watcher
