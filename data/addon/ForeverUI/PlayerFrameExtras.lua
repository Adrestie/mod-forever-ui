-- ForeverUI: player frame extras: PvP icon, raid group, play time and damage taken.
-- They live in ForeverUI.PlayerFrame's overlayHolder (above the art) and move with the frame.
-- Sizes and offsets: camelot PvP icon (scale 0.8, no circle since 70450) and mainline
-- PlayerFrame.xml (GroupIndicator, PlayerPlayTime, HitIndicator).

local frame = ForeverUI.PlayerFrame
local holder = frame.overlayHolder

local PVP_FFA = "ui-hud-unitframe-player-pvp-ffaicon"
local PVP_FACTION = {
	Alliance = "ui-hud-unitframe-smallcircle-alliance",
	Horde = "ui-hud-unitframe-smallcircle-horde",
}
local GROUP_LEFT = "ui-hud-unitframe-player-groupindicatorleft"
local GROUP_RIGHT = "ui-hud-unitframe-player-groupindicatorright"
local GROUP_MID = "_ui-hud-unitframe-player-groupindicatormid"
local PLAYTIME_TIRED_ATLAS = "ui-hud-unitframe-player-playtimetired"
local PLAYTIME_UNHEALTHY_ATLAS = "ui-hud-unitframe-player-playtimeunhealthy"

-- ------------------------------------------------------------------- PvP
-- camelot 70450 (PlayerPvpBackgroundIconTemplate, UnitFramePvPIndicatorStyle): no background
-- circle any more; the icon alone, at scale 0.8 with its TOP at (22, -65) in its own units, so
-- centered at (17.6, -62.8) for a 24 x 27 icon. Kept at that center, but at full size and drawn
-- ABOVE the level circle and its text (user's request, 2026-10-17: camelot puts it under them,
-- where it is hardly seen): a child frame one level above the holder. The FFA icon (28 x 44)
-- keeps scale 0.8.
local PVP_X, PVP_Y = 17.6, -62.8
local PVP_FFA_SCALE = 0.8
local pvpHolder = CreateFrame("Frame", nil, holder)
pvpHolder:SetAllPoints(holder)
pvpHolder:SetFrameLevel(holder:GetFrameLevel() + 1)
local pvpIcon = pvpHolder:CreateTexture(nil, "OVERLAY")
pvpIcon:SetPoint("CENTER", frame, "TOPLEFT", PVP_X, PVP_Y)
pvpIcon:Hide()

local function updatePvP()
	local faction = UnitFactionGroup("player")

	if UnitIsPVPFreeForAll("player") then
		if ForeverUI.SetAtlas(pvpIcon, PVP_FFA) then
			pvpIcon:SetWidth(28 * PVP_FFA_SCALE)
			pvpIcon:SetHeight(44 * PVP_FFA_SCALE)
			pvpIcon:Show()
			return
		end
	elseif faction and faction ~= "Neutral" and UnitIsPVP("player") then
		local atlas = PVP_FACTION[faction]
		if atlas and ForeverUI.SetAtlas(pvpIcon, atlas) then
			pvpIcon:SetWidth(24)
			pvpIcon:SetHeight(27)
			pvpIcon:Show()
			return
		end
	end

	pvpIcon:Hide()
end

-- ------------------------------------------------------------ raid group
local groupIndicator = CreateFrame("Frame", nil, holder)
groupIndicator:SetWidth(10)
groupIndicator:SetHeight(16)
groupIndicator:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", 210, -29)
groupIndicator:Hide()

local groupLeft = groupIndicator:CreateTexture(nil, "BACKGROUND")
ForeverUI.SetAtlas(groupLeft, GROUP_LEFT)
groupLeft:SetPoint("TOPLEFT")

local groupRight = groupIndicator:CreateTexture(nil, "BACKGROUND")
ForeverUI.SetAtlas(groupRight, GROUP_RIGHT)
groupRight:SetPoint("TOPRIGHT")

local groupMid = groupIndicator:CreateTexture(nil, "BACKGROUND")
ForeverUI.SetAtlas(groupMid, GROUP_MID, true)
groupMid:SetPoint("LEFT", groupLeft, "RIGHT")
groupMid:SetPoint("RIGHT", groupRight, "LEFT")

local groupText = groupIndicator:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
groupText:SetAlpha(0.7)
groupText:SetPoint("LEFT", 20, 2)

local function updateGroup()
	local members = GetNumRaidMembers and GetNumRaidMembers() or 0
	if members == 0 then
		groupIndicator:Hide()
		return
	end

	local playerName = UnitName("player")
	for index = 1, members do
		local name, _, subgroup = GetRaidRosterInfo(index)
		if name == playerName and subgroup then
			groupText:SetText(GROUP .. " " .. subgroup)
			groupIndicator:SetWidth(groupText:GetWidth() + 40)
			groupIndicator:Show()
			return
		end
	end

	groupIndicator:Hide()
end

-- ------------------------------------------------------------- play time
local playTime = CreateFrame("Frame", nil, holder)
playTime:SetWidth(29)
playTime:SetHeight(29)
playTime:SetPoint("TOPLEFT", frame, "TOPRIGHT", -21, -24)
playTime:EnableMouse(true)
playTime:Hide()

local playTimeIcon = playTime:CreateTexture(nil, "ARTWORK")
playTimeIcon:SetAllPoints(playTime)

playTime:SetScript("OnEnter", function(self)
	if not self.tooltip then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
end)
playTime:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

local function updatePlayTime()
	if PartialPlayTime and PartialPlayTime() then
		ForeverUI.SetAtlas(playTimeIcon, PLAYTIME_TIRED_ATLAS, true)
		playTime.tooltip = PLAYTIME_TIRED
		playTime:Show()
	elseif NoPlayTime and NoPlayTime() then
		ForeverUI.SetAtlas(playTimeIcon, PLAYTIME_UNHEALTHY_ATLAS, true)
		playTime.tooltip = PLAYTIME_UNHEALTHY
		playTime:Show()
	else
		playTime:Hide()
	end
end

-- ---------------------------------------------------------- damage taken
local hitText = holder:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
hitText:SetPoint("CENTER", frame, "TOPLEFT", 54, -50)
hitText:Hide()

if CombatFeedback_Initialize then
	CombatFeedback_Initialize(frame, hitText, 30)
end

-- ---------------------------------------------------------------- events
local extras = CreateFrame("Frame")
extras:RegisterEvent("PLAYER_ENTERING_WORLD")
extras:RegisterEvent("PLAYER_FLAGS_CHANGED")
extras:RegisterEvent("UNIT_FACTION")
extras:RegisterEvent("RAID_ROSTER_UPDATE")
extras:RegisterEvent("PARTY_MEMBERS_CHANGED")
extras:RegisterEvent("PLAYTIME_CHANGED")
extras:RegisterEvent("UNIT_COMBAT")

extras:SetScript("OnEvent", function(_self, event, unit, action, descriptor, damage, damageType)
	if event == "UNIT_COMBAT" then
		if unit == "player" and CombatFeedback_OnCombatEvent then
			CombatFeedback_OnCombatEvent(frame, action, descriptor, damage, damageType)
		end
		return
	end

	if event == "PLAYTIME_CHANGED" then
		updatePlayTime()
		return
	end

	if event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		updateGroup()
		return
	end

	if event == "UNIT_FACTION" and unit ~= "player" then
		return
	end

	updatePvP()
	if event == "PLAYER_ENTERING_WORLD" then
		updateGroup()
		updatePlayTime()
	end
end)

-- The client's CombatFeedback code animates the damage text: UNIT_COMBAT feeds it (above)
-- and it runs every frame, as in PlayerFrame_OnUpdate.
extras:SetScript("OnUpdate", function(_self, elapsed)
	if CombatFeedback_OnUpdate then
		CombatFeedback_OnUpdate(frame, elapsed)
	end
end)

ForeverUI.PlayerFrameExtras = {
	pvpIcon = pvpIcon,
	pvpHolder = pvpHolder,
	groupIndicator = groupIndicator,
	groupText = groupText,
	playTime = playTime,
	playTimeIcon = playTimeIcon,
	hitText = hitText,
	updatePvP = updatePvP,
	updateGroup = updateGroup,
	updatePlayTime = updatePlayTime,
}
