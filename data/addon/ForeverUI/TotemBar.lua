-- The shaman's totem bar (3.3.5 MultiCastActionBarFrame), placed like the stance bar: its
-- first button on the main bar's left edge, above the reputation bar, one row higher when
-- action bar 2 or 3 is shown (MultiBars.lua); movable in edit mode. The client keeps it as a
-- child of MainMenuBar and puts it back over that bar each time it slides it in or out
-- (MultiCastActionBarFrame_OnUpdate): its place is set again right after, in the same frame.
-- Its buttons are secure: nothing moves in combat, the place waits for the end of combat.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local L = ForeverUI.L
local Layout = ForeverUI.Layout

local bar = MultiCastActionBarFrame
local _, class = UnitClass("player")
if not bar or class ~= "SHAMAN" then
	return
end

local ID = "totembar"
local LEFT_EDGE = -587.5              -- left edge of the main bar, from the screen center
local ROW_Y = 84                       -- above the reputation bar
local INSET = 3                        -- the summon button sits at (3, 3) in the bar
local CONTENT_W = 215                  -- summon, four slots 8 apart, recall

local function defaultY()
	return ROW_Y - INSET + (ForeverUI.MultiBars and ForeverUI.MultiBars.Lift() or 0)
end

-- The client anchors the bar on MainMenuBar; ours is a single anchor on UIParent
local function displaced()
	if bar:GetNumPoints() ~= 1 then
		return true
	end
	local _, relativeTo = bar:GetPoint(1)
	return relativeTo ~= UIParent
end

local pending = false
local function restore()
	if InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	Layout.Apply(ID)
end

-- The default place follows the bottom row (MultiBars.Restack, out of combat only)
local function placeDefault()
	Layout.SetDefaults(ID, "BOTTOMLEFT", "BOTTOM", LEFT_EDGE - INSET, defaultY())
	if displaced() then
		restore()
	end
end

ForeverUI.TotemBar = { Frame = bar, PlaceDefault = placeDefault, ContentWidth = CONTENT_W }

local registered = false
local function setup()
	if registered or InCombatLockdown() then
		return
	end
	registered = true
	Layout.Register(bar, ID, L.TOTEMBAR_EDIT_LABEL, "BOTTOMLEFT", "BOTTOM", LEFT_EDGE - INSET, defaultY())
	-- UIParent_ManageFramePositions leaves alone a frame marked as placed by the player
	bar:SetUserPlaced(true)
	bar:HookScript("OnUpdate", function()
		if displaced() then
			restore()
		end
	end)
	-- The pet bar stands right of the totem bar: it follows it in and out
	bar:HookScript("OnShow", ForeverUI.MultiBars.Restack)
	bar:HookScript("OnHide", ForeverUI.MultiBars.Restack)
	ForeverUI.MultiBars.Restack()
end

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_LOGIN")
watcher:RegisterEvent("PLAYER_REGEN_ENABLED")
watcher:SetScript("OnEvent", function()
	if not registered then
		setup()
	elseif pending then
		restore()
	end
end)
setup()
