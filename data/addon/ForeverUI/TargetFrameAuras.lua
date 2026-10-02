-- Auras under the target frame, as camelot's TargetFrameAuraContainer lays them out
-- (shared/targetframeauracontainer.lua, targetframeaurashared.lua, targetframeaurabutton.xml)
-- and TargetFrameMixin anchors them (mainline/targetframe.lua, loaded by camelot's family):
-- rows of 122 from the frame art's BOTTOMLEFT (5, 9), 3 apart; the first two rows 101 wide
-- while the target of target shows. Hostile target: debuffs first, then buffs on a new row;
-- friendly target: the reverse. Auras from the player, pet or vehicle are 21, others 17.
-- 3.3.5 gives the caster as a unit token only: an aura from a player outside the group has
-- none, so camelot's "from a player or a player's pet" test only knows the casters it can see.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI

local MAX_BUFFS, MAX_DEBUFFS = 32, 16
local SMALL_SIZE, LARGE_SIZE = 17, 21
local SPACING = 3                         -- between auras, and between rows
local LINE_SIZE = 122
local TOT_LINE_SIZE, TOT_LINES = 101, 2   -- rows beside the target of target
local START_X, START_Y = 5, 9             -- from the frame art's BOTTOMLEFT

-- Buff border when the buff can be stolen (the target is not the player); debuff border in
-- the dispel type's color, 1 px around the icon.
local STEALABLE_BORDER = "Interface\\TargetingFrame\\UI-TargetingFrame-Stealable"
local STEALABLE_SIZE = 24
local DEBUFF_BORDER = "Interface\\Buttons\\UI-Debuff-Overlays"

local PLAYER_UNITS = { "player", "vehicle", "pet" }

local frame = ForeverUI.TargetFrame
local targetOfTarget = _G["ForeverUITargetOfTarget"]

local container = CreateFrame("Frame", "ForeverUITargetFrameAuras", frame)
container:SetWidth(1)
container:SetHeight(1)
container:SetPoint("TOPLEFT", frame.art, "BOTTOMLEFT", START_X, START_Y)

-- The rows' height from the container's top, 0 without aura: the target's cast bar goes under
-- them (TargetCastBar.lua)
local auras = { container = container, height = 0 }
ForeverUI.TargetFrameAuras = auras

local buttons = { HELPFUL = {}, HARMFUL = {} }

-- ---------------------------------------------------------------- Rules

-- The player, its vehicle or its pet cast it (camelot ShouldShowAuraWithLargeSize)
local function fromPlayer(caster)
	if not caster then
		return false
	end
	for _, token in ipairs(PLAYER_UNITS) do
		if UnitIsUnit(caster, token) then
			return true
		end
	end
	return false
end

-- camelot ShouldShowAuraAsDebuff: on a hostile creature, debuffs from other players are left out
local function keepDebuff(caster, friendly)
	if fromPlayer(caster) or UnitIsUnit("player", "target") then
		return true
	end
	local targetIsPlayer = UnitIsPlayer("target")
	local targetIsPet = UnitPlayerControlled("target") and not targetIsPlayer
	if not targetIsPlayer and not targetIsPet and not friendly and caster and UnitPlayerControlled(caster) then
		return false
	end
	return true
end

-- Auras of one kind, in client order; filter: "HELPFUL" or "HARMFUL"; maximum: how many
-- at most; friendly: the target's reaction
local function collect(filter, maximum, friendly)
	local list = {}
	local index = 1
	while #list < maximum do
		local name, _, icon, count, dispelType, duration, expiration, caster, stealable = UnitAura("target", index, filter)
		if not name then
			break
		end
		if filter == "HELPFUL" or keepDebuff(caster, friendly) then
			list[#list + 1] = {
				index = index, icon = icon, count = count, dispelType = dispelType,
				duration = duration, expiration = expiration, stealable = stealable,
				size = fromPlayer(caster) and LARGE_SIZE or SMALL_SIZE,
			}
		end
		index = index + 1
	end
	return list
end

-- ---------------------------------------------------------------- Buttons

local function createButton(filter, rank)
	local kind = filter == "HELPFUL" and "Buff" or "Debuff"
	local button = CreateFrame("Button", container:GetName() .. kind .. rank, container)
	button.filter = filter

	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints(button)
	button.icon = icon

	local cooldown = CreateFrame("Cooldown", button:GetName() .. "Cooldown", button)
	cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -1)
	cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -1)
	cooldown:SetReverse(true)
	if cooldown.SetDrawEdge then
		cooldown:SetDrawEdge(true)
	end
	button.cooldown = cooldown

	-- The cooldown is a child frame, drawn above the button: the count and the borders go
	-- in a frame above it
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints(button)
	overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)

	local count = overlay:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	count:SetJustifyH("RIGHT")
	count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.count = count

	local border = overlay:CreateTexture(nil, "OVERLAY")
	if filter == "HELPFUL" then
		border:SetTexture(STEALABLE_BORDER)
		border:SetBlendMode("ADD")
		border:SetWidth(STEALABLE_SIZE)
		border:SetHeight(STEALABLE_SIZE)
		border:SetPoint("CENTER", button, "CENTER", 0, 0)
	else
		border:SetTexture(DEBUFF_BORDER)
		border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
	end
	button.border = border

	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 15, -25)
		if self.filter == "HELPFUL" then
			GameTooltip:SetUnitBuff("target", self.index)
		else
			GameTooltip:SetUnitDebuff("target", self.index)
		end
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	buttons[filter][rank] = button
	return button
end

-- aura: an entry of collect; playerIsTarget: no stealable border on the player's own buffs
local function fill(button, aura, playerIsTarget)
	button.index = aura.index
	button.icon:SetTexture(aura.icon)

	if aura.count and aura.count > 1 then
		button.count:SetText(aura.count)
		button.count:Show()
	else
		button.count:Hide()
	end

	if aura.duration and aura.duration > 0 and aura.expiration then
		CooldownFrame_SetTimer(button.cooldown, aura.expiration - aura.duration, aura.duration, 1)
	else
		button.cooldown:Hide()
	end

	if button.filter == "HELPFUL" then
		if aura.stealable and not playerIsTarget then
			button.border:Show()
		else
			button.border:Hide()
		end
	else
		local color = DebuffTypeColor[aura.dispelType or "none"] or DebuffTypeColor["none"]
		button.border:SetVertexColor(color.r, color.g, color.b)
	end
end

-- ---------------------------------------------------------------- Layout

-- Flow layout of camelot's container: each aura right of the previous one, a new row when
-- the next one would pass the row's width, the second group always on a new row.
local function layout()
	local used = { HELPFUL = 0, HARMFUL = 0 }
	local height = 0

	if UnitExists("target") then
		local friendly = UnitIsFriend("player", "target")
		local playerIsTarget = UnitIsUnit("player", "target")
		local buffs = { filter = "HELPFUL", list = collect("HELPFUL", MAX_BUFFS, friendly) }
		local debuffs = { filter = "HARMFUL", list = collect("HARMFUL", MAX_DEBUFFS, friendly) }
		local groups = friendly and { buffs, debuffs } or { debuffs, buffs }
		local constrained = (targetOfTarget and targetOfTarget:IsShown()) and TOT_LINES or 0

		local x, y, line, lineHeight = 0, 0, 1, 0
		local function newLine()
			y = y + lineHeight + SPACING
			x, line, lineHeight = 0, line + 1, 0
		end

		for _, group in ipairs(groups) do
			if #group.list > 0 and x > 0 then
				newLine()
			end
			for rank, aura in ipairs(group.list) do
				local limit = line <= constrained and TOT_LINE_SIZE or LINE_SIZE
				if x > 0 and x + aura.size > limit then
					newLine()
				end
				local button = buttons[group.filter][rank] or createButton(group.filter, rank)
				button:ClearAllPoints()
				button:SetPoint("TOPLEFT", container, "TOPLEFT", x, -y)
				button:SetWidth(aura.size)
				button:SetHeight(aura.size)
				fill(button, aura, playerIsTarget)
				button:Show()
				x = x + aura.size + SPACING
				lineHeight = math.max(lineHeight, aura.size)
			end
			used[group.filter] = #group.list
		end
		if lineHeight > 0 then
			height = y + lineHeight
		end
	end

	for filter, list in pairs(buttons) do
		for rank = used[filter] + 1, #list do
			list[rank]:Hide()
		end
	end

	auras.height = height
	if ForeverUI.TargetCastBar then
		ForeverUI.TargetCastBar.Place()
	end
end

container:SetScript("OnEvent", function(_, event, unit)
	if event ~= "UNIT_AURA" and event ~= "UNIT_FACTION" or unit == "target" then
		layout()
	end
end)
for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED", "UNIT_AURA", "UNIT_FACTION" }) do
	container:RegisterEvent(event)
end

-- The first rows narrow while the target of target shows
if targetOfTarget then
	targetOfTarget:HookScript("OnShow", layout)
	targetOfTarget:HookScript("OnHide", layout)
end
