-- ForeverUI: Spanish (Spain) texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("esES", {
	-- ActionBar.lua
	ACTIONBAR_BUTTON1_MISSING = "No se encuentra ActionButton1",
	ACTIONBAR_DEBUG = "barra: botón %.0fx%.0f | padre %s | anclaje %s en %s (%.0f, %.0f) | visible=%s | marco=%s | alfa normal=%.2f",
	ACTIONBAR_EDIT_LABEL = "Barra de acción",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Grifo izquierdo",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Grifo derecho",

	-- Bags.lua
	BAGS_CLEANUP = "Ordenar bolsas",
	BAGS_CLEANUP_TOOLTIP = "Combina los montones y ordena tus objetos.",
	BAGS_DEBUG_ANCHOR = " [%s en %s de %s, %d, %d]",
	BAGS_DEBUG_ANCHORS = "%d anclaje(s):",
	BAGS_DEBUG_ANCHORS_FORCE = "los anclajes del marco imponen su altura",
	BAGS_DEBUG_FRAME = "%s (bolsa %d): %d casillas, %d filas",
	BAGS_DEBUG_MATCH = "COINCIDE",
	BAGS_DEBUG_MISMATCH = "NO COINCIDE",
	BAGS_DEBUG_NONE = "ninguno",
	BAGS_DEBUG_NO_BAG_OPEN = "ninguna bolsa abierta: abre una y vuelve a escribir /fui bags",
	BAGS_DEBUG_RESIZED_AFTER = "alguien fija el tamaño DESPUÉS de nosotros",
	BAGS_DEBUG_SCREEN = "la pantalla",
	BAGS_DEBUG_SEGMENT = "segmento: el nuestro visible=%s | el del cliente visible=%s",
	BAGS_DEBUG_SIZE = "calculado %d x %d = cuadrícula %d + relleno %d + extra %d | el marco mide %.0f x %.0f  %s",
	BAGS_DEBUG_SKINNED = "marcos con aspecto %d | casilla %.0f | campo visible=%s",
	BAGS_DEBUG_TOKENS = "monedas seguidas %d/%d: %s",
	BAGS_DEBUG_WITNESS = "testigo: fijado %s, releído al instante %s, deshecho %s veces -> %s",
	BAGS_NUMBER_EXPECTED = "valor esperado: un número",
	BAGS_SET = "bolsas: %s = %s",
	BAGS_UNKNOWN_SETTING = "ajuste desconocido: ",

	-- BottomBar.lua
	BOTTOMBAR_DEBUG = "abajo: micro %.0f x %.0f (%d botones) | bolsas %.0f x %.0f | anclaje %s en %s (%.1f, %.1f) | llavero visible=%s",
	BOTTOMBAR_EDIT_LABEL_BAGS = "Bolsas",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Menú",
	BOTTOMBAR_HOVER_PROMPT = "pasa el cursor por el botón del personaje: cinco segundos.",
	BOTTOMBAR_MICRO_BUTTON = "%2d %-24s %s en %s (%s, %s) | %.0f x %.0f | esperado x=%d | visible=%s activo=%s nivel=%d anclajes=%d",
	BOTTOMBAR_MICRO_DEBUG = "micromenú: %d botones, franja %.0f x %.0f, paso %d",
	BOTTOMBAR_NOTHING = "(nada)",
	BOTTOMBAR_UNDER_CURSOR = "bajo el cursor: ",

	-- Buffs.lua
	BUFFS_DEBUG_BUFFS = "beneficios: unidad %s, %d auras, %d ocultables, %d mostradas | plegar %s (desplegado %s) | consolidación %s (%d) | duraciones %s",
	BUFFS_DEBUG_DEBUFFS = "perjuicios: %d (%s)",
	BUFFS_DEBUG_HIDDEN = "oculto",
	BUFFS_DEBUG_VISIBLE = "visible",
	BUFFS_DISHONORED_DESC = "Todas las facciones, incluida la tuya, te son hostiles y cualquier jugador puede atacarte.",
	BUFFS_EDIT_LABEL_BUFFS = "Marco de beneficios",
	BUFFS_EDIT_LABEL_DEBUFFS = "Marco de perjuicios",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Barra de lanzamiento",

	-- CharacterFrame.lua
	CHARACTERFRAME_DEBUG_CLOSE_SAVED = "botón cerrar: informe guardado; escribe /reload para escribirlo en el disco.",
	CHARACTERFRAME_DEBUG_COVERED_BY = "      tapado por: ",
	CHARACTERFRAME_DEBUG_COVERING = "   lo que tapa su centro y captura el ratón:",
	CHARACTERFRAME_DEBUG_COVERING_ROW = "      %-34s strata=%-16s nivel=%d",
	CHARACTERFRAME_DEBUG_HEAD_SCRIPTS = "   clic=%s arrastrar=%s recibir=%s activo=%s",
	CHARACTERFRAME_DEBUG_HEAD_STATE = "cabeza: %dx%d strata=%s nivel=%d ratón=%s mostrado=%s",
	CHARACTERFRAME_DEBUG_HOVER_SLOT = "pasa el cursor por una casilla durante cinco segundos.",
	CHARACTERFRAME_DEBUG_HOVER_TABS = "pasa el cursor por las pestañas: /fui character indica lo que el ratón toca realmente",
	CHARACTERFRAME_DEBUG_NONE = "ninguno",
	CHARACTERFRAME_DEBUG_PANES = "paneles: ",
	CHARACTERFRAME_DEBUG_SHEET_OPEN_FIRST = "ficha: ábrela primero y vuelve a ejecutar /fui character",
	CHARACTERFRAME_DEBUG_SHOWN_SCREENS = "pantallas del cliente mostradas: %s | grupo abierto: %s",
	CHARACTERFRAME_DEBUG_TABS_OPEN_FIRST = "pestañas: abre primero la ficha de personaje y vuelve a ejecutar /fui tabs",
	CHARACTERFRAME_DEBUG_TAB_STATE = "%-30s mostrado=%-5s ratón=%-5s activo=%-5s strata=%-10s nivel=%d clic=%s",
	CHARACTERFRAME_DEBUG_UNDER_CURSOR = "      bajo el cursor: ",
	CHARACTERFRAME_DEBUG_UNNAMED = "(sin nombre)",
	CHARACTERFRAME_DEBUG_WATCH_END = "   (fin de la vigilancia)",
	CHARACTERFRAME_HIDE_DETAILS = "Ocultar detalles",
	CHARACTERFRAME_MODEL_POSITION_USAGE = "modelo: /fui model position <profundidad> <lateral> <altura>",
	CHARACTERFRAME_MODEL_STATE = "modelo: escala=%s posición=(%s, %s, %s)",
	CHARACTERFRAME_MODEL_USAGE = "modelo: echelle <n> | position <x> <y> <z> | position defaut",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua no está cargado. Un archivo añadido al accesorio solo llega en el siguiente inicio del juego: cierra y vuelve a abrir el cliente. La ficha de personaje permanece inactiva hasta entonces.",
	CHARACTERFRAME_SHOW_DETAILS = "Mostrar detalles",
	CHARACTERFRAME_TAB_MACROS_FULL = "No queda espacio para macros: borra una para poner esta pestaña en una barra.",
	CHARACTERFRAME_TITLES = "Títulos",

	-- Chat.lua
	CHAT_DEBUG_FADE = "   encendido %s (cliente %s, encima %s), fuera durante %.1f s | ratón encima: chat %s, amigos %s, columna %s, barra %s, volver %s",
	CHAT_DEBUG_HIDDEN = "oculto",
	CHAT_DEBUG_NO = "no",
	CHAT_DEBUG_REST = "   reposo: coeficiente %.2f (objetivo %d) en %d piezas + %d de entrada | fondo %.2f (conservado %.2f, hecho %s)",
	CHAT_DEBUG_SHOWN = "mostrado",
	CHAT_DEBUG_STATE = "chat %s: %d mensajes, %d visibles, posición %d/%d, al final %s | barra %s alfa %.2f | volver alfa %.2f | SetScrollOffset %s",
	CHAT_DEBUG_YES = "sí",
	CHAT_DEBUG_YES_UPPER = "SÍ",
	CHAT_LINES_RECORDED = "registro del chat %s: %d objetos de texto (%d visibles), %d mensajes; escribe /reload para guardarlo.",
	CHAT_LINES_TEST = "ForeverUI, prueba de selección: una línea lo bastante larga para que el chat la corte, con acentos (é è à ç), un vínculo %s, un icono %s y una palabramuylargasinningúnespacioparavercómolacortaelmotorcuandonohayningúnespacio fin.",

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
	EQUIPMENTMANAGER_DEBUG_CARD = "   tarjeta %d: nombre=%s visible=%s anclaje=%s marca=%s",
	EQUIPMENTMANAGER_DEBUG_CLOSED = "cerrado",
	EQUIPMENTMANAGER_DEBUG_KEPT_ORDER = "orden guardado: ",
	EQUIPMENTMANAGER_DEBUG_NO_DIALOG = "sin tarjetas: el diálogo del cliente no está.",
	EQUIPMENTMANAGER_DEBUG_OPEN = "abierto",
	EQUIPMENTMANAGER_DEBUG_PLACED_ORDER = "orden colocado: ",
	EQUIPMENTMANAGER_DEBUG_SCROLL = "desplazamiento = %d, tarjetas que caben = %d, panel %s",
	EQUIPMENTMANAGER_DEBUG_SETS = "equipamientos: el cliente publica %d: %s",
	EQUIPMENTMANAGER_DEBUG_WORN = "puesto = %s, en edición = %s",
	EQUIPMENTMANAGER_NEW_SET = "Nuevo equipamiento",

	-- GroupFinder.lua
	GROUPFINDER_DEBUG_HIDDEN = "oculto",
	GROUPFINDER_DEBUG_NONE = "ninguno",
	GROUPFINDER_DEBUG_NOTHING = "nada",
	GROUPFINDER_DEBUG_NOT_BUILT = "buscador de grupo: no construido (¿falta LFDParentFrame?)",
	GROUPFINDER_DEBUG_RAID = "banda: búsqueda %s | servidor buscando %s",
	GROUPFINDER_DEBUG_RAID_ENTRY = "   %s (%d): %s jugador(es) registrado(s)",
	GROUPFINDER_DEBUG_SHOWN = "mostrado",
	GROUPFINDER_DEBUG_STATE = "buscador de grupo: vista %s | tipo %s | modo %s | %d mazmorras | nuestra ventana %s, nivel %d | contenido del cliente alfa %s, nivel %d",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Haz clic para verlo en la lista",
	ICONPICKER_CURRENTLY_SELECTED = "Seleccionado actualmente",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "el modo de edición no está disponible en combate.",
	LAYOUT_HELP = "comandos: /fui (modo de edición), /fui reset [elemento], /fui list, /fui debug, /fui bar, /fui bottom, /fui statusbars, /fui bags, /fui character, /fui close, /fui tabs, /fui model, /fui sets, /fui rep [facción], /fui skills, /fui currency, /fui pet, /fui pvp [0..1], /fui arena, /fui bg, /fui social, /fui finder, /fui chat, /fui chatlines, /fui titles, /fui minimap [scale k], /fui map, /fui mouse, /fui questlog, /fui tracking, /fui spellbook, /fui micro",
	LAYOUT_LIST_HEADER = "elementos registrados:",
	LAYOUT_LIST_MOVED = " - movido",
	LAYOUT_NO_CHAT_LINES = "no hay ningún informe de líneas del chat disponible.",
	LAYOUT_NO_DIAG = "no hay ningún diagnóstico disponible.",
	LAYOUT_NO_DIAG_ACTIONBAR = "no hay ningún diagnóstico de la barra de acción disponible.",
	LAYOUT_NO_DIAG_ARENA = "no hay ningún diagnóstico de equipos de arena disponible.",
	LAYOUT_NO_DIAG_BAGS = "no hay ningún diagnóstico de bolsas disponible.",
	LAYOUT_NO_DIAG_BATTLEGROUNDS = "no hay ningún diagnóstico de campos de batalla disponible.",
	LAYOUT_NO_DIAG_BOTTOM = "no hay ningún diagnóstico de la parte inferior de la pantalla disponible.",
	LAYOUT_NO_DIAG_BUFFS = "no hay ningún diagnóstico de beneficios disponible.",
	LAYOUT_NO_DIAG_CHAT = "no hay ningún diagnóstico del chat disponible.",
	LAYOUT_NO_DIAG_CURRENCY = "no hay ningún diagnóstico de monedas disponible.",
	LAYOUT_NO_DIAG_GROUPFINDER = "no hay ningún diagnóstico del buscador de mazmorras disponible.",
	LAYOUT_NO_DIAG_MICROMENU = "no hay ningún diagnóstico del micromenú disponible.",
	LAYOUT_NO_DIAG_MINIMAP = "no hay ningún diagnóstico del minimapa disponible.",
	LAYOUT_NO_DIAG_PET = "no hay ningún diagnóstico de la mascota disponible.",
	LAYOUT_NO_DIAG_PVP = "no hay ningún diagnóstico JcJ disponible.",
	LAYOUT_NO_DIAG_QUESTLOG = "no hay ningún diagnóstico del registro de misiones disponible.",
	LAYOUT_NO_DIAG_REPUTATION = "no hay ningún diagnóstico de reputación disponible.",
	LAYOUT_NO_DIAG_SETS = "no hay ningún diagnóstico de equipamientos disponible.",
	LAYOUT_NO_DIAG_SHEET = "no hay ningún diagnóstico de la ficha de personaje disponible.",
	LAYOUT_NO_DIAG_SKILLS = "no hay ningún diagnóstico de habilidades disponible.",
	LAYOUT_NO_DIAG_SOCIAL = "no hay ningún diagnóstico de la ventana Social disponible.",
	LAYOUT_NO_DIAG_SPELLBOOK = "no hay ningún diagnóstico del libro de hechizos disponible.",
	LAYOUT_NO_DIAG_STATUSBARS = "no hay ningún diagnóstico de las barras de estado disponible.",
	LAYOUT_NO_DIAG_TABS = "no hay ningún diagnóstico de pestañas disponible.",
	LAYOUT_NO_DIAG_TITLES = "no hay ningún diagnóstico de títulos disponible.",
	LAYOUT_NO_DIAG_TRACKER = "no hay ningún diagnóstico del seguimiento de misiones disponible.",
	LAYOUT_NO_DIAG_WORLDMAP = "no hay ningún diagnóstico del mapa del mundo disponible.",
	LAYOUT_NO_MODEL_TUNE = "no hay ningún ajuste del modelo disponible.",
	LAYOUT_RESET_ALL = "todas las posiciones restablecidas a las predeterminadas.",
	LAYOUT_RESET_ONE = "posición restablecida a la predeterminada: ",
	LAYOUT_SPY_NOTHING = "nada",
	LAYOUT_SPY_PARENTS = "padres: ",
	LAYOUT_SPY_STARTED = "espía del ratón: haz clic en el elemento que quieras; /fui mouse para detenerlo.",
	LAYOUT_SPY_STOPPED = "espía del ratón detenido.",
	LAYOUT_SPY_TEXT = "texto: ",
	LAYOUT_SPY_TEXTURE = "textura: ",
	LAYOUT_SPY_UNDER_MOUSE = "bajo el ratón: ",
	LAYOUT_SPY_UNNAMED = "(sin nombre)",
	LAYOUT_UNKNOWN_ELEMENT = "elemento desconocido: ",

	-- Minimap.lua
	MINIMAP_DEBUG_ABSENT = "AUSENTE",
	MINIMAP_DEBUG_BUTTON = "%-26s %s, ángulo %d",
	MINIMAP_DEBUG_CLOCK = "reloj: %s | calendario: %s | coordenadas: '%s'",
	MINIMAP_DEBUG_CYCLE = "ciclo: hora %s -> %s",
	MINIMAP_DEBUG_DAY = "día",
	MINIMAP_DEBUG_FRAME = "marco %s | máscara %s | escala %.3f (proyecto %.3f)",
	MINIMAP_DEBUG_HIDDEN = "oculto",
	MINIMAP_DEBUG_NIGHT = "noche",
	MINIMAP_DEBUG_NOTHING_BUILT = "minimapa: nada construido.",
	MINIMAP_DEBUG_NOT_LOADED = "no cargado",
	MINIMAP_DEBUG_NOT_SKINNED = "sin aspecto",
	MINIMAP_DEBUG_NO_ATLASUTIL = "minimapa: falta AtlasUtil.lua, no se aplica ningún aspecto.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "minimapa: el cliente no tiene MinimapCluster, Minimap ni MinimapBackdrop.",
	MINIMAP_DEBUG_SCALE = "minimapa: escala %.3f, tamaño %.1f, en pantalla %.1f",
	MINIMAP_DEBUG_SIZES = "minimapa: grupo %.0f x %.0f | contenedor %.0f x %.0f | mapa %.0f",
	MINIMAP_DEBUG_SKINNED = "con aspecto",
	MINIMAP_DEBUG_VISIBLE = "visible",
	MINIMAP_DEBUG_ZONE = "zona: \"%s\" justificada %s, ancho %.0f",
	MINIMAP_DEBUG_ZOOM = "zoom: nivel %s de %s | acercar visible=%s | alejar visible=%s",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Todos los objetivos",
	OBJECTIVETRACKER_DEBUG_NOT_BUILT = "seguimiento: no construido.",
	OBJECTIVETRACKER_DEBUG_STATE = "seguimiento: %.0f x %.0f, plegado=%s | encabezado %s | misiones %d bloque(s) (%s) | logros %d bloque(s) (%s) | controladores %d | orden %s, filtro %s",
	OBJECTIVETRACKER_EDIT_LABEL = "Seguimiento de objetivos",
	OBJECTIVETRACKER_OPEN_MAP = "Abrir mapa de misiones",
	OBJECTIVETRACKER_READY = "Lista para entregar",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Compartir en el chat",
	OBJECTIVETRACKER_UNTRACK = "Dejar de seguir",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: anfitrión desconocido -- ",
	PANES_REPORT_LINE = "%s: grupo=%s página=%s visible=%s | páginas del grupo: %s",
	PANES_REPORT_NEVER_BUILT = ", nunca construido",
	PANES_REPORT_PAGE = "%s(%d marcos%s)",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Marcos de grupo",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Barra de mascota",

	-- PetTab.lua
	PETTAB_DEBUG_PET = "mascota: HasPetUI=%s UnitExists=%s | nivel=%s nombre=%s familia=%s",
	PETTAB_DEBUG_PREVIEW = "vista previa: %s | detalle: %s",
	PETTAB_RESISTANCES = "Resistencias",

	-- PlayerFrame.lua
	PLAYERFRAME_DEBUG = "estado: golpeado=%s lista_odio=%s amenaza=%s objetivo=%s hostil=%s me_selecciona=%s brillo=%s alfa=%.2f",
	PLAYERFRAME_DEBUG_NO_TARGET = "ninguno",
	PLAYERFRAME_EDIT_LABEL = "Marco del jugador",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Visita a un instructor para aprender cocina. La cocina te permite aprender recetas para preparar comida que te cura fuera de combate y te otorga beneficios temporales.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Visita a un instructor para aprender primeros auxilios.  Los primeros auxilios te permiten convertir tela en vendas para curarte a ti y a los demás.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Primera profesión",
	PROFESSIONSBOOK_FISHING_MISSING = "Visita a un instructor para aprender pesca.  La pesca te permite sacar del agua peces y otras cosas extrañas.  Con la habilidad de cocina, los peces se pueden convertir en deliciosos platos.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Visita a un instructor de profesiones en una ciudad importante para aprender una nueva profesión. Puedes tener dos profesiones, en cualquier combinación de profesiones de recolección y de producción.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Segunda profesión",

	-- PvPArena.lua
	PVPARENA_DEBUG_DETAIL = "detalle: abierto=%s equipo=%s temporada=%s",
	PVPARENA_DEBUG_NO_TEAM = "equipo %d: ninguno",
	PVPARENA_DEBUG_SEASON = "temporada %s (anterior %s) | puntos de arena %s",
	PVPARENA_DEBUG_TEAM = "equipo %d: %s (%dc%d) índice %s | semana %s/%s, yo %s | temporada %s/%s | estandarte borde %s emblema %s",

	-- PvPBattlegrounds.lua
	PVPBATTLEGROUNDS_DEBUG_BONUSES = "aleatorio: %s | llamamiento a las armas: %s",
	PVPBATTLEGROUNDS_DEBUG_INFO = "GetBattlefieldInfo: %s, grupo máx. %s",
	PVPBATTLEGROUNDS_DEBUG_QUEUE = "cola %d: %s %s",
	PVPBATTLEGROUNDS_DEBUG_ROW = "%d: %s entrar=%s festivo=%s aleatorio=%s id=%s%s",
	PVPBATTLEGROUNDS_DEBUG_SELECTED = " <- seleccionado",

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
	PVPTAB_DEBUG_GAUGE = "indicador: inicio %s dirección %s | %s",
	PVPTAB_DEBUG_GAUGE_NOT_BUILT = "indicador: la pantalla aún no está construida",
	PVPTAB_DEBUG_HONOR = "honor: actual=%d total=%d mejorRango=%d hoy=%d (%d) ayer=%d (%d)",
	PVPTAB_DEBUG_KEPT = "conservado: rango=%s nombre=%s | muertes=%d umbral=%s -> progreso=%.3f",
	PVPTAB_DEBUG_NONE = "ninguno",
	PVPTAB_DEBUG_QUARTER_ARC = "arco",
	PVPTAB_DEBUG_QUARTER_EMPTY = "vacío",
	PVPTAB_DEBUG_QUARTER_FULL = "lleno",
	PVPTAB_DEBUG_RANK_COUNTER = "contador de rango: UnitPVPRank=%s -> nombre=%s número=%s | GetPVPRankProgress=%s",
	PVPTAB_DEBUG_RANK_TITLES = "títulos de rango (%s, id %d a %d): %s",
	PVPTAB_DEBUG_SEASON = "temporada de arena: %s | facción: %s",
	PVPTAB_DEBUG_TEST_VALUE = "indicador fijado en %.0f %% (valor de prueba)",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Haz clic para ver los detalles de la misión>",
	QUESTLOG_COUNT = "Misiones: %s%d|r|cffffffff/%d|r",
	QUESTLOG_DEBUG_CLOSED = "cerrado",
	QUESTLOG_DEBUG_NOT_BUILT = "registro de misiones: no construido.",
	QUESTLOG_DEBUG_OPEN = "abierto",
	QUESTLOG_DEBUG_STATE = "registro de misiones: panel %s (%.0f x %.0f) | %d encabezado(s), %d misión(es) | búsqueda '%s' | objetivos %s",
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

	-- ReputationTab.lua
	REPUTATIONTAB_DEBUG_CLIENT = "lo que expone el cliente:",
	REPUTATIONTAB_DEBUG_CLIENT_ROW = "   %2d %-28s encabezado=%-5s hijo=%-5s plegado=%-5s tieneRep=%-5s nivel=%s bruto=%s/%s/%s",
	REPUTATIONTAB_DEBUG_EDGES = "i=%.1f d=%.1f",
	REPUTATIONTAB_DEBUG_GEOMETRY = "geometría:",
	REPUTATIONTAB_DEBUG_PLACED = "lo que colocamos:",
	REPUTATIONTAB_DEBUG_PLACED_ROW = "   %d %s encabezado=%s nivel=%s bruto=%s/%s/%s | barra=%s ancho=%s visible=%s tinte=%.2f,%.2f,%.2f",
	REPUTATIONTAB_DEBUG_ROW_GEOMETRY = "   %d %-24s fila %s(%s,%s) an=%s al=%s | flecha %sx%s mostrada=%s | nombre %s: %s",
	REPUTATIONTAB_DEBUG_ROW_RESOLVED = "      resuelto: fila %s | flecha %s | nombre %s an=%.1f justificar=%s fuente=%s",
	REPUTATIONTAB_DEBUG_SUMMARY = "reputación: %d facciones, desplazamiento %d, %d filas, %d colocadas",
	REPUTATIONTAB_DEBUG_UNKNOWN = "desconocido",

	-- SkillsTab.lua
	SKILLSTAB_DEBUG_ROW = "   %2d %-28s encabezado=%-5s plegado=%-5s %s",
	SKILLSTAB_DEBUG_SUMMARY = "habilidades: %d filas del cliente, desplazamiento %d, %d colocadas, seleccionada=%s",

	-- Social.lua
	SOCIAL_DEBUG_FRIENDS = "amigos %s (%s conectados), seleccionado %s | ignorados %s, seleccionado %s",
	SOCIAL_DEBUG_LIST = "lista: %d entrada(s), %d visibles, desplazamiento %d",
	SOCIAL_DEBUG_NOT_BUILT = "ventana Social: no construida (¿falta FriendsFrame?)",
	SOCIAL_DEBUG_STATE = "social: pestaña %s, subpestaña %s | nuestra ventana %s | ratón del panel %s",

	-- SpellBook.lua
	SPELLBOOK_DEBUG_NOT_BUILT = "libro de hechizos: no construido.",
	SPELLBOOK_DEBUG_ONE_PAGE = "una página",
	SPELLBOOK_DEBUG_STATE = "libro de hechizos: %.0f x %.0f, %s | categoría %d/%d, página %d/%d | %s",
	SPELLBOOK_DEBUG_TWO_PAGES = "dos páginas",
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
	STATUSBARS_DEBUG_STATE = "   nivel %s, nivel máx. %s, xp por ganar %s | reputación y predeterminada=%s, y guardada=%s, colocada por el usuario %s",
	STATUSBARS_DEBUG = "barras de estado: fila %.1f -> %.1f, arriba %s | ancho %.0f | xp visible=%s en y=%s | reputación visible=%s en y=%s",
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Barra de experiencia",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Barra de reputación",

	-- TabardFrame.lua
	TABARDFRAME_POSITION_USAGE = "tabardo: /fui tabard position <profundidad> <lateral> <altura>",
	TABARDFRAME_STATE = "tabardo: cámara=%s escala=%s posición=(%s, %s, %s)",
	TABARDFRAME_USAGE = "tabardo: camera <n> | echelle <s> | position <x> <y> <z> | defaut | client",

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

	-- Titles.lua
	TITLES_DEBUG_ABSENT = "ausente",
	TITLES_DEBUG_HIDDEN = "oculto",
	TITLES_DEBUG_SUMMARY = "títulos: %d conocidos + Ninguno, puesto=%s, desplazamiento=%d, %d fila(s) que caben",
	TITLES_DEBUG_VISIBLE = "VISIBLE",

	-- TokensTab.lua
	TOKENSTAB_DEBUG_CLIENT = "cliente: selectedToken=%s selectedID=%s | pantalla=%s",
	TOKENSTAB_DEBUG_ROW = "   %2d %-28s %s cantidad=%-8s especial=%-4s seguida=%-5s sin usar=%s",
	TOKENSTAB_DEBUG_SUMMARY = "monedas: %d en la lista, desplazamiento %d, %d colocadas, seleccionada=%s",

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
	WORLDMAP_DEBUG_BREADCRUMB = "ruta de navegación: ",
	WORLDMAP_DEBUG_DETAIL = "mapa %.0f x %.0f a escala de interfaz %.4f -> %.1f x %.1f",
	WORLDMAP_DEBUG_FLOORS = "plantas: %d | construido: %s | panel: %s",
	WORLDMAP_DEBUG_FRAME = "mapa del mundo: %.0f x %.0f a escala %.4f, modo %s (tamaño del cliente %.4f, ventana pequeña %.4f)",
	WORLDMAP_DEBUG_LANDMARK = "punto de referencia %d: %s (%s) icono %s, vínculo %s, mapa de estancia %s",
	WORLDMAP_DEBUG_MISSING = "mapa del mundo: ausente.",
	WORLDMAP_DEBUG_MODE_FULLSCREEN = "pantalla completa",
	WORLDMAP_DEBUG_MODE_WINDOWED = "ventana",
	WORLDMAP_DEBUG_MOVABLE = "movible: %s (advancedWorldMap %s, bloqueo %s)",
	WORLDMAP_DEBUG_NO_ATLAS = "mapa del mundo: falta AtlasUtil.lua, no se aplica ningún aspecto.",
	WORLDMAP_DEBUG_NO_FRAME = "mapa del mundo: el cliente no tiene WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "mapa del mundo: \"Mundo\" rechazado por el cliente (mapa %s, continente %s, zona %s, planta %s, alejar %s)",
	WORLDMAP_FILTER_SHOW = "Mostrar:",
	WORLDMAP_PLAYER_COORDS = "Jugador: %d, %d",
	WORLDMAP_TITLE = "Mapa y registro de misiones",
	WORLDMAP_WORLD = "Mundo",
})
