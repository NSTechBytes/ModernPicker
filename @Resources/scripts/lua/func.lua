function Initialize()
    for i = 1, 6 do
        local color = SKIN:GetVariable('History_Color' .. i)
        if color == nil or color == '' then
            SKIN:Bang('!HideMeter', 'History_Ellipse_Color_' .. i)
            --print('History_Ellipse_Color_' .. i .. ' will be hidden')
        end
    end
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')  
end



function trim(Text, Match, Replace)
	return Text:gsub(Match, Replace)
end




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
	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')

    -- Print the converted values
    print("Hex:" .. hex)
    print("RGB: rgb(" .. math.floor(r * 255) .. ", " .. math.floor(g * 255) .. ", " .. math.floor(b * 255) .. ")")
    print("HSL: hsl(" .. hslH .. ", " .. hslS .. "%, " .. hslL .. "%)")
    print("HSV: hsv(" .. hsvH .. ", " .. hsvS .. "%, " .. hsvV .. "%)")
    print("HSI: hsi(" .. hsiH .. ", " .. hsiS .. "%, " .. hsiI .. "%)")

    return {
        Hex = "#" .. hex,
        RGB = string.format("rgb(%d, %d, %d)", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)),
        HSL = string.format("hsl(%d, %d%%, %d%%)", hslH, hslS, hslL),
        HSV = string.format("hsv(%d, %d%%, %d%%)", hsvH, hsvS, hsvV),
        HSI = string.format("hsi(%d, %d%%, %d%%)", hsiH, hsiS, hsiI)
    }
end



-- All-in-one function to generate a single palette from a given hex color
function generatePalette(hex)
    -- Remove # from hex if present
    hex = hex:gsub("#", "")

    -- Utility function to clamp values between 0 and 255
    local function clamp(value)
        return math.max(0, math.min(255, value))
    end

    -- Function to convert hex to RGB
    local function hexToRGB(hex)
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        return r, g, b
    end

    -- Function to convert RGB to hex
    local function rgbToHex(r, g, b)
        return string.format("%02X%02X%02X", clamp(r), clamp(g), clamp(b))
    end

    -- Function to generate a lighter or darker shade
    local function shadeColor(r, g, b, factor)
        return clamp(r + factor), clamp(g + factor), clamp(b + factor)
    end

    -- Determine the dominant color component (red, green, blue, or gray)
    local function dominantColor(r, g, b)
        if r == g and g == b then
            return "gray"
        elseif r >= g and r >= b then
            return "red"
        elseif g >= r and g >= b then
            return "green"
        else
            return "blue"
        end
    end

    -- Generate shades based on dominant color
    local function generateShades(r, g, b, factor)
        local shades = {}
        for i = -2, 2 do
            local adjustment = factor * i
            local nr, ng, nb = shadeColor(r, g, b, adjustment)
            table.insert(shades, rgbToHex(nr, ng, nb))
        end
        return shades
    end

    -- Convert hex to RGB
    local r, g, b = hexToRGB(hex)
    local domColor = dominantColor(r, g, b)

    -- Generate shades based on the dominant color
    local palette
    if domColor == "gray" then
        palette = generateShades(r, g, b, 20)  -- Gray shades
    elseif domColor == "red" then
        palette = generateShades(r, g, b, 40)  -- Red shades
    elseif domColor == "green" then
        palette = generateShades(r, g, b, 40)  -- Green shades
    else
        palette = generateShades(r, g, b, 40)  -- Blue shades
    end

    -- Print the palette and set variables in Rainmeter
    for i, color in ipairs(palette) do
        local varName = "Palettes_Color" .. i
        local meterName = "Palettes_Color" .. i
        print(varName .. ": " .. color)
    
        -- Set the variable and write it to the skin file
        SKIN:Bang("!SetVariable", varName, color)
        SKIN:Bang("!WriteKeyValue", "Variables", varName, color)
    
        -- Construct the SKIN:Bang command as a string and print it
        --local command = string.format('!SetOption %s This "FillColor %s"', meterName, color)
        --print(command)
        
    
        -- Execute the actual SKIN:Bang command
        SKIN:Bang("!SetOption", meterName, "This", "FillColor " .. color)
        SKIN:Bang("!UpdateMeter", meterName)
        SKIN:Bang("!Redraw")
    end
    
    

    -- Update all meters and redraw after setting variables
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end
