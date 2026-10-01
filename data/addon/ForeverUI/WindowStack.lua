-- ForeverUI: keeps the large windows (character sheet, spellbook, talents) from interleaving,
-- lets them be moved, and scales them down when the screen is too small. Each window sets
-- explicit frame levels relative to its root, so two roots of the same strata mix on screen,
-- and Raise only lifts the root. Open windows are stacked back to front instead; an opened or
-- clicked window comes to the front.

ForeverUI = ForeverUI or {}

local P = { windows = {}, order = {} }
ForeverUI.WindowStack = P

-- Highest frame level in a subtree
local function highestLevel(frame)
	local n = frame:GetFrameLevel()
	for _, child in ipairs({ frame:GetChildren() }) do
		local m = highestLevel(child)
		if m > n then n = m end
	end
	return n
end

-- Lowest frame level in a subtree: a client frame can sit below its root
local function lowestLevel(frame)
	local n = frame:GetFrameLevel()
	for _, child in ipairs({ frame:GetChildren() }) do
		local m = lowestLevel(child)
		if m < n then n = m end
	end
	return n
end

-- Frame levels of a subtree, parents before children
local function collect(frame, list)
	table.insert(list, { frame, frame:GetFrameLevel() })
	for _, child in ipairs({ frame:GetChildren() }) do collect(child, list) end
	return list
end

-- Moves the root to a level and shifts its descendants by the same gap. Depending on the
-- client, SetFrameLevel may already move the children, so only misplaced frames are reset.
local function placeLevel(root, level)
	local gap = level - root:GetFrameLevel()
	if gap == 0 then return end
	for _, e in ipairs(collect(root, {})) do
		local wanted = math.max(0, e[2] + gap)
		if e[1]:GetFrameLevel() ~= wanted then e[1]:SetFrameLevel(wanted) end
	end
end

-- In combat a protected root (the spellbook has secure buttons) cannot change level;
-- the other windows stack around it.
local function isBlocked(f)
	return InCombatLockdown() and f.root.IsProtected and f.root:IsProtected()
end

local function openWindows()
	local l = {}
	for _, key in ipairs(P.order) do
		local f = P.windows[key]
		if f.root:IsVisible() then table.insert(l, f) end
	end
	return l
end

-- Puts the given window at the front and restacks the open windows in order
function P.bringToFront(key)
	local f = P.windows[key]
	if not f then return end
	for i, c in ipairs(P.order) do
		if c == key then table.remove(P.order, i) break end
	end
	table.insert(P.order, key)
	local level
	for _, g in ipairs(openWindows()) do
		-- Each window's lowest frame goes one level above the previous window's highest frame;
		-- the back window returns to its base level, so levels do not grow with each click.
		if not isBlocked(g) then
			if level then
				placeLevel(g.root, g.root:GetFrameLevel() + level - lowestLevel(g.root))
			else
				placeLevel(g.root, g.base)
			end
		end
		level = highestLevel(g.root) + 1
	end
end

-- Front-most open window under the mouse
local function underMouse()
	local l = openWindows()
	for i = #l, 1, -1 do
		for _, zone in ipairs(l[i].zones()) do
			if zone and zone:IsVisible() and MouseIsOver(zone) then return l[i] end
		end
	end
end

-- Registers a window. root: frame whose level moves; zones: function returning the frames
-- that belong to the window on screen (overflowing art, outside tabs)
function P.register(key, root, zones)
	if P.windows[key] then return end
	P.windows[key] = { key = key, root = root, zones = zones, base = root:GetFrameLevel() }
	table.insert(P.order, key)
	root:HookScript("OnShow", function() P.bringToFront(key) end)
	if root:IsVisible() then P.bringToFront(key) end
end

-- Detects clicks on the next frame: 3.3.5 has no global click event, and a click on a
-- button does not reach its parent. Nothing to do while only one window is open.
local watcher = CreateFrame("Frame")
P.watcher = watcher
local pressed = false
watcher:SetScript("OnUpdate", function()
	local down = IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")
	if down and not pressed then
		local l = openWindows()
		-- Restack even when the front window is clicked: the client's Raise (toplevel roots)
		-- only lifts the root
		if #l > 1 then
			local f = underMouse()
			if f then P.bringToFront(f.key) end
		end
	end
	pressed = down and true or false
end)

-- ---------- Moving
-- Saved window positions (ForeverUIDB), read on each show: saved variables load after the files
local function positions()
	ForeverUIDB = ForeverUIDB or {}
	ForeverUIDB.positions = ForeverUIDB.positions or {}
	return ForeverUIDB.positions
end

-- Scale of a frame relative to UIParent
local function relativeScale(frame)
	return frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
end

-- Anchors a window by its top center. x, y: offset from UIParent's top center, in UIParent
-- units (anchor offsets count in the frame's own units, hence the division by its scale)
local function anchorTop(frame, x, y)
	local k = relativeScale(frame)
	frame:ClearAllPoints()
	frame:SetPoint("TOP", UIParent, "TOP", x / k, y / k)
end

-- Makes a window draggable by its title bar and remembers its position.
-- frame: window; handle: drag area; key: saved position key
-- The window is re-anchored by its top center, so width changes (small spellbook, pet
-- talents) stay centered. Out of combat only: the spellbook has secure buttons.
function P.makeMovable(frame, handle, key)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	handle:EnableMouse(true)
	handle:RegisterForDrag("LeftButton")
	handle:SetScript("OnDragStart", function()
		if not InCombatLockdown() then frame:StartMoving() end
	end)
	handle:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing()
		if InCombatLockdown() then return end
		local k = relativeScale(frame)
		local cx = frame:GetCenter()
		local ux = UIParent:GetCenter()
		local x, y = cx * k - ux, frame:GetTop() * k - UIParent:GetTop()
		anchorTop(frame, x, y)
		-- The position is ours: the client must not save it too
		if frame.SetUserPlaced then frame:SetUserPlaced(false) end
		positions()[key] = { x = x, y = y }
	end)
	local function restorePosition()
		local p = positions()[key]
		if not p or InCombatLockdown() then return end
		anchorTop(frame, p.x, p.y)
	end
	frame:HookScript("OnShow", restorePosition)
	restorePosition()
end

-- ---------- Fitting to the screen
-- camelot's checkFit (UIParentPanelManager, FrameUtil.UpdateScaleForFitSpecific): a window
-- that does not fit in UIParent with its margins is scaled down until it does. The scale goes
-- on the client panel holding the window, so the close button the panel keeps scales with it.
-- The default position is clamped like ClampUIPanelY: bottom at least 140 above the screen's,
-- top at least 10 below it.
local fits = {}
local CLAMP_BOTTOM, CLAMP_TOP = 140, -10
-- Nothing is resized between PLAYER_LEAVING_WORLD / PLAYER_LOGOUT and PLAYER_ENTERING_WORLD:
-- moving the talent window while the client destroys the UI crashes it (Talents.lua)
local leaving = false

local function fit(f)
	if leaving or not f.panel:IsVisible() then return end
	-- the spellbook holds secure buttons: in combat, scale and anchor wait for its end
	if InCombatLockdown() then
		f.pending = true
		return
	end
	f.pending = nil
	local k = math.min(1, UIParent:GetWidth() / (f.frame:GetWidth() + f.extraW),
		UIParent:GetHeight() / (f.frame:GetHeight() + f.extraH))
	if math.abs(f.panel:GetScale() - k) > 0.001 then f.panel:SetScale(k) end
	local p = positions()[f.key]
	if p then
		anchorTop(f.frame, p.x, p.y)
		return
	end
	-- UIParent starts at the screen's bottom: its top is its height
	local y = f.y
	local bottom = UIParent:GetHeight() + y - f.frame:GetHeight() * relativeScale(f.frame)
	if bottom < CLAMP_BOTTOM then y = y + CLAMP_BOTTOM - bottom end
	anchorTop(f.frame, f.x, math.min(y, CLAMP_TOP))
end

-- Scales a window down when it does not fit the screen. key: saved position key
-- (makeMovable); panel: client frame holding the window, whose scale is set; frame: the
-- window, anchored by its top center; x, y: its default offset from UIParent's top center,
-- in UIParent units; extraW, extraH: margins (checkFitExtraWidth, checkFitExtraHeight)
function P.fitToScreen(key, panel, frame, x, y, extraW, extraH)
	local f = { key = key, panel = panel, frame = frame, x = x, y = y, extraW = extraW, extraH = extraH }
	fits[key] = f
	panel:HookScript("OnShow", function() fit(f) end)
	frame:HookScript("OnSizeChanged", function() fit(f) end)
	fit(f)
end

local fitWatcher = CreateFrame("Frame")
for _, event in ipairs({ "DISPLAY_SIZE_CHANGED", "UI_SCALE_CHANGED", "PLAYER_REGEN_ENABLED",
	"PLAYER_ENTERING_WORLD", "PLAYER_LEAVING_WORLD", "PLAYER_LOGOUT" }) do
	fitWatcher:RegisterEvent(event)
end
fitWatcher:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LEAVING_WORLD" or event == "PLAYER_LOGOUT" then
		leaving = true
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then leaving = false end
	for _, f in pairs(fits) do
		if event ~= "PLAYER_REGEN_ENABLED" or f.pending then fit(f) end
	end
end)
