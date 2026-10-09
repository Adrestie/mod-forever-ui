-- ForeverUI: the player's bars while a vehicle bar replaces them, on the client's own timing.
-- They go the moment the player mounts (UNIT_ENTERING_VEHICLE, when the client starts sliding
-- its bar away) and come back with the client's bar (MainMenuBar_ToPlayerArt, once the vehicle
-- bar has slid away). The action bar (protected) and the client's bars turn transparent, which
-- the client allows in combat; ForeverUI's other frames hide.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI

-- True from the mount until the client's bar is back.
ForeverUI.VehicleArt = false

-- Turned transparent: protected, or shown and hidden by the client itself. The client's bar
-- carries the action, bag and micro buttons; ForeverUI places the extra bars on the screen,
-- so they do not slide away with it.
local FADED = {}
for _, name in ipairs({ "ForeverUIActionBarHolder", "MainMenuBar", "MultiBarBottomLeft", "MultiBarBottomRight",
	"MultiBarRight", "MultiBarLeft" }) do
	if _G[name] then table.insert(FADED, _G[name]) end
end
-- Hidden: ForeverUI's own frames, not protected
local HIDDEN = { "ForeverUIActionBarLeftCap", "ForeverUIActionBarRightCap", "ForeverUIMicroMenu", "ForeverUIBagsBar" }

-- the frames hidden here, shown again on the way back (a gryphon without art stays hidden)
local wasShown = {}

local function leave()
	if ForeverUI.VehicleArt then return end
	ForeverUI.VehicleArt = true
	for _, frame in ipairs(FADED) do
		frame:SetAlpha(0)
	end
	for _, name in ipairs(HIDDEN) do
		local frame = _G[name]
		if frame and frame:IsShown() then
			frame:Hide()
			wasShown[frame] = true
		end
	end
	if ForeverUI.StatusBarsUpdate then ForeverUI.StatusBarsUpdate() end
end

local function back()
	if not ForeverUI.VehicleArt then return end
	ForeverUI.VehicleArt = false
	for frame in pairs(wasShown) do
		frame:Show()
	end
	wasShown = {}
	for _, frame in ipairs(FADED) do
		frame:SetAlpha(1)
	end
	if ForeverUI.StatusBarsUpdate then ForeverUI.StatusBarsUpdate() end
	-- the stance, pet and totem bars and the right bars kept their places meanwhile
	if ForeverUI.MultiBars then ForeverUI.MultiBars.Restack() end
end

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("UNIT_ENTERING_VEHICLE")
-- hasVehicleUI: the vehicle shows a vehicle bar (without one, the client keeps its bar)
watcher:SetScript("OnEvent", function(_, _, unit, hasVehicleUI)
	if unit == "player" and hasVehicleUI then leave() end
end)
-- the swap itself also covers a /reload in a vehicle, where no mount event comes
hooksecurefunc("MainMenuBar_ToVehicleArt", leave)
hooksecurefunc("MainMenuBar_ToPlayerArt", back)
