-- ForeverUI: French texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("frFR", {
	-- ActionBar.lua
	ACTIONBAR_EDIT_LABEL = "Barre d'action",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Griffon gauche",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Griffon droit",

	-- Bags.lua
	BAGS_CLEANUP = "Ranger les sacs",
	BAGS_CLEANUP_TOOLTIP = "Réunit les piles et remet les objets en ordre.",

	-- BottomBar.lua
	BOTTOMBAR_EDIT_LABEL_BAGS = "Barre des sacs",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Micro-menu",

	-- Buffs.lua
	BUFFS_DISHONORED_DESC = "Toutes les factions, y compris la vôtre, vous sont hostiles, et tout joueur peut vous attaquer.",
	BUFFS_EDIT_LABEL_BUFFS = "Améliorations",
	BUFFS_EDIT_LABEL_DEBUFFS = "Affaiblissements",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Barre d'incantation",

	-- CharacterFrame.lua
	CHARACTERFRAME_HIDE_DETAILS = "Masquer les détails",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua n'est pas chargé. Un fichier ajouté à l'addon n'arrive qu'au prochain démarrage du jeu : fermez et rouvrez le client. La feuille de personnage reste inactive d'ici là.",
	CHARACTERFRAME_SHOW_DETAILS = "Afficher les détails",
	CHARACTERFRAME_TITLES = "Titres",

	-- CustomizeUI.lua
	CUSTOMIZEUI_GRID_ORIGIN = "Origine de la grille",
	CUSTOMIZEUI_GRID_SPACING = "Espacement de la grille",
	CUSTOMIZEUI_MENU_BUTTON = "Personnaliser l'interface",
	CUSTOMIZEUI_ORIGIN_BOTTOM = "Bas",
	CUSTOMIZEUI_ORIGIN_BOTTOMLEFT = "Bas gauche",
	CUSTOMIZEUI_ORIGIN_BOTTOMRIGHT = "Bas droite",
	CUSTOMIZEUI_ORIGIN_CENTER = "Milieu",
	CUSTOMIZEUI_ORIGIN_LEFT = "Gauche",
	CUSTOMIZEUI_ORIGIN_RIGHT = "Droite",
	CUSTOMIZEUI_ORIGIN_TOP = "Haut",
	CUSTOMIZEUI_ORIGIN_TOPLEFT = "Haut gauche",
	CUSTOMIZEUI_ORIGIN_TOPRIGHT = "Haut droite",
	CUSTOMIZEUI_PERCENT = "%",
	CUSTOMIZEUI_RESET_CONFIRM = "Remettre tous les éléments à la disposition par défaut ?",
	CUSTOMIZEUI_SIZE = "Taille",
	CUSTOMIZEUI_SNAP = "Aimanter à la grille",
	CUSTOMIZEUI_STICKY = "Coller aux éléments",
	CUSTOMIZEUI_TITLE = "Personnaliser l'interface",
	CUSTOMIZEUI_VALIDATE = "Valider",

	-- EquipmentManager.lua
	EQUIPMENTMANAGER_NEW_SET = "Nouvel ensemble",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Cliquez pour afficher dans la liste",
	ICONPICKER_CURRENTLY_SELECTED = "Sélection actuelle",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "le mode édition n'est pas disponible en combat.",
	LAYOUT_HELP = "commandes : /fui (mode édition), /fui reset [élément], /fui list",
	LAYOUT_LIST_HEADER = "éléments enregistrés :",
	LAYOUT_LIST_MOVED = " - déplacé",
	LAYOUT_RESET_ALL = "toutes les positions sont remises par défaut.",
	LAYOUT_RESET_ONE = "position remise par défaut : ",
	LAYOUT_UNKNOWN_ELEMENT = "élément inconnu : ",

	-- Minimap.lua
	MINIMAP_DEBUG_NO_ATLASUTIL = "minimap : AtlasUtil.lua manque, rien n'est habillé.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "minimap : le client n'a pas MinimapCluster, Minimap ou MinimapBackdrop.",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Tous les objectifs",
	OBJECTIVETRACKER_EDIT_LABEL = "Suivi des objectifs",
	OBJECTIVETRACKER_OPEN_MAP = "Ouvrir la carte de quête",
	OBJECTIVETRACKER_READY = "Prête à être rendue",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Partager dans la discussion",
	OBJECTIVETRACKER_UNTRACK = "Ne plus suivre",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes : hôte inconnu -- ",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Cadres de groupe",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Barre du familier",

	-- PetTab.lua
	PETTAB_RESISTANCES = "Résistances",

	-- PlayerFrame.lua
	PLAYERFRAME_EDIT_LABEL = "Cadre du joueur",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Rendez-vous auprès d'un maître pour apprendre la cuisine. La cuisine vous permet d'apprendre des recettes de plats qui vous soignent hors combat et vous confèrent des bonus temporaires.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Rendez-vous auprès d'un maître pour apprendre le secourisme. Le secourisme vous permet de transformer du tissu en bandages pour vous soigner et soigner les autres.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Premier métier",
	PROFESSIONSBOOK_FISHING_MISSING = "Rendez-vous auprès d'un maître pour apprendre la pêche. La pêche vous permet d'attraper des poissons et d'autres choses étranges dans l'eau. Le poisson peut être cuisiné en délicieux plats grâce à la cuisine.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Rendez-vous auprès d'un maître de métier dans une grande ville pour apprendre un nouveau métier. Vous pouvez avoir deux métiers, en combinant à votre guise métiers de récolte et d'artisanat.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Second métier",

	-- Bank.lua
	BANK_TITLE = "Banque",
	BANK_COLON = "%s :",

	-- Mail.lua
	MAIL_OPEN_ALL = "Tout ouvrir",
	MAIL_OPEN_ALL_OPENING = "Ouverture...",

	-- PvPTab.lua
	PVPTAB_CIVILIAN = "Civil",
	PVPTAB_DISHONORED_LEFT = "Déshonoré : encore %s",
	PVPTAB_TOOLTIP_CIVILIAN = "Civil",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Cliquez pour voir les détails de la quête>",
	QUESTLOG_COUNT = "Quêtes : %s%d|r|cffffffff/%d|r",
	QUESTLOG_EMPTY = "Aucune quête disponible|n|nAcceptez des quêtes en parlant aux personnages qui ont un |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t au-dessus de la tête.",
	QUESTLOG_NO_RESULTS = "Aucun résultat",
	QUESTLOG_READY = "Prête à être rendue",
	QUESTLOG_SEARCH = "Rechercher dans le journal de quêtes",
	QUESTLOG_SHARE_IN_CHAT = "Partager dans la discussion",
	QUESTLOG_SHOW_OBJECTIVES = "Afficher les objectifs de quête",
	QUESTLOG_TITLE_FAILED = "%s - (échec)",
	QUESTLOG_TRACK_ALL = "Tout suivre",
	QUESTLOG_UNTRACK = "Ne plus suivre",
	QUESTLOG_UNTRACK_ALL = "Ne plus rien suivre",
	QUESTLOG_UNTRACK_QUEST = "Ne plus suivre la quête",

	-- RaidFrame.lua
	RAIDFRAME_EDIT_LABEL = "Cadres de raid",

	-- SpellBook.lua
	SPELLBOOK_FLYOUT_ASPECT = "Aspect",
	SPELLBOOK_FLYOUT_ASPECT_DESC = "Adoptez les aspects de la nature.",
	SPELLBOOK_FLYOUT_AURAS_DESC = "Active une aura protectrice pour votre groupe.",
	SPELLBOOK_FLYOUT_BLESSINGS = "Bénédictions",
	SPELLBOOK_FLYOUT_BLESSINGS_DESC = "Place une bénédiction sur des cibles amicales.",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS = "Bénédictions supérieures",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS_DESC = "Bénédictions qui ciblent tous les membres de votre groupe appartenant à la même classe.",
	SPELLBOOK_FLYOUT_IMP_SPELLS = "Sorts du diablotin",
	SPELLBOOK_FLYOUT_IMP_SPELLS_DESC = "[PH] Ordonne au diablotin de lancer des sorts",
	SPELLBOOK_FLYOUT_JUDGEMENTS = "Jugements",
	SPELLBOOK_FLYOUT_PET_UTILITIES = "Utilitaires du familier",
	SPELLBOOK_FLYOUT_PET_UTILITIES_DESC = "Gérez vos familiers.",
	SPELLBOOK_FLYOUT_PORTAL = "Portail",
	SPELLBOOK_FLYOUT_PORTAL_DESC = "Crée un portail qui téléporte les membres du groupe qui l'utilisent dans une grande ville.",
	SPELLBOOK_FLYOUT_SEALS = "Sceaux",
	SPELLBOOK_FLYOUT_SHAPESHIFT = "Changeforme",
	SPELLBOOK_FLYOUT_SHAPESHIFT_DESC = "Prenez une autre forme.",
	SPELLBOOK_FLYOUT_STANCES = "Postures",
	SPELLBOOK_FLYOUT_STANCES_DESC = "Adoptez une posture de combat.",
	SPELLBOOK_FLYOUT_SUMMON_DEMON = "Invocation de démon",
	SPELLBOOK_FLYOUT_SUMMON_DEMON_DESC = "Invoque un démon aux ordres du démoniste",
	SPELLBOOK_FLYOUT_TELEPORT = "Téléportation",
	SPELLBOOK_FLYOUT_TELEPORT_DESC = "Vous téléporte dans une grande ville.",
	SPELLBOOK_FLYOUT_TRACKING = "Pistage",
	SPELLBOOK_FLYOUT_TRACKING_DESC = "Pistez votre proie.",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS = "Bénédictions utilitaires",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS_DESC = "Bénédictions de courte durée servant à sauver une seule cible.",
	SPELLBOOK_HIDE_PASSIVES = "Masquer les passifs",
	SPELLBOOK_HIDE_PASSIVES_DISABLED = "Le masquage des passifs est désactivé pendant une recherche",
	SPELLBOOK_PAGE = "Page %d/%d",
	SPELLBOOK_USE_FLYOUTS = "Regrouper les sorts similaires dans des menus volants",

	-- SpellBookSearch.lua
	SPELLBOOKSEARCH_HEADER_DESCRIPTION = "Correspondances de description",
	SPELLBOOKSEARCH_HEADER_EXACT = "Correspondances exactes",
	SPELLBOOKSEARCH_HEADER_GENERIC = "Correspondances",
	SPELLBOOKSEARCH_HEADER_NAME = "Correspondances de nom",
	SPELLBOOKSEARCH_HEADER_RELATED = "Correspondances associées",
	SPELLBOOKSEARCH_INSTRUCTIONS = "Rechercher des techniques, mots-clés",
	SPELLBOOKSEARCH_NOT_ON_ACTIONBAR = "Absent des barres d'action",
	SPELLBOOKSEARCH_PREVIEW_OVERFLOW = "Et %s de plus",

	-- Stable.lua (the pet's specialization, as the client names it)
	STABLE_TALENT_CUNNING = "Ruse",
	STABLE_TALENT_FEROCITY = "Férocité",
	STABLE_TALENT_TENACITY = "Ténacité",

	-- StanceBar.lua
	STANCEBAR_EDIT_LABEL = "Barre des postures",

	-- StatusBars.lua
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Barre d'expérience",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Barre de réputation",

	-- TabMacros.lua
	TABMACROS_FULL = "Plus de place pour une macro : supprimez-en une pour poser cet onglet sur une barre.",

	-- Talents.lua
	TALENTS_APPLY_CHANGES = "Appliquer les modifications",
	TALENTS_CONFIRM_CLOSE = "Vous perdrez toutes les modifications en attente si vous continuez.",
	TALENTS_GATE_TOOLTIP = "Dépensez encore %d points pour débloquer cette rangée",
	TALENTS_INSPECT_TITLE = "Talents de %s",
	TALENTS_SPEC_ACTIVE = "Active",
	TALENTS_SPEC_PRIMARY = "Principale",
	TALENTS_SPEC_SECONDARY = "Secondaire",
	TALENTS_UNDO_PENDING_CHANGES = "Annuler les modifications en attente",
	TALENTS_UNSPENT_POINTS = "Talents non dépensés",

	-- TalentsSearch.lua
	TALENTSSEARCH_HIDE_PASSIVES = "Masquer les passifs",
	TALENTSSEARCH_NOT_ON_ACTIONBAR = "Absent des barres d'action",
	TALENTSSEARCH_PREVIEW_OVERFLOW = "Et %s de plus",
	TALENTSSEARCH_SHOW_RANKS = "Afficher les rangs",
	TALENTSSEARCH_TOOLTIP_EXACT_MATCH = "Correspond exactement à la recherche",
	TALENTSSEARCH_TOOLTIP_MATCH = "Correspond à la recherche",
	TALENTSSEARCH_TOOLTIP_NOT_ON_ACTIONBAR = "Absent des barres d'action",
	TALENTSSEARCH_TOOLTIP_ON_DISABLED_ACTIONBAR = "Sur une barre d'action désactivée",
	TALENTSSEARCH_TOOLTIP_ON_INACTIVE_BONUSBAR = "Sur une barre d'action d'une autre posture",
	TALENTSSEARCH_TOOLTIP_RELATED_MATCH = "Lié au talent recherché",

	-- TargetFrame.lua
	TARGETFRAME_EDIT_LABEL = "Cadre de la cible",

	-- Taxi.lua
	TAXI_TITLE = "Carte de vol",

	-- TotemBar.lua
	TOTEMBAR_EDIT_LABEL = "Barre des totems",

	-- TotemFrame.lua
	TOTEMFRAME_EDIT_LABEL = "Totems",

	-- TradeSkill.lua
	TRADESKILL_CHECK_ALL = "Tout cocher",
	TRADESKILL_CREATE_ALL_FORMAT = "%s [%d]",
	TRADESKILL_FILTER_SKILL_UP = "Progression possible",
	TRADESKILL_FILTER_SLOTS = "Emplacements",
	TRADESKILL_NAME_RANK = "%s %d/%d",
	TRADESKILL_NAME_RANK_MODIFIER = "%s %d (|cff20ff20+%d|r ) /%d",
	TRADESKILL_NO_RESULTS = "Aucun résultat avec les filtres actuels.",
	TRADESKILL_REAGENT_COUNT = "%s/%d",
	TRADESKILL_SKILL_UP_EASY = "Faible chance de progresser",
	TRADESKILL_SKILL_UP_MEDIUM = "Forte chance de progresser",
	TRADESKILL_SKILL_UP_OPTIMAL = "Gain assuré de %d point(s) de compétence",
	TRADESKILL_UNCHECK_ALL = "Tout décocher",

	-- Trainer.lua
	TRAINER_RANK = "%d/%d",
	TRAINER_RANK_BONUS = "%d |cff20ff20(+%d)|r/%d",

	-- Vehicle.lua
	VEHICLE_EDIT_LABEL = "Sièges du véhicule",

	-- WorldMap.lua
	WORLDMAP_CURSOR_COORDS = "Curseur : %d, %d",
	WORLDMAP_DEBUG_NO_ATLAS = "carte du monde : AtlasUtil.lua manque, rien n'est habillé.",
	WORLDMAP_DEBUG_NO_FRAME = "carte du monde : le client n'a pas WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "carte du monde : « Monde » refusé par le client (carte %s, continent %s, zone %s, étage %s, zoom arrière %s)",
	WORLDMAP_FILTER_SHOW = "Afficher :",
	WORLDMAP_PLAYER_COORDS = "Joueur : %d, %d",
	WORLDMAP_TITLE = "Carte et journal de quêtes",
	WORLDMAP_WORLD = "Monde",
})
