
function PopDoorHandles()
    local handles = Entities:FindAllByClassnameWithin('prop_animinteractable',thisEntity:GetOrigin(),100);
    for _,handle in ipairs(handles) do
        if handle:GetModelName() == 'models/interaction/anim_interact/doorhandle/doorhandle.vmdl' then
            DoEntFireByInstanceHandle(handle,'TurnIntoPhysicsProp','',0,nil,nil);
            handle:ApplyAbsVelocityImpulse(Vector(RandomInt(-5,5),RandomInt(-5,5),RandomInt(-5,5)));
        end
    end
end

function AttachHand()
    local id = Convars:GetBool('hlvr_left_hand_primary') and 1 or 0;
    local hand = Entities:GetLocalPlayer():GetHMDAvatar():GetVRHand(id);
    thisEntity:SetParent(hand, '');
    thisEntity:SetLocalAngles(0, 180, 0);
    if id == 0 then
        thisEntity:SetLocalOrigin(Vector(-3, -4, -0.2));
    else
        thisEntity:SetLocalOrigin(Vector(-3, 4, -0.2));
    end
end

function Func() print('hi') DoEntFire('@chamber_pulled','Trigger','',0,nil,nil) end
local gun = Entities:FindByClassnameNearest('hlvr_weapon_energygun', Entities:GetLocalPlayer():GetOrigin(), 256)
print(gun:GetClassname(),gun:GetName())
gun:RedirectOutput('OnSlidePulled', 'Func', thisEntity)