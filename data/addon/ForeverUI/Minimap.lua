-- Minimap in camelot style. Since 1.60.1.70450 camelot has its own minimap code (camelot/
-- Minimap.lua, MinimapZoneTextButton, MiniMapTrackingButton, MiniMapMailFrameTemplate,
-- GameTimeFrame, Diel.lua; Skin.lua is gone): a one-image zone bar, 23 px calendar and tracking
-- buttons, the mail under the bar. camelot drops the instance difficulty; ForeverUI keeps it
-- (user's choice), under the right end of the bar.
-- The client's Minimap frame is kept (only the client draws terrain, blips and the player
-- arrow): it is resized, masked and scaled, and everything around it is replaced.
-- Sizes and anchors: mainline Minimap.xml, GameTime.xml and Blizzard_TimeManager.xml.

ForeverUI = ForeverUI or {}

-- Cluster and container. Frame 253 x 253 is the c60 atlas size (camelot Skin.lua); the map
-- keeps 198. 3.3.5 SetMaskTexture takes a file path, not an atlas name.
local CLUSTER_W, CLUSTER_H = 256, 256
local MOUSE_MARGINS = { 30, 10, 0, 30 }   -- left, right, top, bottom

local ATLAS_FRAME = "ui-hud-minimap-frame-c60"
local FRAME_W, FRAME_H = 253, 253
local MASK_PATH = "interface\\ForeverUI\\hud\\uiminimapmaskgeneralc60"

local CONTAINER_X, CONTAINER_Y = 10, -30
local MAP_SIDE = 198

-- 3.3.5 draws out-of-range arrows (corpse, quest, POI) at a fixed radius in map units, sized
-- for its 140 px map, and no method changes it. So the map keeps size 140 and gets scale
-- 198 / 140: it still shows 198 wide on screen, and the arrows reach its edge.
local CLIENT_MAP = 140
local MAP_SCALE = MAP_SIDE / CLIENT_MAP

-- Arrow images shrunk by 140 / 198 (tools/shrink_arrows.py) to undo the scale. The party arrow
-- has no setter: its shrunk file replaces the original in patch-Z.
local ARROWS = {
	path = "interface\\ForeverUI\\minimap\\",
	{ method = "SetStaticPOIArrowTexture", file = "rotating-minimaparrow" },
	{ method = "SetPOIArrowTexture", file = "rotating-minimapguidearrow" },
	{ method = "SetCorpsePOIArrowTexture", file = "rotating-minimapcorpsearrow" },
}

-- Zone name bar (camelot MinimapZoneTextButtonTemplate): 152 x 23 at TOP (10, 0) of the cluster,
-- its own background ui-hud-minimap-header-button; text GameFontHighlightSmall 110 x 12 at
-- LEFT (8, -1). Hover and press: a copy of the same image in ADD at alpha 0.1 / 0.2
-- (mouseoverAddAlpha, mousedownAddAlpha), for the bar, the calendar and the tracking button.
local BAR_ATLAS = "ui-hud-minimap-header-button"
local BAR_W, BAR_H = 152, 23
local BAR_X, BAR_Y = 10, 0
local TEXT_W, TEXT_H = 110, 12
local TEXT_X, TEXT_Y = 8, -1
local HOVER_ALPHA, PRESS_ALPHA = 0.1, 0.2

-- Tracking (camelot MiniMapTrackingButtonTemplate): 17 x 17 frame RIGHT on the bar's LEFT, its
-- button 23 x 23 centered. Mail (MiniMapMailFrameTemplate): 32 x 24, TOPLEFT on the bar's
-- BOTTOMLEFT, a still icon.
local TRACKING_SIDE = 17
local TRACKING_X = 0
local TRACKING_BUTTON = 23
local MAIL_W, MAIL_H = 32, 24

-- Zoom (buttons hidden unless hovered)
local ZOOM_ZONE = 40
local ZOOM_ZONE_X, ZOOM_ZONE_Y = 77, -77
local ZOOM_PLUS_W, ZOOM_PLUS_H = 17, 17
local ZOOM_PLUS_X, ZOOM_PLUS_Y = 88, -68
local ZOOM_MINUS_W, ZOOM_MINUS_H = 17, 9
local ZOOM_MINUS_X, ZOOM_MINUS_Y = 72, -84

-- Day/night ring (camelot Diel.lua, 70450: parent MinimapContainer, CENTER (55, 86)). 3.3.5 has
-- no DIEL_CYCLE_CHANGED or IsDayTime, only the server hour: day is 6 h to 18 h.
local ATLAS_CYCLE = "ui-hud-minimap-frame-cycle-c60"
local ATLAS_DAY = "ui-hud-minimap-daycycle-c60"
local ATLAS_NIGHT = "ui-hud-minimap-nightcycle-c60"
local CYCLE_SIDE = 42
local ORB_SIDE = 33
local CYCLE_X, CYCLE_Y = 55, 86
local CYCLE_LEVEL = 5
local DAWN, DUSK = 6, 18
local CYCLE_PERIOD = 60          -- re-read the server hour once a minute

-- Instance difficulty: kept (camelot removes it), under the right end of the bar, where camelot
-- has its addon compartment (absent here)
local DIFFICULTY_X, DIFFICULTY_Y = 0, 2

-- One table per element rather than one local per value: Lua 5.1 allows at most 60 upvalues
-- per function, and build() exceeded it.

-- Calendar (camelot GameTimeFrameTemplate): 23 x 23, TOPLEFT on the bar's TOPRIGHT (-4, 0), one
-- fixed image: camelot no longer shows the day
local CALENDAR = { L = 23, H = 23, X = -4, ATLAS = "ui-hud-minimap-calendar-button" }

-- Clock, in the bar
-- camelot 70450 (Blizzard_TimeManagerOverrides): RIGHT on the bar's RIGHT (-3, -1), ticker
-- CENTER (3, 0); at the alarm the ticker flashes instead of the glow.
local CLOCK = {
	L = 40, H = 16, X = -3, Y = -1,
	MARGINS = { 8, 5, 3, 3 },
	TEXT_X = 3, TEXT_Y = 0,
-- WhiteNormalNumberFont (GameFontStyles.xml): FRIZQT__ 10, white, black shadow (1, -1).
-- 3.3.5 lacks this font object, so its settings are applied one by one.
	FONT = "Fonts\\FRIZQT__.TTF", SIZE = 10,
}

-- Player coordinates under the map (camelot MinimapPlayerCoordsMixin), every 0.1 s.
-- Formats from camelot GlobalStrings: 3.3.5 does not have them.
local COORD = {
	L = 90, H = 10, Y = -18,
	INTERVAL = 0.1,
	INTEGER = "%d, %d",          -- MINIMAP_PLAYER_COORDS_INTEGER
	TENTHS = "%.1f, %.1f",    -- MINIMAP_PLAYER_COORDS
}

-- 3.3.5 buttons camelot places elsewhere, set on the ring at our own angles: their 3.3.5
-- offsets fit a 140 map in a 192 cluster. Radius 100 is the middle of the ring's metal
-- (hole 185, metal 15 on each side).
local RING_RADIUS = 100
local RING_ITEMS = {
	{ name = "MiniMapWorldMapButton", angle = 180 },
	{ name = "MiniMapLFGFrame", angle = 215 },
	{ name = "MiniMapBattlefieldFrame", angle = 250 },
	{ name = "MiniMapRecordingButton", angle = 285 },
}

local PREFIX = "|cff66ccffForeverUI|r "
local L = ForeverUI.L

local function say(message)
	DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. message)
end

-- Hides a client region for good. Its own code shows it again or restores its file
-- (Minimap_UpdateRotationSetting, MiniMapTracking_Update), so texture, alpha and visibility
-- are all cleared.
local function suppress(region)
	if not region then
		return
	end
	if region.SetTexture then
		region:SetTexture(nil)
	end
	if region.SetAlpha then
		region:SetAlpha(0)
	end
	if region.Hide then
		region:Hide()
	end
end

-- Puts an atlas on a button state. A 3.3.5 button has only the states its XML declares
-- (MiniMapTrackingButton has only a highlight), and Set<State>Texture takes only a file path,
-- so the sheet is set first, then the atlas rectangle on the texture it creates.
-- state: "Normal", "Pushed", "Highlight" or "Disabled"; name: atlas name
local function applyButtonState(button, state, name)
	local e = ForeverUI.AtlasEntry(name)
	if not e then
		return nil
	end
	local texture = button["Get" .. state .. "Texture"](button)
	if not texture then
		button["Set" .. state .. "Texture"](button, e[1])
		texture = button["Get" .. state .. "Texture"](button)
	end
	if texture then
		ForeverUI.SetAtlas(texture, name, true)
	end
	return texture
end

-- Places a frame on the ring at angle degrees: 0 is east, counterclockwise.
local function placeOnRing(frame, map, angle)
	local radians = angle * math.pi / 180
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", map, "CENTER",
		RING_RADIUS * math.cos(radians), RING_RADIUS * math.sin(radians))
end

local M = {}
ForeverUI.Minimap = M

-- camelot's hover and press (OnButtonStateChanged): a copy of the button's image in ADD, alpha
-- 0.1 on hover and 0.2 pressed, hidden otherwise. target: the frame that gets the mouse; host:
-- the frame that holds the copy; atlas: the image.
local function addGlow(target, host, atlas)
	if target.foreverGlow then
		return target.foreverGlow
	end
	local glow = host:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(glow, atlas, true)
	glow:SetAllPoints(host)
	glow:SetBlendMode("ADD")
	glow:Hide()
	target.foreverGlow = glow
	local function paint()
		if target.foreverPressed then
			glow:SetAlpha(PRESS_ALPHA)
			glow:Show()
		elseif target.foreverHovered then
			glow:SetAlpha(HOVER_ALPHA)
			glow:Show()
		else
			glow:Hide()
		end
	end
	target:HookScript("OnEnter", function(self) self.foreverHovered = true paint() end)
	target:HookScript("OnLeave", function(self) self.foreverHovered, self.foreverPressed = nil, nil paint() end)
	target:HookScript("OnMouseDown", function(self) self.foreverPressed = true paint() end)
	target:HookScript("OnMouseUp", function(self) self.foreverPressed = nil paint() end)
	return glow
end

-- Calendar: one fixed image (camelot OnButtonStateChanged ignores the day). The 3.3.5
-- GameTimeFrame_SetDate still writes the day as text: hidden.
function M.updateCalendar()
	local button = _G["GameTimeFrame"]
	if not button then
		return
	end
	applyButtonState(button, "Normal", CALENDAR.ATLAS)
	applyButtonState(button, "Pushed", CALENDAR.ATLAS)
	-- the client highlight gives way to the ADD copy (addGlow)
	local highlight = button.GetHighlightTexture and button:GetHighlightTexture()
	if highlight then
		highlight:SetAlpha(0)
	end
	local text = button.GetFontString and button:GetFontString()
	if text then
		text:SetAlpha(0)
	end
end

-- Clock: its 3.3.5 background is an unnamed texture (ClockBackground), found among the
-- regions; the text and the alarm glow are kept.
function M.skinClock()
	local clock = _G["TimeManagerClockButton"]
	local bar = M.bar
	if not clock or not bar then
		return
	end
	local text = _G["TimeManagerClockTicker"]
	local alarm = _G["TimeManagerAlarmFiredTexture"]
	for _, region in ipairs({ clock:GetRegions() }) do
		if region ~= text and region ~= alarm then
			suppress(region)
		end
	end
	clock:SetParent(M.cluster)
	clock:SetWidth(CLOCK.L)
	clock:SetHeight(CLOCK.H)
	clock:ClearAllPoints()
	clock:SetPoint("RIGHT", bar, "RIGHT", CLOCK.X, CLOCK.Y)
	-- above the zone button, which covers the bar
	clock:SetFrameLevel(bar:GetFrameLevel() + 2)
	clock:SetHitRectInsets(CLOCK.MARGINS[1], CLOCK.MARGINS[2],
		CLOCK.MARGINS[3], CLOCK.MARGINS[4])
	if text then
		text:SetFont(CLOCK.FONT, CLOCK.SIZE)
		text:SetShadowOffset(1, -1)
		text:SetShadowColor(0, 0, 0, 1)
		text:SetTextColor(1, 1, 1)
		text:ClearAllPoints()
		text:SetPoint("CENTER", clock, "CENTER", CLOCK.TEXT_X, CLOCK.TEXT_Y)
	end
	-- camelot TimeManager_FireAlarm / _TurnOffAlarm: the glow stays hidden, the ticker flashes
	if not M.alarmHooked and hooksecurefunc and TimeManager_FireAlarm and TimeManager_TurnOffAlarm then
		hooksecurefunc("TimeManager_FireAlarm", function()
			local glow, ticker = _G["TimeManagerAlarmFiredTexture"], _G["TimeManagerClockTicker"]
			if glow then
				if UIFrameFlashStop then UIFrameFlashStop(glow) end
				glow:SetAlpha(1)
				glow:Hide()
			end
			if ticker and UIFrameFlash then
				UIFrameFlash(ticker, 0.5, 0.5, -1)
			end
		end)
		hooksecurefunc("TimeManager_TurnOffAlarm", function()
			local ticker = _G["TimeManagerClockTicker"]
			if ticker then
				if UIFrameFlashStop then UIFrameFlashStop(ticker) end
				ticker:SetAlpha(1)
				ticker:Show()
			end
		end)
		M.alarmHooked = true
	end
	M.clockSkinned = true
end

-- 3.3.5 GetPlayerMapPosition answers for the map shown by the world map, so it is set back to
-- the player's zone on zone change and when the world map closes, never while it is open.
-- In instances 3.3.5 returns (0, 0) and nothing is shown.
function M.recenterWorldMap()
	if SetMapToCurrentZone and not (WorldMapFrame and WorldMapFrame:IsShown()) then
		SetMapToCurrentZone()
	end
end

function M.updateCoordinates()
	local coords = M.coords
	if not coords then
		return
	end
	local x, y = 0, 0
	if GetPlayerMapPosition then
		x, y = GetPlayerMapPosition("player")
	end
	if not x or not y or (x == 0 and y == 0) then
		coords.text:SetText("")
		return
	end
	if GetCVar and GetCVar("coordsByTenths") == "1" then
		coords.text:SetText(string.format(COORD.TENTHS, x * 100, y * 100))
	else
		coords.text:SetText(string.format(COORD.INTEGER,
			math.floor(x * 100 + 0.5), math.floor(y * 100 + 0.5)))
	end
end

-- Applies scale k to the map: its size becomes 198 / k, so it stays 198 on screen. Children the
-- addon places (MinimapBackdrop, zoom hit area) get 1 / k to keep their size. MinimapPing
-- follows the map: Minimap_SetPing works in map units.
local function applyScale(k)
	local map = M.map
	if not map then
		return
	end
	M.scale = k
	map:SetScale(k)
	map:SetWidth(MAP_SIDE / k)
	map:SetHeight(MAP_SIDE / k)
	for _, childFrame in ipairs({ _G["MinimapBackdrop"], M.zoomZone }) do
		if childFrame then
			childFrame:SetScale(1 / k)
		end
	end
end

M.applyScale = applyScale

-- Reskins the cluster; returns false when client frames or AtlasUtil are missing.
local function build()
	local cluster = _G["MinimapCluster"]
	local map = _G["Minimap"]
	local background = _G["MinimapBackdrop"]

	if not cluster or not map or not background then
		say(L.MINIMAP_DEBUG_NO_CLIENT_FRAMES)
		return false
	end

	if not ForeverUI.SetAtlas then
		say(L.MINIMAP_DEBUG_NO_ATLASUTIL)
		return false
	end

	M.cluster = cluster
	M.map = map

	-- 1. Cluster: same mouse margins as 3.3.5, new size.
	cluster:SetWidth(CLUSTER_W)
	cluster:SetHeight(CLUSTER_H)
	cluster:SetFrameStrata("LOW")
	cluster:SetHitRectInsets(MOUSE_MARGINS[1], MOUSE_MARGINS[2],
		MOUSE_MARGINS[3], MOUSE_MARGINS[4])

	suppress(_G["MinimapBorderTop"])

	-- 2. Container and map.
	local container = M.container
	if not container then
		container = CreateFrame("Frame", "ForeverUIMinimapContainer", cluster)
		M.container = container
	end
	container:SetWidth(FRAME_W)
	container:SetHeight(FRAME_H)
	container:ClearAllPoints()
	container:SetPoint("TOP", cluster, "TOP", CONTAINER_X, CONTAINER_Y)

	map:SetParent(container)
	map:ClearAllPoints()
	map:SetPoint("CENTER", container, "CENTER", 0, 0)
	map:SetMaskTexture(MASK_PATH)
	for _, arrow in ipairs(ARROWS) do
		if map[arrow.method] then
			map[arrow.method](map, ARROWS.path .. arrow.file)
		end
	end

	-- 3. Frame ring on MinimapBackdrop, as in camelot: a child of the map, it draws above the
	-- terrain, and its own children (the buttons) draw above it.
	-- MinimapCompassTexture is the 3.3.5 compass here, not camelot's frame of the same name.
	background:SetWidth(FRAME_W)
	background:SetHeight(FRAME_H)
	background:ClearAllPoints()
	background:SetPoint("CENTER", map, "CENTER", 0, 0)

	suppress(_G["MinimapBorder"])
	suppress(_G["MinimapNorthTag"])
	suppress(_G["MinimapCompassTexture"])

	local ring = M.ring
	if not ring then
		ring = background:CreateTexture(nil, "ARTWORK")
		M.ring = ring
	end
	ForeverUI.SetAtlas(ring, ATLAS_FRAME, true)
	ring:SetWidth(FRAME_W)
	ring:SetHeight(FRAME_H)
	ring:ClearAllPoints()
	ring:SetPoint("CENTER", background, "CENTER", 0, 0)

	-- 4. Zone name bar.
	local bar = M.bar
	if not bar then
		bar = CreateFrame("Frame", "ForeverUIMinimapBorderTop", cluster)
		M.bar = bar
		bar.background = bar:CreateTexture(nil, "BACKGROUND")
		ForeverUI.SetAtlas(bar.background, BAR_ATLAS, true)
		bar.background:SetAllPoints(bar)
	end
	bar:SetWidth(BAR_W)
	bar:SetHeight(BAR_H)
	bar:ClearAllPoints()
	bar:SetPoint("TOP", cluster, "TOP", BAR_X, BAR_Y)

	local zoneButton = _G["MinimapZoneTextButton"]
	if zoneButton then
		zoneButton:SetParent(cluster)
		-- the button is the bar (camelot: the bar's image is the button's StateTexture)
		zoneButton:ClearAllPoints()
		zoneButton:SetAllPoints(bar)
		zoneButton:SetFrameLevel(bar:GetFrameLevel() + 1)
		addGlow(zoneButton, bar, BAR_ATLAS)
	end

	local zoneText = _G["MinimapZoneText"]
	if zoneText then
		-- GameFontHighlightSmall; the client keeps setting the color (Minimap_Update, PvP status)
		local r, g, b = zoneText:GetTextColor()
		zoneText:SetFontObject(GameFontHighlightSmall)
		if r then
			zoneText:SetTextColor(r, g, b)
		end
		zoneText:SetWidth(TEXT_W)
		zoneText:SetHeight(TEXT_H)
		zoneText:ClearAllPoints()
		zoneText:SetPoint("LEFT", zoneButton or bar, "LEFT", TEXT_X, TEXT_Y)
		zoneText:SetDrawLayer("OVERLAY")
		zoneText:SetJustifyH("LEFT")
		zoneText:SetJustifyV("MIDDLE")
	end

	-- 5. Tracking: the client frame stays (it opens the tracking menu), only reskinned.
	local tracking = _G["MiniMapTracking"]
	if tracking then
		tracking:SetParent(cluster)
		tracking:SetWidth(TRACKING_SIDE)
		tracking:SetHeight(TRACKING_SIDE)
		tracking:ClearAllPoints()
		tracking:SetPoint("RIGHT", bar, "LEFT", TRACKING_X, 0)
		tracking:SetFrameLevel(bar:GetFrameLevel() + 1)

		suppress(_G["MiniMapTrackingBackground"])
		suppress(_G["MiniMapTrackingIcon"])
		suppress(_G["MiniMapTrackingIconOverlay"])

		local button = _G["MiniMapTrackingButton"]
		if button then
			button:SetWidth(TRACKING_BUTTON)
			button:SetHeight(TRACKING_BUTTON)
			button:ClearAllPoints()
			button:SetPoint("CENTER", tracking, "CENTER", 0, 0)
			button:SetHitRectInsets(0, 0, 0, 0)

			suppress(_G["MiniMapTrackingButtonBorder"])
			suppress(_G["MiniMapTrackingButtonShine"])

			applyButtonState(button, "Normal", "ui-hud-minimap-tracking-button")
			applyButtonState(button, "Pushed", "ui-hud-minimap-tracking-button")
			local highlight = button.GetHighlightTexture and button:GetHighlightTexture()
			if highlight then
				highlight:SetAlpha(0)
			end
			addGlow(button, button, "ui-hud-minimap-tracking-button")
		end
	end

	-- 6. Mail, under the bar's left end.
	local rowLine = M.rowLine
	if not rowLine then
		rowLine = CreateFrame("Frame", "ForeverUIMinimapIndicators", cluster)
		M.rowLine = rowLine
	end
	rowLine:SetWidth(MAIL_W)
	rowLine:SetHeight(MAIL_H)
	rowLine:ClearAllPoints()
	rowLine:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, 0)

	local mail = _G["MiniMapMailFrame"]
	if mail then
		mail:SetParent(rowLine)
		mail:SetWidth(MAIL_W)
		mail:SetHeight(MAIL_H)
		mail:ClearAllPoints()
		mail:SetPoint("TOPLEFT", rowLine, "TOPLEFT", 0, 0)

		suppress(_G["MiniMapMailIcon"])
		suppress(_G["MiniMapMailBorder"])

		if not M.mailIcon then
			M.mailIcon = mail:CreateTexture(nil, "ARTWORK")
		end
		ForeverUI.SetAtlas(M.mailIcon, "ui-hud-minimap-mail-icon")
		M.mailIcon:ClearAllPoints()
		M.mailIcon:SetPoint("TOPLEFT", mail, "TOPLEFT", 0, 0)
	end

	-- 7. Zoom. The hit area uses the BACKGROUND strata, as in camelot, so it takes the mouse only
	-- where nothing else does and does not steal map clicks.
	local zoomZone = M.zoomZone
	if not zoomZone then
		zoomZone = CreateFrame("Frame", "ForeverUIMinimapZoomHitArea", map)
		zoomZone:EnableMouse(true)
		zoomZone:SetFrameStrata("BACKGROUND")
		M.zoomZone = zoomZone
	end
	zoomZone:SetWidth(ZOOM_ZONE)
	zoomZone:SetHeight(ZOOM_ZONE)
	zoomZone:ClearAllPoints()
	zoomZone:SetPoint("CENTER", map, "CENTER", ZOOM_ZONE_X, ZOOM_ZONE_Y)

	local plus = _G["MinimapZoomIn"]
	local minus = _G["MinimapZoomOut"]

	local function skinZoom(button, width, height, x, y, name)
		if not button then
			return
		end
		button:SetWidth(width)
		button:SetHeight(height)
		button:ClearAllPoints()
		button:SetPoint("CENTER", map, "CENTER", x, y)
		-- Client hit insets cut 4 px on each side of a 32 px button; a 17 px one needs none.
		button:SetHitRectInsets(0, 0, 0, 0)
		applyButtonState(button, "Normal", name)
		applyButtonState(button, "Pushed", name .. "-down")

		-- camelot desaturates the disabled state. 3.3.5 SetDesaturated returns false when the GPU
		-- cannot do it: then darken by hand.
		local disabled = applyButtonState(button, "Disabled", name)
		if disabled and not (disabled.SetDesaturated and disabled:SetDesaturated(true)) then
			disabled:SetVertexColor(0.45, 0.45, 0.45)
		end

		-- The client highlight is additive; camelot's is a full, lighter image, drawn with BLEND.
		local hover = applyButtonState(button, "Highlight", name .. "-mouseover")
		if hover then
			hover:SetBlendMode("BLEND")
		end
		button:Hide()
	end

	skinZoom(plus, ZOOM_PLUS_W, ZOOM_PLUS_H, ZOOM_PLUS_X, ZOOM_PLUS_Y,
		"ui-hud-minimap-zoom-in")
	skinZoom(minus, ZOOM_MINUS_W, ZOOM_MINUS_H, ZOOM_MINUS_X, ZOOM_MINUS_Y,
		"ui-hud-minimap-zoom-out")

	-- As MinimapMixin:OnLeave: hide the zoom buttons only when the mouse is on none of the four.
	local function showRegion()
		if plus then plus:Show() end
		if minus then minus:Show() end
	end

	local function hideIfPossible()
		if plus and plus:IsMouseOver() then return end
		if minus and minus:IsMouseOver() then return end
		if zoomZone:IsMouseOver() then return end
		if map:IsMouseOver() then return end
		if plus then plus:Hide() end
		if minus then minus:Hide() end
	end


	if not M.zoomHooked then
		map:HookScript("OnEnter", showRegion)
		map:HookScript("OnLeave", hideIfPossible)
		zoomZone:SetScript("OnEnter", showRegion)
		zoomZone:SetScript("OnLeave", hideIfPossible)
		if plus then
			plus:HookScript("OnEnter", showRegion)
			plus:HookScript("OnLeave", hideIfPossible)
		end
		if minus then
			minus:HookScript("OnEnter", showRegion)
			minus:HookScript("OnLeave", hideIfPossible)
		end
		-- Mouse wheel as camelot MinimapMixin:OnMouseWheel: clicks + or - (same effect and sound,
		-- nothing when disabled). 3.3.5 does not give the wheel to the map.
		-- IsEnabled returns 0 or 1, and 0 is true in Lua.
		local function click(button)
			local state = button and button:IsEnabled()
			if state and state ~= 0 then button:Click() end
		end
		map:EnableMouseWheel(true)
		map:SetScript("OnMouseWheel", function(_, direction)
			if direction > 0 then
				click(plus)
			elseif direction < 0 then
				click(minus)
			end
		end)
		M.zoomHooked = true
	end

	-- 8. Day/night ring.
	local cycle = M.cycle
	if not cycle then
		cycle = CreateFrame("Frame", "ForeverUIMinimapDiel", container)
		cycle:SetFrameLevel(CYCLE_LEVEL)
		M.cycle = cycle
		M.orb = cycle:CreateTexture(nil, "BACKGROUND")
		M.orb:SetPoint("CENTER", cycle, "CENTER", 0, 0)
		M.cycleEdge = cycle:CreateTexture(nil, "OVERLAY")
		M.cycleEdge:SetAllPoints(cycle)
	end
	cycle:SetWidth(CYCLE_SIDE)
	cycle:SetHeight(CYCLE_SIDE)
	cycle:ClearAllPoints()
	cycle:SetPoint("CENTER", container, "CENTER", CYCLE_X, CYCLE_Y)
	ForeverUI.SetAtlas(M.cycleEdge, ATLAS_CYCLE, true)
	M.orb:SetWidth(ORB_SIDE)
	M.orb:SetHeight(ORB_SIDE)

	-- 9. Instance difficulty (camelot removes it; kept), under the bar's right end.
	local difficulty = _G["MiniMapInstanceDifficulty"]
	if difficulty then
		difficulty:SetParent(cluster)
		difficulty:ClearAllPoints()
		difficulty:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", DIFFICULTY_X, DIFFICULTY_Y)
	end

	-- 10. Calendar, right of the bar.
	local calendar = _G["GameTimeFrame"]
	if calendar then
		calendar:SetParent(cluster)
		calendar:SetWidth(CALENDAR.L)
		calendar:SetHeight(CALENDAR.H)
		calendar:ClearAllPoints()
		calendar:SetPoint("TOPLEFT", bar, "TOPRIGHT", CALENDAR.X, 0)
		calendar:SetFrameLevel(bar:GetFrameLevel() + 1)
		-- 3.3.5 gives it hit insets of 6/0/5/10 for a 40 px button; camelot declares none.
		calendar:SetHitRectInsets(0, 0, 0, 0)
		M.updateCalendar()
		addGlow(calendar, calendar, CALENDAR.ATLAS)
	end

	-- 11. Clock, in the bar. Blizzard_TimeManager loads on demand: ADDON_LOADED skins it later.
	M.skinClock()

	-- 12. Player coordinates under the map, a sibling of the map in the container
	-- (camelot PlayerCoords).
	local coords = M.coords
	if not coords then
		coords = CreateFrame("Frame", "ForeverUIMinimapPlayerCoords", container)
		coords.text = coords:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		coords.text:SetAllPoints(coords)
		coords.text:SetJustifyH("CENTER")
		coords.pending = 0
		coords:SetScript("OnUpdate", function(self, elapsed)
			self.pending = self.pending - (elapsed or 0)
			if self.pending > 0 then
				return
			end
			self.pending = COORD.INTERVAL
			M.updateCoordinates()
		end)
		M.coords = coords
	end
	coords:SetWidth(COORD.L)
	coords:SetHeight(COORD.H)
	coords:ClearAllPoints()
	coords:SetPoint("BOTTOM", map, "BOTTOM", 0, COORD.Y)

	-- 13. Scale last: the zoom hit area must exist.
	applyScale(M.scale or MAP_SCALE)

	-- 14. The buttons camelot does not have, on the ring.
	for _, item in ipairs(RING_ITEMS) do
		local button = _G[item.name]
		if button then
			button:SetParent(background)
			placeOnRing(button, map, item.angle)
		end
	end

	return true
end

-- The server hour picks sun or moon; 3.3.5 has no cycle event, so it is read once a minute.
local function updateCycle()
	if not M.orb then
		return
	end
	local hour = GetGameTime and GetGameTime() or 12
	local day = hour >= DAWN and hour < DUSK
	M.day = day
	ForeverUI.SetAtlas(M.orb, day and ATLAS_DAY or ATLAS_NIGHT, true)
end

M.Refresh = function()
	if M.cluster then
		updateCycle()
	end
end

local listener = CreateFrame("Frame")
listener.elapsed = 0
listener:RegisterEvent("PLAYER_ENTERING_WORLD")
listener:RegisterEvent("MINIMAP_UPDATE_ZOOM")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("ZONE_CHANGED_NEW_AREA")
listener:SetScript("OnEvent", function(_self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		build()
		updateCycle()
		M.recenterWorldMap()
	elseif event == "ADDON_LOADED" then
		if arg1 == "Blizzard_TimeManager" then
			M.skinClock()
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		M.recenterWorldMap()
	elseif event == "MINIMAP_UPDATE_ZOOM" then
		-- As MinimapMixin:OnEvent: disable a zoom button at the end of its range.
		local plus, minus = _G["MinimapZoomIn"], _G["MinimapZoomOut"]
		local map = M.map
		if plus and minus and map and map.GetZoom and map.GetZoomLevels then
			local level = map:GetZoom()
			if level == map:GetZoomLevels() - 1 then plus:Disable() else plus:Enable() end
			if level == 0 then minus:Disable() else minus:Enable() end
		end
	end
end)

listener:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + (elapsed or 0)
	if self.elapsed < CYCLE_PERIOD then
		return
	end
	self.elapsed = 0
	updateCycle()
end)

-- The client calls GameTimeFrame_SetDate on each day change: reapply the calendar image.
if hooksecurefunc and GameTimeFrame_SetDate then
	hooksecurefunc("GameTimeFrame_SetDate", function() M.updateCalendar() end)
end
if WorldMapFrame and WorldMapFrame.HookScript then
	WorldMapFrame:HookScript("OnHide", function() M.recenterWorldMap() end)
end

if build() then
	updateCycle()
	-- Registered with the layout like every frame, so the player can move it.
	if ForeverUI.Layout and ForeverUI.Layout.Register then
		ForeverUI.Layout.Register(_G["MinimapCluster"], "minimap", MINIMAP_LABEL,
			"TOPRIGHT", "TOPRIGHT", 0, 0)
	end
end
