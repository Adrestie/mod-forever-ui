-- ForeverUI: German texts (see Texts.lua). Same keys as Texts_enUS.lua;
-- a key missing here falls back to the English text.

ForeverUI.AddTexts("deDE", {
	-- ActionBar.lua
	ACTIONBAR_BUTTON1_MISSING = "ActionButton1 nicht gefunden",
	ACTIONBAR_DEBUG = "Leiste: Button %.0fx%.0f | Eltern %s | Anker %s an %s (%.0f, %.0f) | sichtbar=%s | Rahmen=%s | Normal-Alpha=%.2f",
	ACTIONBAR_EDIT_LABEL = "Aktionsleiste",
	ACTIONBAR_EDIT_LABEL_LEFT_GRYPHON = "Linker Greif",
	ACTIONBAR_EDIT_LABEL_RIGHT_GRYPHON = "Rechter Greif",

	-- Bags.lua
	BAGS_CLEANUP = "Taschen aufräumen",
	BAGS_CLEANUP_TOOLTIP = "Fasst Stapel zusammen und sortiert Eure Gegenstände.",
	BAGS_DEBUG_ANCHOR = " [%s an %s von %s, %d, %d]",
	BAGS_DEBUG_ANCHORS = "%d Anker:",
	BAGS_DEBUG_ANCHORS_FORCE = "die Anker des Rahmens erzwingen seine Höhe",
	BAGS_DEBUG_FRAME = "%s (Tasche %d): %d Plätze, %d Reihen",
	BAGS_DEBUG_MATCH = "STIMMT",
	BAGS_DEBUG_MISMATCH = "ABWEICHUNG",
	BAGS_DEBUG_NONE = "keine",
	BAGS_DEBUG_NO_BAG_OPEN = "keine Tasche offen: öffnet eine und gebt dann erneut /fui bags ein",
	BAGS_DEBUG_RESIZED_AFTER = "jemand setzt die Größe NACH uns",
	BAGS_DEBUG_SCREEN = "den Bildschirm",
	BAGS_DEBUG_SEGMENT = "Segment: unseres sichtbar=%s | das des Clients sichtbar=%s",
	BAGS_DEBUG_SIZE = "berechnet %d x %d = Raster %d + Füllung %d + Extra %d | der Rahmen ist %.0f x %.0f  %s",
	BAGS_DEBUG_SKINNED = "gestaltete Rahmen %d | Platz %.0f | Feld sichtbar=%s",
	BAGS_DEBUG_TOKENS = "beobachtete Abzeichen %d/%d: %s",
	BAGS_DEBUG_WITNESS = "Zeuge: gesetzt %s, sofort zurückgelesen %s, %s-mal rückgängig gemacht -> %s",
	BAGS_NUMBER_EXPECTED = "erwarteter Wert: eine Zahl",
	BAGS_SET = "Taschen: %s = %s",
	BAGS_UNKNOWN_SETTING = "unbekannte Einstellung: ",

	-- BottomBar.lua
	BOTTOMBAR_DEBUG = "unten: Mikro %.0f x %.0f (%d Buttons) | Taschen %.0f x %.0f | Anker %s an %s (%.1f, %.1f) | Schlüsselbund sichtbar=%s",
	BOTTOMBAR_EDIT_LABEL_BAGS = "Taschen",
	BOTTOMBAR_EDIT_LABEL_MICROMENU = "Menü",
	BOTTOMBAR_HOVER_PROMPT = "bewegt den Mauszeiger über den Charakterbutton: fünf Sekunden.",
	BOTTOMBAR_MICRO_BUTTON = "%2d %-24s %s an %s (%s, %s) | %.0f x %.0f | erwartet x=%d | sichtbar=%s aktiv=%s Ebene=%d Anker=%d",
	BOTTOMBAR_MICRO_DEBUG = "Mikromenü: %d Buttons, Leiste %.0f x %.0f, Schritt %d",
	BOTTOMBAR_NOTHING = "(nichts)",
	BOTTOMBAR_UNDER_CURSOR = "unter dem Mauszeiger: ",

	-- Buffs.lua
	BUFFS_DEBUG_BUFFS = "Stärkungszauber: Einheit %s, %d Auren, %d ausblendbar, %d angezeigt | eingeklappt %s (ausgeklappt %s) | Zusammenfassung %s (%d) | Dauer %s",
	BUFFS_DEBUG_DEBUFFS = "Schwächungszauber: %d (%s)",
	BUFFS_DEBUG_HIDDEN = "verborgen",
	BUFFS_DEBUG_VISIBLE = "sichtbar",
	BUFFS_DISHONORED_DESC = "Alle Fraktionen, auch Eure eigene, sind Euch feindlich gesinnt, und jeder Spieler darf Euch angreifen.",
	BUFFS_EDIT_LABEL_BUFFS = "Stärkungszauber",
	BUFFS_EDIT_LABEL_DEBUFFS = "Schwächungszauber",

	-- CastBar.lua
	CASTBAR_EDIT_LABEL = "Zauberleiste",

	-- CharacterFrame.lua
	CHARACTERFRAME_DEBUG_CLOSE_SAVED = "Schließen-Button: Bericht gespeichert; gebt /reload ein, um ihn auf die Festplatte zu schreiben.",
	CHARACTERFRAME_DEBUG_COVERED_BY = "      verdeckt von: ",
	CHARACTERFRAME_DEBUG_COVERING = "   was seine Mitte verdeckt und die Maus abfängt:",
	CHARACTERFRAME_DEBUG_COVERING_ROW = "      %-34s Schicht=%-16s Ebene=%d",
	CHARACTERFRAME_DEBUG_HEAD_SCRIPTS = "   Klick=%s Ziehen=%s Empfangen=%s aktiv=%s",
	CHARACTERFRAME_DEBUG_HEAD_STATE = "Kopf: %dx%d Schicht=%s Ebene=%d Maus=%s angezeigt=%s",
	CHARACTERFRAME_DEBUG_HOVER_SLOT = "bewegt den Mauszeiger fünf Sekunden lang über einen Platz.",
	CHARACTERFRAME_DEBUG_HOVER_TABS = "bewegt den Mauszeiger über die Reiter: /fui character zeigt, was die Maus wirklich berührt",
	CHARACTERFRAME_DEBUG_NONE = "keiner",
	CHARACTERFRAME_DEBUG_PANES = "Bereiche: ",
	CHARACTERFRAME_DEBUG_SHEET_OPEN_FIRST = "Charakterfenster: öffnet es zuerst und gebt dann erneut /fui character ein",
	CHARACTERFRAME_DEBUG_SHOWN_SCREENS = "angezeigte Client-Fenster: %s | offene Gruppe: %s",
	CHARACTERFRAME_DEBUG_TABS_OPEN_FIRST = "Reiter: öffnet zuerst das Charakterfenster und gebt dann erneut /fui tabs ein",
	CHARACTERFRAME_DEBUG_TAB_STATE = "%-30s angezeigt=%-5s Maus=%-5s aktiv=%-5s Schicht=%-10s Ebene=%d Klick=%s",
	CHARACTERFRAME_DEBUG_UNDER_CURSOR = "      unter dem Mauszeiger: ",
	CHARACTERFRAME_DEBUG_UNNAMED = "(unbenannt)",
	CHARACTERFRAME_DEBUG_WATCH_END = "   (Ende der Beobachtung)",
	CHARACTERFRAME_HIDE_DETAILS = "Details verbergen",
	CHARACTERFRAME_MODEL_POSITION_USAGE = "Modell: /fui model position <Tiefe> <seitlich> <Höhe>",
	CHARACTERFRAME_MODEL_STATE = "Modell: Skalierung=%s Position=(%s, %s, %s)",
	CHARACTERFRAME_MODEL_USAGE = "Modell: echelle <n> | position <x> <y> <z> | position defaut",
	CHARACTERFRAME_PANES_MISSING = "Panes.lua ist nicht geladen. Eine dem Addon hinzugefügte Datei wird erst beim nächsten Spielstart geladen: Schließt den Client und öffnet ihn erneut. Bis dahin bleibt das Charakterfenster inaktiv.",
	CHARACTERFRAME_SHOW_DETAILS = "Details anzeigen",
	CHARACTERFRAME_TITLES = "Titel",

	-- Chat.lua
	CHAT_DEBUG_FADE = "   beleuchtet %s (Client %s, Hover %s), außerhalb seit %.1f s | Maus über: Chat %s, Kontakte %s, Spalte %s, Leiste %s, Zurück %s",
	CHAT_DEBUG_HIDDEN = "verborgen",
	CHAT_DEBUG_NO = "nein",
	CHAT_DEBUG_REST = "   Ruhe: Koeffizient %.2f (Ziel %d) auf %d Teile + %d Eingabe | Hintergrund %.2f (gespeichert %.2f, erledigt %s)",
	CHAT_DEBUG_SHOWN = "angezeigt",
	CHAT_DEBUG_STATE = "Chat %s: %d Nachrichten, %d sichtbar, Rang %d/%d, ganz unten %s | Leiste %s Alpha %.2f | Zurück Alpha %.2f | SetScrollOffset %s",
	CHAT_DEBUG_YES = "ja",
	CHAT_DEBUG_YES_UPPER = "JA",
	CHAT_LINES_RECORDED = "Chat-Aufzeichnung %s: %d Textobjekte (%d sichtbar), %d Nachrichten; gebt /reload ein, um sie zu speichern.",
	CHAT_LINES_TEST = "ForeverUI, Auswahltest: eine Zeile, die lang genug ist, um vom Chat umbrochen zu werden, mit Umlauten (ä ö ü ß), einem Link %s, einem Symbol %s und einemsehrlangenwortohneleerzeichenumzusehenwiedieenginesieumbrichtwennüberhauptkeinleerzeichendaist Ende.",

	-- CustomizeUI.lua
	CUSTOMIZEUI_GRID_ORIGIN = "Rasterursprung",
	CUSTOMIZEUI_GRID_SPACING = "Rasterabstand",
	CUSTOMIZEUI_MENU_BUTTON = "Benutzeroberfläche anpassen",
	CUSTOMIZEUI_ORIGIN_BOTTOM = "Unten",
	CUSTOMIZEUI_ORIGIN_BOTTOMLEFT = "Unten links",
	CUSTOMIZEUI_ORIGIN_BOTTOMRIGHT = "Unten rechts",
	CUSTOMIZEUI_ORIGIN_CENTER = "Mitte",
	CUSTOMIZEUI_ORIGIN_LEFT = "Links",
	CUSTOMIZEUI_ORIGIN_RIGHT = "Rechts",
	CUSTOMIZEUI_ORIGIN_TOP = "Oben",
	CUSTOMIZEUI_ORIGIN_TOPLEFT = "Oben links",
	CUSTOMIZEUI_ORIGIN_TOPRIGHT = "Oben rechts",
	CUSTOMIZEUI_PERCENT = "%",
	CUSTOMIZEUI_RESET_CONFIRM = "Alle Elemente auf die Standardanordnung zurücksetzen?",
	CUSTOMIZEUI_SIZE = "Größe",
	CUSTOMIZEUI_SNAP = "Am Raster ausrichten",
	CUSTOMIZEUI_STICKY = "An Elementen andocken",
	CUSTOMIZEUI_TITLE = "Benutzeroberfläche anpassen",
	CUSTOMIZEUI_VALIDATE = "Bestätigen",

	-- EquipmentManager.lua
	EQUIPMENTMANAGER_DEBUG_CARD = "   Karte %d: Name=%s sichtbar=%s Anker=%s Haken=%s",
	EQUIPMENTMANAGER_DEBUG_CLOSED = "geschlossen",
	EQUIPMENTMANAGER_DEBUG_KEPT_ORDER = "gespeicherte Reihenfolge: ",
	EQUIPMENTMANAGER_DEBUG_NO_DIALOG = "keine Karten: der Dialog des Clients ist nicht vorhanden.",
	EQUIPMENTMANAGER_DEBUG_OPEN = "offen",
	EQUIPMENTMANAGER_DEBUG_PLACED_ORDER = "gesetzte Reihenfolge: ",
	EQUIPMENTMANAGER_DEBUG_SCROLL = "Bildlauf = %d, passende Karten = %d, Bereich %s",
	EQUIPMENTMANAGER_DEBUG_SETS = "Sets: der Client meldet %d: %s",
	EQUIPMENTMANAGER_DEBUG_WORN = "getragen = %s, in Bearbeitung = %s",
	EQUIPMENTMANAGER_NEW_SET = "Neues Set",

	-- GroupFinder.lua
	GROUPFINDER_DEBUG_HIDDEN = "verborgen",
	GROUPFINDER_DEBUG_NONE = "keine",
	GROUPFINDER_DEBUG_NOTHING = "nichts",
	GROUPFINDER_DEBUG_NOT_BUILT = "Gruppensuche: nicht aufgebaut (LFDParentFrame fehlt?)",
	GROUPFINDER_DEBUG_RAID = "Schlachtzug: Suche %s | Server sucht %s",
	GROUPFINDER_DEBUG_RAID_ENTRY = "   %s (%d): %s Spieler erfasst",
	GROUPFINDER_DEBUG_SHOWN = "angezeigt",
	GROUPFINDER_DEBUG_STATE = "Gruppensuche: Ansicht %s | Typ %s | Modus %s | %d Dungeons | unser Fenster %s, Ebene %d | Client-Inhalt Alpha %s, Ebene %d",

	-- IconPicker.lua
	ICONPICKER_CLICK_TO_VIEW = "Klicken, um es in der Liste anzuzeigen",
	ICONPICKER_CURRENTLY_SELECTED = "Aktuell ausgewählt",

	-- Layout.lua
	LAYOUT_EDIT_MODE_COMBAT = "der Bearbeitungsmodus ist im Kampf nicht verfügbar.",
	LAYOUT_HELP = "Befehle: /fui (Bearbeitungsmodus), /fui reset [Element], /fui list, /fui debug, /fui bar, /fui bottom, /fui statusbars, /fui bags, /fui character, /fui close, /fui tabs, /fui tabicons, /fui model, /fui sets, /fui rep [Fraktion], /fui skills, /fui currency, /fui pet, /fui pvp [0..1], /fui arena, /fui bg, /fui social, /fui finder, /fui chat, /fui chatlines, /fui titles, /fui minimap [scale k], /fui map, /fui mouse, /fui questlog, /fui tracking, /fui spellbook, /fui micro",
	LAYOUT_LIST_HEADER = "registrierte Elemente:",
	LAYOUT_LIST_MOVED = " - verschoben",
	LAYOUT_NO_CHAT_LINES = "kein Bericht über die Chatzeilen verfügbar.",
	LAYOUT_NO_DIAG = "keine Diagnose verfügbar.",
	LAYOUT_NO_DIAG_ACTIONBAR = "keine Diagnose der Aktionsleiste verfügbar.",
	LAYOUT_NO_DIAG_ARENA = "keine Diagnose der Arenateams verfügbar.",
	LAYOUT_NO_DIAG_BAGS = "keine Diagnose der Taschen verfügbar.",
	LAYOUT_NO_DIAG_BATTLEGROUNDS = "keine Diagnose der Schlachtfelder verfügbar.",
	LAYOUT_NO_DIAG_BOTTOM = "keine Diagnose des unteren Bildschirmrands verfügbar.",
	LAYOUT_NO_DIAG_BUFFS = "keine Diagnose der Stärkungszauber verfügbar.",
	LAYOUT_NO_DIAG_CHAT = "keine Diagnose des Chats verfügbar.",
	LAYOUT_NO_DIAG_CURRENCY = "keine Diagnose der Abzeichen verfügbar.",
	LAYOUT_NO_DIAG_GROUPFINDER = "keine Diagnose des Dungeonbrowsers verfügbar.",
	LAYOUT_NO_DIAG_MICROMENU = "keine Diagnose des Mikromenüs verfügbar.",
	LAYOUT_NO_DIAG_MINIMAP = "keine Diagnose der Minikarte verfügbar.",
	LAYOUT_NO_DIAG_PET = "keine Diagnose des Begleiters verfügbar.",
	LAYOUT_NO_DIAG_PVP = "keine PvP-Diagnose verfügbar.",
	LAYOUT_NO_DIAG_QUESTLOG = "keine Diagnose des Questlogs verfügbar.",
	LAYOUT_NO_DIAG_REPUTATION = "keine Diagnose des Rufs verfügbar.",
	LAYOUT_NO_DIAG_SETS = "keine Diagnose der Ausrüstungssets verfügbar.",
	LAYOUT_NO_DIAG_SHEET = "keine Diagnose des Charakterfensters verfügbar.",
	LAYOUT_NO_DIAG_SKILLS = "keine Diagnose der Fertigkeiten verfügbar.",
	LAYOUT_NO_DIAG_SOCIAL = "keine Diagnose des Kontaktfensters verfügbar.",
	LAYOUT_NO_DIAG_SPELLBOOK = "keine Diagnose des Zauberbuchs verfügbar.",
	LAYOUT_NO_DIAG_STATUSBARS = "keine Diagnose der Statusleisten verfügbar.",
	LAYOUT_NO_DIAG_TABS = "keine Diagnose der Reiter verfügbar.",
	LAYOUT_NO_DIAG_TITLES = "keine Diagnose der Titel verfügbar.",
	LAYOUT_NO_DIAG_TRACKER = "keine Diagnose der Questverfolgung verfügbar.",
	LAYOUT_NO_DIAG_WORLDMAP = "keine Diagnose der Weltkarte verfügbar.",
	LAYOUT_NO_MODEL_TUNE = "keine Modelleinstellung verfügbar.",
	LAYOUT_RESET_ALL = "alle Positionen auf Standard zurückgesetzt.",
	LAYOUT_RESET_ONE = "Position auf Standard zurückgesetzt: ",
	LAYOUT_SPY_NOTHING = "nichts",
	LAYOUT_SPY_PARENTS = "Eltern: ",
	LAYOUT_SPY_STARTED = "Mausspion: klickt auf das gewünschte Element; /fui mouse zum Beenden.",
	LAYOUT_SPY_STOPPED = "Mausspion beendet.",
	LAYOUT_SPY_TEXT = "Text: ",
	LAYOUT_SPY_TEXTURE = "Textur: ",
	LAYOUT_SPY_UNDER_MOUSE = "unter der Maus: ",
	LAYOUT_SPY_UNNAMED = "(unbenannt)",
	LAYOUT_UNKNOWN_ELEMENT = "unbekanntes Element: ",

	-- Minimap.lua
	MINIMAP_DEBUG_ABSENT = "FEHLT",
	MINIMAP_DEBUG_BUTTON = "%-26s %s, Winkel %d",
	MINIMAP_DEBUG_CLOCK = "Uhr: %s | Kalender: %s | Koordinaten: '%s'",
	MINIMAP_DEBUG_CYCLE = "Zyklus: Zeit %s -> %s",
	MINIMAP_DEBUG_DAY = "Tag",
	MINIMAP_DEBUG_FRAME = "Rahmen %s | Maske %s | Skalierung %.3f (Projekt %.3f)",
	MINIMAP_DEBUG_HIDDEN = "verborgen",
	MINIMAP_DEBUG_NIGHT = "Nacht",
	MINIMAP_DEBUG_NOTHING_BUILT = "Minikarte: nichts aufgebaut.",
	MINIMAP_DEBUG_NOT_LOADED = "nicht geladen",
	MINIMAP_DEBUG_NOT_SKINNED = "nicht gestaltet",
	MINIMAP_DEBUG_NO_ATLASUTIL = "Minikarte: AtlasUtil.lua fehlt, nichts wird gestaltet.",
	MINIMAP_DEBUG_NO_CLIENT_FRAMES = "Minikarte: dem Client fehlen MinimapCluster, Minimap oder MinimapBackdrop.",
	MINIMAP_DEBUG_SCALE = "Minikarte: Skalierung %.3f, Größe %.1f, auf dem Bildschirm %.1f",
	MINIMAP_DEBUG_SIZES = "Minikarte: Cluster %.0f x %.0f | Container %.0f x %.0f | Karte %.0f",
	MINIMAP_DEBUG_SKINNED = "gestaltet",
	MINIMAP_DEBUG_VISIBLE = "sichtbar",
	MINIMAP_DEBUG_ZONE = "Zone: \"%s\" ausgerichtet %s, Breite %.0f",
	MINIMAP_DEBUG_ZOOM = "Zoom: Stufe %s von %s | hinein sichtbar=%s | heraus sichtbar=%s",

	-- ObjectiveTracker.lua
	OBJECTIVETRACKER_ALL_OBJECTIVES = "Alle Ziele",
	OBJECTIVETRACKER_DEBUG_NOT_BUILT = "Zielverfolgung: nicht aufgebaut.",
	OBJECTIVETRACKER_DEBUG_STATE = "Zielverfolgung: %.0f x %.0f, eingeklappt=%s | Kopfzeile %s | Quests %d Block/Blöcke (%s) | Erfolge %d Block/Blöcke (%s) | Handler %d | Sortierung %s, Filter %s",
	OBJECTIVETRACKER_EDIT_LABEL = "Zielverfolgung",
	OBJECTIVETRACKER_OPEN_MAP = "Questkarte öffnen",
	OBJECTIVETRACKER_READY = "Bereit zur Abgabe",
	OBJECTIVETRACKER_SHARE_IN_CHAT = "Im Chat teilen",
	OBJECTIVETRACKER_UNTRACK = "Nicht mehr verfolgen",

	-- Panes.lua
	PANES_ERROR_UNKNOWN_HOST = "ForeverUI.Panes: unbekannter Host -- ",
	PANES_REPORT_LINE = "%s: Gruppe=%s Seite=%s sichtbar=%s | Seiten der Gruppe: %s",
	PANES_REPORT_NEVER_BUILT = ", nie aufgebaut",
	PANES_REPORT_PAGE = "%s(%d Rahmen%s)",

	-- PartyFrame.lua
	PARTYFRAME_EDIT_LABEL = "Gruppenfenster",

	-- PetBar.lua
	PETBAR_EDIT_LABEL = "Begleiterleiste",

	-- PetTab.lua
	PETTAB_DEBUG_PET = "Begleiter: HasPetUI=%s UnitExists=%s | Stufe=%s Name=%s Familie=%s",
	PETTAB_DEBUG_PREVIEW = "Vorschau: %s | Detail: %s",
	PETTAB_RESISTANCES = "Widerstände",

	-- PlayerFrame.lua
	PLAYERFRAME_DEBUG = "Zustand: getroffen=%s Hassliste=%s Bedrohung=%s Ziel=%s feindlich=%s zielt_auf_mich=%s Leuchten=%s Alpha=%.2f",
	PLAYERFRAME_DEBUG_NO_TARGET = "keins",
	PLAYERFRAME_EDIT_LABEL = "Spielerfenster",

	-- ProfessionsBook.lua
	PROFESSIONSBOOK_COOKING_MISSING = "Sucht einen Lehrer auf, um Kochkunst zu erlernen. Mit Kochkunst erlernt Ihr Rezepte für Speisen, die Euch außerhalb des Kampfes heilen und Euch vorübergehende Stärkungen gewähren.",
	PROFESSIONSBOOK_FIRST_AID_MISSING = "Sucht einen Lehrer auf, um Erste Hilfe zu erlernen.  Mit Erster Hilfe könnt Ihr Stoff zu Verbänden verarbeiten, um Euch und andere zu heilen.",
	PROFESSIONSBOOK_FIRST_PROFESSION = "Erster Beruf",
	PROFESSIONSBOOK_FISHING_MISSING = "Sucht einen Lehrer auf, um Angeln zu erlernen.  Mit Angeln könnt Ihr Fische und andere seltsame Dinge aus dem Wasser ziehen.  Fisch lässt sich mit der Fertigkeit Kochkunst zu köstlichen Mahlzeiten zubereiten.",
	PROFESSIONSBOOK_MISSING_PROFESSION = "Sucht einen Berufslehrer in einer Hauptstadt auf, um einen neuen Beruf zu erlernen. Ihr könnt zwei Berufe haben, in beliebiger Kombination aus Sammel- und Herstellungsberufen.",
	PROFESSIONSBOOK_SECOND_PROFESSION = "Zweiter Beruf",

	-- PvPArena.lua
	PVPARENA_DEBUG_DETAIL = "Detail: offen=%s Team=%s Saison=%s",
	PVPARENA_DEBUG_NO_TEAM = "Team %d: keins",
	PVPARENA_DEBUG_SEASON = "Saison %s (vorherige %s) | Arenapunkte %s",
	PVPARENA_DEBUG_TEAM = "Team %d: %s (%dv%d) Wertung %s | Woche %s/%s, ich %s | Saison %s/%s | Banner Rand %s Emblem %s",

	-- PvPBattlegrounds.lua
	PVPBATTLEGROUNDS_DEBUG_BONUSES = "zufällig: %s | Ruf zu den Waffen: %s",
	PVPBATTLEGROUNDS_DEBUG_INFO = "GetBattlefieldInfo: %s, max. Gruppe %s",
	PVPBATTLEGROUNDS_DEBUG_QUEUE = "Warteschlange %d: %s %s",
	PVPBATTLEGROUNDS_DEBUG_ROW = "%d: %s betreten=%s Feiertag=%s zufällig=%s id=%s%s",
	PVPBATTLEGROUNDS_DEBUG_SELECTED = " <- ausgewählt",

	-- Bank.lua
	BANK_TITLE = "Bank",
	BANK_COLON = "%s:",

	-- Mail.lua
	MAIL_OPEN_ALL = "Alle öffnen",
	MAIL_OPEN_ALL_OPENING = "Wird geöffnet...",

	-- PvPTab.lua
	PVPTAB_CIVILIAN = "Zivilist",
	PVPTAB_DISHONORED_LEFT = "Ehrlos: noch %s",
	PVPTAB_TOOLTIP_CIVILIAN = "Zivilist",
	PVPTAB_DEBUG_GAUGE = "Anzeige: Start %s Richtung %s | %s",
	PVPTAB_DEBUG_GAUGE_NOT_BUILT = "Anzeige: das Fenster ist noch nicht aufgebaut",
	PVPTAB_DEBUG_HONOR = "Ehre: aktuell=%d gesamt=%d besterRang=%d heute=%d (%d) gestern=%d (%d)",
	PVPTAB_DEBUG_KEPT = "gespeichert: Rang=%s Name=%s | Siege=%d Schwelle=%s -> Fortschritt=%.3f",
	PVPTAB_DEBUG_NONE = "keiner",
	PVPTAB_DEBUG_QUARTER_ARC = "Bogen",
	PVPTAB_DEBUG_QUARTER_EMPTY = "leer",
	PVPTAB_DEBUG_QUARTER_FULL = "voll",
	PVPTAB_DEBUG_RANK_COUNTER = "Rangzähler: UnitPVPRank=%s -> Name=%s Nummer=%s | GetPVPRankProgress=%s",
	PVPTAB_DEBUG_RANK_TITLES = "Rangtitel (%s, IDs %d bis %d): %s",
	PVPTAB_DEBUG_SEASON = "Arenasaison: %s | Fraktion: %s",
	PVPTAB_DEBUG_TEST_VALUE = "Anzeige auf %.0f %% gesetzt (Testwert)",

	-- QuestLog.lua
	QUESTLOG_CLICK_DETAILS = "<Klicken, um Questdetails anzuzeigen>",
	QUESTLOG_COUNT = "Quests: %s%d|r|cffffffff/%d|r",
	QUESTLOG_DEBUG_CLOSED = "geschlossen",
	QUESTLOG_DEBUG_NOT_BUILT = "Questlog: nicht aufgebaut.",
	QUESTLOG_DEBUG_OPEN = "offen",
	QUESTLOG_DEBUG_STATE = "Questlog: Bereich %s (%.0f x %.0f) | %d Kopfzeile(n), %d Quest(s) | Suche '%s' | Ziele %s",
	QUESTLOG_EMPTY = "Keine Quests verfügbar|n|nNehmt Quests an, indem Ihr mit Charakteren sprecht, die ein |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t über dem Kopf haben.",
	QUESTLOG_NO_RESULTS = "Keine Ergebnisse gefunden",
	QUESTLOG_READY = "Bereit zur Abgabe",
	QUESTLOG_SEARCH = "Questlog durchsuchen",
	QUESTLOG_SHARE_IN_CHAT = "Im Chat teilen",
	QUESTLOG_SHOW_OBJECTIVES = "Questziele anzeigen",
	QUESTLOG_TITLE_FAILED = "%s - (Fehlgeschlagen)",
	QUESTLOG_TRACK_ALL = "Alle verfolgen",
	QUESTLOG_UNTRACK = "Nicht mehr verfolgen",
	QUESTLOG_UNTRACK_ALL = "Keine mehr verfolgen",
	QUESTLOG_UNTRACK_QUEST = "Quest nicht mehr verfolgen",

	-- RaidFrame.lua
	RAIDFRAME_EDIT_LABEL = "Schlachtzugsfenster",

	-- ReputationTab.lua
	REPUTATIONTAB_DEBUG_CLIENT = "was der Client liefert:",
	REPUTATIONTAB_DEBUG_CLIENT_ROW = "   %2d %-28s Kopf=%-5s Kind=%-5s eingeklappt=%-5s hatRuf=%-5s Stand=%s roh=%s/%s/%s",
	REPUTATIONTAB_DEBUG_EDGES = "l=%.1f r=%.1f",
	REPUTATIONTAB_DEBUG_GEOMETRY = "Geometrie:",
	REPUTATIONTAB_DEBUG_PLACED = "was wir platzieren:",
	REPUTATIONTAB_DEBUG_PLACED_ROW = "   %d %s Kopf=%s Stand=%s roh=%s/%s/%s | Leiste=%s Breite=%s sichtbar=%s Tönung=%.2f,%.2f,%.2f",
	REPUTATIONTAB_DEBUG_ROW_GEOMETRY = "   %d %-24s Zeile %s(%s,%s) B=%s H=%s | Pfeil %sx%s angezeigt=%s | Name %s: %s",
	REPUTATIONTAB_DEBUG_ROW_RESOLVED = "      aufgelöst: Zeile %s | Pfeil %s | Name %s B=%.1f justify=%s Schrift=%s",
	REPUTATIONTAB_DEBUG_SUMMARY = "Ruf: %d Fraktionen, Versatz %d, %d Zeilen, %d platziert",
	REPUTATIONTAB_DEBUG_UNKNOWN = "unbekannt",

	-- SkillsTab.lua
	SKILLSTAB_DEBUG_ROW = "   %2d %-28s Kopf=%-5s eingeklappt=%-5s %s",
	SKILLSTAB_DEBUG_SUMMARY = "Fertigkeiten: %d Client-Zeilen, Versatz %d, %d platziert, ausgewählt=%s",

	-- Social.lua
	SOCIAL_DEBUG_FRIENDS = "Freunde %s (%s online), ausgewählt %s | ignoriert %s, ausgewählt %s",
	SOCIAL_DEBUG_LIST = "Liste: %d Eintrag/Einträge, %d sichtbar, Versatz %d",
	SOCIAL_DEBUG_NOT_BUILT = "Kontaktfenster: nicht aufgebaut (FriendsFrame fehlt?)",
	SOCIAL_DEBUG_STATE = "Kontakte: Reiter %s, Unterreiter %s | unser Fenster %s | Mausbereich %s",

	-- SpellBook.lua
	SPELLBOOK_DEBUG_NOT_BUILT = "Zauberbuch: nicht aufgebaut.",
	SPELLBOOK_DEBUG_ONE_PAGE = "eine Seite",
	SPELLBOOK_DEBUG_STATE = "Zauberbuch: %.0f x %.0f, %s | Kategorie %d/%d, Seite %d/%d | %s",
	SPELLBOOK_DEBUG_TWO_PAGES = "zwei Seiten",
	SPELLBOOK_FLYOUT_ASPECT = "Aspekte",
	SPELLBOOK_FLYOUT_ASPECT_DESC = "Nehmt die Aspekte der Natur an.",
	SPELLBOOK_FLYOUT_AURAS_DESC = "Aktiviert eine schützende Aura für Eure Gruppe.",
	SPELLBOOK_FLYOUT_BLESSINGS = "Segen",
	SPELLBOOK_FLYOUT_BLESSINGS_DESC = "Belegt freundliche Ziele mit einem Segen.",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS = "Große Segen",
	SPELLBOOK_FLYOUT_GREATER_BLESSINGS_DESC = "Segen, die alle Mitglieder Eurer Gruppe derselben Klasse betreffen.",
	SPELLBOOK_FLYOUT_IMP_SPELLS = "Wichtelzauber",
	SPELLBOOK_FLYOUT_IMP_SPELLS_DESC = "[PH] Befiehlt dem Wichtel, Zauber zu wirken",
	SPELLBOOK_FLYOUT_JUDGEMENTS = "Richturteile",
	SPELLBOOK_FLYOUT_PET_UTILITIES = "Begleiterwerkzeuge",
	SPELLBOOK_FLYOUT_PET_UTILITIES_DESC = "Verwaltet Eure Begleiter.",
	SPELLBOOK_FLYOUT_PORTAL = "Portal",
	SPELLBOOK_FLYOUT_PORTAL_DESC = "Erschafft ein Portal, das Gruppenmitglieder, die es benutzen, in eine Hauptstadt teleportiert.",
	SPELLBOOK_FLYOUT_SEALS = "Siegel",
	SPELLBOOK_FLYOUT_SHAPESHIFT = "Gestaltwandel",
	SPELLBOOK_FLYOUT_SHAPESHIFT_DESC = "Verwandelt Euch in eine andere Gestalt.",
	SPELLBOOK_FLYOUT_STANCES = "Haltungen",
	SPELLBOOK_FLYOUT_STANCES_DESC = "Aktiviert eine Kampfhaltung.",
	SPELLBOOK_FLYOUT_SUMMON_DEMON = "Dämon beschwören",
	SPELLBOOK_FLYOUT_SUMMON_DEMON_DESC = "Beschwört einen Dämon, der dem Befehl des Hexenmeisters untersteht",
	SPELLBOOK_FLYOUT_TELEPORT = "Teleportieren",
	SPELLBOOK_FLYOUT_TELEPORT_DESC = "Teleportiert Euch in eine Hauptstadt.",
	SPELLBOOK_FLYOUT_TRACKING = "Aufspüren",
	SPELLBOOK_FLYOUT_TRACKING_DESC = "Spürt Eure Beute auf.",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS = "Nützliche Segen",
	SPELLBOOK_FLYOUT_UTILITY_BLESSINGS_DESC = "Kurz wirkende Segen, um ein einzelnes Ziel zu retten.",
	SPELLBOOK_HIDE_PASSIVES = "Passive verbergen",
	SPELLBOOK_HIDE_PASSIVES_DISABLED = "Das Verbergen passiver Fähigkeiten ist während einer Suche deaktiviert",
	SPELLBOOK_PAGE = "Seite %d/%d",
	SPELLBOOK_USE_FLYOUTS = "Ähnliche Zauber in Ausklappmenüs gruppieren",

	-- SpellBookSearch.lua
	SPELLBOOKSEARCH_HEADER_DESCRIPTION = "Treffer in der Beschreibung",
	SPELLBOOKSEARCH_HEADER_EXACT = "Genaue Treffer",
	SPELLBOOKSEARCH_HEADER_GENERIC = "Treffer",
	SPELLBOOKSEARCH_HEADER_NAME = "Treffer im Namen",
	SPELLBOOKSEARCH_HEADER_RELATED = "Verwandte Treffer",
	SPELLBOOKSEARCH_INSTRUCTIONS = "Fähigkeiten, Stichwörter suchen",
	SPELLBOOKSEARCH_NOT_ON_ACTIONBAR = "Fehlt in der Aktionsleiste",
	SPELLBOOKSEARCH_PREVIEW_OVERFLOW = "Und %s weitere",

	-- Stable.lua (the pet's specialization, as the client names it)
	STABLE_TALENT_CUNNING = "Gerissenheit",
	STABLE_TALENT_FEROCITY = "Wildheit",
	STABLE_TALENT_TENACITY = "Hartnäckigkeit",

	-- StanceBar.lua
	STANCEBAR_EDIT_LABEL = "Haltungsleiste",

	-- StatusBars.lua
	STATUSBARS_DEBUG_STATE = "   Stufe %s, Höchststufe %s, zu verdienende EP %s | Ruf Standard-y=%s, gespeichertes y=%s, vom Benutzer platziert %s",
	STATUSBARS_DEBUG = "Statusleisten: Reihe %.1f -> %.1f, oben %s | Breite %.0f | EP sichtbar=%s bei y=%s | Ruf sichtbar=%s bei y=%s",
	STATUSBARS_EDIT_LABEL_EXPERIENCE = "Erfahrungsleiste",
	STATUSBARS_EDIT_LABEL_REPUTATION = "Rufleiste",

	-- TabMacros.lua
	TABMACROS_DEBUG_COUNT = "Makrosymbole: %d, Kopien von Reitersymbolen (<Modul>_...): %d",
	TABMACROS_DEBUG_TAB = "Reiter %s | Symbol %s | in der Liste: %s (%s) | Makro: %s (%s)",
	TABMACROS_FULL = "Kein freier Makroplatz: Löscht ein Makro, um diesen Reiter auf eine Leiste zu legen.",

	-- TabardFrame.lua
	TABARDFRAME_POSITION_USAGE = "Wappenrock: /fui tabard position <Tiefe> <seitlich> <Höhe>",
	TABARDFRAME_STATE = "Wappenrock: Kamera=%s Skalierung=%s Position=(%s, %s, %s)",
	TABARDFRAME_USAGE = "Wappenrock: camera <n> | echelle <s> | position <x> <y> <z> | defaut | client",

	-- Talents.lua
	TALENTS_APPLY_CHANGES = "Änderungen übernehmen",
	TALENTS_CONFIRM_CLOSE = "Wenn Ihr fortfahrt, gehen alle ausstehenden Änderungen verloren.",
	TALENTS_GATE_TOOLTIP = "Verteilt %d weitere Punkte, um diese Reihe freizuschalten",
	TALENTS_INSPECT_TITLE = "Talente von %s",
	TALENTS_SPEC_ACTIVE = "Aktiv",
	TALENTS_SPEC_PRIMARY = "Primär",
	TALENTS_SPEC_SECONDARY = "Sekundär",
	TALENTS_UNDO_PENDING_CHANGES = "Ausstehende Änderungen verwerfen",
	TALENTS_UNSPENT_POINTS = "Unverteilte Talente",

	-- TalentsSearch.lua
	TALENTSSEARCH_HIDE_PASSIVES = "Passive verbergen",
	TALENTSSEARCH_NOT_ON_ACTIONBAR = "Fehlt in der Aktionsleiste",
	TALENTSSEARCH_PREVIEW_OVERFLOW = "Und %s weitere",
	TALENTSSEARCH_SHOW_RANKS = "Ränge anzeigen",
	TALENTSSEARCH_TOOLTIP_EXACT_MATCH = "Genauer Suchtreffer",
	TALENTSSEARCH_TOOLTIP_MATCH = "Suchtreffer",
	TALENTSSEARCH_TOOLTIP_NOT_ON_ACTIONBAR = "Nicht in der Aktionsleiste",
	TALENTSSEARCH_TOOLTIP_ON_DISABLED_ACTIONBAR = "In einer deaktivierten Aktionsleiste",
	TALENTSSEARCH_TOOLTIP_ON_INACTIVE_BONUSBAR = "In einer Aktionsleiste einer anderen Haltung",
	TALENTSSEARCH_TOOLTIP_RELATED_MATCH = "Verwandt mit dem gesuchten Talent",

	-- TargetFrame.lua
	TARGETFRAME_EDIT_LABEL = "Zielfenster",

	-- Taxi.lua
	TAXI_TITLE = "Flugkarte",

	-- Titles.lua
	TITLES_DEBUG_ABSENT = "fehlt",
	TITLES_DEBUG_HIDDEN = "verborgen",
	TITLES_DEBUG_SUMMARY = "Titel: %d bekannt + Keiner, getragen=%s, Versatz=%d, %d passende Zeile(n)",
	TITLES_DEBUG_VISIBLE = "SICHTBAR",

	-- TokensTab.lua
	TOKENSTAB_DEBUG_CLIENT = "Client: selectedToken=%s selectedID=%s | Fenster=%s",
	TOKENSTAB_DEBUG_ROW = "   %2d %-28s %s Anzahl=%-8s speziell=%-4s beobachtet=%-5s unbenutzt=%s",
	TOKENSTAB_DEBUG_SUMMARY = "Abzeichen: %d in der Liste, Versatz %d, %d platziert, ausgewählt=%s",

	-- TotemBar.lua
	TOTEMBAR_EDIT_LABEL = "Totemleiste",

	-- TotemFrame.lua
	TOTEMFRAME_EDIT_LABEL = "Totems",

	-- TradeSkill.lua
	TRADESKILL_CHECK_ALL = "Alle auswählen",
	TRADESKILL_CREATE_ALL_FORMAT = "%s [%d]",
	TRADESKILL_FILTER_SKILL_UP = "Fertigkeitsanstieg möglich",
	TRADESKILL_FILTER_SLOTS = "Plätze",
	TRADESKILL_NAME_RANK = "%s %d/%d",
	TRADESKILL_NAME_RANK_MODIFIER = "%s %d (|cff20ff20+%d|r ) /%d",
	TRADESKILL_NO_RESULTS = "Mit Euren aktuellen Filtern gibt es keine Ergebnisse.",
	TRADESKILL_REAGENT_COUNT = "%s/%d",
	TRADESKILL_SKILL_UP_EASY = "Geringe Chance auf Fertigkeitsanstieg",
	TRADESKILL_SKILL_UP_MEDIUM = "Hohe Chance auf Fertigkeitsanstieg",
	TRADESKILL_SKILL_UP_OPTIMAL = "Garantierter Anstieg um %d Fertigkeitspunkt(e)",
	TRADESKILL_UNCHECK_ALL = "Alle abwählen",

	-- Trainer.lua
	TRAINER_RANK = "%d/%d",
	TRAINER_RANK_BONUS = "%d |cff20ff20(+%d)|r/%d",

	-- Vehicle.lua
	VEHICLE_EDIT_LABEL = "Fahrzeugsitze",

	-- WorldMap.lua
	WORLDMAP_CURSOR_COORDS = "Mauszeiger: %d, %d",
	WORLDMAP_DEBUG_BREADCRUMB = "Navigationspfad: ",
	WORLDMAP_DEBUG_DETAIL = "Karte %.0f x %.0f bei Interfaceskalierung %.4f -> %.1f x %.1f",
	WORLDMAP_DEBUG_FLOORS = "Ebenen: %d | aufgebaut: %s | Bereich: %s",
	WORLDMAP_DEBUG_FRAME = "Weltkarte: %.0f x %.0f bei Skalierung %.4f, Modus %s (Client-Größe %.4f, kleines Fenster %.4f)",
	WORLDMAP_DEBUG_LANDMARK = "Orientierungspunkt %d: %s (%s) Symbol %s, Link %s, Instanzkarte %s",
	WORLDMAP_DEBUG_MISSING = "Weltkarte: fehlt.",
	WORLDMAP_DEBUG_MODE_FULLSCREEN = "Vollbild",
	WORLDMAP_DEBUG_MODE_WINDOWED = "Fenster",
	WORLDMAP_DEBUG_MOVABLE = "verschiebbar: %s (advancedWorldMap %s, Sperre %s)",
	WORLDMAP_DEBUG_NO_ATLAS = "Weltkarte: AtlasUtil.lua fehlt, nichts wird gestaltet.",
	WORLDMAP_DEBUG_NO_FRAME = "Weltkarte: dem Client fehlt WorldMapFrame.",
	WORLDMAP_DEBUG_WORLD_REFUSED = "Weltkarte: \"Welt\" vom Client abgelehnt (Karte %s, Kontinent %s, Zone %s, Ebene %s, Herauszoomen %s)",
	WORLDMAP_FILTER_SHOW = "Anzeigen:",
	WORLDMAP_PLAYER_COORDS = "Spieler: %d, %d",
	WORLDMAP_TITLE = "Karte & Questlog",
	WORLDMAP_WORLD = "Welt",
})
