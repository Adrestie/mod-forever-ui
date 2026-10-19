-- ForeverUI: Spanish (Spain) texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("esES", {
	-- ActionBar.lua
	ACTIONBAR_EDIT_LABEL = "Barra de acción",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Grifo izquierdo",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Grifo derecho",

	-- Bags.lua
	BAGS_CLEANUP = "Ordenar bolsas",
	BAGS_CLEANUP_TOOLTIP = "Combina los montones y ordena tus objetos.",

	-- BottomBar.lua
	BOTTOMBAR_EDIT_LABEL_BAGS = "Bolsas",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Menú",

	-- Buffs.lua
	BUFFS_DISHONORED_DESC = "Todas las facciones, incluida la tuya, te son hostiles y cualquier jugador puede atacarte.",
	BUFFS_EDIT_LABEL_BUFFS = "Marco de beneficios",
	BUFFS_EDIT_LABEL_DEBUFFS = "Marco de perjuicios",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Barra de lanzamiento",

	-- CharacterFrame.lua
	CHARACTERFRAME_HIDE_DETAILS = "Ocultar detalles",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua no está cargado. Un archivo añadido al accesorio solo llega en el siguiente inicio del juego: cierra y vuelve a abrir el cliente. La ficha de personaje permanece inactiva hasta entonces.",
	CHARACTERFRAME_SHOW_DETAILS = "Mostrar detalles",
	CHARACTERFRAME_TITLES = "Títulos",

	-- Chat.lua
	CHAT_NOT_IN_LFG_NOTICE = "|Hchannel:%d|h[%s]|h Debes estar en la cola del buscador de mazmorras para usar este canal.",

	-- CustomizeUI.lua
	CUSTOMIZEUI_GRID_ORIGIN = "Origen de la cuadrícula",
	CUSTOMIZEUI_GRID_SPACING = "Espaciado de la cuadrícula",
	CUSTOMIZEUI_MENU_BUTTON = "Personalizar interfaz",
	CUSTOMIZEUI_ORIGIN_BOTTOM = "Abajo",
	CUSTOMIZEUI_ORIGIN_BOTTOMLEFT = "Abajo a la izquierda",
	CUSTOMIZEUI_ORIGIN_BOTTOMRIGHT = "Abajo a la derecha",
	CUSTOMIZEUI_ORIGIN_CENTER = "Centro",
	CUSTOMIZEUI_ORIGIN_LEFT = "Izquierda",
	CUSTOMIZEUI_ORIGIN_RIGHT = "Derecha",
	CUSTOMIZEUI_ORIGIN_TOP = "Arriba",
	CUSTOMIZEUI_ORIGIN_TOPLEFT = "Arriba a la izquierda",
	CUSTOMIZEUI_ORIGIN_TOPRIGHT = "Arriba a la derecha",
	CUSTOMIZEUI_PERCENT = "%",
	CUSTOMIZEUI_RESET_CONFIRM = "¿Devolver todos los elementos a la disposición predeterminada?",
	CUSTOMIZEUI_SIZE = "Tamaño",
	CUSTOMIZEUI_SNAP = "Ajustar a la cuadrícula",
	CUSTOMIZEUI_STICKY = "Interfaz magnética",
	CUSTOMIZEUI_TITLE = "Personalizar interfaz",
	CUSTOMIZEUI_VALIDATE = "Validar",

	-- EquipmentManager.lua
	EQUIPMENTMANAGER_NEW_SET = "Nuevo equipamiento",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Haz clic para verlo en la lista",
	ICONPICKER_CURRENTLY_SELECTED = "Seleccionado actualmente",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "el modo de edición no está disponible en combate.",
	LAYOUT_HELP = "comandos: /fui (modo edición), /fui reset [elemento], /fui list",
	LAYOUT_LIST_HEADER = "elementos registrados:",
	LAYOUT_LIST_MOVED = " - movido",
	LAYOUT_RESET_ALL = "todas las posiciones restablecidas a las predeterminadas.",
	LAYOUT_RESET_ONE = "posición restablecida a la predeterminada: ",
	LAYOUT_UNKNOWN_ELEMENT = "elemento desconocido: ",

	-- Minimap.lua
	MINIMAP_DEBUG_NO_ATLASUTIL = "minimapa: falta AtlasUtil.lua, no se aplica ningún aspecto.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "minimapa: el cliente no tiene MinimapCluster, Minimap ni MinimapBackdrop.",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Todos los objetivos",
	OBJECTIVETRACKER_EDIT_LABEL = "Seguimiento de objetivos",
	OBJECTIVETRACKER_OPEN_MAP = "Abrir mapa de misiones",
	OBJECTIVETRACKER_READY = "Lista para entregar",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Compartir en el chat",
	OBJECTIVETRACKER_UNTRACK = "Dejar de seguir",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: anfitrión desconocido -- ",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Marcos de grupo",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Barra de mascota",

	-- PetTab.lua
	PETTAB_RESISTANCES = "Resistencias",

	-- PlayerFrame.lua
	PLAYERFRAME_EDIT_LABEL = "Marco del jugador",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Visita a un instructor para aprender cocina. La cocina te permite aprender recetas para preparar comida que te cura fuera de combate y te otorga beneficios temporales.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Visita a un instructor para aprender primeros auxilios.  Los primeros auxilios te permiten convertir tela en vendas para curarte a ti y a los demás.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Primera profesión",
	PROFESSIONSBOOK_FISHING_MISSING = "Visita a un instructor para aprender pesca.  La pesca te permite sacar del agua peces y otras cosas extrañas.  Con la habilidad de cocina, los peces se pueden convertir en deliciosos platos.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Visita a un instructor de profesiones en una ciudad importante para aprender una nueva profesión. Puedes tener dos profesiones, en cualquier combinación de profesiones de recolección y de producción.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Segunda profesión",

	-- Bank.lua
	BANK_TITLE = "Banco",
	BANK_COLON = "%s:",

	-- Mail.lua
	MAIL_OPEN_ALL = "Abrir todo",
	MAIL_OPEN_ALL_OPENING = "Abriendo...",

	-- PvPTab.lua
	PVPTAB_CIVILIAN = "Civil",
	PVPTAB_DISHONORED_LEFT = "Deshonroso: quedan %s",
	PVPTAB_TOOLTIP_CIVILIAN = "Civil",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Haz clic para ver los detalles de la misión>",
	QUESTLOG_COUNT = "Misiones: %s%d|r|cffffffff/%d|r",
	QUESTLOG_EMPTY = "No hay misiones disponibles|n|nAcepta misiones hablando con los personajes que tienen un |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t sobre la cabeza.",
	QUESTLOG_NO_RESULTS = "No se han encontrado resultados",
	QUESTLOG_READY = "Lista para entregar",
	QUESTLOG_SEARCH = "Buscar en el registro de misiones",
	QUESTLOG_SHARE_IN_CHAT = "Compartir en el chat",
	QUESTLOG_SHOW_OBJECTIVES = "Mostrar objetivos de misión",
	QUESTLOG_TITLE_FAILED = "%s - (Fallida)",
	QUESTLOG_TRACK_ALL = "Seguir todas",
	QUESTLOG_UNTRACK = "Dejar de seguir",
	QUESTLOG_UNTRACK_ALL = "Dejar de seguir todas",
	QUESTLOG_UNTRACK_QUEST = "Dejar de seguir la misión",

	-- RaidFrame.lua
	RAIDFRAME_EDIT_LABEL = "Marcos de banda",

	-- SpellBook.lua
	SPELLBOOK_FLYOUT_ASPECT = "Aspecto",
	SPELLBOOK_FLYOUT_ASPECT_DESC = "Adopta aspectos de la naturaleza.",
	SPELLBOOK_FLYOUT_AURAS_DESC = "Activa un aura protectora para tu grupo.",
	SPELLBOOK_FLYOUT_BLESSINGS = "Bendiciones",
	SPELLBOOK_FLYOUT_BLESSINGS_DESC = "Otorga una bendición a objetivos amistosos.",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS = "Bendiciones superiores",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS_DESC = "Bendiciones que afectan a todos los miembros de tu grupo que son de la misma clase.",
	SPELLBOOK_FLYOUT_IMP_SPELLS = "Hechizos de diablillo",
	SPELLBOOK_FLYOUT_IMP_SPELLS_DESC = "[PH] Ordena al diablillo que lance hechizos",
	SPELLBOOK_FLYOUT_JUDGEMENTS = "Sentencias",
	SPELLBOOK_FLYOUT_PET_UTILITIES = "Utilidades de mascota",
	SPELLBOOK_FLYOUT_PET_UTILITIES_DESC = "Gestiona tus mascotas.",
	SPELLBOOK_FLYOUT_PORTAL = "Portal",
	SPELLBOOK_FLYOUT_PORTAL_DESC = "Crea un portal que teletransporta a una ciudad importante a los miembros del grupo que lo usen.",
	SPELLBOOK_FLYOUT_SEALS = "Sellos",
	SPELLBOOK_FLYOUT_SHAPESHIFT = "Cambio de forma",
	SPELLBOOK_FLYOUT_SHAPESHIFT_DESC = "Cambia a una forma diferente.",
	SPELLBOOK_FLYOUT_STANCES = "Actitudes",
	SPELLBOOK_FLYOUT_STANCES_DESC = "Activa una actitud de combate.",
	SPELLBOOK_FLYOUT_SUMMON_DEMON = "Invocar demonio",
	SPELLBOOK_FLYOUT_SUMMON_DEMON_DESC = "Invoca a un demonio bajo el mando del brujo",
	SPELLBOOK_FLYOUT_TELEPORT = "Teletransporte",
	SPELLBOOK_FLYOUT_TELEPORT_DESC = "Te teletransporta a una ciudad importante.",
	SPELLBOOK_FLYOUT_TRACKING = "Rastreo",
	SPELLBOOK_FLYOUT_TRACKING_DESC = "Rastrea a tu presa.",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS = "Bendiciones de utilidad",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS_DESC = "Bendiciones de corta duración que sirven para salvar a un solo objetivo.",
	SPELLBOOK_HIDE_PASSIVES = "Ocultar pasivas",
	SPELLBOOK_HIDE_PASSIVES_DISABLED = "No se pueden ocultar las pasivas durante una búsqueda",
	SPELLBOOK_PAGE = "Página %d/%d",
	SPELLBOOK_USE_FLYOUTS = "Agrupar hechizos similares en menús desplegables",

	-- SpellBookSearch.lua
	SPELLBOOKSEARCH_HEADER_DESCRIPTION = "Coincidencias en la descripción",
	SPELLBOOKSEARCH_HEADER_EXACT = "Coincidencias exactas",
	SPELLBOOKSEARCH_HEADER_GENERIC = "Coincidencias",
	SPELLBOOKSEARCH_HEADER_NAME = "Coincidencias en el nombre",
	SPELLBOOKSEARCH_HEADER_RELATED = "Coincidencias relacionadas",
	SPELLBOOKSEARCH_INSTRUCTIONS = "Buscar facultades, palabras clave",
	SPELLBOOKSEARCH_NOT_ON_ACTIONBAR = "Falta en la barra de acción",
	SPELLBOOKSEARCH_PREVIEW_OVERFLOW = "Y %s más",

	-- Stable.lua (the pet's specialization, as the client names it)
	STABLE_TALENT_CUNNING = "Astucia",
	STABLE_TALENT_FEROCITY = "Ferocidad",
	STABLE_TALENT_TENACITY = "Tenacidad",

	-- StanceBar.lua
	STANCEBAR_EDIT_LABEL = "Barra de actitudes",

	-- StatusBars.lua
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Barra de experiencia",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Barra de reputación",

	-- TabMacros.lua
	TABMACROS_FULL = "No queda espacio para macros: borra una para poner esta pestaña en una barra.",

	-- Talents.lua
	TALENTS_APPLY_CHANGES = "Aplicar cambios",
	TALENTS_CONFIRM_CLOSE = "Si continúas, perderás los cambios pendientes.",
	TALENTS_GATE_TOOLTIP = "Gasta %d puntos más para desbloquear esta fila",
	TALENTS_INSPECT_TITLE = "Talentos de %s",
	TALENTS_SPEC_ACTIVE = "Activo",
	TALENTS_SPEC_PRIMARY = "Principal",
	TALENTS_SPEC_SECONDARY = "Secundario",
	TALENTS_UNDO_PENDING_CHANGES = "Deshacer cambios pendientes",
	TALENTS_UNSPENT_POINTS = "Talentos sin gastar",

	-- TalentsSearch.lua
	TALENTSSEARCH_HIDE_PASSIVES = "Ocultar pasivos",
	TALENTSSEARCH_NOT_ON_ACTIONBAR = "Falta en la barra de acción",
	TALENTSSEARCH_PREVIEW_OVERFLOW = "Y %s más",
	TALENTSSEARCH_SHOW_RANKS = "Mostrar rangos",
	TALENTSSEARCH_TOOLTIP_EXACT_MATCH = "Coincidencia exacta",
	TALENTSSEARCH_TOOLTIP_MATCH = "Coincidencia de búsqueda",
	TALENTSSEARCH_TOOLTIP_NOT_ON_ACTIONBAR = "No está en la barra de acción",
	TALENTSSEARCH_TOOLTIP_ON_DISABLED_ACTIONBAR = "En una barra de acción desactivada",
	TALENTSSEARCH_TOOLTIP_ON_INACTIVE_BONUSBAR = "En una barra de acción de otra actitud",
	TALENTSSEARCH_TOOLTIP_RELATED_MATCH = "Relacionado con el talento que has buscado",

	-- TargetFrame.lua
	TARGETFRAME_EDIT_LABEL = "Marco del objetivo",

	-- Taxi.lua
	TAXI_TITLE = "Mapa de vuelo",

	-- TotemBar.lua
	TOTEMBAR_EDIT_LABEL = "Barra de tótems",

	-- TotemFrame.lua
	TOTEMFRAME_EDIT_LABEL = "Tótems",

	-- TradeSkill.lua
	TRADESKILL_CHECK_ALL = "Marcar todo",
	TRADESKILL_CREATE_ALL_FORMAT = "%s [%d]",
	TRADESKILL_FILTER_SKILL_UP = "Sube la habilidad",
	TRADESKILL_FILTER_SLOTS = "Casillas",
	TRADESKILL_NAME_RANK = "%s %d/%d",
	TRADESKILL_NAME_RANK_MODIFIER = "%s %d (|cff20ff20+%d|r ) /%d",
	TRADESKILL_NO_RESULTS = "No hay resultados con los filtros actuales.",
	TRADESKILL_REAGENT_COUNT = "%s/%d",
	TRADESKILL_SKILL_UP_EASY = "Baja probabilidad de subir la habilidad",
	TRADESKILL_SKILL_UP_MEDIUM = "Alta probabilidad de subir la habilidad",
	TRADESKILL_SKILL_UP_OPTIMAL = "Subida garantizada de %d puntos de habilidad",
	TRADESKILL_UNCHECK_ALL = "Desmarcar todo",

	-- Trainer.lua
	TRAINER_RANK = "%d/%d",
	TRAINER_RANK_BONUS = "%d |cff20ff20(+%d)|r/%d",

	-- Vehicle.lua
	VEHICLE_EDIT_LABEL = "Asientos del vehículo",

	-- WorldMap.lua
	WORLDMAP_CURSOR_COORDS = "Cursor: %d, %d",
	WORLDMAP_DEBUG_NO_ATLAS = "mapa del mundo: falta AtlasUtil.lua, no se aplica ningún aspecto.",
	WORLDMAP_DEBUG_NO_FRAME = "mapa del mundo: el cliente no tiene WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "mapa del mundo: \"Mundo\" rechazado por el cliente (mapa %s, continente %s, zona %s, planta %s, alejar %s)",
	WORLDMAP_FILTER_SHOW = "Mostrar:",
	WORLDMAP_PLAYER_COORDS = "Jugador: %d, %d",
	WORLDMAP_TITLE = "Mapa y registro de misiones",
	WORLDMAP_WORLD = "Mundo",

	-- GuildFrame.lua, GuildChat.lua, GuildInfo.lua
	GUILD_TAB_CHAT = "Chat",
	GUILD_TAB_ROSTER = "Lista de miembros",
	GUILD_CHAT_PROMPT = "Mensaje: %s",
	GUILD_MEMBERS_ONLINE = "%d/%d conectados",
	GUILD_EDIT_TEXT = "Editar",
	GUILD_NO_EVENTS = "No hay eventos de hermandad.",
})
