-- ForeverUI: Russian texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("ruRU", {
	-- ActionBar.lua
	ACTIONBAR_EDIT_LABEL = "Панель команд",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Левый грифон",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Правый грифон",

	-- Bags.lua
	BAGS_CLEANUP = "Упорядочить сумки",
	BAGS_CLEANUP_TOOLTIP = "Объединяет стопки и упорядочивает предметы.",

	-- BottomBar.lua
	BOTTOMBAR_EDIT_LABEL_BAGS = "Сумки",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Меню",

	-- Buffs.lua
	BUFFS_DISHONORED_DESC = "Все фракции, включая вашу собственную, враждебны к вам, и любой игрок может вас атаковать.",
	BUFFS_EDIT_LABEL_BUFFS = "Положительные эффекты",
	BUFFS_EDIT_LABEL_DEBUFFS = "Отрицательные эффекты",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Полоса заклинаний",

	-- CharacterFrame.lua
	CHARACTERFRAME_HIDE_DETAILS = "Скрыть подробности",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua не загружен. Файл, добавленный в модификацию, появляется только при следующем запуске игры: закройте и снова откройте клиент. До тех пор окно персонажа будет неактивно.",
	CHARACTERFRAME_SHOW_DETAILS = "Показать подробности",
	CHARACTERFRAME_TITLES = "Звания",

	-- Chat.lua
	CHAT_NOT_IN_LFG_NOTICE = "|Hchannel:%d|h[%s]|h Чтобы пользоваться этим каналом, нужно встать в очередь поиска подземелий.",

	-- CustomizeUI.lua
	CUSTOMIZEUI_GRID_ORIGIN = "Начало сетки",
	CUSTOMIZEUI_GRID_SPACING = "Шаг сетки",
	CUSTOMIZEUI_MENU_BUTTON = "Настройка интерфейса",
	CUSTOMIZEUI_ORIGIN_BOTTOM = "Снизу",
	CUSTOMIZEUI_ORIGIN_BOTTOMLEFT = "Снизу слева",
	CUSTOMIZEUI_ORIGIN_BOTTOMRIGHT = "Снизу справа",
	CUSTOMIZEUI_ORIGIN_CENTER = "По центру",
	CUSTOMIZEUI_ORIGIN_LEFT = "Слева",
	CUSTOMIZEUI_ORIGIN_RIGHT = "Справа",
	CUSTOMIZEUI_ORIGIN_TOP = "Сверху",
	CUSTOMIZEUI_ORIGIN_TOPLEFT = "Сверху слева",
	CUSTOMIZEUI_ORIGIN_TOPRIGHT = "Сверху справа",
	CUSTOMIZEUI_PERCENT = "%",
	CUSTOMIZEUI_RESET_CONFIRM = "Вернуть все элементы к расположению по умолчанию?",
	CUSTOMIZEUI_SIZE = "Размер",
	CUSTOMIZEUI_SNAP = "Привязка к сетке",
	CUSTOMIZEUI_STICKY = "Прилипание элементов",
	CUSTOMIZEUI_TITLE = "Настройка интерфейса",
	CUSTOMIZEUI_VALIDATE = "Применить",

	-- EquipmentManager.lua
	EQUIPMENTMANAGER_NEW_SET = "Новый комплект",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Щелкните, чтобы показать в списке",
	ICONPICKER_CURRENTLY_SELECTED = "Выбрано сейчас",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "режим редактирования недоступен в бою.",
	LAYOUT_HELP = "команды: /fui (режим редактирования), /fui reset [элемент], /fui list",
	LAYOUT_LIST_HEADER = "зарегистрированные элементы:",
	LAYOUT_LIST_MOVED = " - перемещен",
	LAYOUT_RESET_ALL = "все положения сброшены по умолчанию.",
	LAYOUT_RESET_ONE = "положение сброшено по умолчанию: ",
	LAYOUT_UNKNOWN_ELEMENT = "неизвестный элемент: ",

	-- Minimap.lua
	MINIMAP_DEBUG_NO_ATLASUTIL = "мини-карта: отсутствует AtlasUtil.lua, ничего не оформлено.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "мини-карта: в клиенте нет MinimapCluster, Minimap или MinimapBackdrop.",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Все задачи",
	OBJECTIVETRACKER_EDIT_LABEL = "Список задач",
	OBJECTIVETRACKER_OPEN_MAP = "Открыть карту заданий",
	OBJECTIVETRACKER_READY = "Можно сдавать",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Ссылка в чат",
	OBJECTIVETRACKER_UNTRACK = "Не отслеживать",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: неизвестный владелец -- ",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Рамки группы",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Панель питомца",

	-- PetTab.lua
	PETTAB_RESISTANCES = "Сопротивление",

	-- PlayerFrame.lua
	PLAYERFRAME_EDIT_LABEL = "Рамка игрока",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Посетите учителя, чтобы освоить кулинарию. Кулинария позволяет изучать рецепты блюд, которые восстанавливают здоровье вне боя и дают временные положительные эффекты.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Посетите учителя, чтобы освоить первую помощь. Первая помощь позволяет делать из ткани бинты, чтобы лечить себя и других.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Первая профессия",
	PROFESSIONSBOOK_FISHING_MISSING = "Посетите учителя, чтобы освоить рыбную ловлю. Рыбная ловля позволяет вылавливать из воды рыбу и другие странные вещи. Владея кулинарией, из рыбы можно готовить вкусные блюда.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Чтобы освоить новую профессию, посетите учителя профессий в одном из крупных городов. Можно владеть двумя профессиями в любом сочетании собирательских и производственных.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Вторая профессия",

	-- Bank.lua
	BANK_TITLE = "Банк",
	BANK_COLON = "%s:",

	-- Mail.lua
	MAIL_OPEN_ALL = "Открыть все",
	MAIL_OPEN_ALL_OPENING = "Открывание...",

	-- PvPTab.lua
	PVPTAB_CIVILIAN = "Мирный житель",
	PVPTAB_DISHONORED_LEFT = "Бесчестье: осталось %s",
	PVPTAB_TOOLTIP_CIVILIAN = "Мирный житель",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Щелкните, чтобы просмотреть подробности задания>",
	QUESTLOG_COUNT = "Задания: %s%d|r|cffffffff/%d|r",
	QUESTLOG_EMPTY = "Нет доступных заданий|n|nБерите задания у персонажей, над головой которых виден знак |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t.",
	QUESTLOG_NO_RESULTS = "Ничего не найдено",
	QUESTLOG_READY = "Можно сдавать",
	QUESTLOG_SEARCH = "Поиск в журнале заданий",
	QUESTLOG_SHARE_IN_CHAT = "Ссылка в чат",
	QUESTLOG_SHOW_OBJECTIVES = "Показать цели заданий",
	QUESTLOG_TITLE_FAILED = "%s - (Провалено)",
	QUESTLOG_TRACK_ALL = "Отслеживать все",
	QUESTLOG_UNTRACK = "Не отслеживать",
	QUESTLOG_UNTRACK_ALL = "Не отслеживать все",
	QUESTLOG_UNTRACK_QUEST = "Не отслеживать задание",

	-- RaidFrame.lua
	RAIDFRAME_EDIT_LABEL = "Рамки рейда",

	-- SpellBook.lua
	SPELLBOOK_FLYOUT_ASPECT = "Дух",
	SPELLBOOK_FLYOUT_ASPECT_DESC = "Примите облик духов природы.",
	SPELLBOOK_FLYOUT_AURAS_DESC = "Активирует защитную ауру для вашей группы.",
	SPELLBOOK_FLYOUT_BLESSINGS = "Благословения",
	SPELLBOOK_FLYOUT_BLESSINGS_DESC = "Накладывает благословение на дружественные цели.",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS = "Великие благословения",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS_DESC = "Благословения, действующие на всех членов группы одного класса.",
	SPELLBOOK_FLYOUT_IMP_SPELLS = "Заклинания беса",
	SPELLBOOK_FLYOUT_IMP_SPELLS_DESC = "[PH] Приказывает бесу применять заклинания",
	SPELLBOOK_FLYOUT_JUDGEMENTS = "Правосудие",
	SPELLBOOK_FLYOUT_PET_UTILITIES = "Управление питомцами",
	SPELLBOOK_FLYOUT_PET_UTILITIES_DESC = "Управляйте своими питомцами.",
	SPELLBOOK_FLYOUT_PORTAL = "Портал",
	SPELLBOOK_FLYOUT_PORTAL_DESC = "Создает портал, переносящий воспользовавшихся им членов группы в один из крупных городов.",
	SPELLBOOK_FLYOUT_SEALS = "Печати",
	SPELLBOOK_FLYOUT_SHAPESHIFT = "Смена облика",
	SPELLBOOK_FLYOUT_SHAPESHIFT_DESC = "Примите другой облик.",
	SPELLBOOK_FLYOUT_STANCES = "Стойки",
	SPELLBOOK_FLYOUT_STANCES_DESC = "Примите боевую стойку.",
	SPELLBOOK_FLYOUT_SUMMON_DEMON = "Призыв демона",
	SPELLBOOK_FLYOUT_SUMMON_DEMON_DESC = "Призывает демона, подчиняющегося чернокнижнику",
	SPELLBOOK_FLYOUT_TELEPORT = "Телепортация",
	SPELLBOOK_FLYOUT_TELEPORT_DESC = "Переносит вас в один из крупных городов.",
	SPELLBOOK_FLYOUT_TRACKING = "Выслеживание",
	SPELLBOOK_FLYOUT_TRACKING_DESC = "Выслеживайте добычу.",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS = "Вспомогательные благословения",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS_DESC = "Кратковременные благословения для спасения одной цели.",
	SPELLBOOK_HIDE_PASSIVES = "Скрыть пассивные",
	SPELLBOOK_HIDE_PASSIVES_DISABLED = "Во время поиска пассивные способности не скрываются",
	SPELLBOOK_PAGE = "Стр. %d/%d",
	SPELLBOOK_USE_FLYOUTS = "Группировать похожие заклинания во всплывающих меню",

	-- SpellBookSearch.lua
	SPELLBOOKSEARCH_HEADER_DESCRIPTION = "Совпадения в описании",
	SPELLBOOKSEARCH_HEADER_EXACT = "Точные совпадения",
	SPELLBOOKSEARCH_HEADER_GENERIC = "Совпадения",
	SPELLBOOKSEARCH_HEADER_NAME = "Совпадения в названии",
	SPELLBOOKSEARCH_HEADER_RELATED = "Похожие совпадения",
	SPELLBOOKSEARCH_INSTRUCTIONS = "Поиск способностей, ключевых слов",
	SPELLBOOKSEARCH_NOT_ON_ACTIONBAR = "Нет на панели команд",
	SPELLBOOKSEARCH_PREVIEW_OVERFLOW = "И еще %s",

	-- Stable.lua (the pet's specialization, as the client names it)
	STABLE_TALENT_CUNNING = "Хитрость",
	STABLE_TALENT_FEROCITY = "Свирепость",
	STABLE_TALENT_TENACITY = "Упорство",

	-- StanceBar.lua
	STANCEBAR_EDIT_LABEL = "Панель стоек",

	-- StatusBars.lua
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Индикатор опыта",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Индикатор репутации",

	-- TabMacros.lua
	TABMACROS_FULL = "Нет места для нового макроса: удалите макрос, чтобы поместить эту вкладку на панель.",

	-- Talents.lua
	TALENTS_APPLY_CHANGES = "Применить изменения",
	TALENTS_CONFIRM_CLOSE = "Если вы продолжите, все несохраненные изменения будут потеряны.",
	TALENTS_GATE_TOOLTIP = "Чтобы открыть этот ряд, потратьте еще очков: %d",
	TALENTS_INSPECT_TITLE = "Таланты: %s",
	TALENTS_SPEC_ACTIVE = "Активный",
	TALENTS_SPEC_PRIMARY = "Основной",
	TALENTS_SPEC_SECONDARY = "Дополнительный",
	TALENTS_UNDO_PENDING_CHANGES = "Отменить несохраненные изменения",
	TALENTS_UNSPENT_POINTS = "Нераспределенные таланты",

	-- TalentsSearch.lua
	TALENTSSEARCH_HIDE_PASSIVES = "Скрыть пассивные",
	TALENTSSEARCH_NOT_ON_ACTIONBAR = "Нет на панели команд",
	TALENTSSEARCH_PREVIEW_OVERFLOW = "И еще %s",
	TALENTSSEARCH_SHOW_RANKS = "Показать уровни",
	TALENTSSEARCH_TOOLTIP_EXACT_MATCH = "Точное совпадение с запросом",
	TALENTSSEARCH_TOOLTIP_MATCH = "Совпадение с запросом",
	TALENTSSEARCH_TOOLTIP_NOT_ON_ACTIONBAR = "Нет на панели команд",
	TALENTSSEARCH_TOOLTIP_ON_DISABLED_ACTIONBAR = "На отключенной панели команд",
	TALENTSSEARCH_TOOLTIP_ON_INACTIVE_BONUSBAR = "На панели команд другой стойки",
	TALENTSSEARCH_TOOLTIP_RELATED_MATCH = "Связано с искомым талантом",

	-- TargetFrame.lua
	TARGETFRAME_EDIT_LABEL = "Рамка цели",

	-- Taxi.lua
	TAXI_TITLE = "Карта полетов",

	-- TotemBar.lua
	TOTEMBAR_EDIT_LABEL = "Панель тотемов",

	-- TotemFrame.lua
	TOTEMFRAME_EDIT_LABEL = "Тотемы",

	-- TradeSkill.lua
	TRADESKILL_CHECK_ALL = "Отметить все",
	TRADESKILL_CREATE_ALL_FORMAT = "%s [%d]",
	TRADESKILL_FILTER_SKILL_UP = "Повышает навык",
	TRADESKILL_FILTER_SLOTS = "Ячейки",
	TRADESKILL_NAME_RANK = "%s %d/%d",
	TRADESKILL_NAME_RANK_MODIFIER = "%s %d (|cff20ff20+%d|r ) /%d",
	TRADESKILL_NO_RESULTS = "С текущими фильтрами ничего не найдено.",
	TRADESKILL_REAGENT_COUNT = "%s/%d",
	TRADESKILL_SKILL_UP_EASY = "Низкая вероятность повысить навык",
	TRADESKILL_SKILL_UP_MEDIUM = "Высокая вероятность повысить навык",
	TRADESKILL_SKILL_UP_OPTIMAL = "Гарантированное повышение навыка: %d",
	TRADESKILL_UNCHECK_ALL = "Снять все",

	-- Trainer.lua
	TRAINER_RANK = "%d/%d",
	TRAINER_RANK_BONUS = "%d |cff20ff20(+%d)|r/%d",

	-- Vehicle.lua
	VEHICLE_EDIT_LABEL = "Места в транспорте",

	-- WorldMap.lua
	WORLDMAP_CURSOR_COORDS = "Курсор: %d, %d",
	WORLDMAP_DEBUG_NO_ATLAS = "карта мира: отсутствует AtlasUtil.lua, ничего не оформлено.",
	WORLDMAP_DEBUG_NO_FRAME = "карта мира: в клиенте нет WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "карта мира: клиент отклонил «Мир» (карта %s, континент %s, зона %s, уровень %s, отдаление %s)",
	WORLDMAP_FILTER_SHOW = "Показать:",
	WORLDMAP_PLAYER_COORDS = "Игрок: %d, %d",
	WORLDMAP_TITLE = "Карта и журнал заданий",
	WORLDMAP_WORLD = "Мир",
})
