# mod-forever-ui

The modern World of Warcraft interface (the "camelot" client), rebuilt for a 3.3.5a client: an addon, its art, the login screens, and a small server part for the statistics.

## Key features

- Unit frames, bars, minimap, chat, tooltips, buffs, quest tracker: the whole screen in the modern look.
- Nearly every window: bags, character sheet, spellbook, talents, map and quest log, social, group finder, auction house, mail, professions, barber...
- The login screens: login, character select and creation, realm list, AddOns list.
- Customize UI: move and resize every element on a grid, with snapping.
- With a server: 18 statistics of the modern client in the Statistics tab.
- Texts in English, French, German, Spanish and Russian.

## Dependencies

| Dependency | For |
|---|---|
| [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk) (WotLK 3.3.5a) | optional: the 18 statistics, only if you run the server |
| [mod-pvp-titles-ext](https://github.com/Adrestie/mod-pvp-titles-ext) | optional: rank thresholds and the Dishonored state in the PvP tab |

## How to install

1. Download `installer.exe` from the [WoW-mods-installer releases](https://github.com/Adrestie/WoW-mods-installer/releases).
2. Close the game, and stop the worldserver if you run it.
3. Run `installer.exe`, give it this folder and the game folder (and the worldserver and MySQL folders only if you run the server), click **Check**, then **Install**.
4. Start the game and check that **ForeverUI** is enabled in the AddOns list. Nothing to rebuild.
5. Optional: `tools/patcher/ForeverUIPatcher.exe` patches `Wow.exe` so that character creation and the barber list the choices by name.

## How to update

Same steps with the new version's folder, choosing **Update** instead of **Install**.

## How to uninstall

Same steps, choosing **Remove**. The `Wow.exe` patch is undone with `ForeverUIPatcher.exe` (**Restore**); the addon's settings stay in `WTF\Account\<account>\SavedVariables\ForeverUI.lua`.

## Commands

| Command | |
|---|---|
| `/fui` | Customize UI (also Esc > Customize UI, or `/foreverui`) |
| `/fui reset` | puts every element back to default |
