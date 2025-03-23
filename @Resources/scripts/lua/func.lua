function Initialize()
    for i = 1, 7 do
        local color = SKIN:GetVariable('History_Color' .. i)
        if color == nil or color == '' then
            SKIN:Bang('!HideMeter', 'History_Ellipse_Color_' .. i)
            -- print('History_Ellipse_Color_' .. i .. ' will be hidden')
        end
    end
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end

function hotkey()
    local isShowSkin = SKIN:GetMeasure('mToggle'):GetValue()
    -- print(isShowSkin)

    if isShowSkin == 0 then
        SKIN:Bang('!UpdateMeasure', 'mToggleSet')
    end
    behaviour()

end

function trim(Text, Match, Replace)
    return Text:gsub(Match, Replace)
end

function DropDown(variant, handler, offsetx, offsety)
    local saveLocation = SKIN:GetVariable('ROOTCONFIGPATH') .. 'DropDown\\Main.ini'
    local MyMeter = SKIN:GetMeter(handler)
    local scale = tonumber(SKIN:GetVariable('Scale'))
    local PosX = SKIN:GetX() + MyMeter:GetX() + offsetx * scale
    local PosY = SKIN:GetY() + MyMeter:GetY() + offsety * scale
    SKIN:Bang('[!WriteKeyValue Variables variants ' .. variant .. ' "' .. saveLocation .. '"]')
    SKIN:Bang('!ZPos', '0')
    SKIN:Bang('!Activateconfig', 'ModernPicker\\DropDown', 'Main.ini')
    SKIN:Bang('!Move', PosX, PosY, 'ModernPicker\\DropDown')
end

function behaviour()
    local behaviour = SKIN:GetVariable('Behaviour')
    if behaviour == 'PE' or behaviour == 'P' then
        SKIN:Bang('!CommandMeasure', 'YourPicker', '-mp')
        SKIN:Bang('!UpdateMeter', '*')
        SKIN:Bang('!Redraw')
    elseif behaviour == 'E' then
        SKIN:Bang('!UpdateMeasure', 'mToggle')

    end
end

function pickerBehaviour()
    local behaviour = SKIN:GetVariable('Behaviour')
    if behaviour ~= 'P' then
        SKIN:Bang('!UpdateMeasure', 'mToggle')
    end
end
