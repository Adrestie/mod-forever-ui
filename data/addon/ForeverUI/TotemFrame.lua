-- Active totems, as camelot's TotemFrame (mainline/totemframe.lua and .xml, loaded by
-- camelot's family): one 37 button per active totem slot, in the shaman's order (earth, fire,
-- water, air) or slot order for other classes, side by side 6 px overlapped, centered where
-- camelot stacks it under the player frame. Each button: the icon, round, 22 in the totem
-- ring (30), the time left under it, and a reverse sweep showing what remains; its tooltip
-- on hover, and a right click destroys the totem.
-- Movable in edit mode; until the player moves it, it follows the player frame.
-- 3.3.5 has no texture masks: SetPortraitToTexture rounds the icon. The sweep stays the
-- client's square, 21 wide so its corners stay under the ring.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local L = ForeverUI.L
local Layout = ForeverUI.Layout

local BUTTON_SIZE = 37
local SPACING = -6
local ICON_SIZE = 22
local SWEEP_SIZE = 21
local RING_SIZE = 30
local RING_X, RING_Y = 1, -1.5
local DURATION_Y = 5                    -- the text's top, 5 above the button's bottom
local SLOTS = MAX_TOTEMS or 4
local FRAME_WIDTH = SLOTS * BUTTON_SIZE + (SLOTS - 1) * SPACING

-- Where camelot's PlayerBottomManagedFrameContainer puts it: the container's top at the
-- player frame's bottom (30, 25), half the frame's 15 left padding added, its -2 top padding
-- taken off; under the class resources when the player has some (the death knight's runes).
-- The pet frame comes before it in that stack: while it shows, the totems sit 3 above its
-- bottom (its -3 bottom padding, the stack's 2 spacing, the totems' -2 top padding).
local OFFSET_X, OFFSET_Y = 30 + 7.5, 25 + 2
local UNDER_RESOURCES_X, UNDER_RESOURCES_Y = 7.5, 2
local UNDER_PET_Y = 3

-- Default before the player frame is placed: its default (10, -10), 232 x 100
local DEFAULT_X, DEFAULT_Y = 10 + 232 / 2 + OFFSET_X, -10 - 100 + OFFSET_Y

local SHAMAN_ORDER = { EARTH_TOTEM_SLOT or 2, FIRE_TOTEM_SLOT or 1, WATER_TOTEM_SLOT or 3, AIR_TOTEM_SLOT or 4 }
local STANDARD_ORDER = { 1, 2, 3, 4 }
local WARNING_TIME = 90                 -- BUFF_DURATION_WARNING_TIME

local frame = CreateFrame("Frame", "ForeverUITotemFrame", UIParent)
frame:SetWidth(FRAME_WIDTH)
frame:SetHeight(BUTTON_SIZE)
frame:Hide()

local buttons = {}

-- AuraButtonMixin:UpdateDuration: the buff duration setting decides; white under 90 s.
-- An open tooltip follows the time left, as TotemButtonMixin:OnUpdate does.
local function updateDuration(button)
	if GameTooltip:IsOwned(button) then
		GameTooltip:SetTotem(button.slot)
	end
	local timeLeft = GetTotemTimeLeft(button.slot)
	if timeLeft and SHOW_BUFF_DURATIONS == "1" then
		timeLeft = math.ceil(timeLeft)
		button.duration:SetFormattedText(SecondsToTimeAbbrev(timeLeft))
		local color = timeLeft < WARNING_TIME and HIGHLIGHT_FONT_COLOR or NORMAL_FONT_COLOR
		button.duration:SetVertexColor(color.r, color.g, color.b)
		button.duration:Show()
	else
		button.duration:Hide()
	end
end

local function createButton(rank)
	local button = CreateFrame("Button", "ForeverUITotemFrameTotem" .. rank, frame)
	button:SetWidth(BUTTON_SIZE)
	button:SetHeight(BUTTON_SIZE)

	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetWidth(ICON_SIZE)
	icon:SetHeight(ICON_SIZE)
	icon:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.icon = icon

	local cooldown = CreateFrame("Cooldown", button:GetName() .. "Cooldown", button)
	cooldown:SetWidth(SWEEP_SIZE)
	cooldown:SetHeight(SWEEP_SIZE)
	cooldown:SetPoint("CENTER", button, "CENTER", 0, 0)
	cooldown:SetReverse(true)
	button.cooldown = cooldown

	-- The ring above the sweep, which is a child frame
	local ringHolder = CreateFrame("Frame", nil, button)
	ringHolder:SetAllPoints(button)
	ringHolder:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	local ring = ringHolder:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(ring, "ui-hud-unitframe-totemframe", true)
	ring:SetWidth(RING_SIZE)
	ring:SetHeight(RING_SIZE)
	ring:SetPoint("CENTER", button, "CENTER", RING_X, RING_Y)

	local duration = button:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
	duration:SetPoint("TOP", button, "BOTTOM", 0, DURATION_Y)
	button.duration = duration

	button:SetScript("OnUpdate", updateDuration)
	-- TotemButtonMixin: the totem's tooltip on hover, a right click destroys it
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetTotem(self.slot)
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	button:RegisterForClicks("RightButtonUp")
	button:SetScript("OnClick", function(self, mouseButton)
		if mouseButton == "RightButton" and self.slot then
			DestroyTotem(self.slot)
		end
	end)
	button:Hide()
	buttons[rank] = button
	return button
end

for rank = 1, SLOTS do
	createButton(rank)
end

-- Fills one button per active slot, in order, centered in the frame. Shown with a totem, or
-- empty while the layout is edited so that it can be moved.
local function update()
	local _, class = UnitClass("player")
	local order = class == "SHAMAN" and SHAMAN_ORDER or STANDARD_ORDER
	local count = 0
	for _, slot in ipairs(order) do
		local haveTotem, _, startTime, duration, icon = GetTotemInfo(slot)
		if haveTotem and duration and duration > 0 then
			count = count + 1
			local button = buttons[count]
			button.slot = slot
			SetPortraitToTexture(button.icon, icon)
			CooldownFrame_SetTimer(button.cooldown, startTime, duration, 1)
			updateDuration(button)
		end
	end

	local width = count * BUTTON_SIZE + math.max(0, count - 1) * SPACING
	for rank, button in ipairs(buttons) do
		if rank <= count then
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", frame, "TOPLEFT",
				(FRAME_WIDTH - width) / 2 + (rank - 1) * (BUTTON_SIZE + SPACING), 0)
			button:Show()
		else
			button:Hide()
		end
	end

	if count > 0 or Layout.editing then
		frame:Show()
	else
		frame:Hide()
	end
end

-- Default position under the player frame, its class resources or its pet; it changes with
-- them until the player moves the totems (SetDefaults leaves a moved element alone). The pet
-- frame is placed from its own anchor, valid even on the frame it shows.
local pet = _G["ForeverUIPetFrame"]
local function follow()
	local resources = _G["ForeverUIClassResourceContainer"]
	local anchor, x, y = ForeverUI.PlayerFrame, OFFSET_X, OFFSET_Y
	if pet and pet:IsShown() then
		local _, relativeTo, _, petX, petY = pet:GetPoint(1)
		anchor, x, y = relativeTo, petX, petY - pet:GetHeight() + UNDER_PET_Y
	elseif resources then
		anchor, x, y = resources, UNDER_RESOURCES_X, UNDER_RESOURCES_Y
	end
	local left, right, bottom = anchor:GetLeft(), anchor:GetRight(), anchor:GetBottom()
	if not (left and right and bottom) then
		return
	end
	local scale = anchor:GetEffectiveScale() / UIParent:GetEffectiveScale()
	Layout.SetDefaults("totems", "TOP", "BOTTOMLEFT",
		((left + right) / 2 + x) * scale, (bottom + y) * scale)
end

Layout.Register(frame, "totems", L.TOTEMFRAME_EDIT_LABEL, "TOP", "TOPLEFT", DEFAULT_X, DEFAULT_Y)

hooksecurefunc(Layout, "Apply", function(id)
	if id == "playerframe" then
		follow()
	end
end)
-- The pet frame comes and goes with the pet (Feral Spirit): the totems go down and back up
if pet then
	pet:HookScript("OnShow", follow)
	pet:HookScript("OnHide", follow)
end
-- Shown empty while the layout is edited, hidden again after
hooksecurefunc(Layout, "BeginEdit", update)
hooksecurefunc(Layout, "Commit", update)
hooksecurefunc(Layout, "Revert", update)

frame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		follow()
	end
	update()
end)
for _, event in ipairs({ "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_TOTEM_UPDATE" }) do
	frame:RegisterEvent(event)
end
