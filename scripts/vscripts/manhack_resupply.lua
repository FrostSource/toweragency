
function SpawnAmmoOnDeath()
    --print('spawn ammo');
    local ammo = SpawnEntityFromTableSynchronous('item_hlvr_clip_energygun',{
        origin = thisEntity:GetOrigin(),
    });
    local velocityMax = 200;
    local velocity = Vector(RandomFloat(-1,1)*velocityMax, RandomFloat(-1,1)*velocityMax, RandomFloat(0.5,1)*velocityMax);
    ammo:ApplyAbsVelocityImpulse(velocity);
    ammo:ApplyLocalAngularVelocityImpulse(velocity);
    --print(velocity, ammo);
end
