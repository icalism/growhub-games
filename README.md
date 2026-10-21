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
      "version": "1.0.0",
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

Optional `UI = function(parent, ctx)` mounts a panel in the Games tab. Build it with
`ctx.ui` (GrowHub's own components) so it looks like the rest of the hub:

```lua
UI = function(parent, ctx)
    local ui = ctx.ui
    local left, right = ui.columns()                         -- 2 scrolling columns
    local sec = ui.section(left, "zap", "MY SECTION")        -- lucide icon + title, auto height
    local setOn = ui.toggle(sec, "Feature", false, function(v) end)   -- setOn(v, silent)
    ui.slider(sec, "Range", 8, 24, 16, " st", function(v) end)
    ui.select(sec, "Mode", { "Off", "On" }, getFn, setFn)
    local setStat = ui.stat(sec, "heart", "Health")          -- setStat(text, color?)
    local box = ui.block(sec, 120)                           -- empty frame for custom content
end,
```

`ctx` also has `Theme`, `setFont`, `corner`, `addStroke`, `tween`, `setLucide`, `notify`.

The hub calls `Stop()` on the previous game before loading another one.
The script should start itself on load — the hub does not call `Start()`.

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
https://raw.githubusercontent.com/icalism/growhub-games/main/
```

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
