-- Target frame and target-of-target frame, rebuilt from camelot.
-- Sizes and anchors: mainline/TargetFrame.xml, as camelot/TargetFrame.lua overrides them since
-- 1.60.1.70450 (TargetFrameMixin:OnLoad, UpdateHealthBarVisuals, TargetOfTargetMixin:OnLoad);
-- art by classification: CheckClassification in mainline/TargetFrame.lua; combo points:
-- camelot/ComboFrame.lua.

local FRAME_WIDTH, FRAME_HEIGHT = 232, 100
local L = ForeverUI.L

local ART = {
	normal = "ui-hud-unitframe-target-portraiton",
	rare = "ui-hud-unitframe-target-rare-portraiton",
	minus = "ui-hud-unitframe-target-minusmob-portraiton",
}
local THREAT_GLOW = "ui-hud-unitframe-target-portraiton-incombat"
local HEALTH_FILL = "ui-hud-unitframe-target-portraiton-bar-health"

-- camelot TargetFrameMixin:UpdateHealthBarVisuals ignores the classification: a minus mob takes
-- the normal bar. Health container 126 x 15 at TOPLEFT (21, -44), the 126 x 20 bar 3 px above
-- it, so (21, -41); power 134 x 10 at (17, -60), hidden for minus mobs (mainline).
local BAR_LAYOUT = {
	normal = { health = { 21, -41, 126, 20 }, power = { 17, -60, 134, 10 }, showPower = true },
	minus = { health = { 21, -41, 126, 20 }, power = nil, showPower = false },
}
local POWER_FILL = {
	normal = {
		MANA = "ui-hud-unitframe-target-portraiton-bar-mana",
		RAGE = "ui-hud-unitframe-target-portraiton-bar-rage",
		FOCUS = "ui-hud-unitframe-target-portraiton-bar-focus",
		ENERGY = "ui-hud-unitframe-target-portraiton-bar-energy",
		RUNIC_POWER = "ui-hud-unitframe-target-portraiton-bar-runicpower",
	},
}

-- Portrait ring by classification (camelot GetBossPortraitFrameData): gold for elite,
-- silver winged for rare and rare elite, gold winged for world boss, anchored TOPRIGHT with
-- these offsets; no star (ShouldShowStar is always false). Sheet: interface/hud/uiunitframeboss.blp.
-- Boss-Rare-Silver-Winged exists only as c60, so camelot uses the c60 set. The base
-- variants are smaller (80x79 vs 100x100) and, anchored by their top-right, land off.
local CLASS_RING = {
	worldboss = { "ui-hud-unitframe-target-portraiton-boss-gold-winged-c60", 11, -4 },
	rareelite = { "ui-hud-unitframe-target-portraiton-boss-rare-silver-winged-c60", 8, -7 },
	rare = { "ui-hud-unitframe-target-portraiton-boss-rare-silver-winged-c60", 8, -7 },
	elite = { "ui-hud-unitframe-target-portraiton-boss-gold-c60", 0, 1 },
}

local frame = CreateFrame("Button", "ForeverUITargetFrame", UIParent, "SecureUnitButtonTemplate")
frame:SetWidth(FRAME_WIDTH)
frame:SetHeight(FRAME_HEIGHT)
frame:SetFrameStrata("LOW")
frame:SetHitRectInsets(20, 20, 16, 17)

frame.unit = "target"
frame:SetAttribute("unit", "target")
frame:SetAttribute("*type1", "target")
frame:SetAttribute("*type2", "menu")
frame:RegisterForClicks("AnyUp")
frame.menu = function(self)
	ForeverUI.UnitMenu.open(ToggleDropDownMenu, 1, nil, TargetFrameDropDown, self, 120, 10)
end

local portrait = frame:CreateTexture(nil, "BACKGROUND")
portrait:SetWidth(58)
portrait:SetHeight(58)
portrait:SetPoint("TOPRIGHT", -26, -19)

-- Bars above the art (OVERLAY): camelot draws its StatusBars over the frame texture, whose
-- bar slots are a dark veil
local healthFill = frame:CreateTexture(nil, "OVERLAY")
healthFill:SetPoint("TOPLEFT", 21, -41)

local powerFill = frame:CreateTexture(nil, "OVERLAY")
powerFill:SetPoint("TOPLEFT", 17, -60)

local art = frame:CreateTexture(nil, "ARTWORK")
art:SetPoint("CENTER", 0, 0)
ForeverUI.SetAtlas(art, ART.normal)

-- Reputation band: it carries the reaction color, not the health bar.
local reputation = frame:CreateTexture(nil, "BACKGROUND")
reputation:SetPoint("TOPRIGHT", -82, -26)
ForeverUI.SetAtlas(reputation, "ui-hud-unitframe-target-portraiton-type")

-- As on the player frame: whatever must stay above the art lives in a child frame, never
-- in the same layer.
local overlayHolder = CreateFrame("Frame", nil, frame)
overlayHolder:SetAllPoints(frame)
overlayHolder:SetFrameLevel(frame:GetFrameLevel() + 1)

local threatGlow = overlayHolder:CreateTexture(nil, "BACKGROUND")
threatGlow:SetPoint("CENTER", frame, "CENTER", -1, 1)
ForeverUI.SetAtlas(threatGlow, THREAT_GLOW)
threatGlow:Hide()

-- Ring: GetBossPortraitFrameData anchors it TOPRIGHT on the container. The source puts it
-- in ARTWORK sublevel 2, above the frame art and threat glow but below the bars, name and
-- level circle. Here: BORDER of the holder, above the glow (BACKGROUND) and below the level
-- circle (ARTWORK) and the text (OVERLAY).
local classRing = overlayHolder:CreateTexture(nil, "BORDER")
classRing:Hide()

local levelCircle = overlayHolder:CreateTexture(nil, "ARTWORK")
levelCircle:SetPoint("BOTTOMRIGHT", -13, 7)
ForeverUI.SetAtlas(levelCircle, "ui-hud-unitframe-smallcircle")

local levelText = overlayHolder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
levelText:SetPoint("CENTER", levelCircle, "CENTER", 0, -0.5)

local nameText = overlayHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
nameText:SetWidth(117)
nameText:SetHeight(12)
-- camelot: centered, TOPLEFT on the band's TOPRIGHT at (-126, -4)
nameText:SetJustifyH("CENTER")
nameText:SetPoint("TOPLEFT", 24, -30)

-- PvP badge (camelot 70450 PvpBackgroundIconTemplate): no circle any more, the icon alone, at
-- scale 0.8 with its TOP at (-24, -65) of the TOPRIGHT in its own units, so centered at
-- (-19.2, -62.8). Kept at that center, at full size (user's request, 2026-10-17), in a child frame
-- one level up: above the level circle and its text. The FFA icon (28 x 44) keeps scale 0.8.
local PVP_SCALE = 0.8
local pvpHolder = CreateFrame("Frame", nil, overlayHolder)
pvpHolder:SetAllPoints(frame)
pvpHolder:SetFrameLevel(overlayHolder:GetFrameLevel() + 1)

local pvpIcon = pvpHolder:CreateTexture(nil, "BORDER")
pvpIcon:SetPoint("CENTER", frame, "TOPRIGHT", -19.2, -62.8)
pvpIcon:Hide()

local PVP_ICONS = {
	FFA = "ui-hud-unitframe-player-pvp-ffaicon",
	Horde = "ui-hud-unitframe-smallcircle-horde",
	Alliance = "ui-hud-unitframe-smallcircle-alliance",
}

local healthText = overlayHolder:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
healthText:SetPoint("CENTER", frame, "TOPLEFT", 21 + 63, -41 - 10)
healthText:Hide()

local powerText = overlayHolder:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
powerText:SetPoint("CENTER", frame, "TOPLEFT", 17 + 67, -60 - 5)
powerText:Hide()

frame.portrait = portrait
frame.healthFill = healthFill
frame.powerFill = powerFill
frame.art = art
frame.threatGlow = threatGlow
frame.classRing = classRing
frame.reputation = reputation
frame.nameText = nameText
frame.levelText = levelText
frame.healthText = healthText
frame.powerText = powerText
frame.overlayHolder = overlayHolder
frame.pvpHolder = pvpHolder
frame.pvpIcon = pvpIcon

-- Target classification. It picks two separate things: the frame art family (normal, rare,
-- minus) and the portrait ring (elite, rare, boss).
local function classification()
	return (UnitClassification and UnitClassification("target")) or "normal"
end

local function artKindFor(class)
	if class == "minus" then
		return "minus"
	end
	if class == "rare" or class == "rareelite" then
		return "rare"
	end
	return "normal"
end

-- camelot CheckFaction, PvP part: free-for-all badge, else the faction's for a flagged target
-- (3.3.5 has no honor levels, so never the prestige variant)
local function updatePvP()
	local key
	local faction = UnitFactionGroup("target")
	if UnitIsPVPFreeForAll("target") then
		key = "FFA"
	elseif faction and faction ~= "Neutral" and UnitIsPVP("target") then
		key = faction
	end

	if key and PVP_ICONS[key] and ForeverUI.SetAtlas(pvpIcon, PVP_ICONS[key]) then
		if key == "FFA" then
			pvpIcon:SetWidth(pvpIcon:GetWidth() * PVP_SCALE)
			pvpIcon:SetHeight(pvpIcon:GetHeight() * PVP_SCALE)
		end
		pvpIcon:Show()
	else
		pvpIcon:Hide()
	end
	frame.pvpShown = pvpIcon:IsShown()
	-- the badge moves the start of the combo point arc
	if ForeverUI.ComboPoints then
		ForeverUI.ComboPoints.place()
	end
end

-- camelot CheckFaction: the band takes the selection color; band and portrait turn grey
-- when the target is tapped by someone else. 3.3.5 has no UnitIsTapDenied, so this uses
-- UnitIsTapped and UnitIsTappedByPlayer.
local function updateFaction()
	local tapDenied = UnitIsTapped and UnitIsTapped("target")
		and not UnitIsTappedByPlayer("target") and not UnitPlayerControlled("target")

	if tapDenied then
		reputation:SetVertexColor(0.5, 0.5, 0.5)
		portrait:SetVertexColor(0.5, 0.5, 0.5)
	else
		if UnitSelectionColor then
			reputation:SetVertexColor(UnitSelectionColor("target"))
		end
		portrait:SetVertexColor(1.0, 1.0, 1.0)
	end
	updatePvP()
end

-- Copy of TargetFrameMixin:CheckClassification: art, glow, and the bars' size and
-- position, which it sets again every time.
local function updateArt()
	local class = classification()
	local artKind = artKindFor(class)
	local barKind = (artKind == "minus") and "minus" or "normal"
	local layout = BAR_LAYOUT[barKind]

	ForeverUI.SetAtlas(art, ART[artKind] or ART.normal)
	ForeverUI.SetAtlas(threatGlow, THREAT_GLOW)

	healthFill:ClearAllPoints()
	healthFill:SetPoint("TOPLEFT", layout.health[1], layout.health[2])

	if layout.showPower then
		powerFill:ClearAllPoints()
		powerFill:SetPoint("TOPLEFT", layout.power[1], layout.power[2])
		powerFill:Show()
		powerText:Show()
	else
		powerFill:Hide()
		powerText:Hide()
	end

	frame.barKind = barKind
	frame.classification = class
	frame.layout = layout

	local ring = CLASS_RING[class]
	if ring and ForeverUI.SetAtlas(classRing, ring[1]) then
		classRing:ClearAllPoints()
		classRing:SetPoint("TOPRIGHT", frame, "TOPRIGHT", ring[2], ring[3])
		classRing:Show()
	else
		classRing:Hide()
	end
end

local function updateHealth()
	local maximum = UnitHealthMax("target")
	local fraction = 0
	if maximum and maximum > 0 then
		fraction = UnitHealth("target") / maximum
	end
	local layout = frame.layout or BAR_LAYOUT.normal
	ForeverUI.SetAtlasFill(healthFill, HEALTH_FILL, fraction, layout.health[3])
end

local function updatePower()
	local layout = frame.layout or BAR_LAYOUT.normal
	if not layout.showPower then
		powerFill:Hide()
		return
	end

	local powerType, powerToken = UnitPowerType("target")
	local set = POWER_FILL.normal
	local atlas = set[powerToken or ""] or set.MANA
	local maximum = UnitPowerMax("target", powerType)
	local fraction = 0
	if maximum and maximum > 0 then
		fraction = UnitPower("target", powerType) / maximum
	end
	ForeverUI.SetAtlasFill(powerFill, atlas, fraction, layout.power[3])
	ForeverUI.TintPower(powerFill, "target")
end

-- Health and power texts: shown with the targetStatusText CVar or on hover.
local function updateTexts()
	local always = GetCVar and GetCVar("targetStatusText") == "1"
	if not (always or frame.hovered) then
		healthText:Hide()
		powerText:Hide()
		return
	end

	local function format(value, maximum)
		if not maximum or maximum <= 0 then
			return ""
		end
		if GetCVarBool and GetCVarBool("statusTextPercentage") then
			return tostring(math.ceil(value / maximum * 100)) .. "%"
		end
		return value .. " / " .. maximum
	end

	local powerType = UnitPowerType("target")
	healthText:SetText(format(UnitHealth("target"), UnitHealthMax("target")))
	powerText:SetText(format(UnitPower("target", powerType), UnitPowerMax("target", powerType)))
	healthText:Show()
	powerText:Show()
end

local function updateName()
	nameText:SetText(UnitName("target"))
end

-- camelot CheckLevel: an attackable target's level takes its difficulty color, any other the
-- normal gold. 3.3.5 rates it with GetQuestDifficultyColor (its TargetFrame_CheckLevel); a level
-- too high to tell is the hardest one. Among creatures, only neutral and hostile ones are rated:
-- UnitCanAttack judges a creature from the player's side only, so a faction set at war while
-- Friendly passes as attackable, which the server refuses.
local LEVEL_GOLD = { r = 1.0, g = 0.82, b = 0.0 }
local REACTION_NEUTRAL = 4

local function isLevelRated()
	if not UnitCanAttack("player", "target") then
		return false
	end
	if UnitPlayerControlled("target") then
		return true
	end
	local reaction = UnitReaction("target", "player")
	return not reaction or reaction <= REACTION_NEUTRAL
end

local function updateLevel()
	local level = UnitLevel("target")
	local attackable = isLevelRated()
	local color = LEVEL_GOLD
	if level and level > 0 then
		levelText:SetText(level)
		if attackable then
			color = GetQuestDifficultyColor(level)
		end
	else
		levelText:SetText("??")
		if attackable then
			color = QuestDifficultyColors.impossible
		end
	end
	levelText:SetVertexColor(color.r, color.g, color.b)
end

local function updatePortrait()
	SetPortraitTexture(portrait, "target")
end

-- Threat: whether the target holds aggro on someone. Falls back on UnitAffectingCombat,
-- like the player frame, since threat data is not guaranteed.
local function updateThreat()
	if not UnitExists("target") then
		threatGlow:Hide()
		return
	end

	local status = UnitThreatSituation and UnitThreatSituation("target")
	local engaged = UnitAffectingCombat("target")

	if status and status >= 2 then
		threatGlow:SetVertexColor(1.0, 0.0, 0.0)
		threatGlow:SetAlpha(1.0)
		threatGlow:Show()
	elseif engaged or (status and status > 0) then
		threatGlow:SetVertexColor(1.0, 0.0, 0.0)
		threatGlow:SetAlpha(0.45)
		threatGlow:Show()
	else
		threatGlow:Hide()
	end
end

local function updateAll()
	if not UnitExists("target") then
		return
	end
	updateArt()
	updateFaction()
	updateHealth()
	updatePower()
	updateName()
	updateLevel()
	updatePortrait()
	updateThreat()
	updateTexts()
end

-- ------------------------------------------------------------- Combo points
-- camelot/ComboFrame.lua (1.60.1.70450): five RogueComboPoint (20 x 20) at scale 0.6, on an
-- arc around the target's portrait: centre = portrait centre + (2, 2), radius 66 in the points'
-- scale (39.6 px), angles -10 + 21 * (i - 1) degrees, from 2 degrees when the PvP badge shows.
-- Filled from the top (one point lights the 74-degree one); shown from one point, fading in
-- over 0.3 s. Atlases uf-roguecp-*-c60 (red only: camelot has no charged points). 3.3.5 has no
-- FlipBook: the slash animation is not reproduced, the icon fades in instead.
local COMBO_COUNT, COMBO_SCALE, COMBO_RADIUS, COMBO_STEP = 5, 0.6, 66, 21
local COMBO_START, COMBO_START_PVP = -10, 2
local COMBO_FADE, COMBO_ICON_FADE = 0.3, 0.27

local combo = CreateFrame("Frame", "ForeverUIComboPoints", frame)
combo:SetWidth(1)
combo:SetHeight(1)
combo:SetPoint("CENTER", portrait, "CENTER", 2, 2)
combo:SetFrameLevel(pvpHolder:GetFrameLevel() + 1)
combo:Hide()

-- one point: shadow, inactive and active backgrounds, red icon, each at its atlas size x 0.6
local function comboLayer(point, layer, atlas, x, y)
	local t = point:CreateTexture(nil, layer)
	ForeverUI.SetAtlas(t, atlas)
	t:SetWidth(t:GetWidth() * COMBO_SCALE)
	t:SetHeight(t:GetHeight() * COMBO_SCALE)
	t:SetPoint("CENTER", point, "CENTER", (x or 0) * COMBO_SCALE, (y or 0) * COMBO_SCALE)
	return t
end

combo.dots = {}
for i = 1, COMBO_COUNT do
	local point = CreateFrame("Frame", nil, combo)
	point:SetWidth(20 * COMBO_SCALE)
	point:SetHeight(20 * COMBO_SCALE)
	point.shadow = comboLayer(point, "BACKGROUND", "uf-roguecp-bg-shadow", 0, -4)
	point.inactive = comboLayer(point, "BORDER", "uf-roguecp-bg-dis")
	point.active = comboLayer(point, "BORDER", "uf-roguecp-bg")
	point.icon = comboLayer(point, "ARTWORK", "uf-roguecp-icon-red")
	point.active:Hide()
	point.icon:Hide()
	combo.dots[i] = point
end

-- arc positions; the PvP badge moves the start of the arc
local function placeComboPoints()
	local start = frame.pvpShown and COMBO_START_PVP or COMBO_START
	for i, point in ipairs(combo.dots) do
		local angle = math.rad(start + COMBO_STEP * (i - 1))
		point:ClearAllPoints()
		point:SetPoint("CENTER", combo, "CENTER",
			COMBO_RADIUS * COMBO_SCALE * math.cos(angle), COMBO_RADIUS * COMBO_SCALE * math.sin(angle))
	end
end

local function setPointActive(point, active, animate)
	if point.isActive == active then return end
	point.isActive = active
	if active then
		point.inactive:Hide()
		point.active:Show()
		point.icon:Show()
	else
		point.inactive:Show()
		point.active:Hide()
		point.icon:Hide()
	end
	point.fade = (active and animate) and 0 or nil
	point.icon:SetAlpha((active and animate) and 0 or 1)
end

-- animate: false on a target change (camelot SetActiveNoAnimation)
local function updateComboPoints(animate)
	local count = (UnitExists("target") and GetComboPoints("player", "target")) or 0
	placeComboPoints()
	local first = COMBO_COUNT - count + 1
	for i, point in ipairs(combo.dots) do
		setPointActive(point, i >= first, animate)
	end
	if count > 0 then
		if not combo:IsShown() then
			combo.fade = 0
			combo:SetAlpha(0)
			combo:Show()
		end
	else
		combo:Hide()
	end
	combo.count = count
end

combo:SetScript("OnUpdate", function(self, elapsed)
	if self.fade then
		self.fade = self.fade + elapsed
		self:SetAlpha(math.min(1, self.fade / COMBO_FADE))
		if self.fade >= COMBO_FADE then self.fade = nil end
	end
	for _, point in ipairs(self.dots) do
		if point.fade then
			point.fade = point.fade + elapsed
			point.icon:SetAlpha(math.min(1, point.fade / COMBO_ICON_FADE))
			if point.fade >= COMBO_ICON_FADE then point.fade = nil end
		end
	end
end)

-- The arc lives on the target frame but listens on its own: the target frame hides with no
-- target, and combo points belong to the player
local comboEvents = CreateFrame("Frame")
comboEvents:SetScript("OnEvent", function(_self, event, unit)
	if event == "PLAYER_TARGET_CHANGED" then
		updateComboPoints(false)
	elseif event == "UNIT_COMBO_POINTS" then
		if unit == nil or unit == "player" or unit == "vehicle" then
			updateComboPoints(true)
		end
	elseif event == "UNIT_FACTION" and unit == "target" then
		updateComboPoints(false)
	end
end)
comboEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
comboEvents:RegisterEvent("UNIT_COMBO_POINTS")
comboEvents:RegisterEvent("UNIT_FACTION")

frame.combo = combo
ForeverUI.ComboPoints = { frame = combo, update = updateComboPoints, place = placeComboPoints }

local function hideDefaultTargetFrame()
	if InCombatLockdown() or not TargetFrame then
		return
	end
	ForeverUI.Suppress(TargetFrame)
	-- The client's ComboFrame gives way to camelot's arc (ForeverUI.ComboPoints below)
	if ComboFrame then
		ForeverUI.Suppress(ComboFrame)
	end
end

frame:SetScript("OnEnter", function(self)
	self.hovered = true
	updateTexts()
end)

frame:SetScript("OnLeave", function(self)
	self.hovered = false
	updateTexts()
end)

frame:SetScript("OnEvent", function(self, event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		hideDefaultTargetFrame()
		updateAll()
		return
	end

	-- Skipped when PLAYER_ENTERING_WORLD came in combat (reload, reconnect): done now
	if event == "PLAYER_REGEN_ENABLED" then
		hideDefaultTargetFrame()
		return
	end

	if event == "PLAYER_TARGET_CHANGED" then
		updateAll()
		return
	end

	if event == "CVAR_UPDATE" then
		updateTexts()
		return
	end

	-- The player's own faction (PvP flag) also decides which targets are attackable
	if event == "UNIT_FACTION" and unit == "player" then
		if UnitExists("target") then
			updateLevel()
		end
		return
	end

	if unit ~= "target" then
		return
	end

	if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
		updateHealth()
		updateTexts()
	elseif event == "UNIT_NAME_UPDATE" then
		updateName()
	elseif event == "UNIT_PORTRAIT_UPDATE" then
		updatePortrait()
	elseif event == "UNIT_LEVEL" then
		updateLevel()
	elseif event == "UNIT_CLASSIFICATION_CHANGED" then
		updateArt()
		updateHealth()
		updatePower()
	elseif event == "UNIT_FACTION" then
		updateFaction()
		updateLevel()
	elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
		updateThreat()
	else
		updatePower()
		updateTexts()
	end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("CVAR_UPDATE")
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("UNIT_MAXHEALTH")
frame:RegisterEvent("UNIT_NAME_UPDATE")
frame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
frame:RegisterEvent("UNIT_LEVEL")
frame:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")
frame:RegisterEvent("UNIT_FACTION")
frame:RegisterEvent("UNIT_DISPLAYPOWER")
frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
frame:RegisterEvent("UNIT_MANA")
frame:RegisterEvent("UNIT_RAGE")
frame:RegisterEvent("UNIT_FOCUS")
frame:RegisterEvent("UNIT_ENERGY")
frame:RegisterEvent("UNIT_RUNIC_POWER")
frame:RegisterEvent("UNIT_MAXMANA")
frame:RegisterEvent("UNIT_MAXRAGE")
frame:RegisterEvent("UNIT_MAXFOCUS")
frame:RegisterEvent("UNIT_MAXENERGY")
frame:RegisterEvent("UNIT_MAXRUNIC_POWER")

-- The frame exists only with a target: the client shows and hides it, like any secure
-- unit frame.
if RegisterUnitWatch then
	RegisterUnitWatch(frame)
end


-- ------------------------------------------------- Target of target
-- mainline/TargetFrame.xml TargetofTargetFrameTemplate: 120 x 49, TOPRIGHT on the target
-- frame's BOTTOMRIGHT at (12, 10), portrait 37 x 37 at (5, -5). camelot 70450
-- TargetOfTargetMixin:OnLoad: name centered right of the portrait (2, -1); health bar 70 x 10
-- BOTTOMRIGHT on the RIGHT point at (-5, -3), i.e. TOPLEFT (45, -17.5); power bar 74 x 7 at
-- (-2, -2) of the health bar's BOTTOMLEFT, i.e. (43, -29.5).

local tot = CreateFrame("Button", "ForeverUITargetOfTarget", frame, "SecureUnitButtonTemplate")
tot:SetWidth(120)
tot:SetHeight(49)
tot:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 12, 10)
tot:SetAttribute("unit", "targettarget")
tot:SetAttribute("*type1", "target")
tot:RegisterForClicks("AnyUp")
tot.unit = "targettarget"

local totPortrait = tot:CreateTexture(nil, "BACKGROUND")
totPortrait:SetWidth(37)
totPortrait:SetHeight(37)
totPortrait:SetPoint("TOPLEFT", 5, -5)

local totHealth = tot:CreateTexture(nil, "OVERLAY")
totHealth:SetPoint("TOPLEFT", 45, -17.5)

local totPower = tot:CreateTexture(nil, "OVERLAY")
totPower:SetPoint("TOPLEFT", 43, -29.5)

local totArt = tot:CreateTexture(nil, "ARTWORK")
totArt:SetPoint("CENTER")
ForeverUI.SetAtlas(totArt, "ui-hud-unitframe-targetoftarget-portraiton")

local totName = tot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
totName:SetWidth(68)
totName:SetHeight(10)
totName:SetJustifyH("CENTER")
totName:SetPoint("TOPLEFT", totPortrait, "TOPRIGHT", 2, -1)

local TOT_POWER = {
	MANA = "ui-hud-unitframe-targetoftarget-portraiton-bar-mana",
	RAGE = "ui-hud-unitframe-targetoftarget-portraiton-bar-rage",
	FOCUS = "ui-hud-unitframe-targetoftarget-portraiton-bar-focus",
	ENERGY = "ui-hud-unitframe-targetoftarget-portraiton-bar-energy",
	RUNIC_POWER = "ui-hud-unitframe-targetoftarget-portraiton-bar-runicpower",
}

local function updateTargetOfTarget()
	if not UnitExists("targettarget") then
		return
	end

	local maximum = UnitHealthMax("targettarget")
	local fraction = 0
	if maximum and maximum > 0 then
		fraction = UnitHealth("targettarget") / maximum
	end
	ForeverUI.SetAtlasFill(totHealth, "ui-hud-unitframe-targetoftarget-portraiton-bar-health", fraction)

	local powerType, powerToken = UnitPowerType("targettarget")
	local powerMax = UnitPowerMax("targettarget", powerType)
	local powerFraction = 0
	if powerMax and powerMax > 0 then
		powerFraction = UnitPower("targettarget", powerType) / powerMax
	end
	ForeverUI.SetAtlasFill(totPower, TOT_POWER[powerToken or ""] or TOT_POWER.MANA, powerFraction)
	ForeverUI.TintPower(totPower, "targettarget")

	totName:SetText(UnitName("targettarget"))
	SetPortraitTexture(totPortrait, "targettarget")
end

tot:SetScript("OnEvent", function(_self, event, unit)
	if event == "PLAYER_TARGET_CHANGED" or unit == "target" then
		updateTargetOfTarget()
	end
end)

tot:RegisterEvent("PLAYER_TARGET_CHANGED")
tot:RegisterEvent("UNIT_TARGET")

-- "targettarget" gets no unit event in 3.3.5 (the client's own frame polls it every frame,
-- TargetofTarget_Update as OnUpdate): polled while shown, five times a second
tot:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.2 then
		self.elapsed = 0
		updateTargetOfTarget()
	end
end)

if RegisterUnitWatch then
	RegisterUnitWatch(tot)
end

tot.portrait = totPortrait
tot.healthFill = totHealth
tot.powerFill = totPower
tot.art = totArt
tot.nameText = totName

ForeverUI.TargetFrame = frame
ForeverUI.Layout.Register(frame, "targetframe", L.TARGETFRAME_EDIT_LABEL, "TOPLEFT", "TOPLEFT", 250, -10)
