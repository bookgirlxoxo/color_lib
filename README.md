# color_lib

Shared HEX color token parsing and rendering for mods.

Supported tokens:
- `&#RRGGBB`
- `&#RRGGBB;`
- `<&#RRGGBB>`
- `<&#RRGGBB;>`

## Global API
- `color_lib.read_hex_token(input, index, opts)`
- `color_lib.parse_minecraft_hex_color(raw, opts)`
- `color_lib.strip_minecraft_hex_tokens(raw, opts)`
- `color_lib.render_minecraft_hex_text(raw, opts)`

## Chat Example
```lua
local C = rawget(_G, "color_lib")

local raw = "&#7DF9FF[Server] &#FFFFFFWelcome to the server!"
local rendered, stored, err, visible = C.render_minecraft_hex_text(raw, {
    trim = true,
    allow_newlines = false,
    max_visible = 120,
    append_white = true,
})

if err then
    minetest.chat_send_player(name, minetest.colorize("#ff7777", err))
    return
end
```

## Render Example
```lua
local C = rawget(_G, "color_lib")

local function render_or_error(player_name, raw, max_visible)
    if not C then
        return nil, "color_lib unavailable"
    end
    local rendered, _, err = C.render_minecraft_hex_text(raw, {
        max_visible = max_visible or 80,
        append_white = true,
    })
    if err then
        return nil, err
    end
    return rendered, nil
end
```