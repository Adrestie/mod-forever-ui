-- Window tabs on the action bars. 3.3.5 bars hold spells, items, macros, equipment sets and
-- companions only: a dragged tab becomes an account macro whose body opens its window, made once
-- and found again by its body. On a bar the macro shows the tab's icon, not the macro's. Making a
-- macro needs a free slot and is refused in combat; picking up an existing one is not.
-- The character sheet's side tabs use it (CharacterFrame.lua), and so can other addons and the
-- server modules' AIO windows when ForeverUI is there:
--   ForeverUI.TabMacros.Register(body, info): the macro with this body is a tab. info:
--     name      macro name, cut to 16 bytes (a value, or a function returning it)
--     icon      texture shown on the bars (same)
--     macroIcon an Interface\Icons file name, for the cursor and the macro window when the
--               client's macro icon list lacks icon; the question mark when it lacks both (same)
-- The macro icon list is SpellIcon.dbc, and a macro keeps only its icon's FILE NAME, read again
-- from Interface\Icons (elsewhere: the question mark). A tab's icon is there when its addon or
-- module installs a copy in Interface\Icons, named <Module>_<file name>, with a SpellIcon row
-- (installer.json; ForeverUI's tranche 94 for the character sheet's tabs). The copy is found
-- from the tab's icon: same file name, or ending in _<file name>.
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

-- Index of an icon in the client's macro list, nil when absent. wanted: a full path (found in
-- Interface\Icons by its file name, or a <Module>_ copy of it), or a bare file name
local function findIcon(wanted)
	if type(wanted) ~= "string" or wanted == "" or not GetNumMacroIcons or not GetMacroIconInfo then
		return nil
	end
	wanted = normalized(wanted)
	local base = fileName(wanted)
	local copy = "_" .. base
	local best, rank
	for index = 1, GetNumMacroIcons() do
		local texture = GetMacroIconInfo(index)
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
		if better and normalized(texture or "") ~= normalized(GetMacroIconInfo(better) or "") then
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
