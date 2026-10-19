-- Window tabs on the action bars. 3.3.5 bars hold spells, items, macros, equipment sets and
-- companions only: a dragged tab becomes an account macro whose body opens its window, made once
-- and found again by its body. On a bar the macro shows the tab's icon, not the macro's. Making a
-- macro needs a free slot and is refused in combat; picking up an existing one is not.
-- The character sheet's side tabs use it (CharacterFrame.lua), and so can other addons and the
-- server modules' AIO windows when ForeverUI is there:
--   ForeverUI.TabMacros.Register(body, info): the macro with this body is a tab. info:
--     name      macro name, cut to 16 bytes (a value, or a function returning it)
--     icon      texture shown on the bars (same)
--     macroIcon an Interface\Icons file name, for the macro window when the client's macro
--               icon lists lack icon; the question mark when they lack both (same)
-- A macro's icon comes from the client's two fixed lists (GetMacroIconInfo, 1125 spell icons in
-- this client, then GetMacroItemIconInfo): no SpellIcon.dbc row or file adds to them (checked in
-- game with /fui tabicons, 2026-10-19). So while a tab macro is on the cursor, the cursor shows
-- the tab's icon itself (SetCursor on each frame until it is dropped).
--   ForeverUI.TabMacros.Pickup(body, info): registers, then puts the macro on the cursor.
--   ForeverUI.TabMacros.EnableDrag(button, body, info): a left drag of the button does Pickup.
--     body may be a function(button) returning body, info, for a button reused by several tabs.

local M = {}
ForeverUI.TabMacros = M

local L = ForeverUI.L
local MACRO_NAME_BYTES = 16
local BAR_PREFIXES = { "ActionButton", "BonusActionButton", "MultiBarBottomLeftButton",
	"MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton" }

-- body -> info
local registry = {}

local function value(v)
	if type(v) == "function" then
		return v()
	end
	return v
end

local function trim(body)
	return type(body) == "string" and (body:gsub("%s+$", "")) or nil
end

-- Cuts a name to the macro limit without splitting a UTF-8 character
local function cutName(name)
	if #name <= MACRO_NAME_BYTES then
		return name
	end
	local cut = MACRO_NAME_BYTES
	while cut > 0 and name:byte(cut + 1) and name:byte(cut + 1) >= 0x80
		and name:byte(cut + 1) < 0xC0 do
		cut = cut - 1
	end
	return name:sub(1, cut)
end

local function find(body)
	if not GetMacroInfo then
		return nil
	end
	local last = (MAX_ACCOUNT_MACROS or 36) + (MAX_CHARACTER_MACROS or 18)
	for index = 1, last do
		local _, _, macroBody = GetMacroInfo(index)
		if trim(macroBody) == body then
			return index
		end
	end
end

local function normalized(path)
	return (path:lower():gsub("/", "\\"))
end

local function fileName(path)
	return path:match("([^\\]+)$") or path
end

-- An icon of the two macro lists by its CreateMacro index: spell icons, then item icons
local function iconTexture(index)
	local spells = GetNumMacroIcons and GetNumMacroIcons() or 0
	if index <= spells then
		return GetMacroIconInfo(index)
	elseif GetMacroItemIconInfo then
		return GetMacroItemIconInfo(index - spells)
	end
end

local function iconCount()
	return (GetNumMacroIcons and GetNumMacroIcons() or 0)
		+ (GetNumMacroItemIcons and GetNumMacroItemIcons() or 0)
end

-- Index of an icon in the client's macro list, nil when absent. wanted: a full path (found in
-- Interface\Icons by its file name, or a <Module>_ copy of it), or a bare file name
local function findIcon(wanted)
	if type(wanted) ~= "string" or wanted == "" or not GetNumMacroIcons or not GetMacroIconInfo then
		return nil
	end
	local total = iconCount()
	wanted = normalized(wanted)
	local base = fileName(wanted)
	local copy = "_" .. base
	local best, rank
	for index = 1, total do
		local texture = iconTexture(index)
		if texture then
			texture = normalized(texture)
			local name = fileName(texture)
			local r
			if texture == wanted then
				r = 1
			elseif name == base then
				r = 2
			elseif name:sub(-#copy) == copy then
				r = 3
			end
			if r and (not rank or r < rank) then
				best, rank = index, r
				if r == 1 then break end
			end
		end
	end
	return best
end

-- The tab's own icon, else the nearest one, else 1 (the question mark)
local function iconIndex(info)
	return findIcon(info and value(info.icon)) or findIcon(info and value(info.macroIcon)) or 1
end

-- An action button holding a tab macro shows the tab's icon. Called after ActionButton_Update
-- (ActionBar.lua) and on each button when a tab is registered.
function M.ShowIcon(button)
	local action = button and button.action
	if not action or not GetActionInfo or not GetMacroInfo then
		return
	end
	local kind, id = GetActionInfo(action)
	if kind ~= "macro" then
		return
	end
	local _, _, body = GetMacroInfo(id)
	local info = registry[trim(body) or ""]
	local texture = info and value(info.icon)
	local icon = texture and button.GetName and _G[(button:GetName() or "") .. "Icon"]
	if icon then
		icon:SetTexture(texture)
	end
end

local function refreshBars()
	for _, prefix in ipairs(BAR_PREFIXES) do
		for index = 1, NUM_ACTIONBAR_BUTTONS or 12 do
			local button = _G[prefix .. index]
			if button then
				M.ShowIcon(button)
			end
		end
	end
end

function M.Register(body, info)
	body = trim(body)
	if not body or type(info) ~= "table" then
		return
	end
	local known = registry[body]
	registry[body] = info
	-- A module loaded after the bars: its macros get their icon now
	if not known then
		refreshBars()
	end
end

function M.Pickup(body, info)
	body = trim(body)
	if not body or not PickupMacro then
		return
	end
	M.Register(body, info)
	local index = find(body)
	-- A macro made before its icon was in the list (the question mark) gets the tab's icon
	if index and not InCombatLockdown() and EditMacro then
		local name, texture, macroBody = GetMacroInfo(index)
		local better = findIcon(info and value(info.icon))
		if better and normalized(texture or "") ~= normalized(iconTexture(better) or "") then
			EditMacro(index, name, better, macroBody)
		end
	end
	if not index then
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1, 1)
			return
		end
		local account, character = GetNumMacros()
		local perCharacter
		if (account or 0) >= (MAX_ACCOUNT_MACROS or 36) then
			if (character or 0) >= (MAX_CHARACTER_MACROS or 18) then
				UIErrorsFrame:AddMessage(L.TABMACROS_FULL, 1, 0.1, 0.1, 1)
				return
			end
			perCharacter = 1
		end
		local name = cutName(tostring(info and value(info.name) or ""))
		if name == "" then
			name = "?"
		end
		index = CreateMacro(name, iconIndex(info), body,
			perCharacter, perCharacter)
		if not index then
			return
		end
	end
	PickupMacro(index)
end

function M.EnableDrag(button, body, info)
	if not button then
		return
	end
	if type(body) ~= "function" then
		M.Register(body, info)
	end
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(self)
		local b, i = body, info
		if type(body) == "function" then
			b, i = body(self)
		end
		GameTooltip:Hide()
		M.Pickup(b, i)
	end)
end

M.registry = registry

-- The cursor: a tab macro held shows the tab's icon instead of the macro's (from the bars too)
local cursor = CreateFrame("Frame")
cursor:SetScript("OnUpdate", function(self)
	if not GetCursorInfo then return end
	local kind, id = GetCursorInfo()
	local info
	if kind == "macro" and id and GetMacroInfo then
		local _, _, body = GetMacroInfo(id)
		info = registry[trim(body) or ""]
	end
	local texture = info and value(info.icon)
	if texture and SetCursor then
		SetCursor(texture)
		self.shown = true
	elseif self.shown then
		self.shown = nil
		if ResetCursor then ResetCursor() end
	end
end)
M.cursor = cursor

-- /fui tabicons: what the client's macro icon list holds for the registered tabs
function M.Debug()
	local say = function(text) DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffForeverUI|r " .. text) end
	local total = iconCount()
	local copies = {}
	for index = 1, total do
		local texture = iconTexture(index)
		local name = texture and fileName(normalized(texture)) or ""
		if name:find("^foreverui_") or name:find("^spheregrid_") or name:find("^stellartarot_")
			or name:find("^attriboost_") then
			copies[#copies + 1] = index .. "=" .. texture
		end
	end
	say(string.format(L.TABMACROS_DEBUG_COUNT, total, #copies))
	for i = 1, math.min(#copies, 6) do
		say("   " .. copies[i])
	end
	for body, info in pairs(registry) do
		local icon = value(info.icon)
		local found = findIcon(icon) or findIcon(value(info.macroIcon))
		local macro = find(body)
		local _, macroTexture = macro and GetMacroInfo(macro)
		say(string.format(L.TABMACROS_DEBUG_TAB, tostring(value(info.name)), tostring(icon),
			tostring(found), tostring(found and iconTexture(found)), tostring(macro),
			tostring(macroTexture)))
	end
end
