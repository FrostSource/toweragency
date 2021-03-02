
AmountToFadePerFrame = 1 / 300
TargetFadeValue = 0
CurrentFadeValue = 1

function FadeFog()
    thisEntity:SetThink(FadeThink, 'FadeThink', 0)
end

function FadeThink()
    CurrentFadeValue = CurrentFadeValue - AmountToFadePerFrame
    DoEntFireByInstanceHandle(thisEntity, 'SetFogMaxOpacity', CurrentFadeValue..'', 0, nil, nil)
    if CurrentFadeValue <= TargetFadeValue then
        DoEntFireByInstanceHandle(thisEntity, 'Kill', '', 0, nil, nil)
        return
    end
    return 0
end
