function updateHistory()
    -- Get the picked color from the measure
    local newColor = SKIN:GetMeasure("YourPicker"):GetStringValue()
    local saveLocation = SKIN:GetVariable('@')..'vars.nek'

    -- Get previous colors from variables
    local history = {}
    for i = 1, 6 do
        history[i] = SKIN:GetVariable("History_Color" .. i, "#FFFFFF")
    end

    -- Shift colors down
    for i = 6, 2, -1 do
        history[i] = history[i - 1]
    end
    history[1] = newColor

    -- Update variables and write to the skin
    for i = 1, 6 do
        SKIN:Bang('!SetVariable', "History_Color" .. i, history[i])
        SKIN:Bang('!WriteKeyValue', 'Variables', "History_Color" .. i, history[i],saveLocation)
    end

    -- Apply colors to ellipse meters
    for i = 1, 6 do
        SKIN:Bang('!SetOption', "History_Ellipse_Color_" .. i, "This" , "FillColor" .. history[i])
    end

    -- Refresh the skin meters
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end
