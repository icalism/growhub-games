# GrowHub Games

Remote game scripts for GrowHub. One file per game, listed in `manifest.json`.
GrowHub only knows this manifest — adding a game never requires touching GrowHub again.

## Repo layout

```
growhub-games/
├── manifest.json
├── indovoice/
│   └── auto_fish.lua
└── README.md
```

## manifest.json

```json
{
  "name": "GrowHub Games",
  "updated": "2026-10-21",
  "games": [
    {
      "id": "indovoice",
      "name": "Indo Voice",
      "subtitle": "Auto Fish",
      "placeIds": [8356562067],
      "script": "indovoice/auto_fish.lua",
      "version": "1.1.1",
      "icon": "fish"
    }
  ]
}
```

| field | meaning |
|---|---|
| `id` | unique key, also used as the chunk name |
| `name` | shown in the Games tab |
| `subtitle` | small text under the name |
| `placeIds` | Roblox place ids where this script is relevant |
| `script` | path relative to the repo root |
| `version` | bump it to bust the raw cache (`?v=version`) |
| `icon` | lucide icon name (optional, not used yet) |

## Script contract

Every game script must leave a table in `getgenv().GrowGame`:

```lua
getgenv().GrowGame = {
    Id = "mygame_feature",
    Name = "My Game - Feature",
    Version = "1.0.0",
    Stop = function()
        -- stop loops / restore state
    end,
}
```

The hub calls `Stop()` on the previous game before loading another one.
The script should start itself on load — the hub does not call `Start()`.

## Game UI contract (optional)

Add a `UI` function and the hub mounts it as its own sub-tab inside the Games tab:

```lua
getgenv().GrowGame = {
    Id = "mygame_feature",
    Name = "My Game",
    Version = "1.1.0",
    UI = function(parent, ctx)
        -- build the panel inside `parent`
    end,
    Stop = function() end,
}
```

The hub calls `UI(parent, ctx)` after the chunk runs, adds a sub-tab named after
`GrowGame.Name`, and switches to it. `parent` is a full-size `Frame` inside the
Games tab. When the game is stopped or another game is loaded, the hub destroys
`parent` and removes the sub-tab.

`ctx` fields:

| field | meaning |
|---|---|
| `Theme` | GrowHub theme table (`TEXT_MAIN`, `TEXT_MUTED`, `CARD_BG`, `WIN_BG`, `NEON_GREEN`, `ACCENT_RED`, `BORDER_DIM`) |
| `setFont(obj, weight)` | applies the hub's Montserrat face (`"Medium"`, `"SemiBold"`, `"Bold"`) |
| `corner(obj, radius)` | adds a `UICorner` |
| `addStroke(obj, color, thickness, transparency)` | adds a `UIStroke` |
| `notify(text, icon)` | hub toast notification |
| `hub` | the GrowHub state table |
| `game` | the manifest entry being loaded |
| `panel` | same frame as `parent` |

A game without `UI` loads normally and shows no sub-tab.

Minimum template:

```lua
if getgenv().GrowGame and type(getgenv().GrowGame.Stop) == "function" then
    pcall(getgenv().GrowGame.Stop)
end

-- ... script body, starts itself ...

getgenv().GrowGame = {
    Id = "mygame_feature",
    Name = "My Game - Feature",
    Version = "1.0.0",
    Stop = function()
        getgenv()._myFeatureRunning = false
    end,
}
```

## Hosting

This repo is live at `icalism/growhub-games` (public). Raw base:

```
https://github.com/icalism/growhub-games/raw/refs/heads/main/
```

This redirects to raw.githubusercontent.com on the `refs/heads/main` path, which
does not serve the stale cache that the plain `/main/` path sometimes returns.

GrowHub's `Games.base` already points there. Verify:

```
https://raw.githubusercontent.com/icalism/growhub-games/main/manifest.json
https://raw.githubusercontent.com/icalism/growhub-games/main/indovoice/auto_fish.lua
```

If you fork or rename the repo, change `Games.base` in GrowHub's Games tab.

## Updating a script

1. Edit the file on GitHub (or push).
2. Bump `version` in `manifest.json` so `?v=` changes and the cache is bypassed.
3. In GrowHub press **REFRESH**, then **LOAD** again.

## Adding a game

1. Add `newgame/feature.lua` following the contract.
2. Add one entry to `manifest.json`.
3. Press **REFRESH** in GrowHub. Done — no GrowHub edit.
