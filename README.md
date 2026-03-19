# color_lib

What it does:
- Parses HEX color tokens from text input.
- Strips HEX tokens to get visible/plain text.
- Renders tokens into Minetest color escape sequences.
- Provides one shared API so holograms, signs, rename tokens, gang styling, and other features stay consistent.

Supported token formats:
- `&#RRGGBB`
- `&#RRGGBB;`
- `<&#RRGGBB>`
- `<&#RRGGBB;>`
- `#RRGGBB` (parse helper support)

Global API:
- `color_lib.read_hex_token(input, index, opts)`
- `color_lib.parse_minecraft_hex_color(raw, opts)`
- `color_lib.strip_minecraft_hex_tokens(raw, opts)`
- `color_lib.render_minecraft_hex_text(raw, opts)`

