
WaitingForFront = WaitingForFront or true
CurrentSkin = CurrentSkin or 0
MaxSkin = MaxSkin or 9

function Spawn()
    thisEntity:RedirectOutput('OnPlayerUse', 'StartDetecting', thisEntity)
    thisEntity:RedirectOutput('OnPhysGunDrop', 'StopDetecting', thisEntity)
end

function StartDetecting()
    thisEntity:StopThink('DetectSide')
    thisEntity:SetThink(DetectSide, 'DetectSide', 0)
end

function StopDetecting()
    thisEntity:StopThink('DetectSide')
end

function ChangeSide()
    CurrentSkin = CurrentSkin + 1
    thisEntity:SetSkin(CurrentSkin)
    WaitingForFront = not WaitingForFront
end

function DetectSide()
    local playerForward = Entities:GetLocalPlayer():GetHMDAvatar():GetForwardVector()
    local up = thisEntity:GetUpVector()

    local dot = up:Dot(playerForward)

    
    --debugoverlay:Sphere(thisEntity:GetOrigin(), dot*2, 0, 255, 0, 255, true, 0.01)

    if WaitingForFront then
        if dot < -0.5 then
            ChangeSide()
            --debugoverlay:Sphere(thisEntity:GetOrigin(), 4, 255, 0, 0, 255, true, 2)
        end
    else
        if dot > 0.5 then
            ChangeSide()
            --debugoverlay:Sphere(thisEntity:GetOrigin(), 4, 0, 0, 255, 255, true, 2)
        end
    end

    if CurrentSkin >= MaxSkin then
        DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
        return
    end

    return 0
end

