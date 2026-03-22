# color_lib

Shared color token parsing and rendering for mods, including Minecraft Bukkit color coding.

Primary supported tokens:
- `&0`..`&9`, `&a`..`&f`, `&r` (Bukkit/Minecraft legacy)
- section-sign form: `\u00A70`..`\u00A79`, `\u00A7a`..`\u00A7f`, `\u00A7r`

Also available (advanced): HEX token rendering (`&#RRGGBB`, `&#RRGGBB;`, `<&#RRGGBB>`, `<&#RRGGBB;>`).

## Main APIs
- `color_lib.render_bukkit_text(raw, opts)`
- `color_lib.render_minecraft_hex_text(raw, opts)`

Returns: `rendered, stored, err, visible`

## Bukkit Example
```lua
local C = rawget(_G, "color_lib")

local raw = "&dHello &fworld"
local rendered, _, err = C.render_bukkit_text(raw, {
    trim = false,
    allow_newlines = false,
    append_white = true,
})

if err then
    minetest.chat_send_player(name, minetest.colorize("#ff7777", err))
    return
end
minetest.chat_send_player(name, rendered)
```

## HEX Example
```lua
local C = rawget(_G, "color_lib")

local raw = "&#7DF9FF[Server] &#FFFFFFWelcome!"
local rendered, _, err = C.render_minecraft_hex_text(raw, {
    trim = false,
    allow_newlines = false,
    append_white = true,
})

if err then
    minetest.chat_send_player(name, minetest.colorize("#ff7777", err))
    return
end
minetest.chat_send_player(name, rendered)
```
