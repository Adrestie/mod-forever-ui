-- ForeverUI: the loot window with camelot's LootFrame (blizzard_uipanels_game/mainline/
-- lootframe.xml / .lua, scrollingflatpanel.xml / .lua): a flat panel titled ITEMS, 220 wide and
-- 290 high at most, listing one card per loot slot (looting_itemcard_*: background tinted by the
-- quality, stroke, rarity tag with the quality name, 37 x 37 item button, name).
-- The client's LootFrame stays the host: its events, the master loot list (anchored to the
-- button named in LootFrame.selectedLootButton) and CloseLoot when it hides. It stays shown while
-- the loot is open, invisible and mouse-less; our panel lives on UIParent and follows it.
-- 3.3.5 does not tell quest items (no quest border) nor currencies.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI

local Tpl = ForeverUI.Templates

local P = {}
ForeverUI.Loot = P

local N = {
	width = 220, maxHeight = 290, barWidth = 16,  -- panelWidth, panelMaxHeight, ScrollBarWidth
	anchors = 26, extra = 20,                      -- ScrollingFlatPanelMixin:Resize
	list = { 4, -22, 4 },                          -- ScrollBox: TOPLEFT (4, -22), BOTTOM (0, 4)
	pad = 6, spacing = 2, card = 46,               -- ScrollBoxPad, ScrollBoxSpacing, element height
	bar = { -16, -28, 6 },                         -- ScrollBar at the panel's TOPRIGHT / BOTTOMRIGHT
	background = { 6, -20, -2, 2 },                -- DefaultPanelFlatTemplate Bg
	title = { 30, -1, -24, 20, -5 },               -- TitleContainer, its text at TOP (0, -5)
	item = { 5, -4, 37, -157 },                    -- ItemButton TOPLEFT (5, -4), hit rect to the right
	stripe = { 100, 13 },                          -- QualityStripe, TOPRIGHT
	quality = { -4, -2 },                          -- QualityText, TOPRIGHT
	text = { 8, -8, 150, 30 },                     -- Text at the item's TOPRIGHT
	money = { 8, 0, 93, 38 },                      -- money Text at the item's RIGHT
	highlight = 0.7,                               -- HighlightNameFrame alpha
	shadow = { 30, 0.2 },                          -- ScrollBox shadows: 30 in from each side, scale 0.2
	cursor = { -30, 50, 350 },                     -- lootUnderMouse: x - 30, max(y + 50, 350)
	default = { 16, -116 },                        -- EditModePresetLayouts: TOPLEFT of UIParent
}

-- GameFontWhiteTiny2 (SystemFont_Tiny2: FRIZQT 8, white), missing in 3.3.5
local TINY = CreateFont("ForeverUIFontWhiteTiny2")
TINY:SetFont("Fonts" .. string.char(92) .. "FRIZQT__.TTF", 8, "")
TINY:SetTextColor(1, 1, 1)

local COMMON = 1

local function atlas(t, name)
	return ForeverUI.SetAtlas(t, name, true)
end

-- ------------------------------------------------------------ animations

-- camelot's animation groups, replayed by hand as in ObjectiveTracker.lua: 3.3.5 groups have no
-- fromAlpha / toAlpha nor setToFinalAlpha. One step per frame (the panel, a card): a new step
-- replaces the running one, stop drops it. fn(progress) runs each frame; finish once done,
-- after the loop.
local A = {
	open = 0.1, close = 0.1, drop = 10,           -- ScrollingFlatPanel ShowAnim / HideAnim
	card = 0.1,                                   -- element ShowAnim
	slide = 0.3, slideX = 100, fade = 0.2, fadeDelay = 0.1, -- SlideOutRightAnim
}
local steps = {}
local runner = CreateFrame("Frame")
runner:Hide()
runner:SetScript("OnUpdate", function(self, elapsed)
	local finished
	for key, e in pairs(steps) do
		e.t = e.t + elapsed
		if e.t >= e.delay then
			local p = (e.duration > 0) and math.min(1, (e.t - e.delay) / e.duration) or 1
			e.fn(p)
			if p >= 1 then
				steps[key] = nil
				if e.finish then
					finished = finished or {}
					table.insert(finished, e.finish)
				end
			end
		end
	end
	if finished then
		for _, finish in ipairs(finished) do finish() end
	end
	if not next(steps) then self:Hide() end
end)
P.steps, P.runner = steps, runner

local function play(key, duration, fn, finish)
	steps[key] = { t = 0, delay = 0, duration = duration, fn = fn, finish = finish }
	runner:Show()
end

local function stop(key)
	steps[key] = nil
end

-- smoothing="IN"
local function easeIn(p) return p * p end

-- ------------------------------------------------------------ panel

local panel = CreateFrame("Frame", "ForeverUILootFrame", UIParent)
panel:SetWidth(N.width)
panel:SetHeight(N.maxHeight)
panel:SetFrameStrata("HIGH")
panel:SetToplevel(true)
panel:SetClampedToScreen(true)
panel:EnableMouse(true)
panel:Hide()
P.panel = panel

-- FlatPanelBackgroundTemplate: two 16 x 16 rounded bottom corners, the edge between them and the
-- rest flat, tinted by PANEL_BACKGROUND_COLOR
do
	local B = N.background
	local c = ForeverUI.PanelBackground
	local bottomLeft = panel:CreateTexture(nil, "BACKGROUND")
	ForeverUI.SetAtlas(bottomLeft, "uiframebackground-nineslice-cornerbottomleft")
	bottomLeft:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", B[1], B[4])
	local bottomRight = panel:CreateTexture(nil, "BACKGROUND")
	ForeverUI.SetAtlas(bottomRight, "uiframebackground-nineslice-cornerbottomright")
	bottomRight:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", B[3], B[4])
	local edge = panel:CreateTexture(nil, "BACKGROUND")
	edge:SetTexture(c[1], c[2], c[3], c[4])
	edge:SetPoint("TOPLEFT", bottomLeft, "TOPRIGHT")
	edge:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT")
	local body = panel:CreateTexture(nil, "BACKGROUND")
	body:SetTexture(c[1], c[2], c[3], c[4])
	body:SetPoint("TOPLEFT", panel, "TOPLEFT", B[1], B[2])
	body:SetPoint("BOTTOMRIGHT", bottomRight, "TOPRIGHT")
	for _, t in ipairs({ bottomLeft, bottomRight }) do t:SetVertexColor(c[1], c[2], c[3], c[4]) end
end

-- Bronze metal without portrait (DefaultPanelBaseTemplate's NineSlice), above the cards
local metal = CreateFrame("Frame", nil, panel)
metal:SetAllPoints(panel)
metal:SetFrameLevel(panel:GetFrameLevel() + 10)
Tpl.NineSlice(metal, "ButtonFrameTemplateNoPortrait", panel)

-- Title (TitleContainer, frame level 510 in the source: above the metal)
do
	local T = N.title
	local container = CreateFrame("Frame", nil, panel)
	container:SetHeight(T[4])
	container:SetPoint("TOPLEFT", panel, "TOPLEFT", T[1], T[2])
	container:SetPoint("TOPRIGHT", panel, "TOPRIGHT", T[3], T[2])
	container:SetFrameLevel(panel:GetFrameLevel() + 12)
	local title = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", container, "TOP", 0, T[5])
	title:SetPoint("LEFT", container, "LEFT")
	title:SetPoint("RIGHT", container, "RIGHT")
	title:SetText(ITEMS)
	P.title = title
end

-- ClosePanelButton: closes the host, as 3.3.5's LootCloseButton does
local close = CreateFrame("Button", "ForeverUILootFrameCloseButton", panel)
Tpl.CloseButton(close, panel)
close:SetFrameLevel(panel:GetFrameLevel() + 12)
close:SetScript("OnClick", function() HideUIPanel(LootFrame) end)

-- ScrollBox: a clipping scroll frame; the cards are laid out in its child
local zone = CreateFrame("ScrollFrame", "ForeverUILootList", panel)
zone:SetPoint("TOPLEFT", panel, "TOPLEFT", N.list[1], N.list[2])
zone:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", N.list[1], N.list[3])
zone:SetWidth(N.width - N.pad)
local child = CreateFrame("Frame", nil, zone)
child:SetWidth(N.width - N.pad)
child:SetHeight(1)
zone:SetScrollChild(child)
P.zone, P.child = zone, child

local step = N.card + N.spacing

-- Upper and lower shadows, shown when there are cards beyond the view. As the ScrollBox's Shadows
-- frame: 15 levels above the cards, at scale 0.2; _looting_itemcard_shadow-center at its size,
-- 30 in from each side in that scale, the upper one flipped.
local shadows = CreateFrame("Frame", nil, zone)
shadows:SetAllPoints(zone)
shadows:SetScale(N.shadow[2])
shadows:SetFrameLevel(child:GetFrameLevel() + 15)
P.shadows = shadows
local function shadow(top)
	local t = shadows:CreateTexture(nil, "OVERLAY")
	local e = ForeverUI.AtlasEntry("_looting_itemcard_shadow-center")
	atlas(t, "_looting_itemcard_shadow-center")
	t:SetHeight(e and e[7] or 150)
	if top then
		if e then t:SetTexCoord(e[2], e[3], e[5], e[4]) end
		t:SetPoint("TOPLEFT", shadows, "TOPLEFT", N.shadow[1], 0)
		t:SetPoint("TOPRIGHT", shadows, "TOPRIGHT", -N.shadow[1], 0)
	else
		t:SetPoint("BOTTOMLEFT", shadows, "BOTTOMLEFT", N.shadow[1], 0)
		t:SetPoint("BOTTOMRIGHT", shadows, "BOTTOMRIGHT", -N.shadow[1], 0)
	end
	t:Hide()
	return t
end
local upperShadow, lowerShadow = shadow(true), shadow(false)
P.upperShadow, P.lowerShadow = upperShadow, lowerShadow

local bar = ForeverUI.CreateScrollBar("ForeverUILootScrollBar", panel, zone)
bar:ClearAllPoints()
bar:SetPoint("TOPLEFT", panel, "TOPRIGHT", N.bar[1], N.bar[2])
bar:SetPoint("BOTTOMLEFT", panel, "BOTTOMRIGHT", N.bar[1], N.bar[3])
bar:SetFrameLevel(panel:GetFrameLevel() + 12)
bar:Hide()
P.bar = bar

local function scrollTo(offset)
	local range = math.max(0, child:GetHeight() - zone:GetHeight())
	local y = math.min(offset * step, range)
	zone:SetVerticalScroll(y)
	Tpl.SetShown(upperShadow, y > 0)
	Tpl.SetShown(lowerShadow, y < range)
end
bar.onScroll = scrollTo

zone:EnableMouseWheel(true)
zone:SetScript("OnMouseWheel", function(_, delta)
	if bar:IsShown() then bar:MoveTo((bar.offset or 0) - delta) end
end)

-- ------------------------------------------------------------ cards

local cards = {}
P.cards = cards

local function quality(slot)
	if LootSlotIsCoin(slot) then return COMMON end
	local _, _, _, q = GetLootSlotInfo(slot)
	return q or COMMON
end

local function onEnter(card)
	local enabled = card.item:IsEnabled()
	if not enabled or enabled == 0 then return end
	card.highlight:Show()
	if LootSlotIsItem(card.slot) then
		GameTooltip:SetOwner(card, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("LEFT", card, "RIGHT")
		GameTooltip:SetLootItem(card.slot)
		CursorUpdate(card)
	end
end

local function onLeave(card)
	if GameTooltip:IsOwned(card) then GameTooltip:Hide() end
	ResetCursor()
	card.highlight:Hide()
end

-- LootButton_OnClick: the host keeps what GroupLootDropDown and the master loot confirmation
-- read (the button name anchors the master loot list)
local function onClick(button)
	local card = button.card
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(card.slot))
		return
	end
	StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
	LootFrame.selectedLootButton = button:GetName()
	LootFrame.selectedSlot = card.slot
	LootFrame.selectedQuality = card.quality
	LootFrame.selectedItemName = card.text:GetText()
	LootSlot(card.slot)
end

-- the card at its place in the list, moved right by dx (slide out)
local function placeCard(card, dx)
	card:ClearAllPoints()
	card:SetPoint("TOPLEFT", child, "TOPLEFT", N.pad + dx, card.top)
	card:SetPoint("TOPRIGHT", child, "TOPRIGHT", -N.pad + dx, card.top)
end

-- LootFrameElementTemplate (+ LootFrameItemElementTemplate's stripe and quality name)
local function createCard(i)
	local card = CreateFrame("Frame", nil, child)
	card:SetHeight(N.card)
	card.top = -(N.pad + (i - 1) * step)
	placeCard(card, 0)
	local nameFrame = card:CreateTexture(nil, "BACKGROUND")
	atlas(nameFrame, "looting_itemcard_bg")
	nameFrame:SetAllPoints(card)
	local stripe = card:CreateTexture(nil, "BACKGROUND")
	atlas(stripe, "looting_raritytag_frame")
	stripe:SetWidth(N.stripe[1])
	stripe:SetHeight(N.stripe[2])
	stripe:SetPoint("TOPRIGHT", card, "TOPRIGHT", 0, 0)
	local border = card:CreateTexture(nil, "BORDER")
	atlas(border, "looting_itemcard_stroke_normal")
	border:SetAllPoints(card)
	local highlight = card:CreateTexture(nil, "OVERLAY")
	atlas(highlight, "looting_itemcard_stroke_clickstate")
	highlight:SetBlendMode("ADD")
	highlight:SetAlpha(N.highlight)
	highlight:SetAllPoints(card)
	highlight:Hide()
	local pushed = card:CreateTexture(nil, "OVERLAY")
	atlas(pushed, "looting_itemcard_stroke_clickstate")
	pushed:SetBlendMode("ADD")
	pushed:SetAllPoints(card)
	pushed:Hide()
	local qualityText = card:CreateFontString(nil, "ARTWORK")
	qualityText:SetFontObject(TINY)
	qualityText:SetJustifyH("RIGHT")
	qualityText:SetPoint("TOPRIGHT", card, "TOPRIGHT", N.quality[1], N.quality[2])
	local I = N.item
	local item = CreateFrame("Button", "ForeverUILootItem" .. i, card, "ItemButtonTemplate")
	item:SetWidth(I[3])
	item:SetHeight(I[3])
	item:SetPoint("TOPLEFT", card, "TOPLEFT", I[1], I[2])
	item:SetHitRectInsets(0, I[4], 0, 0)
	item:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	item.card = card
	local text = card:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetJustifyH("LEFT")
	text:SetJustifyV("TOP")
	card.item, card.text, card.qualityText, card.stripe = item, text, qualityText, stripe
	card.nameFrame, card.highlight, card.pushed = nameFrame, highlight, pushed
	item:SetScript("OnEnter", function() onEnter(card) end)
	item:SetScript("OnLeave", function() onLeave(card) end)
	item:SetScript("OnMouseDown", function() pushed:Show() end)
	item:SetScript("OnMouseUp", function() pushed:Hide() end)
	item:SetScript("OnUpdate", function()
		if GameTooltip:IsOwned(card) then onEnter(card) end
		CursorOnUpdate(card)
	end)
	item:SetScript("OnClick", onClick)
	return card
end

-- LootFrameElementMixin:Init on the card of slot; money and empty slots as camelot's element
-- factory sorts them
local function fill(card, slot)
	card.slot = slot
	stop(card)
	placeCard(card, 0)
	card:SetAlpha(1)
	local isCoin, isItem = LootSlotIsCoin(slot), LootSlotIsItem(slot)
	if not (isCoin or isItem) then
		card:Hide()
		return
	end
	local texture, name, quantity, _, locked = GetLootSlotInfo(slot)
	local q = quality(slot)
	card.quality = q
	local c = ITEM_QUALITY_COLORS[q] or ITEM_QUALITY_COLORS[COMMON]
	card.text:SetText(name)
	card.text:SetVertexColor(c.r, c.g, c.b)
	card.nameFrame:SetVertexColor(c.r, c.g, c.b)
	card.text:ClearAllPoints()
	if isCoin then
		local M = N.money
		card.text:SetWidth(M[3])
		card.text:SetHeight(M[4])
		card.text:SetJustifyV("MIDDLE")
		card.text:SetPoint("LEFT", card.item, "RIGHT", M[1], M[2])
		card.stripe:Hide()
		card.qualityText:Hide()
		Tpl.QualityOutline(card.item, nil)
	else
		local T = N.text
		card.text:SetWidth(T[3])
		card.text:SetHeight(T[4])
		card.text:SetJustifyV("TOP")
		card.text:SetPoint("TOPLEFT", card.item, "TOPRIGHT", T[1], T[2])
		card.stripe:Show()
		card.qualityText:SetText(_G["ITEM_QUALITY" .. q .. "_DESC"])
		card.qualityText:Show()
		Tpl.QualityOutline(card.item, q)
	end
	local icon = _G[card.item:GetName() .. "IconTexture"]
	icon:SetTexture(texture)
	local r, g, b = 1, 1, 1
	if locked then r, g, b = 0.9, 0, 0 end
	SetItemButtonTextureVertexColor(card.item, r, g, b)
	SetItemButtonNormalTextureVertexColor(card.item, r, g, b)
	local count = _G[card.item:GetName() .. "Count"]
	if (quantity or 0) > 1 then
		count:SetText(quantity)
		count:Show()
	else
		count:Hide()
	end
	card.item:Enable()
	-- ShowAnim: fades in over 0.1 s
	card:SetAlpha(0)
	card:Show()
	play(card, A.card, function(p) card:SetAlpha(easeIn(p)) end)
end

-- SlideOutRightAnim, on every looted slot: 100 right over 0.3 s, fading out over the last 0.2 s,
-- then the card hides
local function slideOut(card)
	if GameTooltip:IsOwned(card) then GameTooltip:Hide() end
	card.highlight:Hide()
	card.pushed:Hide()
	card.item:Disable()
	card:SetAlpha(1)
	play(card, A.slide, function(p)
		placeCard(card, A.slideX * easeIn(p))
		local f = math.min(1, math.max(0, (p * A.slide - A.fadeDelay) / A.fade))
		card:SetAlpha(1 - easeIn(f))
	end, function()
		card:Hide()
		placeCard(card, 0)
		card:SetAlpha(1)
	end)
end

-- ScrollingFlatPanelMixin:Resize: the panel fits its cards up to 290, wider by the bar when
-- they do not fit
local function resize(n)
	local cardsHeight = math.max(0, n * N.card + (n - 1) * N.spacing)
	local height = math.min(cardsHeight + N.anchors + N.extra, N.maxHeight)
	panel:SetHeight(height)
	child:SetHeight(math.max(1, cardsHeight + 2 * N.pad))
	local view = height - N.anchors
	local hasBar = cardsHeight + 2 * N.pad > view
	panel:SetWidth(N.width + (hasBar and N.barWidth or 0))
	Tpl.SetShown(bar, hasBar)
	local visibleCount = math.floor((view - N.pad) / step)
	bar:Configure(n, visibleCount, 0)
	scrollTo(0)
end

-- the panel at its place (P.anchor), moved down by dy
local function placePanel(dy)
	local a = P.anchor
	panel:ClearAllPoints()
	panel:SetPoint(a[1], a[2], a[3], a[4], a[5] + dy)
end

function P.Open()
	local n = GetNumLootItems() or 0
	for i = 1, n do
		cards[i] = cards[i] or createCard(i)
		fill(cards[i], i)
	end
	for i = n + 1, #cards do cards[i]:Hide() end
	resize(n)
	if GetCVar("lootUnderMouse") == "1" then
		local C = N.cursor
		local x, y = GetCursorPosition()
		local scale = panel:GetEffectiveScale()
		P.anchor = { "TOPLEFT", nil, "BOTTOMLEFT", x / scale + C[1], math.max(y / scale + C[2], C[3]) }
	else
		P.anchor = { "TOPLEFT", UIParent, "TOPLEFT", N.default[1], N.default[2] }
	end
	-- ShowAnim played backwards: comes up 10 and fades in over 0.1 s
	stop(panel)
	placePanel(-A.drop)
	panel:SetAlpha(0)
	panel:Show()
	panel:Raise()
	play(panel, A.open, function(p)
		local back = easeIn(1 - p)
		placePanel(-A.drop * back)
		panel:SetAlpha(1 - back)
	end)
end

-- HideAnim: goes down 10 and fades out over 0.1 s, then the panel hides (and its OnHide stops
-- every animation, so nothing stays on screen when the last item closes the loot)
function P.Close()
	if GameTooltip:GetOwner() and GameTooltip:GetOwner():GetParent() == child then GameTooltip:Hide() end
	if not panel:IsShown() then return end
	play(panel, A.close, function(p)
		local e = easeIn(p)
		placePanel(-A.drop * e)
		panel:SetAlpha(1 - e)
	end, function() panel:Hide() end)
end

panel:SetScript("OnHide", function()
	stop(panel)
	panel:SetAlpha(1)
	if P.anchor then placePanel(0) end
	for _, card in ipairs(cards) do
		stop(card)
		placeCard(card, 0)
		card:SetAlpha(1)
	end
end)

-- ------------------------------------------------------------ host

-- The client's LootFrame: invisible and mouse-less, shown while the loot is open
local function suppress()
	LootFrame:SetAlpha(0)
	LootFrame:EnableMouse(false)
	for _, name in ipairs({ "LootCloseButton", "LootFrameUpButton", "LootFrameDownButton" }) do
		local b = _G[name]
		if b then b:EnableMouse(false) end
	end
	for i = 1, LOOTFRAME_NUMBUTTONS or 4 do
		local b = _G["LootButton" .. i]
		if b then b:EnableMouse(false) end
	end
end

if LootFrame then
	suppress()
	hooksecurefunc("LootFrame_Show", P.Open)
	LootFrame:HookScript("OnHide", P.Close)
end

-- The master loot list: GetMasterLootCandidate gives no name until the name cache has it (often
-- the master looter's own); the client then queries it and sends UPDATE_MASTER_LOOT_LIST, which
-- 3.3.5's LootFrame answers with UIDropDownMenu_Refresh, which does not rebuild the list. Opened,
-- the list is opened again, so it lists the candidates whose names came.
local function reopenMasterLootList()
	if GroupLootDropDown and UIDROPDOWNMENU_OPEN_MENU == GroupLootDropDown and DropDownList1:IsShown() then
		CloseDropDownMenus()
		ToggleDropDownMenu(1, nil, GroupLootDropDown, LootFrame.selectedLootButton, 0, 0)
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("LOOT_SLOT_CLEARED")
events:RegisterEvent("LOOT_SLOT_CHANGED")
events:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
events:SetScript("OnEvent", function(_, event, slot)
	if event == "UPDATE_MASTER_LOOT_LIST" then
		reopenMasterLootList()
		return
	end
	local card = slot and cards[slot]
	if not (card and panel:IsShown()) then return end
	if event == "LOOT_SLOT_CLEARED" then
		slideOut(card)
	else
		fill(card, slot)
	end
end)
