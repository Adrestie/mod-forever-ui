-- ForeverUI: the guild window, after camelot's Communities frame (Blizzard_Communities,
-- CommunitiesFrame 814 x 426) reduced to the guild: the guild list column on the left, side
-- tabs on the right edge for the views (Chat, Roster, Guild Info) and for the modules that add
-- one (ForeverUI.Guild.AddSideTab: mod-guild-level's talents take camelot's Guild Benefits
-- place). The views are in GuildChat.lua, GuildRoster.lua and GuildInfo.lua and register with
-- G.registerView. Opened by the Guild micro button (SocialsMicroButton) and the Guild key
-- binding (TOGGLEGUILDTAB); the Social window has no Guild tab any more.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local S = ForeverUI.Social
local Tpl = ForeverUI.Templates
local L = ForeverUI.L
if not (S and Tpl) then
	return
end

local G = {}
ForeverUI.Guild = G

local SEP = string.char(92)
local txt = S.txt

-- Layout values from camelot communitiesframe.xml, communitieslist.xml and rightsidetab.xml.
local N = {
	width = 814, height = 426,
	-- CommunitiesList: TOPLEFT (-1, -23), BOTTOMRIGHT at the frame's BOTTOMLEFT (170, 29)
	list = { x1 = -1, y1 = -23, x2 = 170, y2 = 29 },
	-- CommunitiesListEntryTemplate, 178 x 68 (here as wide as the column)
	entry = { h = 68, y = -4 },
	-- RightSideTabTemplate: 32 x 32, the first at the frame's TOPRIGHT (0, -36), 20 apart
	tab = { side = 32, x = 0, y = -36, gap = 20, border = 64, borderX = -3, borderY = 11, icon = 30 },
	-- side popups (member detail, guild control) leave the tabs room
	popupX = 38,
	-- WindowStack: default place, top center, and the room fitToScreen keeps around it
	place = { x = 0, y = -104 }, fitW = 40, fitH = 0,
	portrait = { side = 60, x = -5, y = 8, emblemW = 56, emblemH = 64, emblemX = 25, emblemY = -23,
		borderH = 59, borderY = 7 },
}

-- bluemenu-main pieces (texture coordinates from communitieslist.xml)
local BLUE = "Interface" .. SEP .. "ForeverUI" .. SEP .. "common" .. SEP .. "bluemenu-main"
local BLUE_VERT = "Interface" .. SEP .. "ForeverUI" .. SEP .. "common" .. SEP .. "bluemenu-vert"
local BLUE_HORIZ = "Interface" .. SEP .. "ForeverUI" .. SEP .. "common" .. SEP .. "bluemenu-goldborder-horiz"
local BLUE_PIECES = {
	background = { 0.00390625, 0.82421875, 0.18554688, 0.58984375 },
	topFiligree = { 0.00390625, 0.72656250, 0.12988281, 0.18359375 },
	bottomFiligree = { 0.26171875, 0.98437500, 0.06542969, 0.11914063 },
	topLeft = { 0.00390625, 0.25390625, 0.00097656, 0.06347656 },
	topRight = { 0.51953125, 0.76953125, 0.00097656, 0.06347656 },
	bottomRight = { 0.51171875, 0.26171875, 0.00097656, 0.06347656 },
	bottomLeft = { 0.26171875, 0.51171875, 0.00097656, 0.06347656 },
	entry = { 0.00390625, 0.87890625, 0.75195313, 0.83007813 },
	selection = { 0.00390625, 0.87890625, 0.59179688, 0.66992188 },
}

-- guild tabard: GuildFrame sheet (TabardBackground, TabardBorder) and the large emblems
-- (SetLargeGuildTabardTextures: 64/1024 cells, 16 per row)
local GUILD_SHEET = "Interface" .. SEP .. "ForeverUI" .. SEP .. "guildframe" .. SEP .. "guildframe"
local EMBLEMS_LG = "Interface" .. SEP .. "ForeverUI" .. SEP .. "guildframe" .. SEP .. "guildemblemslg_01"
local TABARD = {
	background = { 0.63183594, 0.69238281, 0.61914063, 0.74023438 },
	border = { 0.63183594, 0.69238281, 0.74414063, 0.86523438 },
	cell = 64 / 1024, columns = 16,
}

-- side tab icons (camelot keys iconTexture; none exists in the 3.3.5 client)
local ICONS = "Interface" .. SEP .. "ForeverUI" .. SEP .. "icons" .. SEP
G.ICONS = {
	chat = ICONS .. "ui_chat",
	roster = ICONS .. "achievement_guildperk_everybodysfriend",
	benefits = ICONS .. "achievement_guildperk_honorablemention",
	info = ICONS .. "inv_misc_scrollunrolled01",
}

local SPELLBOOK_TAB = "Interface" .. SEP .. "SpellBook" .. SEP .. "SpellBook-SkillLineTab"
local TAB_HIGHLIGHT = "Interface" .. SEP .. "Buttons" .. SEP .. "ButtonHilight-Square"
local TAB_CHECKED = "Interface" .. SEP .. "Buttons" .. SEP .. "CheckButtonHilight"

-- 3.3.5 has no SetShown
local function shown(x, yes)
	if yes then x:Show() else x:Hide() end
end
G.shown = shown

-- ------------------------------------------------------------------ Views

-- Views: key -> { order, icon, tooltip, build(frame), update(), show(), hide() }.
-- A view is built on its first display, in a frame over the whole window.
G.views = {}
G.viewOrder = {}
G.annexes = {}

function G.registerView(key, def)
	def.key = key
	G.views[key] = def
	table.insert(G.viewOrder, def)
	table.sort(G.viewOrder, function(a, b) return a.order < b.order end)
	if G.frame then G.layoutTabs() end
end

local function viewFrame(def)
	if def.frame then return def.frame end
	local frame = CreateFrame("Frame", "ForeverUIGuildView" .. def.key, G.frame)
	frame:SetAllPoints(G.frame)
	frame:SetFrameLevel(G.frame:GetFrameLevel() + 2)
	frame:Hide()
	def.frame = frame
	def.build(frame)
	return frame
end

-- Shows view key (camelot SetDisplayMode); the others hide.
function G.setView(key)
	local def = G.views[key]
	if not def or not def.build then return end
	G.current = key
	for _, other in ipairs(G.viewOrder) do
		if other ~= def and other.frame and other.frame:IsShown() then
			other.frame:Hide()
			if other.hide then other.hide() end
		end
	end
	local frame = viewFrame(def)
	if not frame:IsShown() then
		frame:Show()
		if def.show then def.show() end
	end
	G.update()
end

-- Refreshes the open view, the title, the tabard and the tabs.
function G.update()
	if not (G.frame and G.frame:IsShown()) then return end
	local guild = GetGuildInfo("player")
	G.frame.title:SetText(guild or "")
	G.entry.name:SetText(guild or "")
	G.updateTabard()
	G.updateTabs()
	local def = G.views[G.current or ""]
	if def and def.frame and def.frame:IsShown() and def.update then def.update() end
end

-- ------------------------------------------------------------------ Side tabs

-- RightSideTabTemplate: the spellbook's skill line tab art, an icon, highlight and checked
-- glows in ADD. def: { icon, tooltip (text or function), onClick or view key }
local function createSideTab(def)
	local T = N.tab
	local b = CreateFrame("CheckButton", "ForeverUIGuildSideTab" .. def.key, G.frame)
	b:SetWidth(T.side)
	b:SetHeight(T.side)
	b:SetFrameLevel(G.frame:GetFrameLevel() + 25)
	local border = b:CreateTexture(nil, "BORDER")
	border:SetTexture(SPELLBOOK_TAB)
	border:SetWidth(T.border)
	border:SetHeight(T.border)
	border:SetPoint("TOPLEFT", b, "TOPLEFT", T.borderX, T.borderY)
	local icon = b:CreateTexture(nil, "ARTWORK")
	icon:SetWidth(T.icon)
	icon:SetHeight(T.icon)
	icon:SetPoint("CENTER", b, "CENTER", 0, 0)
	icon:SetTexCoord(0.03125, 0.96875, 0.03125, 0.96875)
	icon:SetTexture(def.icon)
	b.icon = icon
	b:SetHighlightTexture(TAB_HIGHLIGHT)
	local h = b:GetHighlightTexture()
	if h then h:SetBlendMode("ADD") end
	b:SetCheckedTexture(TAB_CHECKED)
	local c = b:GetCheckedTexture()
	if c then c:SetBlendMode("ADD") end
	b:SetScript("OnClick", function(self)
		PlaySound("igCharacterInfoTab")
		if def.build then
			G.setView(def.key)
		elseif def.onClick then
			def.onClick(self)
		end
		G.updateTabs()
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local tip = def.tooltip
		if type(tip) == "function" then tip = tip() end
		GameTooltip:SetText(tip or "", 1, 1, 1)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	b.def = def
	return b
end

function G.layoutTabs()
	G.tabs = G.tabs or {}
	local T = N.tab
	local previous
	for n, def in ipairs(G.viewOrder) do
		local b = G.tabs[n]
		if not b or b.def ~= def then
			if b then b:Hide() end
			b = def.tab or createSideTab(def)
			def.tab = b
			G.tabs[n] = b
		end
		b:ClearAllPoints()
		if previous then
			b:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -T.gap)
		else
			b:SetPoint("TOPLEFT", G.frame, "TOPRIGHT", T.x, T.y)
		end
		b:Show()
		previous = b
	end
	for n = #G.viewOrder + 1, #G.tabs do
		G.tabs[n]:Hide()
		G.tabs[n] = nil
	end
end

-- The open view's tab checked; a tab that only opens a window (no build) never is.
function G.updateTabs()
	for _, def in ipairs(G.viewOrder) do
		if def.tab then
			def.tab:SetChecked(def.build and def.key == G.current and true or false)
			if def.visible then shown(def.tab, def.visible()) end
		end
	end
end

-- For modules: a side tab that runs onClick (camelot GuildBenefitsTab's place).
-- def = { key, tooltip (text or function), onClick(tab), icon (G.ICONS.benefits by default),
-- order (30: after Roster, before Guild Info), visible() (optional) }
function G.AddSideTab(def)
	if not def or not def.key or G.views[def.key] then return end
	G.registerView(def.key, {
		order = def.order or 30,
		icon = def.icon or G.ICONS.benefits,
		tooltip = def.tooltip,
		onClick = def.onClick,
		visible = def.visible,
	})
end

-- ------------------------------------------------------------------ Guild column

-- CommunitiesListFrameTemplate: bluemenu background and filigree, gold border; one entry,
-- the guild (CommunitiesListEntryTemplate), always selected.
local function piece(parent, layer, file, coords)
	local t = parent:CreateTexture(nil, layer)
	t:SetTexture(file)
	if coords then t:SetTexCoord(coords[1], coords[2], coords[3], coords[4]) end
	return t
end

local function buildColumn(f)
	local c = CreateFrame("Frame", "ForeverUIGuildList", f)
	c:SetPoint("TOPLEFT", f, "TOPLEFT", N.list.x1, N.list.y1)
	c:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", N.list.x2, N.list.y2)
	c:SetFrameLevel(f:GetFrameLevel() + 1)
	local B = BLUE_PIECES
	local bg = piece(c, "BACKGROUND", BLUE, B.background)
	bg:SetPoint("TOPLEFT", c, "TOPLEFT", 2, 0)
	bg:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -2, 0)
	local top = piece(c, "BORDER", BLUE, B.topFiligree)
	top:SetWidth(155) top:SetHeight(55)
	top:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -6)
	local bottom = piece(c, "BORDER", BLUE, B.bottomFiligree)
	bottom:SetWidth(155) bottom:SetHeight(55)
	bottom:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 14, 1)
	-- FilligreeOverlay: gold corners and edges, above the entries
	local o = CreateFrame("Frame", nil, c)
	o:SetPoint("TOPLEFT", c, "TOPLEFT", 3, -1)
	o:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -2, 0)
	o:SetFrameLevel(c:GetFrameLevel() + 5)
	local function corner(coords, point, x, y)
		local t = piece(o, "ARTWORK", BLUE, coords)
		t:SetWidth(64) t:SetHeight(64)
		t:SetPoint(point, o, point, x, y)
		return t
	end
	local tl = corner(B.topLeft, "TOPLEFT", 3, 2)
	local tr = corner(B.topRight, "TOPRIGHT", -1, 2)
	local br = corner(B.bottomRight, "BOTTOMRIGHT", 0, 0)
	local bl = corner(B.bottomLeft, "BOTTOMLEFT", 3, 0)
	-- 3.3.5 cannot tile part of a texture: the edges stretch (their pattern is uniform along them)
	local function edge(file, coords, layer)
		local t = piece(o, layer, file, coords)
		return t
	end
	local left = edge(BLUE_VERT, { 0.0625, 0.3984375, 0, 1 }, "OVERLAY")
	left:SetWidth(43)
	left:SetPoint("TOPLEFT", tl, "BOTTOMLEFT", 0, 0)
	left:SetPoint("BOTTOMLEFT", bl, "TOPLEFT", 0, 0)
	local right = edge(BLUE_VERT, { 0.4140625, 0.75, 0, 1 }, "OVERLAY")
	right:SetWidth(43)
	right:SetPoint("TOPRIGHT", tr, "BOTTOMRIGHT", 0, 0)
	right:SetPoint("BOTTOMRIGHT", br, "TOPRIGHT", 0, 0)
	local topBar = edge(BLUE_HORIZ, { 0, 1, 0.0078125, 0.34375 }, "BORDER")
	topBar:SetHeight(43)
	topBar:SetPoint("TOPLEFT", tl, "TOPRIGHT", 0, 0)
	topBar:SetPoint("TOPRIGHT", tr, "TOPLEFT", 0, 0)
	local bottomBar = edge(BLUE_HORIZ, { 0, 1, 0.359375, 0.6953125 }, "BORDER")
	bottomBar:SetHeight(43)
	bottomBar:SetPoint("BOTTOMLEFT", bl, "BOTTOMRIGHT", 0, 0)
	bottomBar:SetPoint("BOTTOMRIGHT", br, "BOTTOMLEFT", 0, 0)
	-- InsetFrame: the inset trim around the column, without its background
	local inset = ForeverUI.CreateInset(c)
	inset:SetPoint("TOPLEFT", c, "TOPLEFT", 3, 1)
	inset:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", 0, -3)
	inset:SetFrameLevel(c:GetFrameLevel() + 6)
	inset.background:Hide()
	G.column = c

	-- the guild's entry: banner with the emblem, name; selected
	local e = CreateFrame("Button", "ForeverUIGuildListEntry", c)
	e:SetHeight(N.entry.h)
	e:SetPoint("TOPLEFT", c, "TOPLEFT", 0, N.entry.y)
	e:SetPoint("TOPRIGHT", c, "TOPRIGHT", 0, N.entry.y)
	e:SetFrameLevel(c:GetFrameLevel() + 2)
	local back = piece(e, "BACKGROUND", BLUE, B.entry)
	back:SetHeight(80)
	back:SetPoint("LEFT", e, "LEFT", 0, 0)
	back:SetPoint("RIGHT", e, "RIGHT", 0, 0)
	local selection = piece(e, "BORDER", BLUE, B.selection)
	selection:SetHeight(80)
	selection:SetPoint("LEFT", e, "LEFT", 0, 0)
	selection:SetPoint("RIGHT", e, "RIGHT", 0, 0)
	local banner = e:CreateTexture(nil, "ARTWORK")
	ForeverUI.SetAtlas(banner, "communities-guildbanner-background")
	banner:SetWidth(52) banner:SetHeight(51)
	banner:SetPoint("TOPLEFT", e, "TOPLEFT", 6, -11)
	local emblem = e:CreateTexture(nil, "ARTWORK")
	emblem:SetTexture(EMBLEMS_LG)
	emblem:SetWidth(36) emblem:SetHeight(42)
	emblem:SetPoint("CENTER", e, "TOPLEFT", 32, -31)
	local bannerBorder = e:CreateTexture(nil, "OVERLAY")
	ForeverUI.SetAtlas(bannerBorder, "communities-guildbanner-border")
	bannerBorder:SetWidth(52) bannerBorder:SetHeight(51)
	bannerBorder:SetPoint("TOPLEFT", e, "TOPLEFT", 6, -11)
	local name = e:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", e, "LEFT", 60, 0)
	name:SetPoint("RIGHT", e, "RIGHT", -10, 0)
	name:SetHeight(40)
	e.name, e.banner, e.emblem = name, banner, emblem
	G.entry = e
end

-- ------------------------------------------------------------------ Tabard

-- Portrait (camelot PortraitOverlay: TabardBackground, TabardEmblem, TabardBorder) and the
-- entry banner, tinted from the guild's tabard (BottomBar.lua reads it).
local function emblemCoords(t, motif)
	local x = (motif % TABARD.columns) * TABARD.cell
	local y = math.floor(motif / TABARD.columns) * TABARD.cell
	t:SetTexCoord(x, x + TABARD.cell, y, y + TABARD.cell)
end

function G.updateTabard()
	local background, motif, color
	if ForeverUI.GuildTabard then background, motif, color = ForeverUI.GuildTabard() end
	local p = G.portrait
	if background then
		p.background:SetVertexColor(background[1], background[2], background[3])
		p.border:SetVertexColor(1, 1, 1)
		for _, t in ipairs({ p.emblem, G.entry.emblem }) do
			emblemCoords(t, motif)
			t:SetVertexColor(color[1], color[2], color[3])
			t:Show()
		end
		G.entry.banner:SetVertexColor(background[1], background[2], background[3])
	else
		p.background:SetVertexColor(0.3, 0.3, 0.3)
		p.emblem:Hide()
		G.entry.emblem:Hide()
		G.entry.banner:SetVertexColor(1, 1, 1)
	end
end

local function buildPortrait(f, skin)
	local P = N.portrait
	skin.portrait:Hide()
	local host = skin.portraitFrame
	local bg = piece(host, "BACKGROUND", GUILD_SHEET, TABARD.background)
	bg:SetWidth(P.side) bg:SetHeight(P.side)
	bg:SetPoint("TOPLEFT", f, "TOPLEFT", P.x, P.y)
	local emblem = host:CreateTexture(nil, "BORDER")
	emblem:SetTexture(EMBLEMS_LG)
	emblem:SetWidth(P.emblemW) emblem:SetHeight(P.emblemH)
	emblem:SetPoint("CENTER", f, "TOPLEFT", P.emblemX, P.emblemY)
	local border = piece(host, "ARTWORK", GUILD_SHEET, TABARD.border)
	border:SetWidth(P.side) border:SetHeight(P.borderH)
	border:SetPoint("TOPLEFT", f, "TOPLEFT", P.x, P.borderY)
	G.portrait = { background = bg, emblem = emblem, border = border }
end

-- ------------------------------------------------------------------ Window

-- A side popup of the guild window (member detail, guild info editor, guild control).
function G.createPopup(name, width, height)
	return S.createPopup(name, width, height, G.frame, G.annexes, N.popupX)
end

-- A panel button with the window's font.
function G.button(parent, text, width)
	return S.button(parent, text, width)
end

-- The client GuildFrame (FriendsFrame.xml) stays shown while our window is: UnitPopup offers
-- Promote to Guildmaster and Leave Guild only then (UnitPopup_HideButtons), and the client
-- updates the roster and the guild control window only then (FriendsFrame_OnEvent). It is
-- moved into our window, off screen and transparent; the Social window hides it whenever it
-- changes tab (FriendsFrame_ShowSubFrame), so it comes back after.
local function keepGuildFrame()
	if not GuildFrame then return end
	GuildFrame:SetParent(G.frame)
	GuildFrame:ClearAllPoints()
	GuildFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -5000, 5000)
	GuildFrame:SetWidth(384)
	GuildFrame:SetHeight(512)
	GuildFrame:SetAlpha(0)
	if GuildFrame.EnableMouse then GuildFrame:EnableMouse(false) end
	if hooksecurefunc and FriendsFrame_ShowSubFrame then
		hooksecurefunc("FriendsFrame_ShowSubFrame", function()
			if G.frame:IsShown() and not GuildFrame:IsShown() then GuildFrame:Show() end
		end)
	end
end

local function build()
	if G.frame then return G.frame end
	local f = CreateFrame("Frame", "ForeverUIGuildFrame", UIParent)
	f:SetWidth(N.width)
	f:SetHeight(N.height)
	f:SetPoint("TOP", UIParent, "TOP", N.place.x, N.place.y)
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:Hide()
	G.frame = f
	local skin = Tpl.PortraitWindow(f, { portraitSide = N.portrait.side, portraitX = N.portrait.x,
		portraitY = N.portrait.y, title = "" })
	f.title = skin.title
	f.skin = skin
	buildPortrait(f, skin)
	local close = Tpl.CloseButton(CreateFrame("Button", "ForeverUIGuildFrameCloseButton", f), f)
	close:SetFrameLevel(f:GetFrameLevel() + 22)
	close:SetScript("OnClick", function() f:Hide() end)
	buildColumn(f)
	G.layoutTabs()
	-- Esc closes it, like the client's panels
	if UISpecialFrames then table.insert(UISpecialFrames, "ForeverUIGuildFrame") end
	keepGuildFrame()
	f:SetScript("OnShow", function()
		PlaySound("igCharacterInfoOpen")
		if GuildFrame and not GuildFrame:IsShown() then GuildFrame:Show() end
		GuildRoster()
		if not G.current then G.current = G.viewOrder[1] and G.viewOrder[1].key end
		G.setView(G.current)
		if UpdateMicroButtons then UpdateMicroButtons() end
	end)
	f:SetScript("OnHide", function()
		PlaySound("igCharacterInfoClose")
		for _, def in ipairs(G.viewOrder) do
			if def.frame and def.frame:IsShown() and def.hide then def.hide() end
		end
		if S.popup and S.popup:GetParent() == f then S.popup:Hide() end
		-- Its OnHide closes the guild control window, whose OnHide sets FriendsFrame's
		-- attributes: refused to our code in combat (see GuildRoster.lua).
		if GuildFrame and not InCombatLockdown() then GuildFrame:Hide() end
		if UpdateMicroButtons then UpdateMicroButtons() end
	end)
	ForeverUI.WindowStack.makeMovable(f, skin.banner, "guild")
	ForeverUI.WindowStack.register("guild", f, function()
		local z = { f }
		for _, def in ipairs(G.viewOrder) do
			if def.tab then z[#z + 1] = def.tab end
		end
		for _, a in ipairs(G.annexes) do z[#z + 1] = a end
		return z
	end)
	ForeverUI.WindowStack.fitToScreen("guild", f, f, N.place.x, N.place.y, N.fitW, N.fitH)
	return f
end

function G.toggle()
	local f = build()
	if f:IsShown() then
		f:Hide()
		return
	end
	if not IsInGuild() then
		if UIErrorsFrame then
			UIErrorsFrame:AddMessage(txt("ERR_GUILD_PLAYER_NOT_IN_GUILD"), 1.0, 0.1, 0.1, 1.0)
		end
		return
	end
	f:Show()
end

-- Opens the window on view key.
function G.open(key)
	local f = build()
	if not IsInGuild() then return end
	if key then G.current = key end
	if f:IsShown() then G.setView(G.current) else f:Show() end
end

-- ------------------------------------------------------------------ Ways in

-- The Guild micro button (camelot GuildMicroButton): opens our window, pushed while it is open.
local micro = _G.SocialsMicroButton
if micro then
	micro:SetScript("OnClick", function() G.toggle() end)
	micro:SetScript("OnEnter", function(self)
		GameTooltip_AddNewbieTip(self, MicroButtonTooltipText(txt("GUILD"), "TOGGLEGUILDTAB"), 1.0, 1.0, 1.0,
			txt("NEWBIE_TOOLTIP_GUILDTAB"))
	end)
	if ForeverUI.SetMicroOwner then
		ForeverUI.SetMicroOwner("SocialsMicroButton", function() return G.frame and G.frame:IsShown() end)
	end
end

-- The Guild key binding (TOGGLEGUILDTAB, ToggleFriendsFrame(3)) clicks a hidden button of ours
-- instead: an override binding, set out of combat, again when the bindings change.
local toggleButton = CreateFrame("Button", "ForeverUIGuildToggleButton", UIParent)
toggleButton:SetScript("OnClick", function() G.toggle() end)
local bindingOwner = CreateFrame("Frame")
local boundKeys = ""
local function bindKeys()
	if InCombatLockdown() then
		bindingOwner:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	local keys = { GetBindingKey("TOGGLEGUILDTAB") }
	local signature = table.concat(keys, " ")
	if signature == boundKeys then return end
	boundKeys = signature
	ClearOverrideBindings(bindingOwner)
	for _, key in ipairs(keys) do
		SetOverrideBindingClick(bindingOwner, false, key, "ForeverUIGuildToggleButton")
	end
end
bindingOwner:RegisterEvent("PLAYER_LOGIN")
bindingOwner:RegisterEvent("UPDATE_BINDINGS")
bindingOwner:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	bindKeys()
end)

-- ------------------------------------------------------------------ Events

local listener = CreateFrame("Frame")
for _, ev in ipairs({ "PLAYER_GUILD_UPDATE", "GUILDTABARD_UPDATE", "GUILD_ROSTER_UPDATE" }) do
	listener:RegisterEvent(ev)
end
listener:SetScript("OnEvent", function(_, event)
	if not (G.frame and G.frame:IsShown()) then return end
	-- left the guild: nothing to show
	if event == "PLAYER_GUILD_UPDATE" and not IsInGuild() then
		G.frame:Hide()
		return
	end
	G.update()
end)

-- Built now: the views register from their files, loaded after this one.
build()
