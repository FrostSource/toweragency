
function Activate()
    thisEntity:RegisterAnimTagListener( AnimTagListener )
end

function AnimTagListener( sTagName, nStatus )
	--print( " AnimTag: ", sTagName, " Status: ", nStatus )
    if sTagName == 'Finished_ThrowGrenade' then
        thisEntity:SetThink(function()
            KillGrenade()
            DoEntFireByInstanceHandle(thisEntity,'SetAllowedToThrowGrenades','0',0,nil,nil)
        end, 'delay', 0.5)
    end
    if sTagName == 'finished_stagger' then
        DoEntFireByInstanceHandle(thisEntity, 'FireUser2', '', 0, nil, nil)
    end
end

function KillGrenade()
    local ents = thisEntity:GetChildren()
    for _,ent in ipairs(ents) do
        if ent:GetClassname() == 'item_hlvr_grenade_frag' then
            ent:Kill()
            break
        end
    end
end

function InitItemAlarm()
    print('Finding combine items')
    local children = thisEntity:GetChildren()
    for _,child in ipairs(children) do
        if child:GetClassname() == 'item_hlvr_grenade_frag' then
            print('FOUND combine grenade, redirecting output')
            child:RedirectOutput('OnPlayerPickup', 'OnItemPickupAlarm', thisEntity)
            --thisEntity:RedirectOutput('OnPlayerPickup', 'OnGrenadePickupAlarm', ent)
        elseif child:GetClassname() == 'item_hlvr_clip_energygun' then
            print('FOUND combine ammo, redirecting output')
            child:RedirectOutput('OnPlayerPickup', 'OnItemPickupAlarm', thisEntity)
        end
    end
end

function OnItemPickupAlarm()
    print('OnItemPickupAlarm called')
    DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end
function OnGrenadePickupAlarm2()
print('OnGrenadePickupAlarm2 called')
DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end