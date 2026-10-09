-- ForeverUI: the player's bars while a vehicle bar replaces them, on the client's own timing.
-- They go the moment the player mounts (UNIT_ENTERING_VEHICLE, when the client starts sliding
-- its bar away) and come back with the client's bar (MainMenuBar_ToPlayerArt, once the vehicle
-- bar has slid away), fading in while the client's bar rises. The action bar (protected) and
-- the client's bars turn transparent, which the client allows in combat; ForeverUI's other
-- frames hide.

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

-- Fade-in on the way back, as long as the client's bar takes to rise (MAINMENU_SLIDETIME, local
-- to MainMenuBar.lua)
local FADE_TIME = 0.3
local fading = {}
local fader = CreateFrame("Frame")
fader:Hide()
fader:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	local alpha = math.min(1, self.elapsed / FADE_TIME)
	for _, frame in ipairs(fading) do
		frame:SetAlpha(alpha)
	end
	if alpha >= 1 then
		self:Hide()
	end
end)
ForeverUI.VehicleFade = fader

-- Default place of the seat indicator (below), which depends on the vehicle state
local placeSeats = function() end

local function leave()
	if ForeverUI.VehicleArt then return end
	ForeverUI.VehicleArt = true
	placeSeats()
	fader:Hide()
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
	placeSeats()
	fading = {}
	for _, frame in ipairs(FADED) do
		table.insert(fading, frame)
	end
	for frame in pairs(wasShown) do
		frame:SetAlpha(0)
		frame:Show()
		table.insert(fading, frame)
	end
	wasShown = {}
	for _, name in ipairs({ "ForeverUIExperienceBar", "ForeverUIReputationBar" }) do
		if _G[name] then
			_G[name]:SetAlpha(0)
			table.insert(fading, _G[name])
		end
	end
	fader.elapsed = 0
	fader:Show()
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

-- The seat indicator (VehicleSeatIndicator, shown in vehicles with several seats) moves like
-- the other elements. Its default is where the client leaves it: its top right corner 13 under
-- the minimap's bottom right one, 62 left of the right action bar shown, 100 of both
-- (MultiActionBars.lua), flush with the minimap while a vehicle bar hides those bars (the end of
-- its slide, MainMenuBar.lua); it follows the minimap. The client re-anchors it to the minimap
-- in MultiActionBar_Update and on every frame of its slides: its own anchor is put back.
local seats = VehicleSeatIndicator
if seats then
	local Layout = ForeverUI.Layout
	local function placeDefault()
		local cluster = MinimapCluster
		local right, bottom = cluster:GetRight(), cluster:GetBottom()
		if not (right and bottom) then
			return
		end
		local k = cluster:GetEffectiveScale() / UIParent:GetEffectiveScale()
		local shift = 0
		if not (ForeverUI.VehicleArt or MainMenuBar.state == "vehicle") then
			shift = (SHOW_MULTI_ACTIONBAR_3 and SHOW_MULTI_ACTIONBAR_4 and -100) or (SHOW_MULTI_ACTIONBAR_3 and -62) or 0
		end
		Layout.SetDefaults("vehicleseats", "TOPRIGHT", "TOPRIGHT", right * k - UIParent:GetWidth() + shift,
			bottom * k - UIParent:GetHeight() - 13)
	end
	placeSeats = placeDefault
	-- the screen's top right corner until the minimap is laid out
	Layout.Register(seats, "vehicleseats", ForeverUI.L.VEHICLE_EDIT_LABEL, "TOPRIGHT", "TOPRIGHT", 0, 0)
	placeDefault()
	-- relativeTo: the frame the anchor refers to; ours and Customize UI's are on UIParent
	hooksecurefunc(seats, "SetPoint", function(_, _, relativeTo)
		if relativeTo == MinimapCluster then
			Layout.Apply("vehicleseats")
		end
	end)
	hooksecurefunc("MultiActionBar_Update", placeDefault)
	hooksecurefunc(Layout, "Apply", function(id)
		if id == "minimap" then placeDefault() end
	end)
	local events = CreateFrame("Frame")
	for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "DISPLAY_SIZE_CHANGED", "UI_SCALE_CHANGED" }) do
		events:RegisterEvent(event)
	end
	events:SetScript("OnEvent", placeDefault)
end
