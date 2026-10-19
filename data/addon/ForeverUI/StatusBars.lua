-- Bottom status bars: experience and reputation.
-- mainline/StatusTrackingBarTemplate.xml: both bars are the same object (background, fill,
-- frame over it, centered text), so both are built the same way.
-- camelot/StatusTrackingBarConstants.lua: the containers are one bar height apart, so the
-- bars touch; camelot's image is 13 high. The game shows reputation above experience,
-- although the priorities (Experience 0, Reputation 2) sorted descending suggest the reverse.
-- Reputation fill color by standing (shared/ReputationBar.lua), same ranges as 3.3.5
-- FACTION_BAR_COLORS.
-- The experience bar hides at max level and reputation moves down to its place (camelot
-- StatusTrackingBarManager fills containers from the bottom). Reputation hides when no
-- faction is watched.
-- Both bars span the bottom row (action bar, micro menu, bags) and sit on its top, measured
-- by BottomBar (ForeverUI.BottomRow). Each stays movable. Both carry camelot's 19 dividers.

local HEIGHT = 13   -- camelot image height (1020 x 13)

-- Dividers (camelot StatusTrackingBarContainerMixin:UpdateDividers, unchanged in 70450):
-- STATUS_BAR_NUM_SEGMENTS = 20 segments, so 19 StatusBarDividerTemplate frames (3 x 10,
-- ui-hud-experiencebar-divider, OVERLAY) at LEFT (width / 20 * i, 0), above the fill.
-- Rested tick (ExhaustionTick, UI-HUD-ExperienceBar-Frame-Pip, 10 x 14): centered on the right
-- end of the rested fill, shown while rested experience remains. The rested fill is
-- Fill-Rested (dark blue); while rested, the earned fill is Fill-Prediction (bright blue) instead
-- of Fill-Experience (purple). camelot's ExpBarOverrides names them the other way round
-- (earned Fill-Rested, bonus Fill-Prediction); the game shows them as here (seen in game).
local SEGMENTS = 20
local DIVIDER_W, DIVIDER_H = 3, 10
local L = ForeverUI.L

local ATLAS_REPUTATION = {
	"ui-hud-experiencebar-fill-reputation-faction-red-camelot",     -- hated
	"ui-hud-experiencebar-fill-reputation-faction-red-camelot",     -- hostile
	"ui-hud-experiencebar-fill-reputation-faction-orange-camelot",  -- unfriendly
	"ui-hud-experiencebar-fill-reputation-faction-yellow-camelot",  -- neutral
	"ui-hud-experiencebar-fill-reputation-faction-green-camelot",   -- friendly
	"ui-hud-experiencebar-fill-reputation-faction-green-camelot",   -- honored
	"ui-hud-experiencebar-fill-reputation-faction-green-camelot",   -- revered
	"ui-hud-experiencebar-fill-reputation-faction-green-camelot",   -- exalted
}

-- Crops a fill to the fraction. The image has rounded ends: cutting it on the right gives
-- the straight edge of a partial fill. width: bar width at 100 %.
local function populate(texture, atlas, fraction, width)
	local e = atlas and ForeverUI.AtlasEntry(atlas)
	if not e or not fraction or fraction ~= fraction or fraction <= 0 then
		texture:Hide()
		return
	end

	if fraction > 1 then
		fraction = 1
	end

	local w = width * fraction
	if w < 1 then
		texture:Hide()
		return
	end

	texture:SetTexture(e[1])
	texture:SetTexCoord(e[2], e[2] + (e[3] - e[2]) * fraction, e[4], e[5])
	texture:SetWidth(w)
	texture:Show()
end

local function createBar(name)
	local bar = CreateFrame("Frame", name, UIParent)
	bar:SetHeight(HEIGHT)
	bar:EnableMouse(true)

	local background = bar:CreateTexture(nil, "BACKGROUND")
	ForeverUI.SetAtlas(background, "ui-hud-experiencebar-background-camelot", true)
	background:SetAllPoints(bar)

	-- Rested part shows behind the earned part: lower layer, same left edge.
	local rested = bar:CreateTexture(nil, "BORDER")
	rested:SetPoint("LEFT", bar, "LEFT", 0, 0)
	rested:SetHeight(HEIGHT)
	rested:Hide()

	local fill = bar:CreateTexture(nil, "ARTWORK")
	fill:SetPoint("LEFT", bar, "LEFT", 0, 0)
	fill:SetHeight(HEIGHT)
	fill:Hide()

	local frame = bar:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(frame, "ui-hud-experiencebar-frame-camelot", true)
	frame:SetAllPoints(bar)

	local text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("CENTER")
	text:Hide()

	bar.background, bar.rested, bar.fill, bar.frame, bar.text =
		background, rested, fill, frame, text

	-- Dividers and rested tick, in a child frame above the fill and the frame art
	local marks = CreateFrame("Frame", nil, bar)
	marks:SetAllPoints(bar)
	marks:SetFrameLevel(bar:GetFrameLevel() + 1)
	bar.dividers = {}
	for i = 1, SEGMENTS - 1 do
		local divider = marks:CreateTexture(nil, "OVERLAY")
		ForeverUI.SetAtlas(divider, "ui-hud-experiencebar-divider", true)
		divider:SetWidth(DIVIDER_W)
		divider:SetHeight(DIVIDER_H)
		bar.dividers[i] = divider
	end
	local tick = marks:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(tick, "ui-hud-experiencebar-frame-pip-camelot")
	tick:Hide()
	bar.marks, bar.tick = marks, tick

	bar:SetScript("OnEnter", function(self)
		self.text:Show()
	end)
	bar:SetScript("OnLeave", function(self)
		self.text:Hide()
	end)

	return bar
end

-- Places the dividers on the bar's current width (camelot: on each layout change)
local function placeDividers(bar)
	local width = bar:GetWidth() or 0
	for i, divider in ipairs(bar.dividers) do
		divider:ClearAllPoints()
		divider:SetPoint("LEFT", bar, "LEFT", math.floor(width / SEGMENTS * i + 0.5), 0)
	end
end

local experience = createBar("ForeverUIExperienceBar")
local reputation = createBar("ForeverUIReputationBar")

-- Reputation: just above experience, or in its place when experience is hidden (max level)
local function placeReputation()
	local rowLine = ForeverUI.BottomRow
	if not rowLine then
		return
	end
	local center = (rowLine.left + rowLine.right) / 2
	local y = experience:IsShown() and rowLine.top + HEIGHT or rowLine.top
	ForeverUI.Layout.SetDefaults("reputationbar", "BOTTOM", "BOTTOM", center, y)
end

-- ---------- Experience
local function updateExperience()
	local maximum = UnitXPMax("player")
	local level = UnitLevel("player")
	local maxLevel = MAX_PLAYER_LEVEL or 80

	-- hidden too while a vehicle bar replaces the player's bars (Vehicle.lua)
	if ForeverUI.VehicleArt or not maximum or maximum <= 0 or (level and level >= maxLevel) then
		experience:Hide()
		placeReputation()
		return
	end

	experience:Show()
	placeReputation()

	local width = experience:GetWidth()
	local earned = UnitXP("player")
	local rested = (GetXPExhaustion and GetXPExhaustion()) or 0
	local fraction = earned / maximum

	populate(experience.rested, "ui-hud-experiencebar-fill-rested-camelot",
		(earned + rested) / maximum, width)
	-- rested tick at the end of the rested part
	if rested > 0 then
		local x = math.min(1, (earned + rested) / maximum) * width
		experience.tick:ClearAllPoints()
		experience.tick:SetPoint("CENTER", experience, "LEFT", x, 0)
		experience.tick:Show()
	else
		experience.tick:Hide()
	end
	-- rested (GetRestState 1): the earned part turns bright blue over the darker rested bonus
	local isRested = GetRestState and GetRestState() == 1
	populate(experience.fill, isRested and "ui-hud-experiencebar-fill-prediction-camelot"
		or "ui-hud-experiencebar-fill-experience-camelot", fraction, width)

	experience.text:SetText(string.format("%d / %d  (%d%%)", earned, maximum,
		math.floor(fraction * 100)))
end

-- ---------- Reputation
local function updateReputation()
	local name, standingId, minimum, maximum, value = GetWatchedFactionInfo()
	if ForeverUI.VehicleArt or not name or not maximum or maximum <= minimum then
		reputation:Hide()
		return
	end

	reputation:Show()

	local span = maximum - minimum
	local earned = value - minimum
	local fraction = earned / span

	populate(reputation.fill, ATLAS_REPUTATION[standingId] or ATLAS_REPUTATION[4],
		fraction, reputation:GetWidth())

	reputation.text:SetText(string.format("%s  %d / %d", name, earned, span))
end

-- ---------- Placement
-- Both bars span the row (action bar, micro menu, bags) and touch: experience on the row,
-- reputation just above (or on the row without experience).
local function place()
	local rowLine = ForeverUI.BottomRow
	if not rowLine then
		return
	end

	local width = rowLine.right - rowLine.left
	local center = (rowLine.left + rowLine.right) / 2

	experience:SetWidth(width)
	reputation:SetWidth(width)
	placeDividers(experience)
	placeDividers(reputation)

	ForeverUI.Layout.SetDefaults("experiencebar", "BOTTOM", "BOTTOM", center, rowLine.top)
	placeReputation()
end

local listener = CreateFrame("Frame")
listener:RegisterEvent("PLAYER_ENTERING_WORLD")
listener:RegisterEvent("PLAYER_XP_UPDATE")
listener:RegisterEvent("PLAYER_LEVEL_UP")
listener:RegisterEvent("UPDATE_EXHAUSTION")
listener:RegisterEvent("PLAYER_UPDATE_RESTING")
listener:RegisterEvent("UPDATE_FACTION")
listener:SetScript("OnEvent", function(_self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		-- The client's bars: experience, rested tick, and reputation, which re-places itself on
		-- every update.
		ForeverUI.Suppress(MainMenuExpBar)
		ForeverUI.Suppress(ExhaustionTick)
		ForeverUI.Suppress(ReputationWatchBar)
		place()
	end
	updateExperience()
	updateReputation()
end)

ForeverUI.Layout.Register(experience, "experiencebar", L.STATUSBARS_EDIT_LABEL_EXPERIENCE, "BOTTOM", "BOTTOM", 0, 54)
ForeverUI.Layout.Register(reputation, "reputationbar", L.STATUSBARS_EDIT_LABEL_REPUTATION, "BOTTOM", "BOTTOM", 0, 67)
place()
updateExperience()
updateReputation()

ForeverUI.ReputationBar = reputation
ForeverUI.StatusBarsUpdate = function()
	updateExperience()
	updateReputation()
end
-- the row changed width (BottomBar.lua: a micro button was added)
ForeverUI.StatusBarsLayout = function()
	place()
	updateExperience()
	updateReputation()
end
