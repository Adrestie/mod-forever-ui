-- ForeverUI: the four extra action bars of 3.3.5 placed as camelot's Action Bars 2 to 5
-- (mainline EditModePresetLayouts, shared EditModeManager): twelve buttons of 45, 2 apart, no
-- slot background. Bars 2 and 3 (bottom left / right) stand side by side above the experience
-- and reputation bars, 22 and 606 right of the main bar's left edge; the stance and pet bars
-- then rise by one row. Bars 4 and 5 (right, right 2) stand upright against the right edge,
-- RIGHT (-5, -77), the fifth 5 left of the fourth, shrunk if needed to fit between the right
-- gryphon and the minimap (UpdateRightActionBarPositions). In the LOW strata, under windows
-- and bags; kept on screen; movable and resizable in edit mode. Their buttons are secure:
-- nothing is laid out in combat.

ForeverUI = ForeverUI or {}

local BUTTON_COUNT = 12
local BUTTON_PITCH = 45 + 2       -- ActionButtonTemplate 45, IconPadding 2
local LENGTH = BUTTON_COUNT * BUTTON_PITCH - 2
local LEFT_EDGE = -587.5          -- left edge of the main bar, from the screen center
local ROW_Y = 84                  -- above the reputation bar
local ROW_SPACING = 4             -- BOTTOM_ACTION_BARS_SPACER_Y
local RIGHT_X, RIGHT_Y = -5, -77  -- RIGHT_ACTION_BAR_DEFAULT_OFFSET_X / _Y
local RIGHT_GAP = 5               -- between the two right bars
local FIT_MARGIN = 10             -- GetRightActionBarTopLimit: 10 under the minimap; as much above the gryphon

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

-- Buttons in one row or one column without slot background, the bar sized to them, under
-- every window and bag (the client puts these bars in HIGH)
local function layout(bar)
	local f = bar.frame
	f:SetWidth(bar.vertical and 45 or LENGTH)
	f:SetHeight(bar.vertical and LENGTH or 45)
	f:SetFrameStrata("LOW")
	f:SetFrameLevel(1)
	for i = 1, BUTTON_COUNT do
		local button = _G[bar.prefix .. i]
		if button then
			button:ClearAllPoints()
			if bar.vertical then
				button:SetPoint("TOP", f, "TOP", 0, -(i - 1) * BUTTON_PITCH)
			else
				button:SetPoint("LEFT", f, "LEFT", (i - 1) * BUTTON_PITCH, 0)
			end
			if button.foreverBackground then button.foreverBackground:Hide() end
			if button.foreverSlot then button.foreverSlot:Hide() end
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

-- Top of a region in UIParent units
local function top(region)
	local t = region:GetTop()
	return t and t * region:GetEffectiveScale() / UIParent:GetEffectiveScale()
end

-- Right bars in their default place: one scale for both, at most 1, so that their height fits
-- between the right gryphon and the minimap; then moved down or up as little as needed to
-- stay between them. A bar the player moved keeps its size.
local function fitRight()
	local minimap, caps = MinimapCluster, ForeverUI.ActionBarEndCaps
	local gryphon = caps and caps.right
	local high = UIParent:GetHeight()
	if minimap and minimap:IsShown() and ForeverUI.Layout.IsDefault("minimap") and minimap:GetBottom() then
		high = minimap:GetBottom() * minimap:GetEffectiveScale() / UIParent:GetEffectiveScale() - FIT_MARGIN
	end
	local low = 0
	if gryphon and gryphon:IsShown() and top(gryphon) then
		low = top(gryphon) + FIT_MARGIN
	end
	local scale = math.max(0.1, math.min(1, (high - low) / LENGTH))
	local half = LENGTH * scale / 2
	local center = UIParent:GetHeight() / 2 + RIGHT_Y
	if center + half > high then center = high - half end
	if center - half < low then center = low + half end
	for k = 3, 4 do
		local bar = M.bars[k]
		if bar.frame then
			local fixed = ForeverUI.Layout.IsDefault(bar.id)
			ForeverUI.Layout.SetDefaults(bar.id, bar.point, bar.relativePoint, bar.x,
				(center - UIParent:GetHeight() / 2) / scale)
			ForeverUI.Layout.SetBaseScale(bar.id, fixed and scale or 1)
		end
	end
end

-- The stance and pet bars follow the bottom row, the right bars their room; out of combat
-- only (secure buttons)
local pending, busy = false, false
function M.Restack()
	if InCombatLockdown() then
		pending = true
		return
	end
	if busy then return end
	busy, pending = true, false
	if ForeverUI.StanceBar and ForeverUI.StanceBar.PlaceDefault then ForeverUI.StanceBar.PlaceDefault() end
	if ForeverUI.PetBar and ForeverUI.PetBar.PlaceDefault then ForeverUI.PetBar.PlaceDefault() end
	fitRight()
	busy = false
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
			bar.frame:HookScript("OnShow", M.Restack)
			bar.frame:HookScript("OnHide", M.Restack)
		end
	end
	M.Restack()
end

-- An extra bar, the minimap or the right gryphon moved, resized or put back in edit mode
local FOLLOWED = { multibarbottomleft = true, multibarbottomright = true, multibarright = true,
	multibarleft = true, minimap = true, rightgryphon = true }
hooksecurefunc(ForeverUI.Layout, "Apply", function(id)
	if laidOut and FOLLOWED[id] then M.Restack() end
end)

local watcher = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "PLAYER_REGEN_ENABLED", "DISPLAY_SIZE_CHANGED", "UI_SCALE_CHANGED" }) do
	watcher:RegisterEvent(event)
end
watcher:SetScript("OnEvent", function(_, event)
	if not laidOut then
		setup()
	elseif event ~= "PLAYER_REGEN_ENABLED" or pending then
		M.Restack()
	end
end)
setup()
