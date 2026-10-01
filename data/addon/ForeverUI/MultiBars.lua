-- ForeverUI: the four extra action bars of 3.3.5 placed as camelot's Action Bars 2 to 5
-- (mainline EditModePresetLayouts, shared EditModeManager): twelve buttons of 45, 2 apart.
-- Bars 2 and 3 (bottom left / right) stand side by side above the experience and reputation
-- bars, 22 and 606 right of the main bar's left edge; the stance and pet bars then rise by one
-- row. Bars 4 and 5 (right, right 2) stand upright against the right edge, RIGHT (-5, -77),
-- the fifth 5 left of the fourth. In the main bar's strata, under windows and bags, kept on
-- screen, movable and resizable in edit mode. Their buttons are secure: nothing is laid out
-- in combat.

ForeverUI = ForeverUI or {}

local BUTTON_COUNT = 12
local BUTTON_PITCH = 45 + 2       -- ActionButtonTemplate 45, IconPadding 2
local LENGTH = BUTTON_COUNT * BUTTON_PITCH - 2
local LEFT_EDGE = -587.5          -- left edge of the main bar, from the screen center
local ROW_Y = 84                  -- above the reputation bar
local ROW_SPACING = 4             -- BOTTOM_ACTION_BARS_SPACER_Y
local RIGHT_X, RIGHT_Y = -5, -77  -- RIGHT_ACTION_BAR_DEFAULT_OFFSET_X / _Y
local RIGHT_GAP = 5               -- between the two right bars

local M = {}
ForeverUI.MultiBars = M

-- frame: the client bar; prefix: its buttons; label: edit mode name (client strings);
-- vertical: one column; point, x, y: default anchor on UIParent (relative point = point,
-- except the bottom row, anchored on the screen's bottom center)
M.bars = {
	{ frame = MultiBarBottomLeft, prefix = "MultiBarBottomLeftButton", id = "multibarbottomleft",
		label = SHOW_MULTIBAR1_TEXT, point = "BOTTOMLEFT", relativePoint = "BOTTOM", x = LEFT_EDGE + 22, y = ROW_Y },
	{ frame = MultiBarBottomRight, prefix = "MultiBarBottomRightButton", id = "multibarbottomright",
		label = SHOW_MULTIBAR2_TEXT, point = "BOTTOMLEFT", relativePoint = "BOTTOM", x = LEFT_EDGE + 606, y = ROW_Y },
	{ frame = MultiBarRight, prefix = "MultiBarRightButton", id = "multibarright", vertical = true,
		label = SHOW_MULTIBAR3_TEXT, point = "RIGHT", relativePoint = "RIGHT", x = RIGHT_X, y = RIGHT_Y },
	{ frame = MultiBarLeft, prefix = "MultiBarLeftButton", id = "multibarleft", vertical = true,
		label = SHOW_MULTIBAR4_TEXT, point = "RIGHT", relativePoint = "RIGHT",
		x = RIGHT_X - 45 - RIGHT_GAP, y = RIGHT_Y },
}

-- Buttons in one row or one column, the bar sized to them, in the main bar's strata
local function layout(bar)
	local f = bar.frame
	f:SetWidth(bar.vertical and 45 or LENGTH)
	f:SetHeight(bar.vertical and LENGTH or 45)
	local holder = ForeverUI.ActionBarHolder
	if holder then
		f:SetFrameStrata(holder:GetFrameStrata())
		f:SetFrameLevel(holder:GetFrameLevel())
	end
	for i = 1, BUTTON_COUNT do
		local button = _G[bar.prefix .. i]
		if button then
			button:ClearAllPoints()
			if bar.vertical then
				button:SetPoint("TOP", f, "TOP", 0, -(i - 1) * BUTTON_PITCH)
			else
				button:SetPoint("LEFT", f, "LEFT", (i - 1) * BUTTON_PITCH, 0)
			end
		end
	end
end

-- Height the bottom row adds under the stance and pet bars: a bar 2 or 3 shown where the
-- stack puts it (a bar the player moved leaves the stack, as in camelot)
function M.Lift()
	for k = 1, 2 do
		local bar = M.bars[k]
		if bar.frame and bar.frame:IsShown() and ForeverUI.Layout.IsDefault(bar.id) then
			return 45 + ROW_SPACING
		end
	end
	return 0
end

-- The stance and pet bars follow the bottom row; out of combat only (secure buttons)
local pending = false
function M.Restack()
	if InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	if ForeverUI.StanceBar and ForeverUI.StanceBar.PlaceDefault then ForeverUI.StanceBar.PlaceDefault() end
	if ForeverUI.PetBar and ForeverUI.PetBar.PlaceDefault then ForeverUI.PetBar.PlaceDefault() end
end

local laidOut = false
local function setup()
	if laidOut or InCombatLockdown() then return end
	laidOut = true
	for _, bar in ipairs(M.bars) do
		if bar.frame then
			layout(bar)
			ForeverUI.Layout.Register(bar.frame, bar.id, bar.label, bar.point, bar.relativePoint, bar.x, bar.y)
			-- UIParent_ManageFramePositions moves MultiBarBottomLeft and MultiBarRight again on many
			-- events; it leaves alone a frame marked as placed by the player
			bar.frame:SetUserPlaced(true)
			if bar.id == "multibarbottomleft" or bar.id == "multibarbottomright" then
				bar.frame:HookScript("OnShow", M.Restack)
				bar.frame:HookScript("OnHide", M.Restack)
			end
		end
	end
	M.Restack()
end

-- A bar 2 or 3 moved, resized or put back in edit mode joins or leaves the stack
hooksecurefunc(ForeverUI.Layout, "Apply", function(id)
	if laidOut and (id == "multibarbottomleft" or id == "multibarbottomright") then M.Restack() end
end)

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_LOGIN")
watcher:RegisterEvent("PLAYER_REGEN_ENABLED")
watcher:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		setup()
	elseif not laidOut then
		setup()
	elseif pending then
		M.Restack()
	end
end)
setup()
