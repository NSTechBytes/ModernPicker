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

function hotkey()
    local isShowSkin = SKIN:GetMeasure('mToggle'):GetValue()
    print(isShowSkin)

    if isShowSkin == 0 then 
        SKIN:Bang('!UpdateMeasure', 'mToggleSet')
    end

    SKIN:Bang('!CommandMeasure', 'YourPicker', '-mp')
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')  
end


function trim(Text, Match, Replace)
	return Text:gsub(Match, Replace)
end




