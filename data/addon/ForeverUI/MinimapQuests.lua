-- Tracked quests on the minimap: 3.3.5 shows none (quest POIs reached the minimap in 4.0).
-- For each tracked quest with a POI on the player's map: its POI (the tracker's number or ?)
-- on the minimap while in range, else an arrow on the minimap's edge pointing at it; and its
-- area (the world map's blue quest blob). Hovering an area or a POI shows the quest's progress,
-- as the world map does (WorldMapQuestPOI_SetTooltip).
-- Positions: the client gives map fractions (GetPlayerMapPosition, QuestPOIGetIconInfo, both on
-- the map the world map shows, the player's when it is closed); MapSizes.lua turns them into
-- yards, and the minimap's zoom into yards per minimap unit.
-- Areas: a QuestPOIFrame draws the blobs of the shown map over its whole rectangle and nothing
-- clips to a circle in 3.3.5, so the round minimap is cut into horizontal strips, each a
-- ScrollFrame (they clip to their rectangle) holding its own QuestPOIFrame: the strips together
-- follow the circle. A QuestPOIFrame does not rotate: with "Rotate Minimap" on, the areas hide
-- and only POIs and arrows show.

local Q = {}
ForeverUI.MinimapQuests = Q

local wipe = table.wipe or wipe or function(t) for k in pairs(t) do t[k] = nil end return t end
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end

-- Minimap diameter in yards by zoom (0 to 5), outdoors and indoors (the client's fixed values)
local OUTDOOR = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 }
local INDOOR = { [0] = 300, 240, 180, 120, 80, 50 }

local STRIPS = 16
local POI_SCALE = 0.5            -- QuestPOITemplate is 32 x 32
local POI_INSET = 6              -- a POI closer than this to the edge becomes an arrow
local ARROW_SIZE = 18
local ARROW_RADIUS_INSET = 7
local ARROW_TEXTURE = "Interface\\Minimap\\ROTATING-MINIMAPGUIDEARROW"
local HOVER_RADIUS = 7           -- a POI under the cursor, in minimap units
local PARENT = "ForeverUIMinimapQuests"

local holder, blobs, arrows = nil, {}, {}
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

-- Minimap units per yard
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

	-- The strips: rows of the circle, each as wide as its chord nearest the center
	local radius = Minimap:GetWidth() / 2
	local h = Minimap:GetWidth() / STRIPS
	for i = 1, STRIPS do
		local top = radius - (i - 1) * h
		local bottom = top - h
		local near = math.min(math.abs(top), math.abs(bottom))
		if top > 0 and bottom < 0 then near = 0 end
		local half = math.sqrt(math.max(0, radius * radius - near * near))
		local clip = CreateFrame("ScrollFrame", nil, holder)
		clip:SetWidth(half * 2)
		clip:SetHeight(h)
		clip:SetPoint("TOPLEFT", holder, "CENTER", -half, top)
		local child = CreateFrame("Frame", nil, clip)
		child:SetWidth(half * 2)
		child:SetHeight(h)
		clip:SetScrollChild(child)
		-- a QuestPOIFrame made from Lua; without it, no areas (the POIs and arrows stay)
		local ok, blob = pcall(CreateFrame, "QuestPOIFrame", nil, child)
		if not ok or not blob then
			clip:Hide()
			break
		end
		local texture = blob:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(blob)
		if blob.SetFillTexture then
			-- WorldMapBlobFrame_OnLoad
			blob:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside")
			blob:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside")
			blob:SetFillAlpha(128)
			blob:SetBorderAlpha(192)
			blob:SetBorderScalar(1.0)
		end
		blob.half, blob.top = half, top
		blobs[i] = { clip = clip, child = child, blob = blob }
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
local function collect()
	wipe(markers)
	if not (QuestPOIGetIconInfo and GetQuestIndexForWatch) then return end
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

-- The areas, drawn again when the quests or the map change
local function drawBlobs(key)
	if key == drawnKey then return end
	drawnKey = key
	for _, s in ipairs(blobs) do
		local blob = s.blob
		if blob.DrawNone then blob:DrawNone() end
		for _, m in ipairs(markers) do
			if not m.complete and blob.DrawQuestBlob then
				blob:DrawQuestBlob(m.questId, true)
			end
		end
	end
end

local function hideAll()
	if not holder then return end
	holder:Hide()
	for _, a in ipairs(arrows) do a:Hide() end
	hidePOIs()
end

-- ---------------------------------------------------------------- each frame

local function update()
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
			a:ClearAllPoints()
			a:SetPoint("CENTER", holder, "CENTER", sx / d * r, sy / d * r)
			-- the image points up: turned to the POI's direction
			rotateTexture(a, atan2(sy, sx) - math.pi / 2)
			a:Show()
		end
	end
	for i = shownArrows + 1, #arrows do arrows[i]:Hide() end
	hidePOIs(keptPOIs)

	-- Areas: the map's rectangle at the minimap's scale, its corner placed from the player
	local show = not rotate
	for _, strip in ipairs(blobs) do
		if show then
			local blob = strip.blob
			blob:SetWidth(w * k)
			blob:SetHeight(h * k)
			blob:ClearAllPoints()
			blob:SetPoint("TOPLEFT", strip.child, "TOPLEFT",
				blob.half - px * w * k, py * h * k - blob.top)
			strip.clip:Show()
		else
			strip.clip:Hide()
		end
	end
	Q.view = { px = px, py = py, w = w, h = h, k = k }
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
	-- a POI under the cursor
	for _, m in ipairs(markers) do
		if m.inRange and (m.sx - ux) ^ 2 + (m.sy - uy) ^ 2 <= HOVER_RADIUS ^ 2 then
			questTooltip(m)
			return
		end
	end
	-- an area: the blob frame answers for a point of the map (fractions of its rectangle)
	local v, blob = Q.view, blobs[1] and blobs[1].blob
	local radius = Minimap:GetWidth() / 2
	if not rotating() and blob and blob.UpdateMouseOverTooltip and ux * ux + uy * uy <= radius * radius then
		local fx = v.px + ux / (v.w * v.k)
		local fy = v.py - uy / (v.h * v.k)
		local index, objectives = blob:UpdateMouseOverTooltip(fx, fy)
		if objectives then
			for _, m in ipairs(markers) do
				if m.questIndex == index then
					questTooltip(m, blob)
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

local function refresh()
	collect()
	local key = {}
	for _, m in ipairs(markers) do key[#key + 1] = m.questId .. (m.complete and "c" or "") end
	drawBlobs((GetCurrentMapAreaID and GetCurrentMapAreaID() or 0) .. ":" ..
		((GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel()) or 0) .. ":" .. table.concat(key, ","))
	update()
end
Q.refresh = refresh
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
	refresh()
end)

-- Quest watches change without an event of their own
if hooksecurefunc then
	for _, name in ipairs({ "AddQuestWatch", "RemoveQuestWatch" }) do
		if _G[name] then hooksecurefunc(name, function() if minimapReady() then refresh() end end) end
	end
end

watcher:SetScript("OnUpdate", function()
	if #markers > 0 then
		update()
		hover()
	end
end)
Q.watcher = watcher
