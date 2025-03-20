function convertColor(hex)
    -- Remove the "#" from the hex string
    hex = hex:gsub("#", "")

    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255

    local max, min = math.max(r, g, b), math.min(r, g, b)
    local d = max - min
    local h, s, l, v, i = 0, 0, (max + min) / 2, max, (r + g + b) / 3

    -- HSL
    if max ~= min then
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    local hslH, hslS, hslL = math.floor(h * 360), math.floor(s * 100), math.floor(l * 100)

    -- HSV
    s = max == 0 and 0 or d / max
    local hsvH, hsvS, hsvV = math.floor(h * 360), math.floor(s * 100), math.floor(v * 100)

    -- HSI
    local minColor = math.min(r, g, b)
    local saturation = i == 0 and 0 or (1 - (minColor / i))
    local num = 0.5 * ((r - g) + (r - b))
    local den = math.sqrt((r - g) * (r - g) + (r - b) * (g - b))
    local theta = den == 0 and 0 or math.acos(num / den)
    if b > g then h = 360 - math.deg(theta) else h = math.deg(theta) end
    local hsiH, hsiS, hsiI = math.floor(h), math.floor(saturation * 100), math.floor(i * 100)

    -- Set Rainmeter variables
	SKIN:Bang("!SetVariable", "Hex", hex)
    SKIN:Bang("!SetVariable", "RGB", string.format("rgb(%d, %d, %d)", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)))
    SKIN:Bang("!SetVariable", "HSL", string.format("hsl(%d, %d%%, %d%%)", hslH, hslS, hslL))
    SKIN:Bang("!SetVariable", "HSV", string.format("hsv(%d, %d%%, %d%%)", hsvH, hsvS, hsvV))
    SKIN:Bang("!SetVariable", "HSI", string.format("hsi(%d, %d%%, %d%%)", hsiH, hsiS, hsiI))
    SKIN:Bang("!WriteKeyValue","Variables", "Hex", hex)
    SKIN:Bang("!WriteKeyValue","Variables", "RGB", string.format("rgb(%d, %d, %d)", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)))
    SKIN:Bang("!WriteKeyValue","Variables", "HSL", string.format("hsl(%d, %d%%, %d%%)", hslH, hslS, hslL))
    SKIN:Bang("!WriteKeyValue","Variables", "HSV", string.format("hsv(%d, %d%%, %d%%)", hsvH, hsvS, hsvV))
    SKIN:Bang("!WriteKeyValue","Variables", "HSI", string.format("hsi(%d, %d%%, %d%%)", hsiH, hsiS, hsiI))
	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')

    -- Print the converted values
    --print("Hex:" .. hex)
    --print("RGB: rgb(" .. math.floor(r * 255) .. ", " .. math.floor(g * 255) .. ", " .. math.floor(b * 255) .. ")")
    --print("HSL: hsl(" .. hslH .. ", " .. hslS .. "%, " .. hslL .. "%)")
    --print("HSV: hsv(" .. hsvH .. ", " .. hsvS .. "%, " .. hsvV .. "%)")
    --print("HSI: hsi(" .. hsiH .. ", " .. hsiS .. "%, " .. hsiI .. "%)")

    return {
        Hex = "#" .. hex,
        RGB = string.format("rgb(%d, %d, %d)", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)),
        HSL = string.format("hsl(%d, %d%%, %d%%)", hslH, hslS, hslL),
        HSV = string.format("hsv(%d, %d%%, %d%%)", hsvH, hsvS, hsvV),
        HSI = string.format("hsi(%d, %d%%, %d%%)", hsiH, hsiS, hsiI)
    }
end