-- ForeverUI: the target's cast bar, under the target frame. The client's TargetFrameSpellBar is
-- a child of TargetFrame, which ForeverUI hides, so the target's casts showed nowhere.
-- Same art and rules as the player bar (CastBar.lua: ui-castingbar-*, UnitCastingInfo and
-- UnitChannelInfo, the castID of each event), at the size of 3.3.5's TargetSpellBarTemplate
-- (150 wide), with the spell icon on its left as TargetFrame_CreateSpellbar shows it.
-- Placed as Target_Spellbar_AdjustPosition does: (25, 7) from the frame's BOTTOMLEFT, lower under
-- the aura rows and under the target of target when they show (measured, so it covers neither).
-- The client's option (showTargetCastbar) is followed.

local BAR_WIDTH = 150                     -- TargetSpellBarTemplate
local K = BAR_WIDTH / 214                 -- the player bar's frame art is 214 wide
local FILL_WIDTH, FILL_HEIGHT = 209 * K, 11 * K
local ICON_SIZE, ICON_GAP = 16, 5         -- CastingBarFrameTemplate's icon, shown on the target bar
local BAR_X, BAR_Y = 25, 7                -- Target_Spellbar_AdjustPosition, no aura row
local GAP = 6                             -- under the last aura row or the target of target
local HOLD_AFTER_END = 1.0

local FILL = {
	standard = "ui-castingbar-filling-standard",
	channel = "ui-castingbar-filling-channel",
	uninterruptible = "ui-castingbar-uninterruptable",
	interrupted = "ui-castingbar-interrupted",
}

local target = ForeverUI.TargetFrame
local targetOfTarget = _G["ForeverUITargetOfTarget"]

local frame = CreateFrame("Frame", "ForeverUITargetCastBar", target)
frame:SetWidth(BAR_WIDTH)
frame:SetHeight(16 * K)
frame:Hide()

local function sized(texture, name)
	local e = ForeverUI.AtlasEntry(name)
	ForeverUI.SetAtlas(texture, name, true)
	if e then
		texture:SetWidth(e[6] * K)
		texture:SetHeight(e[7] * K)
	end
end

local background = frame:CreateTexture(nil, "BACKGROUND")
sized(background, "ui-castingbar-background")
background:SetPoint("CENTER")

local fill = frame:CreateTexture(nil, "BORDER")
fill:SetPoint("LEFT", background, "LEFT", 0, 0)

local border = frame:CreateTexture(nil, "ARTWORK")
sized(border, "ui-castingbar-frame")
border:SetPoint("CENTER")

local icon = frame:CreateTexture(nil, "ARTWORK")
icon:SetWidth(ICON_SIZE)
icon:SetHeight(ICON_SIZE)
icon:SetPoint("RIGHT", frame, "LEFT", -ICON_GAP, 0)

-- camelot's target bar (SmallCastingBarFrameTemplate): the shield is behind the spell icon and
-- holds it, 29 x 33 for a 20 x 20 icon, from (-5, 4) of the icon's top left; scaled to our icon
local SHIELD_SCALE = ICON_SIZE / 20
local shield = frame:CreateTexture(nil, "BACKGROUND")
ForeverUI.SetAtlas(shield, "ui-castingbar-shield", true)
shield:SetWidth(29 * SHIELD_SCALE)
shield:SetHeight(33 * SHIELD_SCALE)
shield:SetPoint("TOPLEFT", icon, "TOPLEFT", -5 * SHIELD_SCALE, 4 * SHIELD_SCALE)
shield:Hide()

local spellText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
spellText:SetPoint("CENTER", frame, "CENTER", 0, 0)
spellText:SetWidth(BAR_WIDTH - 8)
spellText:SetHeight(12)

-- Under the frame, its aura rows and the target of target. All are children of the target
-- frame, so their edges compare in the same units.
local function place()
	local y = BAR_Y
	local bottom = target:GetBottom()
	if bottom then
		local auras = ForeverUI.TargetFrameAuras
		local top = auras and auras.height > 0 and auras.container:GetTop()
		if top then
			y = math.min(y, top - auras.height - GAP - bottom)
		end
		local totBottom = targetOfTarget and targetOfTarget:IsShown() and targetOfTarget:GetBottom()
		if totBottom then
			y = math.min(y, totBottom - GAP - bottom)
		end
	end
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", target, "BOTTOMLEFT", BAR_X, y)
end

local function enabled()
	return GetCVar("showTargetCastbar") ~= "0"
end

local function stopBar()
	frame.casting = false
	frame.channeling = false
	frame.holdUntil = nil
	frame:Hide()
end

-- Shows the failed bar for HOLD_AFTER_END seconds; message: text shown on the bar
local function showFailure(message)
	frame.casting = false
	frame.channeling = false
	frame.holdUntil = GetTime() + HOLD_AFTER_END
	ForeverUI.SetAtlasFill(fill, FILL.interrupted, 1, FILL_WIDTH)
	fill:SetHeight(FILL_HEIGHT)
	spellText:SetText(message or "")
	shield:Hide()
	frame:Show()
end

-- Starts the bar from the target's current cast. channel: true for a channeled spell
local function startCast(channel)
	local name, _subtext, text, texture, startTime, endTime, _isTrade, castID, notInterruptible
	if channel then
		name, _subtext, text, texture, startTime, endTime, _isTrade, notInterruptible = UnitChannelInfo("target")
	else
		name, _subtext, text, texture, startTime, endTime, _isTrade, castID, notInterruptible = UnitCastingInfo("target")
	end

	if not name or not enabled() then
		stopBar()
		return
	end

	frame.casting = not channel
	frame.channeling = channel and true or false
	frame.castID = castID
	frame.startTime = startTime / 1000
	frame.endTime = endTime / 1000
	frame.holdUntil = nil
	frame.fillKey = notInterruptible and "uninterruptible" or (channel and "channel" or "standard")

	spellText:SetText(text or name)
	icon:SetTexture(texture)
	if notInterruptible then
		shield:Show()
	else
		shield:Hide()
	end
	place()
	frame:Show()
end

-- A new target: its cast, if any (Target_Spellbar_OnEvent on its updateEvent)
local function refresh()
	if UnitChannelInfo("target") then
		startCast(true)
	elseif UnitCastingInfo("target") then
		startCast(false)
	else
		stopBar()
	end
end

frame:SetScript("OnEvent", function(_self, event, unit, _spell, _rank, castID)
	if event == "PLAYER_TARGET_CHANGED" then
		refresh()
		return
	end
	if event == "CVAR_UPDATE" then
		if unit == "SHOW_TARGET_CASTBAR" then
			refresh()
		end
		return
	end

	if unit ~= "target" then
		return
	end

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		startCast(false)
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		startCast(true)
	elseif event == "UNIT_SPELLCAST_STOP" then
		-- As 3.3.5's CastingBarFrame_OnEvent: only the cast on the bar (its castID)
		if frame.casting and castID == frame.castID then
			stopBar()
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if frame.channeling then
			stopBar()
		end
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		if frame.casting and castID == frame.castID then
			showFailure(event == "UNIT_SPELLCAST_FAILED" and FAILED or INTERRUPTED)
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" then
		shield:Hide()
		frame.fillKey = frame.channeling and "channel" or "standard"
	elseif event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" then
		shield:Show()
		frame.fillKey = "uninterruptible"
	end
end)

frame:SetScript("OnUpdate", function(self)
	if self.holdUntil then
		if GetTime() > self.holdUntil then
			stopBar()
		end
		return
	end

	if not (self.casting or self.channeling) then
		return
	end

	local now = GetTime()
	local total = self.endTime - self.startTime
	if total <= 0 then
		stopBar()
		return
	end

	local fraction = (now - self.startTime) / total
	if fraction < 0 then
		fraction = 0
	elseif fraction > 1 then
		fraction = 1
	end

	-- A cast fills, a channel drains.
	if self.channeling then
		fraction = 1 - fraction
	end

	ForeverUI.SetAtlasFill(fill, FILL[self.fillKey or "standard"], fraction, FILL_WIDTH)
	fill:SetHeight(FILL_HEIGHT)

	if now >= self.endTime then
		stopBar()
	end
end)

for _, event in ipairs({ "PLAYER_TARGET_CHANGED", "CVAR_UPDATE", "UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_INTERRUPTIBLE", "UNIT_SPELLCAST_NOT_INTERRUPTIBLE",
	"UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_CHANNEL_STOP" }) do
	frame:RegisterEvent(event)
end

ForeverUI.TargetCastBar = { Frame = frame, Place = place }
