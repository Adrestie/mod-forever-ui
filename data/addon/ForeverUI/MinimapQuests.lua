-- Tracked quests on the minimap: 3.3.5 shows none (quest POIs reached the minimap in 4.0).
-- For each tracked quest with a POI on the player's map: its POI (the tracker's number or ?)
-- on the minimap while in range, else an arrow on the minimap's edge pointing at it; and its
-- area (the world map's blue quest blob). Hovering an area, a POI or an arrow shows the quest's
-- progress,
-- as the world map does (WorldMapQuestPOI_SetTooltip).
-- Positions: the client gives map fractions (GetPlayerMapPosition, QuestPOIGetIconInfo, both on
-- the map the world map shows, the player's when it is closed); MapSizes.lua turns them into
-- yards, and the minimap's zoom into yards per minimap unit.
-- Areas: the game's own drawing, the world map's (a QuestPOIFrame, WorldMapBlobFrame_OnLoad's
-- textures and alphas). Seen in game: it lays an area out once, where and how large the frame is
-- when DrawQuestBlob runs, and in a ScrollFrame it squeezes the whole area into the visible part;
-- but drawn while its ScrollFrame is opened over the whole map, then left as the ScrollFrame
-- shrinks back, it is cut cleanly. Nothing clips to a circle in 3.3.5: the minimap is cut into
-- horizontal strips, each a ScrollFrame as wide as the circle at its height with its own
-- QuestPOIFrame, drawn again that way whenever the view moves. An invisible QuestPOIFrame that
-- never moves answers the hover test (UpdateMouseOverTooltip, the world map's). A QuestPOIFrame
-- does not rotate: with "Rotate Minimap" on, the areas hide (POIs and arrows turn).

local Q = {}
ForeverUI.MinimapQuests = Q

local wipe = table.wipe or wipe or function(t) for k in pairs(t) do t[k] = nil end return t end
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end

-- Minimap diameter in yards by zoom (0 to 5), outdoors and indoors (the client's fixed values)
local OUTDOOR = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 }
local INDOOR = { [0] = 300, 240, 180, 120, 80, 50 }

local STRIPS = 24                -- strips across the minimap's diameter
local AREA_WAIT = 0.05           -- the strips are drawn again at most twenty times a second
local PROBE_ALPHA = 1            -- out of 255
local PROBE_W, PROBE_H = 1002, 668        -- the world map's size (WorldMapBlobFrame)
local POI_SCALE = 0.5            -- QuestPOITemplate is 32 x 32
local POI_INSET = 6              -- a POI closer than this to the edge becomes an arrow
local ARROW_SIZE = 18
local ARROW_RADIUS_INSET = 7
local ARROW_TEXTURE = "Interface\\Minimap\\ROTATING-MINIMAPGUIDEARROW"
local HOVER_RADIUS = 7           -- a POI or an arrow under the cursor, in minimap units
local PARENT = "ForeverUIMinimapQuests"

local holder, over, probe, arrows = nil, nil, nil, {}
local strips = {}                -- { clip, child, blob, half, top, height }
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
	holder:SetFrameLevel(Minimap:GetFrameLevel() + 1)

	-- The probe: an invisible QuestPOIFrame (made from Lua; without it, no areas: the POIs and
	-- arrows stay)
	local ok, frame = pcall(CreateFrame, "QuestPOIFrame", "ForeverUIMinimapQuestsProbe", UIParent)
	if ok and frame then
		-- drawn, but too faint to see: the engine lays its areas out at the frame's size and may
		-- skip what it does not draw. It lays them out once, where and how large the frame is when
		-- they are drawn, and answers from that: a probe that moved with the player or changed
		-- size with the zoom answered for a stale picture (seen in game: the areas stood still on
		-- the minimap). So it never moves: the world map's size, at a fixed place. The frame's
		-- alpha does not reach the areas: their own alphas (0 to 255) do.
		probe = frame
		probe:SetWidth(PROBE_W)
		probe:SetHeight(PROBE_H)
		probe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
		if probe.SetFillTexture then
			probe:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside")
			probe:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside")
			probe:SetFillAlpha(PROBE_ALPHA)
			probe:SetBorderAlpha(PROBE_ALPHA)
		end
	end

	-- The strips: rows of the circle, each as wide as the circle at its middle
	local radius = Minimap:GetWidth() / 2
	local height = Minimap:GetWidth() / STRIPS
	for i = 1, STRIPS do
		local top = radius - (i - 1) * height
		local middle = top - height / 2
		local half = math.sqrt(math.max(0, radius * radius - middle * middle))
		local okStrip, blob = pcall(CreateFrame, "QuestPOIFrame", nil, holder)
		if not okStrip or not blob then break end
		local clip = CreateFrame("ScrollFrame", nil, holder)
		local child = CreateFrame("Frame", nil, clip)
		clip:SetScrollChild(child)
		blob:SetParent(child)
		if blob.SetFillTexture then
			blob:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside")
			blob:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside")
			blob:SetFillAlpha(128)
			blob:SetBorderAlpha(192)
			blob:SetBorderScalar(1.0)
		end
		strips[i] = { clip = clip, child = child, blob = blob, half = half, top = top, height = height,
			drawn = {} }
	end
	-- Areas and POIs above the terrain, under the ring: the ring (MinimapBackdrop, Minimap.lua) and
	-- the buttons it carries go above the strips (holder + 1 to + 3); the edge arrows above the ring
	local backdrop = _G["MinimapBackdrop"]
	local ringLevel = holder:GetFrameLevel() + 4
	if backdrop and backdrop:GetFrameLevel() < ringLevel then
		backdrop:SetFrameLevel(ringLevel)
		for _, c in ipairs({ backdrop:GetChildren() }) do
			if c:GetFrameLevel() <= ringLevel then c:SetFrameLevel(ringLevel + 1) end
		end
	end
	over = CreateFrame("Frame", nil, Minimap)
	over:SetAllPoints(Minimap)
	over:SetFrameLevel(math.max(ringLevel, backdrop and backdrop:GetFrameLevel() or 0) + 2)
	Q.arrowFrame = over
	return holder
end

local function arrow(i)
	local a = arrows[i]
	if not a then
		a = over:CreateTexture(nil, "OVERLAY")
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
local probeDrawn = {}
local function drawBlobs(key)
	if key == drawnKey or not probe then return end
	drawnKey = key
	areaKey = nil
	if not probe.DrawQuestBlob then return end
	-- no DrawNone in 3.3.5: the areas drawn before are taken off one by one
	for id in pairs(probeDrawn) do probe:DrawQuestBlob(id, false) end
	wipe(probeDrawn)
	for _, m in ipairs(markers) do
		if not m.complete then
			probe:DrawQuestBlob(m.questId, true)
			probeDrawn[m.questId] = true
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

-- The strips, drawn again when the view moves: each ScrollFrame opened over the map's rectangle,
-- its area drawn there, then shrunk back to its strip with the area left in place
local areaWait = 0
local function place(strip, x, y, w, h)
	strip.clip:ClearAllPoints()
	strip.clip:SetPoint("TOPLEFT", holder, "CENTER", x, y)
	strip.clip:SetWidth(w)
	strip.clip:SetHeight(h)
	strip.child:SetWidth(w)
	strip.child:SetHeight(h)
end

local function showAreas(v, elapsed)
	areaWait = areaWait - (elapsed or AREA_WAIT)
	if v.rotate then
		for _, strip in ipairs(strips) do strip.clip:Hide() end
		areaKey = nil
		return
	end
	local k = string.format("%s:%.4f:%.4f:%.3f", tostring(drawnKey), v.px, v.py, v.k)
	if k == areaKey or areaWait > 0 then return end
	areaKey, areaWait = k, AREA_WAIT
	local mw, mh = v.w * v.k, v.h * v.k
	local left, top = -v.px * mw, v.py * mh      -- the map's corner, from the minimap's center
	for _, strip in ipairs(strips) do
		local blob = strip.blob
		strip.clip:Show()
		place(strip, left, top, mw, mh)
		blob:ClearAllPoints()
		blob:SetPoint("TOPLEFT", strip.child, "TOPLEFT", 0, 0)
		blob:SetWidth(mw)
		blob:SetHeight(mh)
		if blob.DrawQuestBlob then
			-- no DrawNone in 3.3.5: each area is taken off, then drawn where the frame now is
			for id in pairs(strip.drawn) do blob:DrawQuestBlob(id, false) end
			wipe(strip.drawn)
			for _, m in ipairs(markers) do
				if not m.complete then
					blob:DrawQuestBlob(m.questId, true)
					strip.drawn[m.questId] = true
				end
			end
		end
		place(strip, -strip.half, strip.top, strip.half * 2, strip.height)
		blob:ClearAllPoints()
		blob:SetPoint("TOPLEFT", strip.child, "TOPLEFT", left + strip.half, top - strip.top)
	end
end

local function hideAll()
	if not holder then return end
	holder:Hide()
	for _, a in ipairs(arrows) do a:Hide() end
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

-- the strips drawn again on the next update, whatever moved
Q.redrawAreas = function() areaKey, areaWait = nil, 0 end
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
