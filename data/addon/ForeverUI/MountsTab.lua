-- ForeverUI: the mounts tab of the character sheet, under the pet tab (3.3.5 showed mounts as a
-- page of the pet screen). Left pane: the selected mount in 3D, turned by the arrows or the
-- mouse like the pet. Right pane: the mounts as equipment set cards (EquipmentManager.lua
-- measures), without the edit and delete buttons, scrolled by camelot's bar.
-- GetCompanionInfo("MOUNT", i) returns creatureID, name, spellID, icon, active.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI

-- The equipment set card: 40 high, background 45 high from x = 42 (the art keeps its 5 px
-- overhang), icon 36 at x = 4 in its circle, name from x = 55, check 12 px from the right
-- edge. Without edit and delete buttons the name keeps only the check's room.
local CARD_H = 40
local CARD_BACKGROUND_X, CARD_BACKGROUND_H = 42, 45
local CARD_ICON, CARD_ICON_X = 36, 4
local CARD_TEXT_X, CARD_TEXT_H = 55, 38
local CHECKMARK_X = -12
local TEXT_RIGHT = 30

-- List: 9 from the pane's left edge and 8 from its top, as the set list; 8 from the right edge
-- without a bar, 21 with one (5 gap, 8 bar, 8 margin).
local LIST_X, LIST_Y = 9, -8
local LIST_RIGHT, LIST_RIGHT_BAR = -8, -21
local LIST_BOTTOM = 8

-- Rotation arrows of the character and pet previews: 35 x 35, side by side, centered on the
-- pane's top
local ROTATION_SIZE, ROTATION_Y, ROTATION_GAP = 35, -12, 4

-- Right pane height before the window is laid out (GetHeight returns 0 then)
local PANE_H = 464

local ATLAS_BACKGROUND = "ui-character-info-outfitcard"
local ATLAS_HOVER = "ui-character-info-outfitcard-hover"
local ATLAS_SELECTED = "ui-character-info-outfitcard-selected"
local ATLAS_CHECKMARK = "ui-character-info-icon-tick"
local ATLAS_CIRCLE = "ui-character-info-outfiticon-frame"

local preview, panel, list, bar
local cards, offset = {}, 0
local selected                       -- creature id of the chosen mount

local layout

-- ---------------------------------------------------------------- Data

local function count()
	return (GetNumCompanions and GetNumCompanions("MOUNT")) or 0
end

-- Index of the chosen mount. With none chosen yet, or gone, the ridden one, else the first.
local function selectedIndex()
	local total, ridden = count(), nil
	for index = 1, total do
		local creatureID, _, _, _, active = GetCompanionInfo("MOUNT", index)
		if creatureID == selected then
			return index
		end
		if active and not ridden then
			ridden = index
		end
	end
	local index = ridden or (total > 0 and 1) or nil
	selected = index and GetCompanionInfo("MOUNT", index) or nil
	return index
end

-- ---------------------------------------------------------------- Preview

local function updatePreview()
	if not preview or not preview:IsVisible() then
		return
	end
	local index = selectedIndex()
	local creatureID = index and GetCompanionInfo("MOUNT", index)
	if creatureID and preview.creature ~= creatureID then
		preview.creature = creatureID
		preview:SetCreature(creatureID)
		preview:SetRotation(preview.rotation or 0)
	end
end

-- side: "Left" or "Right"; x: offset from the pane's top center. Named after the model, as
-- Model_OnUpdate looks them up to turn it while held.
local function createArrow(pane, side, x)
	local button = CreateFrame("Button", preview:GetName() .. "Rotate" .. side .. "Button", preview)
	button:SetWidth(ROTATION_SIZE)
	button:SetHeight(ROTATION_SIZE)
	button:SetPoint("TOP", pane, "TOP", x, ROTATION_Y)
	button:SetFrameLevel(preview:GetFrameLevel() + 2)
	button:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
	button:SetNormalTexture("Interface\\Buttons\\UI-Rotation" .. side .. "-Button-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-Rotation" .. side .. "-Button-Down")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
	button:GetHighlightTexture():SetBlendMode("ADD")
	local turn = side == "Left" and Model_RotateLeft or Model_RotateRight
	button:SetScript("OnClick", function()
		turn(preview)
	end)
end

-- Left pane content; host: the left pane frame. Returns its root (see Panes.Register).
local function build(host)
	if preview then
		updatePreview()
		return preview.pane, {}
	end

	local pane = CreateFrame("Frame", "ForeverUIMountsPreviewPane", host)
	pane:SetAllPoints(host)

	preview = CreateFrame("PlayerModel", "ForeverUIMountsPreview", pane)
	preview:SetAllPoints(pane)
	preview.pane = pane
	Model_OnLoad(preview)

	local half = ROTATION_SIZE / 2 + ROTATION_GAP / 2
	createArrow(pane, "Left", -half)
	createArrow(pane, "Right", half)

	preview:SetScript("OnUpdate", Model_OnUpdate)
	-- A model hidden when its creature was set shows nothing: set it again on show
	preview:SetScript("OnShow", function(self)
		self.creature = nil
		updatePreview()
	end)
	ForeverUI.RotateWithMouse(preview)

	updatePreview()
	return pane, {}
end

-- ---------------------------------------------------------------- List

local function visibleCards()
	local height = list:GetHeight() or 0
	if height < CARD_H then
		height = PANE_H + LIST_Y - LIST_BOTTOM
	end
	return math.max(1, math.floor(height / CARD_H))
end

-- atlas: card art; layer: draw layer. Spans the card from x = 42, as the set card's.
local function cardArt(card, atlas, layer)
	local texture = card:CreateTexture(nil, layer)
	ForeverUI.SetAtlas(texture, atlas, true)
	texture:SetHeight(CARD_BACKGROUND_H)
	texture:SetPoint("TOPLEFT", card, "TOPLEFT", CARD_BACKGROUND_X, 0)
	texture:SetPoint("TOPRIGHT", card, "TOPRIGHT", 0, 0)
	return texture
end

local function createCard(rank)
	local card = CreateFrame("Button", "ForeverUIMountsCard" .. rank, list)
	card:SetHeight(CARD_H)

	-- Selected (ARTWORK) draws above hover (BORDER), as on the set cards
	card.background = cardArt(card, ATLAS_BACKGROUND, "BACKGROUND")
	card.hover = cardArt(card, ATLAS_HOVER, "BORDER")
	card.hover:Hide()
	card.selected = cardArt(card, ATLAS_SELECTED, "ARTWORK")
	card.selected:Hide()

	local icon = card:CreateTexture(nil, "ARTWORK")
	icon:SetWidth(CARD_ICON)
	icon:SetHeight(CARD_ICON)
	icon:SetPoint("LEFT", card, "LEFT", CARD_ICON_X, 0)
	card.icon = icon

	local circle = card:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(circle, ATLAS_CIRCLE)
	circle:SetPoint("CENTER", icon, "CENTER", 0, 0)

	-- The ridden mount carries the check, as the worn set does
	local check = card:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(check, ATLAS_CHECKMARK)
	check:SetPoint("RIGHT", card, "RIGHT", CHECKMARK_X, 0)
	check:Hide()
	card.check = check

	local name = card:CreateFontString(nil, "ARTWORK")
	name:SetFontObject(GameFontNormalLeft or GameFontNormal)
	name:SetHeight(CARD_TEXT_H)
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", card, "LEFT", CARD_TEXT_X, 0)
	name:SetPoint("RIGHT", card, "RIGHT", -TEXT_RIGHT, 0)
	card.name = name

	card:SetScript("OnEnter", function(self)
		self.hover:Show()
	end)
	card:SetScript("OnLeave", function(self)
		self.hover:Hide()
	end)
	card:SetScript("OnClick", function(self)
		if self.creatureID then
			selected = self.creatureID
			layout()
		end
	end)

	cards[rank] = card
	return card
end

-- Fills the cards from the scroll offset, then the bar and the preview
layout = function()
	if not list then
		return
	end

	local total = count()
	local visibleCount = visibleCards()
	offset = math.max(0, math.min(offset, total - visibleCount))
	local current = selectedIndex()

	for rank = 1, visibleCount do
		local card = cards[rank] or createCard(rank)
		local index = offset + rank
		local creatureID, name, _, icon, active
		if index <= total then
			creatureID, name, _, icon, active = GetCompanionInfo("MOUNT", index)
		end
		if creatureID then
			card:ClearAllPoints()
			card:SetPoint("TOPLEFT", list, "TOPLEFT", 0, -(rank - 1) * CARD_H)
			card:SetPoint("TOPRIGHT", list, "TOPRIGHT", 0, -(rank - 1) * CARD_H)
			card.creatureID = creatureID
			card.icon:SetTexture(icon)
			card.name:SetText(name)
			if index == current then
				card.selected:Show()
			else
				card.selected:Hide()
			end
			if active then
				card.check:Show()
			else
				card.check:Hide()
			end
			card:Show()
		else
			card.creatureID = nil
			card:Hide()
		end
	end
	for rank = visibleCount + 1, #cards do
		cards[rank]:Hide()
	end

	bar:Configure(total, visibleCount, offset)
	updatePreview()
end

-- Right pane content; host: the right pane frame. Returns its root (see Panes.Register).
local function buildRight(host)
	if panel then
		layout()
		return panel, {}
	end

	panel = CreateFrame("Frame", "ForeverUIMountsListPane", host)
	panel:SetAllPoints(host)

	list = CreateFrame("Frame", "ForeverUIMountsList", panel)
	list:SetPoint("TOPLEFT", panel, "TOPLEFT", LIST_X, LIST_Y)
	list:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", LIST_RIGHT, LIST_BOTTOM)

	-- The cards follow the list's width: with the bar shown they give it their room
	bar = ForeverUI.CreateScrollBar("ForeverUIMountsScrollBar", panel, list)
	bar.onScroll = function(new)
		offset = new
		layout()
	end
	bar.onVisibility = function(hasBar)
		list:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT",
			hasBar and LIST_RIGHT_BAR or LIST_RIGHT, LIST_BOTTOM)
	end

	list:EnableMouseWheel(true)
	list:SetScript("OnMouseWheel", function(_, direction)
		bar:MoveTo(offset - direction)
	end)
	panel:SetScript("OnShow", layout)

	layout()
	return panel, {}
end

ForeverUI.MountsTab = { Build = build, BuildRight = buildRight }

-- Learned, forgotten, mounted or dismounted
local listener = CreateFrame("Frame")
for _, event in ipairs({ "COMPANION_LEARNED", "COMPANION_UNLEARNED", "COMPANION_UPDATE" }) do
	listener:RegisterEvent(event)
end
listener:SetScript("OnEvent", function()
	if panel and panel:IsVisible() then
		layout()
	end
end)
