
function Activate()
    thisEntity:RegisterAnimTagListener( AnimTagListener )
end

function AnimTagListener( sTagName, nStatus )
	--print( " AnimTag: ", sTagName, " Status: ", nStatus )
    --if sTagName == 'Finished_ThrowGrenade' then
    --    KillGrenade()
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

function InitGrenadeAlarm()
    print('Finding combine grenade')
    local ents = thisEntity:GetChildren()
    for _,ent in ipairs(ents) do
        if ent:GetClassname() == 'item_hlvr_grenade_frag' then
            print('FOUND combine grenade, redirecting output')
            ent:RedirectOutput('OnPlayerPickup', 'OnGrenadePickupAlarm', thisEntity)
            thisEntity:RedirectOutput('OnPlayerPickup', 'OnGrenadePickupAlarm', ent)
            break
        end
    end
end

function OnGrenadePickupAlarm()
    print('OnGrenadePickupAlarm called')
    DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end
function OnGrenadePickupAlarm2()
print('OnGrenadePickupAlarm2 called')
DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end