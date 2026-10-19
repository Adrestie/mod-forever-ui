-- ForeverUI: the Roster view of the guild window (GuildFrame.lua), after camelot's
-- Communities roster (CommunitiesMemberList, expanded display, GUILD_COLUMN_INFO), with the
-- WotLK GuildFrame's data and actions: member detail, guild control window, add member.
-- Shared with the Chat view's member list: G.click, G.selection, G.memberColor...

local ForeverUI = ForeverUI or {}
_G.ForeverUI = ForeverUI
local S = ForeverUI.Social
local G = ForeverUI.Guild
if not (S and G) then
	return
end

local Gu = {}
G.Roster = Gu

local SEP = string.char(92)
local txt = S.txt

local P = {
	-- the inset around headers and list: from the guild column's right (camelot MemberList
	-- expanded: CommunitiesList TOPRIGHT + 26, -60) to the frame's right, above the buttons
	insetX1 = 194, insetY1 = -58, insetX2 = -6, insetY2 = 28,
	headerX = 4, headerY = -4, gap = -2,
	rowH = 20, textH = 12,
	-- GUILD_COLUMN_INFO: Level 40, Class 45, Name 100, Zone 100, Rank 85, Note to the edge
	columns = { { "LEVEL", 40, "level" }, { "CLASS", 45, "class" }, { "NAME", 100, "name" },
		{ "ZONE", 100, "zone" }, { "RANK", 85, "rank" }, { "LABEL_NOTE", 0, "note" } },
	-- The last column reaches the list edge; fillW: its width before anchoring.
	-- Without a scroll bar, list and headers keep their left margin on the right:
	-- list at -5, last column at +1 from the list edge.
	noteRight = -6, noteRightAlone = 1, fillW = 60, listX2 = -22, listX2NoBar = -5,
	strip = "Interface" .. SEP .. "ForeverUI" .. SEP .. "guildframe" .. SEP .. "guildframe",
	stripCoords = { 0.36230469, 0.38183594, 0.95898438, 0.99804688 },
	bar = "Interface" .. SEP .. "FriendsFrame" .. SEP .. "UI-FriendsFrame-HighlightBar",
	classes = "Interface" .. SEP .. "Glues" .. SEP .. "CharacterCreate" .. SEP .. "UI-CharacterCreate-Classes",
	leader = "Interface" .. SEP .. "GroupFrame" .. SEP .. "UI-Group-LeaderIcon",
	absent = "Interface" .. SEP .. "FriendsFrame" .. SEP .. "StatusIcon-Away",
	busy = "Interface" .. SEP .. "FriendsFrame" .. SEP .. "StatusIcon-DnD",
	nameW = 95, zoneW = 90, rankW = 80,
	-- Show offline (ShowOfflineButton) and the totals, above the inset
	offlineX = 198, offlineY = -30, totalsRight = -12, totalsY = -36,
	buttonBottom = 5, buttonRight = -5, controlW = 130, addW = 130,
	gray = 0.5, grayText = 0.65,
}

local function active(b, yes)
	if b.Activate then b:Activate(yes) elseif yes then b:Enable() else b:Disable() end
end

-- The client's RecentTimeDate if present, else the same rule.
local function fromIndex(year, month, day, hour)
	if RecentTimeDate then return RecentTimeDate(year, month, day, hour) end
	if year and year > 0 then return string.format(txt("LASTONLINE_YEARS"), year) end
	if month and month > 0 then return string.format(txt("LASTONLINE_MONTHS"), month) end
	if day and day > 0 then return string.format(txt("LASTONLINE_DAYS"), day) end
	if hour and hour > 0 then return string.format(txt("LASTONLINE_HOURS"), hour) end
	return txt("LASTONLINE_MINS")
end
G.fromIndex = fromIndex

-- IsTruncated, missing in 3.3.5: true if a fixed-width font string is too narrow.
local function isTruncated(fs)
	local l = fs:GetWidth()
	return l and l > 0 and fs:GetStringWidth() > l + 0.5
end

local function classColor(file)
	local c = file and RAID_CLASS_COLORS and RAID_CLASS_COLORS[file] or NORMAL_FONT_COLOR
	return c.r, c.g, c.b
end
G.classColor = classColor

-- Presence icon of an online member (CommunitiesMemberListEntryMixin:UpdatePresence):
-- AFK or DND, nil otherwise.
function G.presenceTexture(status)
	if status == CHAT_FLAG_AFK then return FRIENDS_TEXTURE_AFK or P.absent end
	if status == CHAT_FLAG_DND then return FRIENDS_TEXTURE_DND or P.busy end
	return nil
end

-- Member tooltip (CommunitiesMemberListEntryMixin:OnEnter): name, rank, level and class,
-- zone, note. owner: the row; i: roster index.
function G.memberTooltip(owner, i)
	local name, rank, _, level, className, zone, note, _, online = GetGuildRosterInfo(i)
	if not name then return end
	local n = NORMAL_FONT_COLOR or { r = 1, g = 0.82, b = 0 }
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:AddLine(name)
	GameTooltip:AddLine(rank or "")
	if level and className then
		GameTooltip:AddLine(string.format(txt("FRIENDS_LEVEL_TEMPLATE"), level, className), 1, 1, 1, true)
	end
	if online and zone and zone ~= "" then
		GameTooltip:AddLine(zone, 1, 1, 1, true)
	elseif not online then
		GameTooltip:AddLine(fromIndex(GetGuildRosterLastOnline(i)), 1, 1, 1, true)
	end
	if note and note ~= "" then
		GameTooltip:AddLine(txt("NOTE_COLON") .. " " .. note, n.r, n.g, n.b, true)
	end
	GameTooltip:Show()
end

-- ---------- Member list

-- Builds a roster row (CommunitiesMemberListEntryTemplate). l: row button.
local function createRow(l)
	l:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	l:SetNormalTexture(P.strip)
	local n = l:GetNormalTexture()
	n:SetTexCoord(P.stripCoords[1], P.stripCoords[2], P.stripCoords[3], P.stripCoords[4])
	n:ClearAllPoints()
	n:SetAllPoints(l)
	l:SetHighlightTexture(P.bar)
	local s = l:GetHighlightTexture()
	s:SetBlendMode("ADD")
	s:ClearAllPoints()
	s:SetAllPoints(l)
	local function field(parent, width)
		local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetJustifyH("LEFT")
		fs:SetHeight(P.textH)
		if width then fs:SetWidth(width) end
		return fs
	end
	-- Level centered on its column: the Level header spans -1 to 39 from the list edge
	-- (camelot left-aligns it at 4).
	l.level = field(l, P.columns[1][2])
	l.level:SetPoint("LEFT", l, "LEFT", -1, 0)
	l.level:SetJustifyH("CENTER")
	-- Class icon at its camelot place (4 + 40 + 8), centered under Class.
	l.className = l:CreateTexture(nil, "OVERLAY")
	l.className:SetTexture(P.classes)
	l.className:SetWidth(16)
	l.className:SetHeight(16)
	l.className:SetPoint("LEFT", l, "LEFT", 52, 0)
	-- NameFrame: presence, name, rank icon.
	local nf = CreateFrame("Frame", nil, l)
	nf:SetHeight(20)
	nf:SetWidth(P.nameW)
	nf:SetPoint("LEFT", l.className, "RIGHT", 18, 0)
	l.nameFrame = nf
	l.presence = nf:CreateTexture(nil, "OVERLAY")
	l.presence:SetWidth(16)
	l.presence:SetHeight(16)
	l.presence:SetPoint("LEFT", nf, "LEFT", 0, 0)
	l.name = field(nf)
	l.rankIcon = nf:CreateTexture(nil, "OVERLAY")
	l.rankIcon:SetWidth(12)
	l.rankIcon:SetHeight(12)
	l.zone = field(l, P.zoneW)
	l.zone:SetPoint("LEFT", nf, "RIGHT", 8, 0)
	l.rank = field(l, P.rankW)
	l.rank:SetPoint("LEFT", l.zone, "RIGHT", 7, 0)
	-- Note fills the rest of the row
	l.note = field(l)
	l.note:SetPoint("LEFT", l.rank, "RIGHT", 8, 0)
	l.note:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	l:SetScript("OnClick", function(self, button) G.click(self.index, button) end)
	-- CommunitiesMemberListEntryMixin:OnEnter, Roster view: only when a text is cut
	l:SetScript("OnEnter", function(self)
		if isTruncated(self.name) or isTruncated(self.rank) or isTruncated(self.zone) or isTruncated(self.note) then
			G.memberTooltip(self, self.index)
		end
	end)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- UpdateNameFrame: name after the presence icon, rank icon after the name.
local function updateNameFrame(l)
	local icons, offset = 0, 0
	local presence = l.presence:IsShown()
	l.name:ClearAllPoints()
	if presence then
		icons = icons + 20
		l.name:SetPoint("LEFT", l.presence, "RIGHT", 0, 0)
		offset = l.presence:GetWidth()
	else
		l.name:SetPoint("LEFT", l.nameFrame, "LEFT", 0, 0)
	end
	if l.rankIcon:IsShown() then
		icons = icons + (presence and 20 or 25)
	end
	local nameWidth = P.nameW - icons
	l.name:SetWidth(nameWidth)
	local text = l.name:GetStringWidth()
	l.rankIcon:ClearAllPoints()
	l.rankIcon:SetPoint("LEFT", l.nameFrame, "LEFT", math.min(text, nameWidth) + offset, 0)
end

-- CommunitiesMemberListEntryMixin: SetMember, UpdateRank, UpdatePresence,
-- RefreshExpandedColumns. 3.3.5 has no community roles: the rank icon only marks
-- the guild master.
local function populateRow(l, i)
	local name, rank, rankIndex, level, _, zone, note, _, online, status, file = GetGuildRosterInfo(i)
	l.name:SetText(name)
	l.level:SetText(level or "")
	local tc = file and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[file]
	if tc then
		l.className:SetTexCoord(tc[1], tc[2], tc[3], tc[4])
		l.className:Show()
	else
		l.className:Hide()
	end
	local fields = { l.level, l.zone, l.rank, l.note }
	if online then
		l.name:SetTextColor(classColor(file))
		for _, fs in ipairs(fields) do fs:SetTextColor(1, 1, 1) end
		local presence = G.presenceTexture(status)
		if presence then
			l.presence:SetTexture(presence)
			l.presence:Show()
		else
			l.presence:Hide()
		end
		l.zone:SetText(zone or "")
	else
		l.presence:Hide()
		l.name:SetTextColor(P.gray, P.gray, P.gray)
		for _, fs in ipairs(fields) do fs:SetTextColor(P.gray, P.gray, P.gray) end
		l.zone:SetText(fromIndex(GetGuildRosterLastOnline(i)))
	end
	l.rank:SetText(rank or "")
	l.note:SetText(note or "")
	if rankIndex == 0 then
		l.rankIcon:SetTexture(P.leader)
		l.rankIcon:Show()
	else
		l.rankIcon:Hide()
	end
	updateNameFrame(l)
	if GetGuildRosterSelection() == i then l:LockHighlight() else l:UnlockHighlight() end
end

-- ---------- Member detail

local D = {}

-- Label and value line of the detail. caption: text key; y: offset from the top.
local function detailField(a, caption, y)
	local l = a:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	l:SetPoint("TOPLEFT", a, "TOPLEFT", 18, y)
	l:SetText(txt(caption))
	local v = a:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	v:SetPoint("LEFT", l, "RIGHT", 6, 0)
	v:SetPoint("RIGHT", a, "RIGHT", -18, 0)
	v:SetJustifyH("LEFT")
	v:SetHeight(12)
	return l, v
end

-- A note: clickable inset, text grayed when it cannot be edited.
-- popup: StaticPopup that edits it.
local function detailNote(a, caption, popup)
	local l = a:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	l:SetText(txt(caption))
	local e = ForeverUI.CreateInset(a)
	e:SetHeight(40)
	e:SetPoint("TOPLEFT", l, "BOTTOMLEFT", -2, -3)
	e:SetPoint("RIGHT", a, "RIGHT", -16, 0)
	e:EnableMouse(true)
	local t = e:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	t:SetPoint("TOPLEFT", e, "TOPLEFT", 6, -5)
	t:SetPoint("BOTTOMRIGHT", e, "BOTTOMRIGHT", -6, 5)
	t:SetJustifyH("LEFT")
	t:SetJustifyV("TOP")
	if t.SetWordWrap then t:SetWordWrap(true) end
	e:SetScript("OnMouseUp", function(self)
		if self.editable then StaticPopup_Show(popup) end
	end)
	return l, e, t
end

local function createDetail()
	local a = G.createPopup("ForeverUIGuildMemberDetail", 232, 290)
	D.frame = a
	D.level = a:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	D.level:SetPoint("TOPLEFT", a, "TOPLEFT", 18, -30)
	D.zoneLabel, D.zone = detailField(a, "ZONE_COLON", -48)
	D.rankLabel, D.rank = detailField(a, "RANK_COLON", -64)
	D.rank:SetPoint("RIGHT", a, "RIGHT", -52, 0)
	D.lastSeenLabel, D.found = detailField(a, "LAST_ONLINE_COLON", -80)
	-- Promote / demote: camelot scroll bar arrows.
	local function arrow(atlas, hover, onClick)
		local f = CreateFrame("Button", nil, a)
		f:SetWidth(17)
		f:SetHeight(11)
		local e = ForeverUI.AtlasEntry(atlas)
		f:SetNormalTexture(e and e[1] or "")
		local n = f:GetNormalTexture()
		if n then ForeverUI.SetAtlas(n, atlas, true) n:SetAllPoints(f) end
		f:SetHighlightTexture(e and e[1] or "")
		local h = f:GetHighlightTexture()
		if h then ForeverUI.SetAtlas(h, hover, true) h:SetAllPoints(f) end
		f:SetScript("OnClick", onClick)
		return f
	end
	D.promote = arrow("minimal-scrollbar-arrow-top-c60", "minimal-scrollbar-arrow-top-over-c60", function(self)
		GuildPromote(GuildFrame.selectedName)
		PlaySound("UChatScrollButton")
		self:Disable()
	end)
	D.promote:SetPoint("LEFT", D.rank, "RIGHT", 4, 6)
	D.demote = arrow("minimal-scrollbar-arrow-bottom-c60", "minimal-scrollbar-arrow-bottom-over-c60", function(self)
		GuildDemote(GuildFrame.selectedName)
		PlaySound("UChatScrollButton")
		self:Disable()
	end)
	D.demote:SetPoint("TOP", D.promote, "BOTTOM", 0, -2)
	D.noteLabel, D.note, D.noteText = detailNote(a, "NOTE_COLON", "SET_GUILDPLAYERNOTE")
	D.noteLabel:SetPoint("TOPLEFT", a, "TOPLEFT", 18, -102)
	D.officerLabel, D.officer, D.officerText = detailNote(a, "OFFICER_NOTE_COLON", "SET_GUILDOFFICERNOTE")
	D.officerLabel:SetPoint("TOPLEFT", D.note, "BOTTOMLEFT", 2, -10)
	D.remove = G.button(a, txt("REMOVE"), 100)
	D.remove:SetPoint("BOTTOMLEFT", a, "BOTTOMLEFT", 12, 12)
	D.remove:SetScript("OnClick", function() StaticPopup_Show("REMOVE_GUILDMEMBER") end)
	D.inviteButton = G.button(a, txt("GROUP_INVITE"), 100)
	D.inviteButton:SetPoint("LEFT", D.remove, "RIGHT", 4, 0)
	D.inviteButton:SetScript("OnClick", function() InviteUnit(GuildFrame.selectedName) end)
	a:HookScript("OnHide", function()
		-- Closing the detail clears the selection (the client resets it to 0).
		if Gu.closing then return end
		G.selection(0)
	end)
end

-- GuildStatus_Update, for the detail pane.
function G.updateDetail()
	local a = D.frame
	if not a or not a:IsShown() then return end
	local i = GetGuildRosterSelection()
	if not i or i == 0 then a:Hide() return end
	local name, rank, rankIndex, level, className, zone, note, officer, online = GetGuildRosterInfo(i)
	local _, _, myRank = GetGuildInfo("player")
	myRank = myRank or 0
	local maxRank = (GuildControlGetNumRanks and GuildControlGetNumRanks() or 1) - 1
	a.title:SetText(name or "")
	D.level:SetText(string.format(txt("FRIENDS_LEVEL_TEMPLATE"), level or 0, className or ""))
	D.zone:SetText(zone)
	D.rank:SetText(rank)
	D.found:SetText(online and txt("GUILD_ONLINE_LABEL") or fromIndex(GetGuildRosterLastOnline(i)))
	-- Public note
	D.note.editable = CanEditPublicNote()
	if D.note.editable then
		if not note or note == "" then note = txt("GUILD_NOTE_EDITLABEL") end
		D.noteText:SetTextColor(1, 1, 1)
	else
		D.noteText:SetTextColor(P.grayText, P.grayText, P.grayText)
	end
	D.noteText:SetText(note or "")
	-- Officer note
	if CanViewOfficerNote() then
		D.officer.editable = CanEditOfficerNote()
		if D.officer.editable then
			if not officer or officer == "" then officer = txt("GUILD_OFFICERNOTE_EDITLABEL") end
			D.officerText:SetTextColor(1, 1, 1)
		else
			D.officerText:SetTextColor(P.grayText, P.grayText, P.grayText)
		end
		D.officerText:SetText(officer or "")
		D.officerLabel:Show()
		D.officer:Show()
		a:SetHeight(290)
	else
		D.officerLabel:Hide()
		D.officer:Hide()
		a:SetHeight(230)
	end
	-- Promote, demote, remove, invite
	local canPromote = CanGuildPromote() and rankIndex and rankIndex > 1 and rankIndex > (myRank + 1)
	local canDemote = CanGuildDemote() and rankIndex and rankIndex >= 1 and rankIndex > myRank and rankIndex ~= maxRank
	if canPromote then D.promote:Enable() else D.promote:Disable() end
	if canDemote then D.demote:Enable() else D.demote:Disable() end
	if canPromote or canDemote then
		D.promote:Show()
		D.demote:Show()
	else
		D.promote:Hide()
		D.demote:Hide()
	end
	active(D.remove, CanGuildRemove() and rankIndex and rankIndex >= 1 and rankIndex > myRank)
	active(D.inviteButton, UnitName("player") ~= name and online and true or false)
end

-- Sets the client selection and what its popups read (GuildFrame.selectedName).
function G.selection(i)
	SetGuildRosterSelection(i or 0)
	if GuildFrame then
		GuildFrame.selectedGuildMember = i or 0
		GuildFrame.selectedName = (i and i > 0) and GetGuildRosterInfo(i) or nil
	end
	if Gu.list and Gu.list:IsVisible() then Gu.list:Update() end
	if G.Chat and G.Chat.updateMembers then G.Chat.updateMembers() end
end

-- FriendsFrameGuildStatusButton_OnClick. i: roster index.
function G.click(i, button)
	if not i then return end
	if button == "RightButton" then
		local name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
		ForeverUI.UnitMenu.open(FriendsFrame_ShowDropdown, name, online)
		return
	end
	PlaySound("igMainMenuOptionCheckBoxOn")
	if not D.frame then createDetail() end
	if D.frame:IsShown() and GetGuildRosterSelection() == i then
		G.selection(0)
		D.frame:Hide()
	else
		G.selection(i)
		D.frame:Show()
		G.updateDetail()
	end
end

-- Totals of the roster: members and members online (all, whatever the offline filter).
function G.counts()
	local shownItems = GetNumGuildMembers() or 0
	local total = GetNumGuildMembers(true) or shownItems
	local online = 0
	for i = 1, shownItems do
		if select(9, GetGuildRosterInfo(i)) then online = online + 1 end
	end
	return total, online, shownItems
end

-- ---------- Update

function Gu.update()
	if not Gu.list then return end
	-- List: shown members (no offline ones if the box is unchecked); total: all members.
	local total, online, shownItems = G.counts()
	Gu.totals:SetText(string.format(txt("GUILD_TOTAL"), total) .. " " .. string.format(txt("GUILD_TOTALONLINE"), online))
	Gu.offlineCheck:SetChecked(GetGuildRosterShowOffline() and true or false)
	Gu.list:Update(shownItems)
	active(Gu.control, IsGuildLeader() and true or false)
	active(Gu.add, CanGuildInvite() and true or false)
	G.updateDetail()
end

-- ---------- Guild control window

local CONTROL_CHECKBOXES = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17 }
G.CONTROL_TOP = 24

-- Reskins the client's GuildControlPopupFrame once. gc: that frame.
function G.skinControl(gc)
	if gc.foreverSkinApplied then return end
	gc.foreverSkinApplied = true
	-- MacroPopup background: six unnamed textures.
	for _, r in ipairs({ gc:GetRegions() }) do
		local f = r.GetTexture and r:GetTexture()
		if type(f) == "string" and string.find(string.lower(f), "macropopup", 1, true) then
			r:SetAlpha(0)
			r:Hide()
		end
	end
	-- The skin reaches 24 above the frame: the client content starts 15 below the top
	-- (GUILDCONTROL_SELECTRANK) and the metal bar would cover it. The skin draws under the
	-- content, its metal in front. Size set by hand: UpdatePanelCorners reads it.
	local skin = CreateFrame("Frame", nil, gc)
	skin:SetWidth(gc:GetWidth() > 0 and gc:GetWidth() or 320)
	skin:SetHeight((gc:GetHeight() > 0 and gc:GetHeight() or 457) + G.CONTROL_TOP)
	skin:SetPoint("TOPLEFT", gc, "TOPLEFT", 0, G.CONTROL_TOP)
	skin:SetFrameLevel(math.max(0, gc:GetFrameLevel() - 1))
	ForeverUI.SetPanelArt(skin, { topLeftCorner = "ui-frame-metal-cornertopleft", level = 25 })
	gc.foreverSkin = skin
	local metal = skin.foreverSkinLayer or skin
	local banner = CreateFrame("Frame", nil, gc)
	banner:SetAllPoints(skin)
	banner:SetFrameLevel(metal:GetFrameLevel() + 1)
	local title = banner:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", skin, "TOP", 0, -6)
	title:SetText(txt("GUILDCONTROL"))
	gc.foreverTitle = title
	local closeButton = CreateFrame("Button", nil, gc)
	closeButton:SetWidth(24)
	closeButton:SetHeight(24)
	closeButton:SetFrameLevel(metal:GetFrameLevel() + 2)
	closeButton:SetPoint("TOPRIGHT", skin, "TOPRIGHT", 1, 0)
	for _, state in ipairs({
		{ "SetNormalTexture", "GetNormalTexture", "redbutton-exit" },
		{ "SetPushedTexture", "GetPushedTexture", "redbutton-exit-pressed" },
		{ "SetHighlightTexture", "GetHighlightTexture", "redbutton-highlight" },
	}) do
		local e = ForeverUI.AtlasEntry(state[3])
		closeButton[state[1]](closeButton, e and e[1] or "")
		local t = closeButton[state[2]](closeButton)
		if t then
			ForeverUI.SetAtlas(t, state[3], true)
			t:ClearAllPoints()
			t:SetAllPoints(closeButton)
			if state[3] == "redbutton-highlight" then t:SetBlendMode("ADD") end
		end
	end
	closeButton:SetScript("OnClick", function() gc:Hide() end)
	gc.foreverCloseButton = closeButton
	-- Checkboxes
	for _, i in ipairs(CONTROL_CHECKBOXES) do
		local c = _G["GuildControlPopupFrameCheckbox" .. i]
		if c then S.skinCell(c) end
	end
	for _, n in ipairs({ "GuildControlTabPermissionsViewTab", "GuildControlTabPermissionsDepositItems",
		"GuildControlTabPermissionsUpdateText" }) do
		if _G[n] then S.skinCell(_G[n]) end
	end
	-- Edit boxes
	for _, n in ipairs({ "GuildControlPopupFrameEditBox", "GuildControlWithdrawGoldEditBox",
		"GuildControlWithdrawItemsEditBox" }) do
		if _G[n] then S.skinInput(_G[n]) end
	end
	-- Bank permissions frame: camelot inset instead of the tooltip backdrop.
	local tp = _G["GuildControlPopupFrameTabPermissions"]
	if tp then
		if tp.SetBackdrop then tp:SetBackdrop(nil) end
		ForeverUI.DecorateInset(tp)
	end
end

-- The Guild Control button (camelot CommunitiesControlFrame.GuildControlButton), shared by
-- the Roster and Guild Info views: opens the client's window, kept for its functions.
function G.controlButton(parent)
	local b = G.button(parent, txt("GUILDCONTROL"), P.controlW)
	b:SetPoint("BOTTOMRIGHT", G.frame, "BOTTOMRIGHT", P.buttonRight, P.buttonBottom)
	b:SetScript("OnClick", function()
		local gc = GuildControlPopupFrame
		if not gc then return end
		-- Its OnShow and OnHide set FriendsFrame's attributes and place it (UpdateUIPanelPositions):
		-- refused to our code in combat, FriendsFrame being protected by the secure tabs.
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0)
			return
		end
		if gc:IsShown() then
			gc:Hide()
		else
			if S.popup then S.popup:Hide() end
			if GuildControlPopupFrame_Initialize and not gc.initialized then
				GuildControlPopupFrame_Initialize()
			end
			gc:Show()
		end
	end)
	return b
end

-- ---------- Build

-- Builds the Roster view. frame: the view's frame over the guild window.
local function build(frame)
	local f = G.frame
	local frameBox = ForeverUI.CreateInset(frame, "ForeverUIGuildRosterInset")
	frameBox:SetPoint("TOPLEFT", f, "TOPLEFT", P.insetX1, P.insetY1)
	frameBox:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", P.insetX2, P.insetY2)

	-- Headers: GUILD_COLUMN_INFO, Note up to the edge.
	Gu.headers = {}
	local previous
	for i, col in ipairs(P.columns) do
		local h = S.createHeader(frameBox, "ForeverUIGuildColumn" .. i, col[2] > 0 and col[2] or P.fillW, txt(col[1]), function(self)
			SortGuildRoster(self.sort)
		end)
		h.sort = col[3]
		if previous then
			h:SetPoint("LEFT", previous, "RIGHT", P.gap, 0)
		else
			h:SetPoint("TOPLEFT", frameBox, "TOPLEFT", P.headerX, P.headerY)
		end
		Gu.headers[i] = h
		previous = h
	end
	Gu.list = S.createList(frameBox, "ForeverUIGuildRosterList", P.rowH, createRow, populateRow)
	-- Without a scroll bar, the list and the Note column reach the edge.
	local placeAnchors = Gu.list.PlaceAnchors
	function Gu.list:PlaceAnchors()
		placeAnchors(self)
		Gu.headers[#P.columns]:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT",
			self.hasBar and P.noteRight or P.noteRightAlone, 1)
	end
	Gu.list:FollowBar({ "TOPLEFT", Gu.headers[1], "BOTTOMLEFT", 1, -1 },
		{ "BOTTOMRIGHT", frameBox, "BOTTOMRIGHT", P.listX2, 4 }, P.listX2NoBar)

	-- Totals, top right
	Gu.totals = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	Gu.totals:SetPoint("TOPRIGHT", f, "TOPRIGHT", P.totalsRight, P.totalsY)
	Gu.totals:SetJustifyH("RIGHT")

	-- Show offline checkbox (ShowOfflineButton), top left of the list.
	local outside = S.createCheckbox(frame, "ForeverUIGuildShowOffline", txt("SHOW_OFFLINE_MEMBERS"))
	outside:SetPoint("TOPLEFT", f, "TOPLEFT", P.offlineX, P.offlineY)
	-- As GuildFrameLFGButton's OnClick: clear the selection (roster indexes change with the
	-- filter), toggle the filter and redraw now instead of waiting for GUILD_ROSTER_UPDATE.
	outside:SetScript("OnClick", function(self)
		G.selection(0)
		if self:GetChecked() then
			PlaySound("igMainMenuOptionCheckBoxOff")
		else
			PlaySound("igMainMenuOptionCheckBoxOn")
		end
		SetGuildRosterShowOffline(self:GetChecked() and true or false)
		Gu.update()
	end)
	Gu.offlineCheck = outside

	-- Bottom buttons: Guild Control at the right, Add Member before it
	Gu.control = G.controlButton(frame)
	Gu.add = G.button(frame, txt("ADDMEMBER"), P.addW)
	Gu.add:SetPoint("RIGHT", Gu.control, "LEFT", -2, 0)
	Gu.add:SetScript("OnClick", function() StaticPopup_Show("ADD_GUILDMEMBER") end)
end

-- The detail and the control window close with the view, unless the Chat view (whose member
-- list opens the detail too) takes over.
function Gu.closePopups()
	Gu.closing = true
	if D.frame then D.frame:Hide() end
	-- In combat the client hides it (FriendsFrame_OnHide): its OnHide, run from ours, would be
	-- refused (see G.controlButton).
	if GuildControlPopupFrame and not InCombatLockdown() then GuildControlPopupFrame:Hide() end
	Gu.closing = nil
end

G.registerView("roster", {
	order = 20,
	icon = G.ICONS.roster,
	tooltip = function() return ForeverUI.L.GUILD_TAB_ROSTER end,
	build = build,
	update = Gu.update,
	hide = Gu.closePopups,
})

-- The client's guild control window (parent UIParent) is kept: its functions drive the server.
-- It is moved to the right of our window on each show; anchored to GuildFrame, it would go
-- off screen with it.
if GuildControlPopupFrame then
	G.skinControl(GuildControlPopupFrame)
	GuildControlPopupFrame:HookScript("OnShow", function(self)
		if S.popup then S.popup:Hide() end
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", G.frame, "TOPRIGHT", 38, -G.CONTROL_TOP)
	end)
end

local listener = CreateFrame("Frame")
for _, ev in ipairs({ "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE" }) do
	listener:RegisterEvent(ev)
end
listener:SetScript("OnEvent", function()
	if Gu.list and Gu.list:IsVisible() then Gu.update() end
	if D.frame and D.frame:IsShown() then G.updateDetail() end
end)
