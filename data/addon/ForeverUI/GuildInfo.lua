-- ForeverUI: the Guild Info view of the guild window (GuildFrame.lua), after camelot's
-- GuildDetailsFrame (guildinfo.xml, guildnews.xml): on the left the message of the day and
-- the guild information, each with its Edit link; on the right, where camelot shows the guild
-- news (which 3.3.5 lacks), the guild event log. Guild Control at the bottom right.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local S = ForeverUI.Social
local G = ForeverUI.Guild
local L = ForeverUI.L
if not (S and G) then
	return
end

local I = {}
G.Info = I

local SEP = string.char(92)
local txt = S.txt

-- camelot GuildDetailsFrame: TOPLEFT at the guild column's TOPRIGHT (24, -40), BOTTOMRIGHT
-- (-12, 30); Info 270 wide on the left, News 316 wide at TOPRIGHT (-4, 0)
local P = {
	x1 = 24, y1 = -40, x2 = -12, y2 = 30,
	infoW = 270, newsW = 316, newsX = -4,
	-- headers: GuildFrame sheet, 280 x 22 (300 for the news), text at 10
	headerH = 22, headerTextX = 10, editX = -8,
	textX = 14, textW = 246, motdH = 46, gap = 12,
	lineH = 14, newsTextX = 10,
	editColor = { 0.973, 0.937, 0.580 },
	grayText = 0.65,
	editorW = 300, editorH = 300,
}

local GUILD_SHEET = "Interface" .. SEP .. "ForeverUI" .. SEP .. "guildframe" .. SEP .. "guildframe"
local SHEET = {
	background = { 0, 0.3154296875, 0, 0.595703125 },
	header = { 0.00097656, 0.31445313, 0.93164063, 0.97460938 },
}

local function sheetPiece(parent, layer, coords)
	local t = parent:CreateTexture(nil, layer)
	t:SetTexture(GUILD_SHEET)
	t:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	return t
end

-- A panel: inset trim, the GuildFrame background inside.
local function panel(parent, name)
	local e = ForeverUI.CreateInset(parent, name)
	e.background:SetTexture(GUILD_SHEET)
	e.background:SetTexCoord(SHEET.background[1], SHEET.background[2], SHEET.background[3], SHEET.background[4])
	if e.background.SetHorizTile then
		e.background:SetHorizTile(false)
		e.background:SetVertTile(false)
	end
	return e
end

-- A header bar with its title and, optionally, an Edit link (GUILD_EDIT_TEXT_LINK).
local function header(parent, width, text, onEdit)
	local h = sheetPiece(parent, "ARTWORK", SHEET.header)
	h:SetWidth(width)
	h:SetHeight(P.headerH)
	local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("LEFT", h, "LEFT", P.headerTextX, 0)
	label:SetText(text)
	local edit
	if onEdit then
		edit = CreateFrame("Button", nil, parent)
		edit:SetHeight(P.headerH)
		local fs = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetPoint("RIGHT", edit, "RIGHT", -2, 0)
		fs:SetTextColor(P.editColor[1], P.editColor[2], P.editColor[3])
		edit:SetFontString(fs)
		edit:SetText(L.GUILD_EDIT_TEXT)
		edit:SetWidth(fs:GetStringWidth() + 8)
		edit:SetPoint("RIGHT", h, "RIGHT", P.editX, 0)
		edit:SetScript("OnClick", onEdit)
		edit:SetScript("OnEnter", function() fs:SetTextColor(1, 1, 1) end)
		edit:SetScript("OnLeave", function() fs:SetTextColor(P.editColor[1], P.editColor[2], P.editColor[3]) end)
	end
	return h, label, edit
end

-- A text in a clipped, wheel-scrolled area. Returns the scroll frame and the text.
local function textArea(parent, name, width, height)
	local sf = CreateFrame("ScrollFrame", name, parent)
	sf:SetWidth(width)
	if height then sf:SetHeight(height) end
	local child = CreateFrame("Frame", nil, sf)
	child:SetWidth(width)
	child:SetHeight(1)
	sf:SetScrollChild(child)
	local fs = child:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	fs:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -4)
	fs:SetWidth(width)
	fs:SetJustifyH("LEFT")
	fs:SetJustifyV("TOP")
	if fs.SetWordWrap then fs:SetWordWrap(true) end
	if fs.SetNonSpaceWrap then fs:SetNonSpaceWrap(true) end
	sf:EnableMouseWheel(true)
	sf:SetScript("OnMouseWheel", function(self, delta)
		local range = math.max(0, (fs:GetHeight() or 0) + 8 - (self:GetHeight() or 0))
		local v = math.max(0, math.min(range, self:GetVerticalScroll() - delta * P.lineH))
		self:SetVerticalScroll(v)
		if self.onScrolled then self.onScrolled() end
	end)
	sf.text, sf.child = fs, child
	return sf, fs
end

-- Sets a text area's text and fits its child to it.
local function setText(sf, text)
	sf.text:SetText(text or "")
	sf.child:SetHeight(math.max(1, (sf.text:GetHeight() or 0) + 8))
	local range = math.max(0, sf.child:GetHeight() - (sf:GetHeight() or 0))
	if sf:GetVerticalScroll() > range then sf:SetVerticalScroll(range) end
end

-- ---------- Guild information editor (camelot CommunitiesGuildTextEditFrame)

local E = {}
I.editor = E

local function createEditor()
	local a = G.createPopup("ForeverUIGuildInfoFrame", P.editorW, P.editorH)
	a.title:SetText(txt("GUILD_INFORMATION"))
	E.frame = a
	local e = ForeverUI.CreateInset(a)
	e:SetPoint("TOPLEFT", a, "TOPLEFT", 12, -30)
	e:SetPoint("BOTTOMRIGHT", a, "BOTTOMRIGHT", -12, 44)
	local scrollFrame = CreateFrame("ScrollFrame", "ForeverUIGuildInfoScroll", e)
	scrollFrame:SetPoint("TOPLEFT", e, "TOPLEFT", 6, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", e, "BOTTOMRIGHT", -6, 6)
	local b = CreateFrame("EditBox", "ForeverUIGuildInfoEditBox", scrollFrame)
	b:SetMultiLine(true)
	b:SetAutoFocus(false)
	b:SetMaxLetters(500)
	-- Full width of the scroll frame (300 - 2 x 12 - 2 x 6): there is no scroll bar here.
	b:SetWidth(264)
	b:SetHeight(200)
	b:SetFontObject(GameFontHighlightSmall)
	b:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	scrollFrame:SetScrollChild(b)
	scrollFrame:EnableMouse(true)
	scrollFrame:SetScript("OnMouseUp", function() b:SetFocus() end)
	E.input = b
	local accept = G.button(a, txt("ACCEPT"), 90)
	E.accept = accept
	accept:SetScript("OnClick", function()
		SetGuildInfoText(b:GetText())
		if GuildInfoFrame then GuildInfoFrame.cachedText = b:GetText() end
		I.savedText = b:GetText()
		GuildRoster()
		a:Hide()
		I.update()
	end)
	local close = G.button(a, txt("CLOSE"), 90)
	close:SetPoint("BOTTOMRIGHT", a, "BOTTOMRIGHT", -12, 14)
	accept:SetPoint("RIGHT", close, "LEFT", -4, 0)
	close:SetScript("OnClick", function() a:Hide() end)
	a:HookScript("OnShow", function()
		local text = I.savedText or GetGuildInfoText() or ""
		b:SetText(text)
		b:SetFocus()
	end)
end

-- ---------- Event log

-- Text of guild event i, followed by its age.
local function eventLogLine(i)
	local type, j1, j2, rank, year, month, day, hour = GetGuildEventInfo(i)
	j1 = j1 or txt("UNKNOWN")
	j2 = j2 or txt("UNKNOWN")
	local msg
	if type == "invite" then msg = string.format(txt("GUILDEVENT_TYPE_INVITE"), j1, j2)
	elseif type == "join" then msg = string.format(txt("GUILDEVENT_TYPE_JOIN"), j1)
	elseif type == "promote" then msg = string.format(txt("GUILDEVENT_TYPE_PROMOTE"), j1, j2, rank)
	elseif type == "demote" then msg = string.format(txt("GUILDEVENT_TYPE_DEMOTE"), j1, j2, rank)
	elseif type == "remove" then msg = string.format(txt("GUILDEVENT_TYPE_REMOVE"), j1, j2)
	elseif type == "quit" then msg = string.format(txt("GUILDEVENT_TYPE_QUIT"), j1)
	end
	if not msg then return nil end
	return msg .. "|cff009999   " .. string.format(txt("GUILD_BANK_LOG_TIME"), G.fromIndex(year, month, day, hour)) .. "|r"
end

-- The log, most recent first (the client's loop), one event per paragraph.
local function eventLog()
	local lines = {}
	local n = GetNumGuildEvents() or 0
	for i = n, 1, -1 do
		local l = eventLogLine(i)
		if l then lines[#lines + 1] = l end
	end
	return table.concat(lines, "\n")
end

-- The news area's scroll bar, in steps of a line.
local function updateNewsBar()
	local sf = I.news
	local view = sf:GetHeight() or 0
	local steps = math.max(0, math.ceil((sf.child:GetHeight() - view) / P.lineH))
	local visible = math.max(1, math.floor(view / P.lineH))
	I.newsBar:Configure(steps + visible, visible, math.floor(sf:GetVerticalScroll() / P.lineH + 0.5))
end

-- ---------- Build

local function build(frame)
	local f = G.frame
	local d = CreateFrame("Frame", "ForeverUIGuildDetails", frame)
	d:SetPoint("TOPLEFT", G.column, "TOPRIGHT", P.x1, P.y1)
	d:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", P.x2, P.y2)

	-- Info: message of the day, then the guild information
	local info = panel(d, "ForeverUIGuildDetailsInfo")
	info:SetWidth(P.infoW)
	info:SetPoint("TOPLEFT", d, "TOPLEFT", 0, 0)
	info:SetPoint("BOTTOMLEFT", d, "BOTTOMLEFT", 0, 0)
	local motdHeader, _, motdEdit = header(info, P.infoW - 8, txt("GUILD_MOTD_LABEL"), function()
		StaticPopup_Show("SET_GUILDMOTD")
	end)
	motdHeader:SetPoint("TOPLEFT", info, "TOPLEFT", 4, -4)
	I.motd = textArea(info, "ForeverUIGuildDetailsMOTD", P.textW, P.motdH)
	I.motd:SetPoint("TOPLEFT", motdHeader, "BOTTOMLEFT", P.textX, -1)
	I.motdEdit = motdEdit
	local infoHeader, _, infoEdit = header(info, P.infoW - 8, txt("GUILD_INFORMATION"), function()
		if not E.frame then createEditor() end
		if E.frame:IsShown() then E.frame:Hide() else E.frame:Show() end
	end)
	infoHeader:SetPoint("TOPLEFT", motdHeader, "BOTTOMLEFT", 0, -(P.motdH + P.gap))
	I.details = textArea(info, "ForeverUIGuildDetailsText", P.textW)
	I.details:SetPoint("TOPLEFT", infoHeader, "BOTTOMLEFT", P.textX, -1)
	I.details:SetPoint("BOTTOM", info, "BOTTOM", 0, 6)
	I.infoEdit = infoEdit

	-- News: the event log
	local news = panel(d, "ForeverUIGuildDetailsNews")
	news:SetWidth(P.newsW)
	news:SetPoint("TOPRIGHT", d, "TOPRIGHT", P.newsX, 0)
	news:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", P.newsX, 0)
	local newsHeader = header(news, P.newsW - 8, txt("GUILD_EVENT_LOG"))
	newsHeader:SetPoint("TOPLEFT", news, "TOPLEFT", 4, -4)
	I.news = textArea(news, "ForeverUIGuildDetailsNewsText", P.newsW - 2 * P.newsTextX - 16)
	I.news:SetPoint("TOPLEFT", newsHeader, "BOTTOMLEFT", P.newsTextX - 4, -2)
	I.news:SetPoint("BOTTOM", news, "BOTTOM", 0, 6)
	I.news.text:SetFontObject(GameFontHighlightSmall)
	I.newsBar = ForeverUI.CreateScrollBar("ForeverUIGuildDetailsNewsBar", news, I.news)
	I.newsBar.onScroll = function(step)
		I.news:SetVerticalScroll(math.max(0, step * P.lineH))
		updateNewsBar()
	end
	I.news.onScrolled = updateNewsBar
	I.noNews = news:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	I.noNews:SetPoint("CENTER", news, "CENTER", 0, -11)
	I.noNews:SetText(L.GUILD_NO_EVENTS)

	G.controlButton(frame)
end

function I.update()
	if not I.motd then return end
	local motd = CURRENT_GUILD_MOTD or (GetGuildRosterMOTD and GetGuildRosterMOTD()) or ""
	setText(I.motd, motd)
	G.shown(I.motdEdit, CanEditMOTD() and true or false)
	setText(I.details, I.savedText or GetGuildInfoText() or "")
	G.shown(I.infoEdit, CanEditGuildInfo() and true or false)
	local log = eventLog()
	setText(I.news, log)
	G.shown(I.noNews, log == "")
	updateNewsBar()
end

G.registerView("info", {
	order = 40,
	icon = G.ICONS.info,
	tooltip = function() return txt("GUILD_INFORMATION") end,
	build = build,
	show = function() QueryGuildEventLog() end,
	update = I.update,
	hide = function()
		if E.frame then E.frame:Hide() end
		if G.Roster and G.Roster.closePopups then G.Roster.closePopups() end
	end,
})

local listener = CreateFrame("Frame")
for _, ev in ipairs({ "GUILD_ROSTER_UPDATE", "GUILD_MOTD", "GUILD_EVENT_LOG_UPDATE" }) do
	listener:RegisterEvent(ev)
end
listener:SetScript("OnEvent", function(_, event)
	if event == "GUILD_ROSTER_UPDATE" then I.savedText = nil end
	if I.motd and I.motd:IsVisible() then I.update() end
end)
