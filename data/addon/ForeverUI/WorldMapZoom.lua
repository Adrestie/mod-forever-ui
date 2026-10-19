-- World map zoom: the mouse wheel enlarges the map toward the cursor (x 1.25 per step, 1 to 4)
-- and a left-button drag pans the zoomed map; a click without drag keeps its meaning.
-- Camelot zooms through map art layers (mapcanvas_scrollcontainermixin.lua), which 3.3.5
-- lacks. The zoom returns to 1 when the map changes, changes mode or closes.
-- The map is ENLARGED, not scaled: WorldMapDetailFrame and WorldMapButton get their width and
-- height x zoom at their own scale. The client places every marker at its map fraction x
-- their width, so the markers move with the map and keep their size, as in camelot. The art
-- (tiles, explored areas) has fixed sizes in the client: it is laid out and cropped here.
-- Units: "map units" are those of the whole map (1002 x 668); the frames' are map units x zoom.

local W = ForeverUI.WorldMap
local Z = { z = 1, cx = 0.5, cy = 0.5, active = false, STEP = 1.25, MAX = 4, THRESHOLD = 4 }
W.zoom = Z

local wipe = table.wipe or wipe or function(t) for k in pairs(t) do t[k] = nil end return t end
local CARD_W, CARD_H = 1002, 668
local TILE, COLUMNS, ROWS = 256, 4, 3

local function tile(k)
	return _G["WorldMapDetailTile" .. k]
end

local function ready()
	return W.built and W.canvas and WorldMapDetailFrame and WorldMapButton and WORLDMAP_SETTINGS
end

-- Screen pixels per map unit
local function pixelsPerUnit()
	return WorldMapDetailFrame:GetEffectiveScale() * Z.z
end

-- The view: the canvas rectangle in map units, origin at the map's top left
local function viewSize()
	local c, d = W.canvas, WorldMapDetailFrame
	local k = c:GetEffectiveScale() / d:GetEffectiveScale() / Z.z
	return c:GetWidth() * k, c:GetHeight() * k
end

local function view()
	local vw, vh = viewSize()
	local x, y = Z.cx * CARD_W, Z.cy * CARD_H
	return x - vw / 2, y - vh / 2, x + vw / 2, y + vh / 2
end
Z.view = view

-- Keep the center where the view stays inside the map
local function clampView()
	local vw, vh = viewSize()
	local halfX, halfY = vw / 2 / CARD_W, vh / 2 / CARD_H
	if halfX >= 0.5 then Z.cx = 0.5 else Z.cx = math.max(halfX, math.min(1 - halfX, Z.cx)) end
	if halfY >= 0.5 then Z.cy = 0.5 else Z.cy = math.max(halfY, math.min(1 - halfY, Z.cy)) end
end

-- ------------------------------------------------------------------ Art

-- 3.3.5 clips nothing outside a ScrollFrame and client frames are never reparented, so each
-- piece of art is cropped to the view: its visible part, at its place x zoom, with matching
-- tex coords. x, y, w, h: the piece in map units; u0, u1, v0, v1: its tex coords.
local function cropRegion(t, x, y, w, h, u0, u1, v0, v1, x0, y0, x1, y1)
	local d, z = WorldMapDetailFrame, Z.z
	local ix0, iy0 = math.max(x, x0), math.max(y, y0)
	local ix1 = math.min(x + w, CARD_W, x1)
	local iy1 = math.min(y + h, CARD_H, y1)
	t:ClearAllPoints()
	if ix1 - ix0 < 0.01 or iy1 - iy0 < 0.01 then
		t:SetPoint("TOPLEFT", d, "TOPLEFT", x * z, -y * z)
		t:SetWidth(1)
		t:SetHeight(1)
		t:SetAlpha(0)
	else
		local du, dv = (u1 - u0) / w, (v1 - v0) / h
		t:SetPoint("TOPLEFT", d, "TOPLEFT", ix0 * z, -iy0 * z)
		t:SetWidth((ix1 - ix0) * z)
		t:SetHeight((iy1 - iy0) * z)
		t:SetTexCoord(u0 + (ix0 - x) * du, u0 + (ix1 - x) * du, v0 + (iy0 - y) * dv, v0 + (iy1 - y) * dv)
		t:SetAlpha(1)
	end
end

-- Explored areas (WorldMapOverlay<n>, laid out by WorldMapFrame_Update in map units from the
-- map's top left): each piece's place, size and tex coords, read after the client sets them
local function overlay(i)
	return _G["WorldMapOverlay" .. i]
end

local function recordOverlays()
	for i = 1, NUM_WORLDMAP_OVERLAYS or 0 do
		local o = overlay(i)
		if o and o:IsShown() then
			local _, _, _, x, y = o:GetPoint(1)
			local ulx, uly, llx, lly, urx = o:GetTexCoord()
			o.foreverZoomArt = { x or 0, -(y or 0), o:GetWidth(), o:GetHeight(),
				ulx or 0, urx or 1, uly or 0, lly or 1 }
		elseif o then
			o.foreverZoomArt = nil
		end
	end
end

local function restoreOverlays()
	for i = 1, NUM_WORLDMAP_OVERLAYS or 0 do
		local o = overlay(i)
		local a = o and o.foreverZoomArt
		if a then
			o:ClearAllPoints()
			o:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", a[1], -a[2])
			o:SetWidth(a[3])
			o:SetHeight(a[4])
			o:SetTexCoord(a[5], a[6], a[7], a[8])
			o:SetAlpha(1)
			o.foreverZoomArt = nil
		end
	end
end

local function cropTexture()
	local x0, y0, x1, y1 = view()
	for rowLine = 1, ROWS do
		for column = 1, COLUMNS do
			local t = tile((rowLine - 1) * COLUMNS + column)
			if t then
				cropRegion(t, (column - 1) * TILE, (rowLine - 1) * TILE, TILE, TILE, 0, 1, 0, 1,
					x0, y0, x1, y1)
			end
		end
	end
	for i = 1, NUM_WORLDMAP_OVERLAYS or 0 do
		local o = overlay(i)
		local a = o and o.foreverZoomArt
		if a and o:IsShown() then
			cropRegion(o, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], x0, y0, x1, y1)
		end
	end
end

-- Tile anchors from WorldMapFrame.xml (541-636): the first at the corner, each right of the
-- previous one, each row under the first tile of the row above; then the small-window crop
-- (WorldMap.lua)
local function rechainTiles()
	for k = 1, COLUMNS * ROWS do
		local t = tile(k)
		if t then
			t:ClearAllPoints()
			t:SetAlpha(1)
			if k == 1 then
				t:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", 0, 0)
			elseif (k - 1) % COLUMNS == 0 then
				t:SetPoint("TOPLEFT", tile(k - COLUMNS), "BOTTOMLEFT", 0, 0)
			else
				t:SetPoint("TOPLEFT", tile(k - 1), "TOPRIGHT", 0, 0)
			end
		end
	end
	if W.cropTiles then W.cropTiles(true) end
end

-- --------------------------------------------------------------- Markers

-- A marker out of the view fades out and releases the mouse (invisible, it would still
-- steal hover and clicks from the quest log or the frame); back in view, it gets its alpha
-- and mouse back
local function turnOff(f)
	f.foreverZoomAlpha = f:GetAlpha()
	f.foreverZoomMouse = f.IsMouseEnabled and f:IsMouseEnabled() and true or false
	f:SetAlpha(0)
	if f.foreverZoomMouse then f:EnableMouse(false) end
end

local function restore(f)
	f:SetAlpha(f.foreverZoomAlpha)
	if f.foreverZoomMouse then f:EnableMouse(true) end
	f.foreverZoomAlpha, f.foreverZoomMouse = nil, nil
end

-- Fade out the markers outside the view, restore those back inside
local function sortBy()
	local c = W.canvas
	local e = c:GetEffectiveScale()
	local left, down, right, top = c:GetLeft(), c:GetBottom(), c:GetRight(), c:GetTop()
	if not (left and down and right and top) then return end
	left, down, right, top = left * e, down * e, right * e, top * e
	for _, parent in ipairs({ WorldMapButton, WorldMapPOIFrame }) do
		if parent then
			for _, f in ipairs({ parent:GetChildren() }) do
				if f ~= WorldMapFrameAreaFrame and f:IsShown() then
					local x, y = f:GetCenter()
					local fe = f:GetEffectiveScale()
					local inside = not x or (x * fe >= left and x * fe <= right and y * fe >= down and y * fe <= top)
					if inside then
						if f.foreverZoomAlpha then restore(f) end
					elseif not f.foreverZoomAlpha then
						turnOff(f)
					end
				end
			end
		end
	end
end

local function restoreChildren()
	for _, parent in ipairs({ WorldMapButton, WorldMapPOIFrame }) do
		if parent then
			for _, f in ipairs({ parent:GetChildren() }) do
				if f.foreverZoomAlpha then restore(f) end
			end
		end
	end
end

-- Quest POIs (children of WorldMapPOIFrame, 32 x 32 at its scale) keep on screen the size
-- they have in the small window: the full screen scales WorldMapFrame up to fit the map to the
-- screen, which doubled them. Their scale is the small window's over the current one.
local function markerScale(parent)
	if parent ~= WorldMapPOIFrame or not W.reducedScale or not UIParent then return 1 end
	local now = WorldMapPOIFrame:GetEffectiveScale() / UIParent:GetEffectiveScale()
	if not now or now <= 0 then return 1 end
	return W.reducedScale() / now
end

-- Markers anchored to the map's top left. Their offsets (from the client, in their parent's
-- units) are kept as a base at zoom 1, then written x zoom / their scale: landmarks and quest
-- POIs placed once follow the zoom, quest POIs keep their size. Markers the client places on
-- each frame (units) already follow the map's width. foreverZoomSet remembers what was
-- written here, to tell it from offsets the client wrote since, at zoom clientZoom.
local function placeMarkers(clientZoom)
	local d, b, p = WorldMapDetailFrame, WorldMapButton, WorldMapPOIFrame
	for _, parent in ipairs({ b, p, d }) do
		if parent then
			local m = markerScale(parent)
			for _, f in ipairs({ parent:GetChildren() }) do
				if f ~= b and f ~= p and f ~= WorldMapBlobFrame and f ~= WorldMapFrameAreaFrame
					and f:GetNumPoints() == 1 then
					local point, rel, relPoint, x, y = f:GetPoint(1)
					if (rel == d or rel == b or rel == p) and relPoint == "TOPLEFT" and x and y then
						local s = f.foreverZoomSet
						local bx, by
						if s and math.abs(s[1] - x) < 1e-3 and math.abs(s[2] - y) < 1e-3 then
							bx, by = s[3], s[4]
						else
							bx, by = x / clientZoom, y / clientZoom
						end
						if parent == p and math.abs((f:GetScale() or 1) - m) > 1e-6 then
							f:SetScale(m)
						end
						local nx, ny = bx * Z.z / m, by * Z.z / m
						if math.abs(nx - x) > 1e-3 or math.abs(ny - y) > 1e-3 then
							f:ClearAllPoints()
							f:SetPoint(point, rel, relPoint, nx, ny)
						end
						f.foreverZoomSet = { nx, ny, bx, by }
					elseif parent == p and rel and rel ~= d and rel ~= b and rel ~= p then
						-- Placed on another marker (the selected completed quest: QuestPOI_SelectButton
						-- shows a QUEST_POI_COMPLETE_SWAP button on the CENTER of the selected one):
						-- the same scale, its place follows the marker it sits on
						if math.abs((f:GetScale() or 1) - m) > 1e-6 then
							f:SetScale(m)
						end
					end
				end
			end
		end
	end
end
Z.placeMarkers = placeMarkers

-- ----------------------------------------------------------------- Areas

-- The quest areas while zoomed. The client's WorldMapBlobFrame lays its areas out once, where and
-- how large it is when DrawQuestBlob runs; its frame alpha does not reach them (their own fill
-- and border alphas do) and nothing crops it (seen in game on the minimap, MinimapQuests.lua).
-- While zoomed it is turned invisible (fill and border alpha 0) and a mirror draws the same
-- quests (DrawQuestBlob hooked) at the zoomed size, in a ScrollFrame over the view: drawn while
-- the ScrollFrame is opened over the whole enlarged map, then left as it shrinks back to the view.
-- WorldMapBlobFrame_OnLoad: fill alpha 128, border alpha 192.
local BLOB_FILL, BLOB_BORDER = 128, 192
local areas = { drawn = {} }

if WorldMapBlobFrame and hooksecurefunc and WorldMapBlobFrame.DrawQuestBlob then
	hooksecurefunc(WorldMapBlobFrame, "DrawQuestBlob", function(_, questId, show)
		if not questId then return end
		areas.drawn[questId] = show and true or nil
		if Z.active and Z.drawAreas then Z.drawAreas() end
	end)
end

local function areaFrames()
	if areas.clip or not (WorldMapDetailFrame and CreateFrame) then return areas.clip end
	local ok, blob = pcall(CreateFrame, "QuestPOIFrame", nil, WorldMapDetailFrame)
	if not ok or not blob then return nil end
	local clip = CreateFrame("ScrollFrame", nil, WorldMapDetailFrame)
	local child = CreateFrame("Frame", nil, clip)
	clip:SetScrollChild(child)
	blob:SetParent(child)
	if blob.SetFillTexture then
		blob:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside")
		blob:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside")
		blob:SetFillAlpha(BLOB_FILL)
		blob:SetBorderAlpha(BLOB_BORDER)
		blob:SetBorderScalar(1.0)
	end
	-- where the client's areas draw: above the map, under its POIs
	if WorldMapBlobFrame then clip:SetFrameLevel(WorldMapBlobFrame:GetFrameLevel()) end
	areas.clip, areas.child, areas.blob, areas.mirrored = clip, child, blob, {}
	return clip
end

local function placeClip(x, y, w, h)
	areas.clip:ClearAllPoints()
	areas.clip:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", x, -y)
	areas.clip:SetWidth(w)
	areas.clip:SetHeight(h)
	areas.child:SetWidth(w)
	areas.child:SetHeight(h)
end

-- Draws the mirror at the current zoom and view. again: the drawing of a frame after a change
function Z.drawAreas(again)
	if not (Z.active and areaFrames()) then return end
	local z, blob = Z.z, areas.blob
	local mw, mh = CARD_W * z, CARD_H * z
	areas.clip:Show()
	placeClip(0, 0, mw, mh)
	blob:ClearAllPoints()
	blob:SetPoint("TOPLEFT", areas.child, "TOPLEFT", 0, 0)
	blob:SetWidth(mw)
	blob:SetHeight(mh)
	if blob.DrawQuestBlob then
		-- no DrawNone in 3.3.5: each area is taken off, then drawn where the frame now is
		for id in pairs(areas.mirrored) do blob:DrawQuestBlob(id, false) end
		wipe(areas.mirrored)
		for id in pairs(areas.drawn) do
			blob:DrawQuestBlob(id, true)
			areas.mirrored[id] = true
		end
	end
	-- back to the view, the map's part in the canvas (map units x zoom)
	local x0, y0, x1, y1 = view()
	x0, y0 = math.max(0, x0), math.max(0, y0)
	x1, y1 = math.min(CARD_W, x1), math.min(CARD_H, y1)
	placeClip(x0 * z, y0 * z, (x1 - x0) * z, (y1 - y0) * z)
	blob:ClearAllPoints()
	blob:SetPoint("TOPLEFT", areas.child, "TOPLEFT", -x0 * z, y0 * z)
	-- a new place or size reaches the engine on the next frame: drawn again on the frame after a
	-- pan, on the two after a zoom
	if not again then
		areas.again = math.abs(mw - (areas.width or 0)) > 0.01 and 2 or math.max(areas.again or 0, 1)
		areas.width = mw
	end
end

local function hideAreas()
	if areas.clip then areas.clip:Hide() end
	areas.width = nil
end

-- The client's hover test (WorldMapBlobFrame_OnUpdate) reads fractions of WorldMapBlobFrame's
-- rectangle: while zoomed, fractions of the enlarged map instead
if hooksecurefunc and WorldMapBlobFrame_CalculateHitTranslations then
	hooksecurefunc("WorldMapBlobFrame_CalculateHitTranslations", function()
		if not (Z.active and WorldMapBlobFrame and WorldMapDetailFrame) then return end
		local d = WorldMapDetailFrame
		local left, top, width, height = d:GetLeft(), d:GetTop(), d:GetWidth(), d:GetHeight()
		if not (left and top and width and width > 0) then return end
		local scale = d:GetEffectiveScale()
		local b = WorldMapBlobFrame
		b.xRatio, b.xOffset = width * scale, left / width
		b.yRatio, b.yOffset = height * scale, top / height
	end)
end

-- ------------------------------------------------------------- Apply

-- Current map key: a map change resets the zoom to 1
function Z.mapKey()
	return tostring(GetCurrentMapAreaID and GetCurrentMapAreaID()) .. ":" ..
		tostring(GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel())
end

-- The enlarged frames: WorldMapDetailFrame and WorldMapButton (siblings, same scale and corner).
-- WorldMapFrame_DisplayQuestPOI keeps quest POIs inside bounds read from the map's width
-- (WorldMapFrame_SetPOIMaxBounds, on opening and mode change): without new bounds, each time
-- the client places them again (a selection, a quest update) the zoomed POIs past the
-- unzoomed map's edge were pushed back onto it.
local function enlarge()
	for f, s in pairs(Z.sizes) do
		f:SetWidth(s[1] * Z.z)
		f:SetHeight(s[2] * Z.z)
	end
	if WorldMapFrame_SetPOIMaxBounds then
		WorldMapFrame_SetPOIMaxBounds()
	end
end

-- The quest areas: WorldMapBlobFrame turns invisible while zoomed and a mirror draws them zoomed
-- (see Areas); WorldMapButton's hit rect is limited to the view.
-- old: the zoom before this change (markers placed once follow it)
function Z.apply(old)
	local d = WorldMapDetailFrame
	if not Z.active then
		Z.active = true
		Z.points = {}
		for i = 1, d:GetNumPoints() do
			Z.points[i] = { d:GetPoint(i) }
		end
		Z.sizes = {
			[d] = { d:GetWidth(), d:GetHeight() },
			[WorldMapButton] = { WorldMapButton:GetWidth(), WorldMapButton:GetHeight() },
		}
		Z.key = Z.mapKey()
		recordOverlays()
		old = 1
	end
	old = old or Z.z
	local z = Z.z
	enlarge()
	clampView()
	d:ClearAllPoints()
	d:SetPoint("CENTER", W.canvas, "CENTER", (0.5 - Z.cx) * CARD_W * z, (Z.cy - 0.5) * CARD_H * z)
	if WorldMapBlobFrame then
		if WorldMapBlobFrame.SetFillAlpha then
			WorldMapBlobFrame:SetFillAlpha(0)
			WorldMapBlobFrame:SetBorderAlpha(0)
		end
		if WorldMapBlobFrame_CalculateHitTranslations then WorldMapBlobFrame_CalculateHitTranslations() end
	end
	local a = WorldMapFrameAreaFrame
	if a then
		a:ClearAllPoints()
		a:SetPoint("TOP", W.canvas, "TOP", 0, -10)
	end
	local x0, y0, x1, y1 = view()
	WorldMapButton:SetHitRectInsets(math.max(0, x0) * z, math.max(0, CARD_W - x1) * z,
		math.max(0, y0) * z, math.max(0, CARD_H - y1) * z)
	cropTexture()
	placeMarkers(old)
	sortBy()
	Z.drawAreas()
end

-- Back to the whole map. After a mode change, the client and WorldMap.lua have just set
-- their own anchors: the map's is kept then.
function Z.reset(isModeChange)
	if not Z.active then
		Z.z = 1
		return
	end
	local old = Z.z
	Z.z = 1
	Z.active = false
	enlarge()
	local d = WorldMapDetailFrame
	if not isModeChange and Z.points then
		d:ClearAllPoints()
		for _, p in ipairs(Z.points) do
			d:SetPoint(p[1], p[2], p[3], p[4], p[5])
		end
	end
	if WorldMapBlobFrame then
		if WorldMapBlobFrame.SetFillAlpha then
			WorldMapBlobFrame:SetFillAlpha(BLOB_FILL)
			WorldMapBlobFrame:SetBorderAlpha(BLOB_BORDER)
		end
		if WorldMapBlobFrame_CalculateHitTranslations then WorldMapBlobFrame_CalculateHitTranslations() end
	end
	hideAreas()
	local a = WorldMapFrameAreaFrame
	if a then
		a:ClearAllPoints()
		a:SetPoint("TOP", WorldMapButton, "TOP", 0, -10)
	end
	WorldMapButton:SetHitRectInsets(0, 0, 0, 0)
	WorldMapButton:EnableMouse(true)
	Z.pressPoint, Z.dragging = nil, false
	rechainTiles()
	restoreOverlays()
	placeMarkers(old)
	restoreChildren()
	Z.cx, Z.cy = 0.5, 0.5
end

-- ------------------------------------------------------------- Mouse wheel

-- Map point under the cursor, and the cursor offset from the canvas center in screen pixels
local function pointUnderCursor()
	local x, y = GetCursorPosition()
	local c = W.canvas
	local cx, cy = c:GetCenter()
	if not cx then return nil end
	local ce = c:GetEffectiveScale()
	local dx, dy = x - cx * ce, y - cy * ce
	local de = pixelsPerUnit()
	return Z.cx + dx / (CARD_W * de), Z.cy - dy / (CARD_H * de), dx, dy, de
end

function Z.wheel(direction)
	if not ready() then return end
	local old = Z.z
	local new = direction > 0 and old * Z.STEP or old / Z.STEP
	if new > Z.MAX then new = Z.MAX end
	if new < 1.0001 then new = 1 end
	if new == old then return end
	if new == 1 then
		Z.reset(false)
		return
	end
	if not Z.active then Z.cx, Z.cy = 0.5, 0.5 end
	-- Keep the point under the cursor in place (camelot: SetPanTarget)
	local fx, fy, dx, dy, de = pointUnderCursor()
	Z.z = new
	if fx then
		local de2 = de * new / old
		Z.cx = fx - dx / (CARD_W * de2)
		Z.cy = fy + dy / (CARD_H * de2)
	end
	Z.apply(old)
end

-- --------------------------------------------------------------- Watcher

local mapKey = Z.mapKey

-- Child of the map frame, so it only runs while the map is open
local watcher = CreateFrame("Frame", nil, WorldMapFrame)
watcher:SetScript("OnUpdate", function(_, elapsed)
	-- Markers the client placed since the last pass (ten passes a second)
	Z.markWait = (Z.markWait or 0) - elapsed
	if Z.markWait <= 0 and ready() and not Z.dragging then
		Z.markWait = 0.1
		placeMarkers(Z.z)
	end
	if not (Z.active and ready()) then
		Z.key = ready() and mapKey() or nil
		return
	end
	if mapKey() ~= Z.key then
		Z.reset(false)
		Z.key = mapKey()
		return
	end
	-- Drag: past THRESHOLD pixels the map follows the cursor. WorldMapButton_OnClick navigates
	-- on mouse up, so WorldMapButton releases the mouse until the button is up. The client code
	-- is not wrapped: it closes dropdowns and would taint their state if called from the addon.
	local pressPoint = Z.pressPoint
	if pressPoint then
		local x, y = GetCursorPosition()
		if not IsMouseButtonDown("LeftButton") then
			Z.pressPoint = nil
			if Z.dragging then
				Z.dragging = false
				WorldMapButton:EnableMouse(true)
			end
		else
			if not Z.dragging and math.abs(x - pressPoint.x) + math.abs(y - pressPoint.y) > Z.THRESHOLD then
				Z.dragging = true
				WorldMapButton:EnableMouse(false)
			end
			if Z.dragging then
				local de = pixelsPerUnit()
				Z.cx = pressPoint.cx - (x - pressPoint.x) / (CARD_W * de)
				Z.cy = pressPoint.cy + (y - pressPoint.y) / (CARD_H * de)
				Z.apply()
				return
			end
		end
	end
	-- A new place or zoom reaches the engine on the next frame: the areas are drawn again after
	if areas.again and areas.again > 0 then
		areas.again = areas.again - 1
		Z.drawAreas(true)
	end
	-- Markers move with their units: ten passes a second are enough (Z.apply sorts at once).
	-- Each pass reads every child of the map buttons (about sixty) and builds three tables.
	Z.sortWait = (Z.sortWait or 0) - elapsed
	if Z.sortWait <= 0 then
		Z.sortWait = 0.1
		sortBy()
	end
end)
Z.watcher = watcher

-- ------------------------------------------------------------ Hooks

if WorldMapButton then
	WorldMapButton:EnableMouseWheel(true)
	WorldMapButton:SetScript("OnMouseWheel", function(_, direction)
		Z.wheel(direction)
	end)
	WorldMapButton:HookScript("OnMouseDown", function(_, button)
		if button == "LeftButton" and Z.active then
			local x, y = GetCursorPosition()
			Z.pressPoint = { x = x, y = y, cx = Z.cx, cy = Z.cy }
			Z.dragging = false
		end
	end)
	-- Player arrow: WorldMapButton_OnUpdate places it (position x the map's width x
	-- WORLDMAP_SETTINGS.size); place it again, or hide it out of the view
	WorldMapButton:HookScript("OnUpdate", function()
		if not Z.active then return end
		local x, y = GetPlayerMapPosition("player")
		if not x or (x == 0 and y == 0) then return end
		local px, py = x * CARD_W, y * CARD_H
		local x0, y0, x1, y1 = view()
		if px < x0 or px > x1 or py < y0 or py > y1 then
			if ShowWorldMapArrowFrame then ShowWorldMapArrowFrame(nil) end
		elseif PositionWorldMapArrowFrame then
			local s = WORLDMAP_SETTINGS.size * Z.z
			PositionWorldMapArrowFrame("CENTER", "WorldMapDetailFrame", "TOPLEFT", px * s, -py * s)
		end
	end)
end

if WorldMapFrame then
	WorldMapFrame:HookScript("OnHide", function() Z.reset(false) end)
end

-- WorldMapFrame_Update reloads the tiles and lays out the explored areas again
-- (WORLD_MAP_UPDATE): crop them again while zoomed
if WorldMapFrame_Update then
	hooksecurefunc("WorldMapFrame_Update", function()
		if Z.active then
			recordOverlays()
			cropTexture()
		end
		if ready() then placeMarkers(Z.z) end
	end)
end

-- A quest POI selected: its swap button appears
if QuestPOI_SelectButton then
	hooksecurefunc("QuestPOI_SelectButton", function()
		if ready() then placeMarkers(Z.z) end
	end)
end

-- The quest POIs, placed again on each quest update
if WorldMapFrame_DisplayQuests then
	hooksecurefunc("WorldMapFrame_DisplayQuests", function()
		if ready() then placeMarkers(Z.z) end
	end)
end

-- Mode or view change: back to 1, without undoing what the client has just set
for _, name in ipairs({ "WorldMap_ToggleSizeDown", "WorldMap_ToggleSizeUp", "WorldMapFrame_SetMiniMode",
	"WorldMapFrame_SetQuestMapView", "WorldMapFrame_SetFullMapView" }) do
	if _G[name] then
		hooksecurefunc(name, function()
			Z.reset(true)
			if ready() then placeMarkers(Z.z) end
		end)
	end
end
