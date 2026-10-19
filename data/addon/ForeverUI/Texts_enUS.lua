-- ForeverUI: English texts, the base table (see Texts.lua). Every key exists here;
-- other languages only translate the values.

ForeverUI.AddTexts("enUS", {
	-- ActionBar.lua
	ACTIONBAR_EDIT_LABEL = "Action Bar",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Left Gryphon",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Right Gryphon",

	-- Bags.lua
	BAGS_CLEANUP = "Clean Up Bags",
	BAGS_CLEANUP_TOOLTIP = "Combines stacks and puts your items in order.",

	-- BottomBar.lua
	BOTTOMBAR_EDIT_LABEL_BAGS = "Bags",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Menu",

	-- Buffs.lua
	BUFFS_DISHONORED_DESC = "Every faction, your own included, is hostile to you, and any player may attack you.",
	BUFFS_EDIT_LABEL_BUFFS = "Buff Frame",
	BUFFS_EDIT_LABEL_DEBUFFS = "Debuff Frame",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Cast Bar",

	-- CharacterFrame.lua
	CHARACTERFRAME_HIDE_DETAILS = "Hide details",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua is not loaded. A file added to the addon only arrives at the next game start: close and reopen the client. The character sheet stays inactive until then.",
	CHARACTERFRAME_SHOW_DETAILS = "Show details",
	CHARACTERFRAME_TITLES = "Titles",

	-- Chat.lua
	CHAT_NOT_IN_LFG_NOTICE = "|Hchannel:%d|h[%s]|h You must be queued in the Dungeon Finder to use this channel.",

	-- CustomizeUI.lua
	CUSTOMIZEUI_GRID_ORIGIN = "Grid Origin",
	CUSTOMIZEUI_GRID_SPACING = "Grid Spacing",
	CUSTOMIZEUI_MENU_BUTTON = "Customize UI",
	CUSTOMIZEUI_ORIGIN_BOTTOM = "Bottom",
	CUSTOMIZEUI_ORIGIN_BOTTOMLEFT = "Bottom Left",
	CUSTOMIZEUI_ORIGIN_BOTTOMRIGHT = "Bottom Right",
	CUSTOMIZEUI_ORIGIN_CENTER = "Middle",
	CUSTOMIZEUI_ORIGIN_LEFT = "Left",
	CUSTOMIZEUI_ORIGIN_RIGHT = "Right",
	CUSTOMIZEUI_ORIGIN_TOP = "Top",
	CUSTOMIZEUI_ORIGIN_TOPLEFT = "Top Left",
	CUSTOMIZEUI_ORIGIN_TOPRIGHT = "Top Right",
	CUSTOMIZEUI_PERCENT = "%",
	CUSTOMIZEUI_RESET_CONFIRM = "Put every element back to the default layout?",
	CUSTOMIZEUI_SIZE = "Size",
	CUSTOMIZEUI_SNAP = "Snap on Grid",
	CUSTOMIZEUI_STICKY = "Sticky UI",
	CUSTOMIZEUI_TITLE = "Customize UI",
	CUSTOMIZEUI_VALIDATE = "Validate",

	-- EquipmentManager.lua
	EQUIPMENTMANAGER_NEW_SET = "New Set",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Click to view in the list",
	ICONPICKER_CURRENTLY_SELECTED = "Currently Selected",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "edit mode is not available in combat.",
	LAYOUT_HELP = "commands: /fui (edit mode), /fui reset [element], /fui list",
	LAYOUT_LIST_HEADER = "registered elements:",
	LAYOUT_LIST_MOVED = " - moved",
	LAYOUT_RESET_ALL = "all positions reset to default.",
	LAYOUT_RESET_ONE = "position reset to default: ",
	LAYOUT_UNKNOWN_ELEMENT = "unknown element: ",

	-- Minimap.lua
	MINIMAP_DEBUG_NO_ATLASUTIL = "minimap: AtlasUtil.lua is missing, nothing is skinned.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "minimap: the client has no MinimapCluster, Minimap or MinimapBackdrop.",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "All Objectives",
	OBJECTIVETRACKER_EDIT_LABEL = "Objective Tracker",
	OBJECTIVETRACKER_OPEN_MAP = "Open Quest Map",
	OBJECTIVETRACKER_READY = "Ready for turn-in",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Share in Chat",
	OBJECTIVETRACKER_UNTRACK = "Untrack",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: unknown host -- ",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Party Frames",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Pet Bar",

	-- PetTab.lua
	PETTAB_RESISTANCES = "Resistances",

	-- PlayerFrame.lua
	PLAYERFRAME_EDIT_LABEL = "Player Frame",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Visit a trainer to learn cooking. Cooking lets you learn recipes to create food that heals you out of combat and grants you temporary buffs.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Visit a trainer to learn first aid.  First aid lets you turn cloth into bandages for healing yourself and others.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "First Profession",
	PROFESSIONSBOOK_FISHING_MISSING = "Visit a trainer to learn fishing.  Fishing lets you catch fish and other strange things from water.  Fish can be cooked into delicious meals with the Cooking skill.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Visit a profession trainer in a major city to learn a new profession. You may have two professions. You may have any combination of gathering and production professions.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Second Profession",

	-- Bank.lua
	BANK_TITLE = "Bank",
	BANK_COLON = "%s:",

	-- Mail.lua
	MAIL_OPEN_ALL = "Open All",
	MAIL_OPEN_ALL_OPENING = "Opening...",

	-- PvPTab.lua
	PVPTAB_CIVILIAN = "Civilian",
	PVPTAB_DISHONORED_LEFT = "Dishonored: %s left",
	PVPTAB_TOOLTIP_CIVILIAN = "Civilian",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Click to view Quest Details>",
	QUESTLOG_COUNT = "Quests: %s%d|r|cffffffff/%d|r",
	QUESTLOG_EMPTY = "No quests available|n|nAccept quests by talking to characters with a |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t above their head.",
	QUESTLOG_NO_RESULTS = "No results found",
	QUESTLOG_READY = "Ready for turn-in",
	QUESTLOG_SEARCH = "Search Quest Log",
	QUESTLOG_SHARE_IN_CHAT = "Share in Chat",
	QUESTLOG_SHOW_OBJECTIVES = "Show Quest Objectives",
	QUESTLOG_TITLE_FAILED = "%s - (Failed)",
	QUESTLOG_TRACK_ALL = "Track All",
	QUESTLOG_UNTRACK = "Untrack",
	QUESTLOG_UNTRACK_ALL = "Untrack All",
	QUESTLOG_UNTRACK_QUEST = "Untrack Quest",

	-- RaidFrame.lua
	RAIDFRAME_EDIT_LABEL = "Raid Frames",

	-- SpellBook.lua
	SPELLBOOK_FLYOUT_ASPECT = "Aspect",
	SPELLBOOK_FLYOUT_ASPECT_DESC = "Take on aspects of nature.",
	SPELLBOOK_FLYOUT_AURAS_DESC = "Activate a protective aura for your group.",
	SPELLBOOK_FLYOUT_BLESSINGS = "Blessings",
	SPELLBOOK_FLYOUT_BLESSINGS_DESC = "Places a Blessing on friendly targets.",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS = "Greater Blessings",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS_DESC = "Blessings that target all members of your group that share the same class.",
	SPELLBOOK_FLYOUT_IMP_SPELLS = "Imp Spells",
	SPELLBOOK_FLYOUT_IMP_SPELLS_DESC = "[PH] Commands the Imp to cast spells",
	SPELLBOOK_FLYOUT_JUDGEMENTS = "Judgements",
	SPELLBOOK_FLYOUT_PET_UTILITIES = "Pet Utilities",
	SPELLBOOK_FLYOUT_PET_UTILITIES_DESC = "Manage your pets.",
	SPELLBOOK_FLYOUT_PORTAL = "Portal",
	SPELLBOOK_FLYOUT_PORTAL_DESC = "Creates a portal, teleporting group members who use it to a major city.",
	SPELLBOOK_FLYOUT_SEALS = "Seals",
	SPELLBOOK_FLYOUT_SHAPESHIFT = "Shapeshift",
	SPELLBOOK_FLYOUT_SHAPESHIFT_DESC = "Shapeshift into a different form.",
	SPELLBOOK_FLYOUT_STANCES = "Stances",
	SPELLBOOK_FLYOUT_STANCES_DESC = "Activate a combat stance.",
	SPELLBOOK_FLYOUT_SUMMON_DEMON = "Summon Demon",
	SPELLBOOK_FLYOUT_SUMMON_DEMON_DESC = "Summons a Demon under the command of the Warlock",
	SPELLBOOK_FLYOUT_TELEPORT = "Teleport",
	SPELLBOOK_FLYOUT_TELEPORT_DESC = "Teleports you to a major city.",
	SPELLBOOK_FLYOUT_TRACKING = "Tracking",
	SPELLBOOK_FLYOUT_TRACKING_DESC = "Track your quarry.",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS = "Utility Blessings",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS_DESC = "Short duration Blessings used to save a single target.",
	SPELLBOOK_HIDE_PASSIVES = "Hide Passives",
	SPELLBOOK_HIDE_PASSIVES_DISABLED = "Hiding Passives is disabled while searching",
	SPELLBOOK_PAGE = "Page %d/%d",
	SPELLBOOK_USE_FLYOUTS = "Group Similar Spells on Flyouts",

	-- SpellBookSearch.lua
	SPELLBOOKSEARCH_HEADER_DESCRIPTION = "Description Matches",
	SPELLBOOKSEARCH_HEADER_EXACT = "Exact Matches",
	SPELLBOOKSEARCH_HEADER_GENERIC = "Matches",
	SPELLBOOKSEARCH_HEADER_NAME = "Name Matches",
	SPELLBOOKSEARCH_HEADER_RELATED = "Related Matches",
	SPELLBOOKSEARCH_INSTRUCTIONS = "Search abilities, keywords",
	SPELLBOOKSEARCH_NOT_ON_ACTIONBAR = "Missing from action bar",
	SPELLBOOKSEARCH_PREVIEW_OVERFLOW = "And %s more",

	-- Stable.lua (the pet's specialization, as the client names it)
	STABLE_TALENT_CUNNING = "Cunning",
	STABLE_TALENT_FEROCITY = "Ferocity",
	STABLE_TALENT_TENACITY = "Tenacity",

	-- StanceBar.lua
	STANCEBAR_EDIT_LABEL = "Stance Bar",

	-- StatusBars.lua
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Experience Bar",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Reputation Bar",

	-- TabMacros.lua
	TABMACROS_FULL = "No free macro slot: delete a macro to put this tab on a bar.",

	-- Talents.lua
	TALENTS_APPLY_CHANGES = "Apply Changes",
	TALENTS_CONFIRM_CLOSE = "You will lose any pending changes if you continue.",
	TALENTS_GATE_TOOLTIP = "Spend %d more points to unlock this row",
	TALENTS_INSPECT_TITLE = "%s's Talents",
	TALENTS_SPEC_ACTIVE = "Active",
	TALENTS_SPEC_PRIMARY = "Primary",
	TALENTS_SPEC_SECONDARY = "Secondary",
	TALENTS_UNDO_PENDING_CHANGES = "Undo Pending Changes",
	TALENTS_UNSPENT_POINTS = "Unspent Talents",

	-- TalentsSearch.lua
	TALENTSSEARCH_HIDE_PASSIVES = "Hide Passives",
	TALENTSSEARCH_NOT_ON_ACTIONBAR = "Missing from action bar",
	TALENTSSEARCH_PREVIEW_OVERFLOW = "And %s more",
	TALENTSSEARCH_SHOW_RANKS = "Show Ranks",
	TALENTSSEARCH_TOOLTIP_EXACT_MATCH = "Exact search match",
	TALENTSSEARCH_TOOLTIP_MATCH = "Search match",
	TALENTSSEARCH_TOOLTIP_NOT_ON_ACTIONBAR = "Not on action bar",
	TALENTSSEARCH_TOOLTIP_ON_DISABLED_ACTIONBAR = "On a disabled action bar",
	TALENTSSEARCH_TOOLTIP_ON_INACTIVE_BONUSBAR = "On an action bar belonging to a different stance",
	TALENTSSEARCH_TOOLTIP_RELATED_MATCH = "Related to the talent you searched for",

	-- TargetFrame.lua
	TARGETFRAME_EDIT_LABEL = "Target Frame",

	-- Taxi.lua
	TAXI_TITLE = "Flight Map",

	-- TotemBar.lua
	TOTEMBAR_EDIT_LABEL = "Totem Bar",

	-- TotemFrame.lua
	TOTEMFRAME_EDIT_LABEL = "Totems",

	-- TradeSkill.lua
	TRADESKILL_CHECK_ALL = "Check All",
	TRADESKILL_CREATE_ALL_FORMAT = "%s [%d]",
	TRADESKILL_FILTER_SKILL_UP = "Has skill up",
	TRADESKILL_FILTER_SLOTS = "Slots",
	TRADESKILL_NAME_RANK = "%s %d/%d",
	TRADESKILL_NAME_RANK_MODIFIER = "%s %d (|cff20ff20+%d|r ) /%d",
	TRADESKILL_NO_RESULTS = "There are no results with your current filters.",
	TRADESKILL_REAGENT_COUNT = "%s/%d",
	TRADESKILL_SKILL_UP_EASY = "Low chance of gaining skill",
	TRADESKILL_SKILL_UP_MEDIUM = "High chance of gaining skill",
	TRADESKILL_SKILL_UP_OPTIMAL = "Guaranteed chance of gaining %d skill ups",
	TRADESKILL_UNCHECK_ALL = "Uncheck All",

	-- Trainer.lua
	TRAINER_RANK = "%d/%d",
	TRAINER_RANK_BONUS = "%d |cff20ff20(+%d)|r/%d",

	-- Vehicle.lua
	VEHICLE_EDIT_LABEL = "Vehicle Seats",

	-- WorldMap.lua
	WORLDMAP_CURSOR_COORDS = "Cursor: %d, %d",
	WORLDMAP_DEBUG_NO_ATLAS = "world map: AtlasUtil.lua is missing, nothing is skinned.",
	WORLDMAP_DEBUG_NO_FRAME = "world map: the client has no WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "world map: \"World\" refused by the client (map %s, continent %s, zone %s, floor %s, zoom out %s)",
	WORLDMAP_FILTER_SHOW = "Show:",
	WORLDMAP_PLAYER_COORDS = "Player: %d, %d",
	WORLDMAP_TITLE = "Map & Quest Log",
	WORLDMAP_WORLD = "World",
})
