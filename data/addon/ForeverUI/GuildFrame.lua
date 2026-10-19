-- ForeverUI: the Guild page of the Social window (client tab 3), after camelot's Communities
-- frame (Blizzard_Communities, CommunitiesFrame 814 x 426) reduced to the guild: on this page
-- the Social window takes that size; the guild list column on the left, side tabs on the right
-- edge for the views (Chat, Roster, Guild Info) and for the modules that add one
-- (ForeverUI.Guild.AddSideTab: mod-guild-level's talents take camelot's Guild Benefits
-- place). The views are in GuildChat.lua, GuildRoster.lua and GuildInfo.lua and register with
-- G.registerView.

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
	-- CommunitiesList: TOPLEFT (-1, -23), BOTTOMRIGHT at the frame's BOTTOMLEFT (170, 29);
	-- 20 wider here, taken from the gap before the views
	list = { x1 = -1, y1 = -23, x2 = 190, y2 = 29 },
	-- CommunitiesListEntryTemplate, 178 x 68 (here as wide as the column)
	entry = { h = 68, y = -4 },
	-- RightSideTabTemplate: 32 x 32, the first at the frame's TOPRIGHT (0, -36), 20 apart
	tab = { side = 32, x = 0, y = -36, gap = 20, border = 64, borderX = -3, borderY = 11, icon = 30 },
	-- side popups (member detail, guild control) leave the tabs room
	popupX = 38,
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
	if not (G.frame and G.frame:IsVisible()) then return end
	local guild = GetGuildInfo("player")
	S.frame.title:SetText(guild or "")
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
			if not def.tab then
				S.annexes = S.annexes or {}
				table.insert(S.annexes, b)
			end
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

-- On the guild page the Social window's portrait gives way to the tabard, in a frame at its
-- level (Social.lua: portrait frame at +19, under the metal at +20).
local function buildPortrait(f)
	local P = N.portrait
	local host = CreateFrame("Frame", nil, f)
	host:SetAllPoints(S.frame)
	host:SetFrameLevel(S.frame:GetFrameLevel() + 19)
	local bg = piece(host, "BACKGROUND", GUILD_SHEET, TABARD.background)
	bg:SetWidth(P.side) bg:SetHeight(P.side)
	bg:SetPoint("TOPLEFT", S.frame, "TOPLEFT", P.x, P.y)
	local emblem = host:CreateTexture(nil, "BORDER")
	emblem:SetTexture(EMBLEMS_LG)
	emblem:SetWidth(P.emblemW) emblem:SetHeight(P.emblemH)
	emblem:SetPoint("CENTER", S.frame, "TOPLEFT", P.emblemX, P.emblemY)
	local border = piece(host, "ARTWORK", GUILD_SHEET, TABARD.border)
	border:SetWidth(P.side) border:SetHeight(P.borderH)
	border:SetPoint("TOPLEFT", S.frame, "TOPLEFT", P.x, P.borderY)
	G.portrait = { background = bg, emblem = emblem, border = border }
end

-- ------------------------------------------------------------------ Page

-- A side popup of the guild page (member detail, guild info editor, guild control), past the
-- side tabs.
function G.createPopup(name, width, height)
	return S.createPopup(name, width, height, S.frame, nil, N.popupX)
end

-- A panel button with the window's font.
function G.button(parent, text, width)
	return S.button(parent, text, width)
end

-- The Social window takes camelot's Communities size on the guild page and its own on the
-- others. Its secure tabs protect it: in combat the size waits for the end.
local sizer = CreateFrame("Frame")
local wantedGuildSize
local function resize(guild)
	wantedGuildSize = guild
	if InCombatLockdown() then
		sizer:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	S.frame:SetWidth(guild and N.width or S.G.width)
	S.frame:SetHeight(guild and N.height or S.G.height)
end
sizer:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	resize(wantedGuildSize)
end)

local function build(frame)
	G.frame = frame
	buildPortrait(frame)
	buildColumn(frame)
	G.layoutTabs()
	-- The client GuildFrame stays shown, off screen and transparent: UnitPopup offers Promote
	-- to Guildmaster and Leave Guild, and the client refreshes the roster, only while it is shown.
	if GuildFrame then
		S.keep("GuildFrame")
		GuildFrame:ClearAllPoints()
		GuildFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -5000, 5000)
		GuildFrame:SetWidth(384)
		GuildFrame:SetHeight(512)
		GuildFrame:SetAlpha(0)
		if GuildFrame.EnableMouse then GuildFrame:EnableMouse(false) end
	end
end

local function title()
	return GetGuildInfo("player") or ""
end

S.registerPage(3, {
	build = build,
	title = title,
	update = function() G.update() end,
	showRegion = function(initial)
		resize(true)
		S.frame.portrait:Hide()
		if initial then
			GuildRoster()
			if not G.current then G.current = G.viewOrder[1] and G.viewOrder[1].key end
			G.setView(G.current)
		end
	end,
	hide = function()
		for _, def in ipairs(G.viewOrder) do
			if def.frame and def.frame:IsShown() and def.hide then def.hide() end
		end
		S.frame.portrait:Show()
		resize(false)
	end,
})

-- ------------------------------------------------------------------ Events

local listener = CreateFrame("Frame")
for _, ev in ipairs({ "GUILDTABARD_UPDATE", "GUILD_ROSTER_UPDATE" }) do
	listener:RegisterEvent(ev)
end
listener:SetScript("OnEvent", function()
	if G.frame and G.frame:IsVisible() then G.update() end
end)

-- Built now, so that modules find the page (G.frame, G.column) as they load.
S.prepare(3)
