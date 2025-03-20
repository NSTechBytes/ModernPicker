function generatePalette(hex)
    -- Remove # from hex if present
    hex = hex:gsub("#", "")
    local saveLocation = SKIN:GetVariable('@')..'vars.nek'

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
        --print(varName .. ": " .. color)
    
        -- Set the variable and write it to the skin file
        SKIN:Bang("!SetVariable", varName, color)
        SKIN:Bang("!WriteKeyValue", "Variables", varName, color,saveLocation)
    
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
