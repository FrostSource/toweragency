
print("Broken tv activated")
--thisEntity:RedirectOutput("OnPlayerPickup", "OnPlayerPickup", thisEntity)

--function OnPlayerPickup()
--    print("Broken tv has been picked up")
--    DoEntFire("ending_tv_picked_up", "Trigger", "", 0, nil, nil)
--    thisEntity:DisconnectRedirectedOutput("OnPlayerPickup", "OnPlayerPickup", thisEntity)
--end

--function Particles(data)
    --local tv = data.activator
    local target = SpawnEntityFromTableSynchronous("info_target", {})
    target:SetForwardVector(thisEntity:GetRightVector() * -1)
    target:SetParent(thisEntity, "")
    target:SetLocalOrigin(Vector(0,-6,6))
    local p = ParticleManager:CreateParticle("particles/creatures/blind_zombie/blind_zombie_vomit_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(p, 1, target, PATTACH_ABSORIGIN, "", Vector(0,0,0), false)
    --ParticleManager:SetParticleControlForward(p, 1, tv:GetRightVector() * -1)
    thisEntity:SetHealth(9999)
--end
