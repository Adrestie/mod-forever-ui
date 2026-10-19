-- ForeverUI: Russian texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("ruRU", {
	-- ActionBar.lua
	ACTIONBAR_BUTTON1_MISSING = "ActionButton1 не найдена",
	ACTIONBAR_DEBUG = "панель: кнопка %.0fx%.0f | родитель %s | привязка %s к %s (%.0f, %.0f) | видима=%s | рамка=%s | обычная альфа=%.2f",
	ACTIONBAR_EDIT_LABEL = "Панель команд",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Левый грифон",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Правый грифон",

	-- Bags.lua
	BAGS_CLEANUP = "Упорядочить сумки",
	BAGS_CLEANUP_TOOLTIP = "Объединяет стопки и упорядочивает предметы.",
	BAGS_DEBUG_ANCHOR = " [%s к %s у %s, %d, %d]",
	BAGS_DEBUG_ANCHORS = "привязок: %d",
	BAGS_DEBUG_ANCHORS_FORCE = "привязки рамки задают ее высоту",
	BAGS_DEBUG_FRAME = "%s (сумка %d): %d ячеек, %d рядов",
	BAGS_DEBUG_MATCH = "СОВПАДАЕТ",
	BAGS_DEBUG_MISMATCH = "НЕ СОВПАДАЕТ",
	BAGS_DEBUG_NONE = "нет",
	BAGS_DEBUG_NO_BAG_OPEN = "нет открытых сумок: откройте одну и снова введите /fui bags",
	BAGS_DEBUG_RESIZED_AFTER = "кто-то задает размер ПОСЛЕ нас",
	BAGS_DEBUG_SCREEN = "экран",
	BAGS_DEBUG_SEGMENT = "сегмент: наш видим=%s | клиентский видим=%s",
	BAGS_DEBUG_SIZE = "расчет %d x %d = сетка %d + заполнение %d + доп. %d | размер рамки %.0f x %.0f  %s",
	BAGS_DEBUG_SKINNED = "оформлено рамок %d | ячейка %.0f | поле видимо=%s",
	BAGS_DEBUG_TOKENS = "отслеживаемая валюта %d/%d: %s",
	BAGS_DEBUG_WITNESS = "проверка: задано %s, сразу прочитано %s, отменено %s раз -> %s",
	BAGS_NUMBER_EXPECTED = "ожидалось значение: число",
	BAGS_SET = "сумки: %s = %s",
	BAGS_UNKNOWN_SETTING = "неизвестный параметр: ",

	-- BottomBar.lua
	BOTTOMBAR_DEBUG = "низ: микроменю %.0f x %.0f (%d кнопок) | сумки %.0f x %.0f | привязка %s к %s (%.1f, %.1f) | связка ключей видима=%s",
	BOTTOMBAR_EDIT_LABEL_BAGS = "Сумки",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Меню",
	BOTTOMBAR_HOVER_PROMPT = "наведите курсор на кнопку персонажа: пять секунд.",
	BOTTOMBAR_MICRO_BUTTON = "%2d %-24s %s к %s (%s, %s) | %.0f x %.0f | ожидалось x=%d | видима=%s активна=%s уровень=%d привязок=%d",
	BOTTOMBAR_MICRO_DEBUG = "микроменю: %d кнопок, полоса %.0f x %.0f, шаг %d",
	BOTTOMBAR_NOTHING = "(ничего)",
	BOTTOMBAR_UNDER_CURSOR = "под курсором: ",

	-- Buffs.lua
	BUFFS_DEBUG_BUFFS = "положительные эффекты: единица %s, %d аур, %d скрываемых, %d показано | свертывание %s (развернуто %s) | объединение %s (%d) | длительность %s",
	BUFFS_DEBUG_DEBUFFS = "отрицательные эффекты: %d (%s)",
	BUFFS_DEBUG_HIDDEN = "скрыто",
	BUFFS_DEBUG_VISIBLE = "видимо",
	BUFFS_DISHONORED_DESC = "Все фракции, включая вашу собственную, враждебны к вам, и любой игрок может вас атаковать.",
	BUFFS_EDIT_LABEL_BUFFS = "Положительные эффекты",
	BUFFS_EDIT_LABEL_DEBUFFS = "Отрицательные эффекты",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Полоса заклинаний",

	-- CharacterFrame.lua
	CHARACTERFRAME_DEBUG_CLOSE_SAVED = "кнопка закрытия: отчет сохранен; введите /reload, чтобы записать его на диск.",
	CHARACTERFRAME_DEBUG_COVERED_BY = "      перекрыто: ",
	CHARACTERFRAME_DEBUG_COVERING = "   что перекрывает ее центр и перехватывает мышь:",
	CHARACTERFRAME_DEBUG_COVERING_ROW = "      %-34s слой=%-16s уровень=%d",
	CHARACTERFRAME_DEBUG_HEAD_SCRIPTS = "   щелчок=%s перетаскивание=%s прием=%s активна=%s",
	CHARACTERFRAME_DEBUG_HEAD_STATE = "голова: %dx%d слой=%s уровень=%d мышь=%s показана=%s",
	CHARACTERFRAME_DEBUG_HOVER_SLOT = "наведите курсор на ячейку на пять секунд.",
	CHARACTERFRAME_DEBUG_HOVER_TABS = "наведите курсор на вкладки: /fui character покажет, чего на самом деле касается мышь",
	CHARACTERFRAME_DEBUG_NONE = "нет",
	CHARACTERFRAME_DEBUG_PANES = "панели: ",
	CHARACTERFRAME_DEBUG_SHEET_OPEN_FIRST = "окно персонажа: сначала откройте его, затем снова введите /fui character",
	CHARACTERFRAME_DEBUG_SHOWN_SCREENS = "показанные экраны клиента: %s | открытая группа: %s",
	CHARACTERFRAME_DEBUG_TABS_OPEN_FIRST = "вкладки: сначала откройте окно персонажа, затем снова введите /fui tabs",
	CHARACTERFRAME_DEBUG_TAB_STATE = "%-30s показана=%-5s мышь=%-5s активна=%-5s слой=%-10s уровень=%d щелчок=%s",
	CHARACTERFRAME_DEBUG_UNDER_CURSOR = "      под курсором: ",
	CHARACTERFRAME_DEBUG_UNNAMED = "(без имени)",
	CHARACTERFRAME_DEBUG_WATCH_END = "   (конец наблюдения)",
	CHARACTERFRAME_HIDE_DETAILS = "Скрыть подробности",
	CHARACTERFRAME_MODEL_POSITION_USAGE = "модель: /fui model position <глубина> <смещение> <высота>",
	CHARACTERFRAME_MODEL_STATE = "модель: масштаб=%s положение=(%s, %s, %s)",
	CHARACTERFRAME_MODEL_USAGE = "модель: echelle <n> | position <x> <y> <z> | position defaut",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua не загружен. Файл, добавленный в модификацию, появляется только при следующем запуске игры: закройте и снова откройте клиент. До тех пор окно персонажа будет неактивно.",
	CHARACTERFRAME_SHOW_DETAILS = "Показать подробности",
	CHARACTERFRAME_TITLES = "Звания",

	-- Chat.lua
	CHAT_DEBUG_FADE = "   подсвечено %s (клиент %s, наведение %s), вне окна %.1f с | мышь над: чат %s, друзья %s, столбец %s, панель %s, возврат %s",
	CHAT_DEBUG_HIDDEN = "скрыта",
	CHAT_DEBUG_NO = "нет",
	CHAT_DEBUG_REST = "   покой: коэффициент %.2f (цель %d) на %d элементов + %d ввода | фон %.2f (сохранено %.2f, готово %s)",
	CHAT_DEBUG_SHOWN = "показана",
	CHAT_DEBUG_STATE = "чат %s: %d сообщений, %d видимых, позиция %d/%d, внизу %s | панель %s альфа %.2f | возврат альфа %.2f | SetScrollOffset %s",
	CHAT_DEBUG_YES = "да",
	CHAT_DEBUG_YES_UPPER = "ДА",
	CHAT_LINES_RECORDED = "запись чата %s: %d текстовых объектов (%d видимых), %d сообщений; введите /reload, чтобы сохранить ее.",
	CHAT_LINES_TEST = "ForeverUI, проверка выделения: строка достаточно длинная, чтобы чат ее перенес, с диакритикой (é è à ç), ссылкой %s, значком %s и оченьдлинноесловобезединогопробелачтобыувидетькакдвижокегоразбиваеткогдапробеловнетвовсе конец.",

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
	EQUIPMENTMANAGER_DEBUG_CARD = "   карточка %d: название=%s видима=%s привязка=%s отметка=%s",
	EQUIPMENTMANAGER_DEBUG_CLOSED = "закрыто",
	EQUIPMENTMANAGER_DEBUG_KEPT_ORDER = "сохраненный порядок: ",
	EQUIPMENTMANAGER_DEBUG_NO_DIALOG = "нет карточек: окно клиента отсутствует.",
	EQUIPMENTMANAGER_DEBUG_OPEN = "открыто",
	EQUIPMENTMANAGER_DEBUG_PLACED_ORDER = "заданный порядок: ",
	EQUIPMENTMANAGER_DEBUG_SCROLL = "прокрутка = %d, помещается карточек = %d, панель %s",
	EQUIPMENTMANAGER_DEBUG_SETS = "комплекты: клиент сообщает о %d: %s",
	EQUIPMENTMANAGER_DEBUG_WORN = "надет = %s, редактируется = %s",
	EQUIPMENTMANAGER_NEW_SET = "Новый комплект",

	-- GroupFinder.lua
	GROUPFINDER_DEBUG_HIDDEN = "скрыто",
	GROUPFINDER_DEBUG_NONE = "нет",
	GROUPFINDER_DEBUG_NOTHING = "ничего",
	GROUPFINDER_DEBUG_NOT_BUILT = "поиск группы: не создан (нет LFDParentFrame?)",
	GROUPFINDER_DEBUG_RAID = "рейд: поиск %s | сервер ищет %s",
	GROUPFINDER_DEBUG_RAID_ENTRY = "   %s (%d): записано игроков: %s",
	GROUPFINDER_DEBUG_SHOWN = "показано",
	GROUPFINDER_DEBUG_STATE = "поиск группы: вид %s | тип %s | режим %s | подземелий: %d | наше окно %s, уровень %d | содержимое клиента альфа %s, уровень %d",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Щелкните, чтобы показать в списке",
	ICONPICKER_CURRENTLY_SELECTED = "Выбрано сейчас",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "режим редактирования недоступен в бою.",
	LAYOUT_HELP = "команды: /fui (режим редактирования), /fui reset [элемент], /fui list, /fui debug, /fui bar, /fui bottom, /fui statusbars, /fui bags, /fui character, /fui close, /fui tabs, /fui model, /fui sets, /fui rep [фракция], /fui skills, /fui currency, /fui pet, /fui pvp [0..1], /fui arena, /fui bg, /fui social, /fui finder, /fui chat, /fui chatlines, /fui titles, /fui minimap [scale k], /fui map, /fui mouse, /fui questlog, /fui tracking, /fui spellbook, /fui micro",
	LAYOUT_LIST_HEADER = "зарегистрированные элементы:",
	LAYOUT_LIST_MOVED = " - перемещен",
	LAYOUT_NO_CHAT_LINES = "нет доступного отчета о строках чата.",
	LAYOUT_NO_DIAG = "нет доступной диагностики.",
	LAYOUT_NO_DIAG_ACTIONBAR = "нет доступной диагностики панели команд.",
	LAYOUT_NO_DIAG_ARENA = "нет доступной диагностики команд арены.",
	LAYOUT_NO_DIAG_BAGS = "нет доступной диагностики сумок.",
	LAYOUT_NO_DIAG_BATTLEGROUNDS = "нет доступной диагностики полей боя.",
	LAYOUT_NO_DIAG_BOTTOM = "нет доступной диагностики нижней части экрана.",
	LAYOUT_NO_DIAG_BUFFS = "нет доступной диагностики эффектов.",
	LAYOUT_NO_DIAG_CHAT = "нет доступной диагностики чата.",
	LAYOUT_NO_DIAG_CURRENCY = "нет доступной диагностики валюты.",
	LAYOUT_NO_DIAG_GROUPFINDER = "нет доступной диагностики поиска подземелий.",
	LAYOUT_NO_DIAG_MICROMENU = "нет доступной диагностики микроменю.",
	LAYOUT_NO_DIAG_MINIMAP = "нет доступной диагностики мини-карты.",
	LAYOUT_NO_DIAG_PET = "нет доступной диагностики питомца.",
	LAYOUT_NO_DIAG_PVP = "нет доступной диагностики PvP.",
	LAYOUT_NO_DIAG_QUESTLOG = "нет доступной диагностики журнала заданий.",
	LAYOUT_NO_DIAG_REPUTATION = "нет доступной диагностики репутации.",
	LAYOUT_NO_DIAG_SETS = "нет доступной диагностики комплектов экипировки.",
	LAYOUT_NO_DIAG_SHEET = "нет доступной диагностики окна персонажа.",
	LAYOUT_NO_DIAG_SKILLS = "нет доступной диагностики навыков.",
	LAYOUT_NO_DIAG_SOCIAL = "нет доступной диагностики окна «Общение».",
	LAYOUT_NO_DIAG_SPELLBOOK = "нет доступной диагностики книги заклинаний.",
	LAYOUT_NO_DIAG_STATUSBARS = "нет доступной диагностики индикаторов.",
	LAYOUT_NO_DIAG_TABS = "нет доступной диагностики вкладок.",
	LAYOUT_NO_DIAG_TITLES = "нет доступной диагностики званий.",
	LAYOUT_NO_DIAG_TRACKER = "нет доступной диагностики списка задач.",
	LAYOUT_NO_DIAG_WORLDMAP = "нет доступной диагностики карты мира.",
	LAYOUT_NO_MODEL_TUNE = "нет доступной настройки модели.",
	LAYOUT_RESET_ALL = "все положения сброшены по умолчанию.",
	LAYOUT_RESET_ONE = "положение сброшено по умолчанию: ",
	LAYOUT_SPY_NOTHING = "ничего",
	LAYOUT_SPY_PARENTS = "родители: ",
	LAYOUT_SPY_STARTED = "слежение за мышью: щелкните нужный элемент; /fui mouse для остановки.",
	LAYOUT_SPY_STOPPED = "слежение за мышью остановлено.",
	LAYOUT_SPY_TEXT = "текст: ",
	LAYOUT_SPY_TEXTURE = "текстура: ",
	LAYOUT_SPY_UNDER_MOUSE = "под мышью: ",
	LAYOUT_SPY_UNNAMED = "(без имени)",
	LAYOUT_UNKNOWN_ELEMENT = "неизвестный элемент: ",

	-- Minimap.lua
	MINIMAP_DEBUG_ABSENT = "ОТСУТСТВУЕТ",
	MINIMAP_DEBUG_BUTTON = "%-26s %s, угол %d",
	MINIMAP_DEBUG_CLOCK = "часы: %s | календарь: %s | координаты: '%s'",
	MINIMAP_DEBUG_CYCLE = "цикл: время %s -> %s",
	MINIMAP_DEBUG_DAY = "день",
	MINIMAP_DEBUG_FRAME = "рамка %s | маска %s | масштаб %.3f (проект %.3f)",
	MINIMAP_DEBUG_HIDDEN = "скрыто",
	MINIMAP_DEBUG_NIGHT = "ночь",
	MINIMAP_DEBUG_NOTHING_BUILT = "мини-карта: ничего не создано.",
	MINIMAP_DEBUG_NOT_LOADED = "не загружено",
	MINIMAP_DEBUG_NOT_SKINNED = "не оформлено",
	MINIMAP_DEBUG_NO_ATLASUTIL = "мини-карта: отсутствует AtlasUtil.lua, ничего не оформлено.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "мини-карта: в клиенте нет MinimapCluster, Minimap или MinimapBackdrop.",
	MINIMAP_DEBUG_SCALE = "мини-карта: масштаб %.3f, размер %.1f, на экране %.1f",
	MINIMAP_DEBUG_SIZES = "мини-карта: кластер %.0f x %.0f | контейнер %.0f x %.0f | карта %.0f",
	MINIMAP_DEBUG_SKINNED = "оформлено",
	MINIMAP_DEBUG_VISIBLE = "видимо",
	MINIMAP_DEBUG_ZONE = "зона: \"%s\" выравнивание %s, ширина %.0f",
	MINIMAP_DEBUG_ZOOM = "масштаб: уровень %s из %s | приближение видимо=%s | отдаление видимо=%s",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Все задачи",
	OBJECTIVETRACKER_DEBUG_NOT_BUILT = "список задач: не создан.",
	OBJECTIVETRACKER_DEBUG_STATE = "список задач: %.0f x %.0f, свернут=%s | заголовок %s | задания: блоков %d (%s) | достижения: блоков %d (%s) | обработчиков %d | сортировка %s, фильтр %s",
	OBJECTIVETRACKER_EDIT_LABEL = "Список задач",
	OBJECTIVETRACKER_OPEN_MAP = "Открыть карту заданий",
	OBJECTIVETRACKER_READY = "Можно сдавать",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Ссылка в чат",
	OBJECTIVETRACKER_UNTRACK = "Не отслеживать",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: неизвестный владелец -- ",
	PANES_REPORT_LINE = "%s: группа=%s страница=%s видима=%s | страницы группы: %s",
	PANES_REPORT_NEVER_BUILT = ", ни разу не создана",
	PANES_REPORT_PAGE = "%s(рамок: %d%s)",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Рамки группы",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Панель питомца",

	-- PetTab.lua
	PETTAB_DEBUG_PET = "питомец: HasPetUI=%s UnitExists=%s | уровень=%s имя=%s семейство=%s",
	PETTAB_DEBUG_PREVIEW = "предпросмотр: %s | подробности: %s",
	PETTAB_RESISTANCES = "Сопротивление",

	-- PlayerFrame.lua
	PLAYERFRAME_DEBUG = "состояние: удар=%s список_угрозы=%s угроза=%s цель=%s враждебна=%s целится_в_меня=%s свечение=%s альфа=%.2f",
	PLAYERFRAME_DEBUG_NO_TARGET = "нет",
	PLAYERFRAME_EDIT_LABEL = "Рамка игрока",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Посетите учителя, чтобы освоить кулинарию. Кулинария позволяет изучать рецепты блюд, которые восстанавливают здоровье вне боя и дают временные положительные эффекты.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Посетите учителя, чтобы освоить первую помощь. Первая помощь позволяет делать из ткани бинты, чтобы лечить себя и других.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Первая профессия",
	PROFESSIONSBOOK_FISHING_MISSING = "Посетите учителя, чтобы освоить рыбную ловлю. Рыбная ловля позволяет вылавливать из воды рыбу и другие странные вещи. Владея кулинарией, из рыбы можно готовить вкусные блюда.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Чтобы освоить новую профессию, посетите учителя профессий в одном из крупных городов. Можно владеть двумя профессиями в любом сочетании собирательских и производственных.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Вторая профессия",

	-- PvPArena.lua
	PVPARENA_DEBUG_DETAIL = "подробности: открыто=%s команда=%s сезон=%s",
	PVPARENA_DEBUG_NO_TEAM = "команда %d: нет",
	PVPARENA_DEBUG_SEASON = "сезон %s (предыдущий %s) | очки арены %s",
	PVPARENA_DEBUG_TEAM = "команда %d: %s (%dx%d) рейтинг %s | неделя %s/%s, я %s | сезон %s/%s | знамя: кайма %s эмблема %s",

	-- PvPBattlegrounds.lua
	PVPBATTLEGROUNDS_DEBUG_BONUSES = "случайное: %s | призыв к оружию: %s",
	PVPBATTLEGROUNDS_DEBUG_INFO = "GetBattlefieldInfo: %s, макс. группа %s",
	PVPBATTLEGROUNDS_DEBUG_QUEUE = "очередь %d: %s %s",
	PVPBATTLEGROUNDS_DEBUG_ROW = "%d: %s вход=%s праздник=%s случайное=%s id=%s%s",
	PVPBATTLEGROUNDS_DEBUG_SELECTED = " <- выбрано",

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
	PVPTAB_DEBUG_GAUGE = "шкала: начало %s направление %s | %s",
	PVPTAB_DEBUG_GAUGE_NOT_BUILT = "шкала: экран еще не создан",
	PVPTAB_DEBUG_HONOR = "честь: текущая=%d всего=%d лучшееЗвание=%d сегодня=%d (%d) вчера=%d (%d)",
	PVPTAB_DEBUG_KEPT = "сохранено: звание=%s название=%s | победы=%d порог=%s -> прогресс=%.3f",
	PVPTAB_DEBUG_NONE = "нет",
	PVPTAB_DEBUG_QUARTER_ARC = "дуга",
	PVPTAB_DEBUG_QUARTER_EMPTY = "пусто",
	PVPTAB_DEBUG_QUARTER_FULL = "полно",
	PVPTAB_DEBUG_RANK_COUNTER = "счетчик званий: UnitPVPRank=%s -> название=%s номер=%s | GetPVPRankProgress=%s",
	PVPTAB_DEBUG_RANK_TITLES = "звания (%s, id с %d по %d): %s",
	PVPTAB_DEBUG_SEASON = "сезон арены: %s | фракция: %s",
	PVPTAB_DEBUG_TEST_VALUE = "шкала установлена на %.0f %% (тестовое значение)",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Щелкните, чтобы просмотреть подробности задания>",
	QUESTLOG_COUNT = "Задания: %s%d|r|cffffffff/%d|r",
	QUESTLOG_DEBUG_CLOSED = "закрыт",
	QUESTLOG_DEBUG_NOT_BUILT = "журнал заданий: не создан.",
	QUESTLOG_DEBUG_OPEN = "открыт",
	QUESTLOG_DEBUG_STATE = "журнал заданий: панель %s (%.0f x %.0f) | заголовков: %d, заданий: %d | поиск '%s' | цели %s",
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

	-- ReputationTab.lua
	REPUTATIONTAB_DEBUG_CLIENT = "что предоставляет клиент:",
	REPUTATIONTAB_DEBUG_CLIENT_ROW = "   %2d %-28s заголовок=%-5s дочерняя=%-5s свернута=%-5s естьРеп=%-5s отношение=%s исх=%s/%s/%s",
	REPUTATIONTAB_DEBUG_EDGES = "л=%.1f п=%.1f",
	REPUTATIONTAB_DEBUG_GEOMETRY = "геометрия:",
	REPUTATIONTAB_DEBUG_PLACED = "что размещаем мы:",
	REPUTATIONTAB_DEBUG_PLACED_ROW = "   %d %s заголовок=%s отношение=%s исх=%s/%s/%s | полоса=%s ширина=%s видима=%s оттенок=%.2f,%.2f,%.2f",
	REPUTATIONTAB_DEBUG_ROW_GEOMETRY = "   %d %-24s строка %s(%s,%s) ш=%s в=%s | шеврон %sx%s показан=%s | название %s: %s",
	REPUTATIONTAB_DEBUG_ROW_RESOLVED = "      итог: строка %s | шеврон %s | название %s ш=%.1f выравнивание=%s шрифт=%s",
	REPUTATIONTAB_DEBUG_SUMMARY = "репутация: %d фракций, смещение %d, %d строк, %d размещено",
	REPUTATIONTAB_DEBUG_UNKNOWN = "неизвестно",

	-- SkillsTab.lua
	SKILLSTAB_DEBUG_ROW = "   %2d %-28s заголовок=%-5s свернута=%-5s %s",
	SKILLSTAB_DEBUG_SUMMARY = "навыки: %d строк клиента, смещение %d, %d размещено, выбрано=%s",

	-- Social.lua
	SOCIAL_DEBUG_FRIENDS = "друзья %s (%s в сети), выбран %s | черный список %s, выбран %s",
	SOCIAL_DEBUG_LIST = "список: записей %d, видимых %d, смещение %d",
	SOCIAL_DEBUG_NOT_BUILT = "Окно «Общение»: не создано (нет FriendsFrame?)",
	SOCIAL_DEBUG_STATE = "общение: вкладка %s, подвкладка %s | наше окно %s | мышь на панели %s",

	-- SpellBook.lua
	SPELLBOOK_DEBUG_NOT_BUILT = "книга заклинаний: не создана.",
	SPELLBOOK_DEBUG_ONE_PAGE = "одна страница",
	SPELLBOOK_DEBUG_STATE = "книга заклинаний: %.0f x %.0f, %s | категория %d/%d, страница %d/%d | %s",
	SPELLBOOK_DEBUG_TWO_PAGES = "две страницы",
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
	STATUSBARS_DEBUG_STATE = "   уровень %s, макс. уровень %s, опыта до уровня %s | репутация: y по умолчанию=%s, сохраненный y=%s, размещена вручную %s",
	STATUSBARS_DEBUG = "индикаторы: ряд %.1f -> %.1f, верх %s | ширина %.0f | опыт видим=%s на y=%s | репутация видима=%s на y=%s",
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Индикатор опыта",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Индикатор репутации",

	-- TabMacros.lua
	TABMACROS_FULL = "Нет места для нового макроса: удалите макрос, чтобы поместить эту вкладку на панель.",

	-- TabardFrame.lua
	TABARDFRAME_POSITION_USAGE = "гербовая накидка: /fui tabard position <глубина> <смещение> <высота>",
	TABARDFRAME_STATE = "гербовая накидка: камера=%s масштаб=%s положение=(%s, %s, %s)",
	TABARDFRAME_USAGE = "гербовая накидка: camera <n> | echelle <s> | position <x> <y> <z> | defaut | client",

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

	-- Titles.lua
	TITLES_DEBUG_ABSENT = "отсутствует",
	TITLES_DEBUG_HIDDEN = "скрыто",
	TITLES_DEBUG_SUMMARY = "звания: известно %d + Нет, текущее=%s, смещение=%d, помещается строк: %d",
	TITLES_DEBUG_VISIBLE = "ВИДИМО",

	-- TokensTab.lua
	TOKENSTAB_DEBUG_CLIENT = "клиент: selectedToken=%s selectedID=%s | экран=%s",
	TOKENSTAB_DEBUG_ROW = "   %2d %-28s %s кол-во=%-8s особая=%-4s отслеж.=%-5s не исп.=%s",
	TOKENSTAB_DEBUG_SUMMARY = "валюта: %d в списке, смещение %d, %d размещено, выбрано=%s",

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
	WORLDMAP_DEBUG_BREADCRUMB = "навигационная цепочка: ",
	WORLDMAP_DEBUG_DETAIL = "карта %.0f x %.0f при масштабе интерфейса %.4f -> %.1f x %.1f",
	WORLDMAP_DEBUG_FLOORS = "уровней: %d | создано: %s | панель: %s",
	WORLDMAP_DEBUG_FRAME = "карта мира: %.0f x %.0f при масштабе %.4f, режим %s (размер клиента %.4f, малое окно %.4f)",
	WORLDMAP_DEBUG_LANDMARK = "ориентир %d: %s (%s) значок %s, ссылка %s, карта подземелья %s",
	WORLDMAP_DEBUG_MISSING = "карта мира: отсутствует.",
	WORLDMAP_DEBUG_MODE_FULLSCREEN = "полноэкранный",
	WORLDMAP_DEBUG_MODE_WINDOWED = "оконный",
	WORLDMAP_DEBUG_MOVABLE = "перемещаемая: %s (advancedWorldMap %s, блокировка %s)",
	WORLDMAP_DEBUG_NO_ATLAS = "карта мира: отсутствует AtlasUtil.lua, ничего не оформлено.",
	WORLDMAP_DEBUG_NO_FRAME = "карта мира: в клиенте нет WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "карта мира: клиент отклонил «Мир» (карта %s, континент %s, зона %s, уровень %s, отдаление %s)",
	WORLDMAP_FILTER_SHOW = "Показать:",
	WORLDMAP_PLAYER_COORDS = "Игрок: %d, %d",
	WORLDMAP_TITLE = "Карта и журнал заданий",
	WORLDMAP_WORLD = "Мир",
})
