-- ForeverUI: the Chat view of the guild window (GuildFrame.lua), after camelot's Communities
-- chat (CommunitiesChatTemplate, StreamDropdown, ChatEditBox) and its member list beside it
-- (CommunitiesMemberList, compact display). 3.3.5 has no community streams: the two streams
-- are the guild and officer channels; the messages come from CHAT_MSG_GUILD and
-- CHAT_MSG_OFFICER and are kept (ForeverUIDB.guildChat, per realm and guild), since the game
-- keeps no history.

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local S = ForeverUI.Social
local G = ForeverUI.Guild
local Tpl = ForeverUI.Templates
local L = ForeverUI.L
if not (S and G and Tpl) then
	return
end

local C = {}
G.Chat = C

local txt = S.txt

-- camelot communitiesframe.lua (UpdateCommunitiesChat, expanded) and communitiesframe.xml
local P = {
	-- MemberList: TOPLEFT at the frame's TOPRIGHT (-165, -63), BOTTOMRIGHT (-26, 28)
	members = { x1 = -165, y1 = -63, x2 = -26, y2 = 28 },
	-- MemberCount: BOTTOMLEFT at the list's TOPLEFT (0, 17)
	countY = 17,
	-- Chat: TOPLEFT at the guild column's TOPRIGHT (31, -44, here 12: the column is 20 wider),
	-- BOTTOMRIGHT at the member list's BOTTOMLEFT (-32, 28)
	chat = { x1 = 12, y1 = -44, x2 = -32, y2 = 28 },
	-- ChatEditBox: under the chat's inset (-8 to +26 around the chat), its border on the
	-- inset's edges (skinInput draws 5 left of the box), 20 high
	edit = { x1 = -3, x2 = 26, y = -10, h = 20 },
	-- StreamDropdown: TOPLEFT (195, -31)
	stream = { x = 195, y = -31, w = 160 },
	rowH = 20, nameW = 115,
	buttonBottom = 5, buttonRight = -5, inviteW = 130,
	keep = 200,                       -- messages kept per guild
	timestamp = "%H:%M",
	gray = 0.5,
}

-- The two streams: chat type, menu text
local STREAMS = {
	{ kind = "GUILD", text = function() return txt("CHAT_MSG_GUILD") end },
	{ kind = "OFFICER", text = function() return txt("CHAT_MSG_OFFICER") end },
}
C.stream = "GUILD"

-- ------------------------------------------------------------------ History

-- Messages of this guild, oldest first: { time, kind, author, text }
local function history()
	local guild = GetGuildInfo("player")
	if not guild then return nil end
	ForeverUIDB = ForeverUIDB or {}
	ForeverUIDB.guildChat = ForeverUIDB.guildChat or {}
	local key = (GetRealmName() or "") .. "-" .. guild
	ForeverUIDB.guildChat[key] = ForeverUIDB.guildChat[key] or {}
	return ForeverUIDB.guildChat[key]
end

-- Class of each member by name, read from the roster, for the names' colors
local classes = {}
local function readClasses()
	for i = 1, GetNumGuildMembers(true) or 0 do
		local name, _, _, _, _, _, _, _, _, _, file = GetGuildRosterInfo(i)
		if name and file then classes[name] = file end
	end
end

-- A line as camelot writes it: time, name in its class color (a player link), text in the
-- stream's color (ChatTypeInfo).
local function line(m)
	local name = m[3] or ""
	local file = classes[name]
	local nameText = name
	if file and RAID_CLASS_COLORS and RAID_CLASS_COLORS[file] then
		local c = RAID_CLASS_COLORS[file]
		nameText = string.format("|cff%02x%02x%02x%s|r", c.r * 255, c.g * 255, c.b * 255, name)
	end
	local stamp = date(P.timestamp, m[1])
	return string.format("|cff888888%s|r |Hplayer:%s|h[%s]|h: %s", stamp, name, nameText, m[4] or "")
end

local function color(kind)
	local info = ChatTypeInfo and ChatTypeInfo[kind]
	if info then return info.r, info.g, info.b end
	return 0.25, 1, 0.25
end

-- Fills the message frame again with the open stream's messages.
function C.refill()
	if not C.messages then return end
	C.messages:Clear()
	local list = history()
	if not list then return end
	readClasses()
	local r, g, b = color(C.stream)
	for _, m in ipairs(list) do
		if m[2] == C.stream then C.messages:AddMessage(line(m), r, g, b) end
	end
	C.updateBar()
end

local function record(kind, text, author)
	local list = history()
	if not list then return end
	local m = { time(), kind, author, text }
	table.insert(list, m)
	while #list > P.keep do table.remove(list, 1) end
	if C.messages and C.messages:IsVisible() and kind == C.stream then
		if not classes[author] then readClasses() end
		local r, g, b = color(kind)
		C.messages:AddMessage(line(m), r, g, b)
		C.updateBar()
	end
end

-- ------------------------------------------------------------------ Chat

-- Scroll bar over the message frame: lines counted in messages, the frame scrolled from its
-- bottom (3.3.5 ScrollingMessageFrame: GetCurrentScroll, ScrollUp, ScrollDown).
local function visibleLines(m)
	local visible = m.GetNumLinesDisplayed and m:GetNumLinesDisplayed() or 0
	if visible <= 0 then visible = math.floor((m:GetHeight() or 0) / 14) end
	return visible
end

function C.updateBar()
	local m = C.messages
	if not (m and C.bar and m.GetCurrentScroll) then return end
	local total = m:GetNumMessages() or 0
	local visible = visibleLines(m)
	local fromBottom = m:GetCurrentScroll() or 0
	C.bar:Configure(total, visible, math.max(0, total - visible - fromBottom))
end

local function scrollTo(offset)
	local m = C.messages
	if not m.GetCurrentScroll then return end
	local total = m:GetNumMessages() or 0
	local visible = visibleLines(m)
	local wanted = math.max(0, total - visible - offset)
	local current = m:GetCurrentScroll() or 0
	local guard = 0
	while current < wanted and guard < 500 do
		m:ScrollUp()
		current, guard = m:GetCurrentScroll() or wanted, guard + 1
	end
	while current > wanted and guard < 1000 do
		m:ScrollDown()
		current, guard = m:GetCurrentScroll() or wanted, guard + 1
	end
	C.updateBar()
end

-- The edit box: sends to the open stream; the arrows go through what was sent.
local function buildEdit(frame, chat)
	local b = CreateFrame("EditBox", "ForeverUIGuildChatEditBox", frame)
	b:SetHeight(P.edit.h)
	b:SetPoint("TOPLEFT", chat, "BOTTOMLEFT", P.edit.x1, P.edit.y)
	b:SetPoint("TOPRIGHT", chat, "BOTTOMRIGHT", P.edit.x2, P.edit.y)
	b:SetAutoFocus(false)
	b:SetFontObject(ChatFontNormal)
	b:SetTextInsets(6, 6, 0, 0)
	b:SetMaxLetters(255)
	if b.SetAltArrowKeyMode then b:SetAltArrowKeyMode(false) end
	S.skinInput(b)
	b:SetScript("OnEnterPressed", function(self)
		local text = self:GetText()
		if text and text ~= "" then
			SendChatMessage(text, C.stream)
			if self.AddHistoryLine then self:AddHistoryLine(text) end
		end
		self:SetText("")
		self:ClearFocus()
	end)
	b:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
	end)
	-- the prompt while empty and unfocused (camelot: the stream's name)
	local prompt = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	prompt:SetPoint("LEFT", b, "LEFT", 6, 0)
	local function updatePrompt()
		local empty = (b:GetText() or "") == ""
		G.shown(prompt, empty and not b.focused)
		prompt:SetText(string.format(L.GUILD_CHAT_PROMPT, C.streamText()))
	end
	b:SetScript("OnEditFocusGained", function(self) self.focused = true updatePrompt() end)
	b:SetScript("OnEditFocusLost", function(self) self.focused = nil updatePrompt() end)
	b:SetScript("OnTextChanged", updatePrompt)
	C.updatePrompt = updatePrompt
	C.edit = b
	return b
end

function C.streamText()
	for _, s in ipairs(STREAMS) do
		if s.kind == C.stream then return s.text() end
	end
	return ""
end

-- Officer chat only for the ranks that can read the officer note: 3.3.5 has no other test of
-- the player's own rights (GuildControlGetRankFlags reads the rank being edited).
local function streams()
	local list = { STREAMS[1] }
	if CanViewOfficerNote and CanViewOfficerNote() then list[2] = STREAMS[2] end
	return list
end

local function buildStream(frame)
	local dd = CreateFrame("Frame", "ForeverUIGuildStreamDropDown", frame, "UIDropDownMenuTemplate")
	dd:SetPoint("TOPLEFT", G.frame, "TOPLEFT", P.stream.x, P.stream.y)
	UIDropDownMenu_Initialize(dd, function()
		for _, s in ipairs(streams()) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = s.text()
			info.checked = s.kind == C.stream
			info.func = function()
				C.stream = s.kind
				UIDropDownMenu_SetText(dd, s.text())
				C.refill()
				if C.updatePrompt then C.updatePrompt() end
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	Tpl.MenuStyle1(dd, P.stream.w)
	UIDropDownMenu_SetText(dd, C.streamText())
	C.dropdown = dd
end

-- ------------------------------------------------------------------ Members

-- Online members, in the roster's order (whatever its offline filter); the selected one
-- highlighted.
local online = {}

local function createMember(l)
	l:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	l:SetHighlightTexture("Interface" .. string.char(92) .. "FriendsFrame" .. string.char(92) .. "UI-FriendsFrame-HighlightBar")
	local s = l:GetHighlightTexture()
	s:SetBlendMode("ADD")
	s:ClearAllPoints()
	s:SetAllPoints(l)
	l.presence = l:CreateTexture(nil, "OVERLAY")
	l.presence:SetWidth(16)
	l.presence:SetHeight(16)
	l.presence:SetPoint("LEFT", l, "LEFT", 2, 0)
	l.name = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.name:SetJustifyH("LEFT")
	l.name:SetHeight(12)
	l.name:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	l:SetScript("OnClick", function(self, button) G.click(self.member, button) end)
	l:SetScript("OnEnter", function(self) G.memberTooltip(self, self.member) end)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function populateMember(l, n)
	local i = online[n]
	l.member = i
	local name, _, _, _, _, _, _, _, _, status, file = GetGuildRosterInfo(i)
	l.name:SetText(name or "")
	l.name:SetTextColor(G.classColor(file))
	local presence = G.presenceTexture(status)
	l.name:ClearAllPoints()
	l.name:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	if presence then
		l.presence:SetTexture(presence)
		l.presence:Show()
		l.name:SetPoint("LEFT", l.presence, "RIGHT", 2, 0)
	else
		l.presence:Hide()
		l.name:SetPoint("LEFT", l, "LEFT", 4, 0)
	end
	if GetGuildRosterSelection() == i then l:LockHighlight() else l:UnlockHighlight() end
end

function C.updateMembers()
	if not (C.members and C.members:IsVisible()) then return end
	local total = G.counts()
	for k in pairs(online) do online[k] = nil end
	for i = 1, GetNumGuildMembers() or 0 do
		if select(9, GetGuildRosterInfo(i)) then online[#online + 1] = i end
	end
	C.count:SetText(string.format(L.GUILD_MEMBERS_ONLINE, #online, total))
	C.members:Update(#online)
end

-- ------------------------------------------------------------------ Build

local function build(frame)
	local f = G.frame
	-- member list and its inset
	local M = P.members
	local membersBox = ForeverUI.CreateInset(frame, "ForeverUIGuildChatMembersInset")
	membersBox:SetPoint("TOPLEFT", f, "TOPRIGHT", M.x1 - 4, M.y1 + 4)
	membersBox:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -6, M.y2 - 2)
	C.members = S.createList(membersBox, "ForeverUIGuildChatMembers", P.rowH, createMember, populateMember)
	C.members:FollowBar({ "TOPLEFT", f, "TOPRIGHT", M.x1, M.y1 },
		{ "BOTTOMRIGHT", f, "BOTTOMRIGHT", M.x2, M.y2 }, -10)
	C.count = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	C.count:SetPoint("BOTTOMLEFT", f, "TOPRIGHT", M.x1, M.y1 + P.countY)

	-- the chat: message frame in an inset, its scroll bar on the right
	local A = P.chat
	local chat = CreateFrame("ScrollingMessageFrame", "ForeverUIGuildChatMessages", frame)
	chat:SetPoint("TOPLEFT", G.column, "TOPRIGHT", A.x1, A.y1)
	chat:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", M.x1 - 4 + A.x2, M.y2 + A.y2)
	chat:SetFontObject(ChatFontNormal)
	chat:SetJustifyH("LEFT")
	chat:SetFading(false)
	chat:SetMaxLines(P.keep)
	if chat.SetHyperlinksEnabled then chat:SetHyperlinksEnabled(true) end
	chat:SetScript("OnHyperlinkClick", function(_, link, text, button) SetItemRef(link, text, button) end)
	chat:EnableMouseWheel(true)
	chat:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then self:ScrollUp() else self:ScrollDown() end
		C.updateBar()
	end)
	C.messages = chat
	local chatBox = ForeverUI.CreateInset(frame, "ForeverUIGuildChatInset")
	chatBox:SetPoint("TOPLEFT", chat, "TOPLEFT", -8, 6)
	chatBox:SetPoint("BOTTOMRIGHT", chat, "BOTTOMRIGHT", 26, -4)
	chatBox:SetFrameLevel(math.max(0, chat:GetFrameLevel() - 1))
	C.bar = ForeverUI.CreateScrollBar("ForeverUIGuildChatScrollBar", frame, chat)
	C.bar:ClearAllPoints()
	C.bar:SetPoint("TOPLEFT", chat, "TOPRIGHT", 10, 0)
	C.bar:SetPoint("BOTTOMLEFT", chat, "BOTTOMRIGHT", 10, 0)
	C.bar.onScroll = scrollTo

	buildEdit(frame, chat)
	buildStream(frame)

	-- Invite (camelot InviteButton): add a member
	C.invite = G.button(frame, txt("ADDMEMBER"), P.inviteW)
	C.invite:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", P.buttonRight, P.buttonBottom)
	C.invite:SetScript("OnClick", function() StaticPopup_Show("ADD_GUILDMEMBER") end)
end

local function update()
	C.updateMembers()
	local can = CanGuildInvite() and true or false
	if C.invite.Activate then C.invite:Activate(can) end
	-- officer chat no longer readable: back to the guild's
	if C.stream == "OFFICER" and not (CanViewOfficerNote and CanViewOfficerNote()) then
		C.stream = "GUILD"
		UIDropDownMenu_SetText(C.dropdown, C.streamText())
		C.refill()
	end
	if C.updatePrompt then C.updatePrompt() end
end

G.registerView("chat", {
	order = 10,
	icon = G.ICONS.chat,
	tooltip = function() return L.GUILD_TAB_CHAT end,
	build = build,
	show = function() C.refill() end,
	update = update,
	hide = function()
		if C.edit then C.edit:ClearFocus() end
		if G.Roster and G.Roster.closePopups then G.Roster.closePopups() end
	end,
})

local listener = CreateFrame("Frame")
for _, ev in ipairs({ "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "GUILD_ROSTER_UPDATE" }) do
	listener:RegisterEvent(ev)
end
listener:SetScript("OnEvent", function(_, event, text, author)
	if event == "CHAT_MSG_GUILD" then
		record("GUILD", text, author)
	elseif event == "CHAT_MSG_OFFICER" then
		record("OFFICER", text, author)
	elseif C.members and C.members:IsVisible() then
		C.updateMembers()
	end
end)
