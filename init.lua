local C = rawget(_G, "color_lib")
if type(C) ~= "table" then
    C = {}
    rawset(_G, "color_lib", C)
end
if C._module_loaded then
    return
end
C._module_loaded = true

local function trim(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function set_case(hex, mode)
    if mode == "upper" then
        return tostring(hex):upper()
    end
    return tostring(hex):lower()
end

function C.read_hex_token(input, index, opts)
    input = tostring(input or "")
    index = math.max(1, math.floor(tonumber(index) or 1))
    opts = type(opts) == "table" and opts or {}

    local allow_plain_hash = opts.allow_plain_hash == true
    local out_case = opts.case == "upper" and "upper" or "lower"

    if allow_plain_hash then
        local t7 = input:sub(index, index + 6)
        local h7 = t7:match("^#([%x][%x][%x][%x][%x][%x])$")
        if h7 then
            return set_case("#" .. h7, out_case), 7
        end
    end

    local t8 = input:sub(index, index + 7)
    local h8 = t8:match("^&#([%x][%x][%x][%x][%x][%x])$")
    if h8 then
        return set_case("#" .. h8, out_case), 8
    end

    local t9 = input:sub(index, index + 8)
    local h9 = t9:match("^&#([%x][%x][%x][%x][%x][%x]);$")
    if h9 then
        return set_case("#" .. h9, out_case), 9
    end

    local t10 = input:sub(index, index + 9)
    local h10 = t10:match("^<&#([%x][%x][%x][%x][%x][%x])>$")
    if h10 then
        return set_case("#" .. h10, out_case), 10
    end

    local t11 = input:sub(index, index + 10)
    local h11 = t11:match("^<&#([%x][%x][%x][%x][%x][%x]);>$")
    if h11 then
        return set_case("#" .. h11, out_case), 11
    end

    return nil, 0
end

function C.parse_minecraft_hex_color(raw, opts)
    opts = type(opts) == "table" and opts or {}
    local input = trim(raw)
    if input == "" then
        return nil
    end

    local plain = input:match("^#([%x][%x][%x][%x][%x][%x])$")
    if plain then
        return "#" .. plain:lower()
    end

    local i = 1
    while i <= #input do
        local hex, step = C.read_hex_token(input, i, {
            allow_plain_hash = opts.allow_plain_hash == true,
            case = "lower",
        })
        if hex then
            return hex
        end
        i = i + 1
    end
    return nil
end

function C.strip_minecraft_hex_tokens(raw, opts)
    opts = type(opts) == "table" and opts or {}
    local input = tostring(raw or "")
    local out = {}
    local i = 1
    while i <= #input do
        local _, step = C.read_hex_token(input, i, {
            allow_plain_hash = opts.strip_plain_hash == true,
            case = "lower",
        })
        if step > 0 then
            i = i + step
        else
            out[#out + 1] = input:sub(i, i)
            i = i + 1
        end
    end
    return table.concat(out)
end

function C.render_minecraft_hex_text(raw, opts)
    opts = type(opts) == "table" and opts or {}
    local input = tostring(raw or "")
    if opts.trim ~= false then
        input = trim(input)
    end
    if opts.allow_newlines ~= true then
        input = input:gsub("[\r\n\t]", " ")
    end
    if input == "" then
        return nil, nil, "Text cannot be empty.", ""
    end

    local visible = C.strip_minecraft_hex_tokens(input, {
        strip_plain_hash = opts.strip_plain_hash == true,
    })
    local visible_trimmed = trim(visible)
    if visible_trimmed == "" then
        return nil, nil, "Text cannot be empty.", visible_trimmed
    end

    local max_visible = tonumber(opts.max_visible)
    if max_visible and max_visible > 0 and #visible_trimmed > math.floor(max_visible) then
        return nil, nil, "Text too long. Max " .. tostring(math.floor(max_visible)) .. " visible characters.", visible_trimmed
    end

    local out = {}
    local i = 1
    while i <= #input do
        local hex, step = C.read_hex_token(input, i, {
            allow_plain_hash = opts.convert_plain_hash == true,
            case = "lower",
        })
        if hex then
            out[#out + 1] = minetest.get_color_escape_sequence(hex)
            i = i + step
        else
            out[#out + 1] = input:sub(i, i)
            i = i + 1
        end
    end

    if opts.append_white ~= false then
        out[#out + 1] = minetest.get_color_escape_sequence("#ffffff")
    end
    return table.concat(out), input, nil, visible_trimmed
end

