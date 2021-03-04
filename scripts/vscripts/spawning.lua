
local ItemPool = {
    -- 1st floor (base)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        { class = 'item_hlvr_clip_energygun_multiple', weight = 0.1 },
        { class = 'item_healthvial', weight = 0.5 },
        { class = 'item_hlvr_grenade_frag', weight = 0.02 },
    },
    -- 2nd floor (damaged)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        { class = 'item_hlvr_clip_energygun_multiple', weight = 0.1 },
        { class = 'item_healthvial', weight = 0.5 },
        { class = 'item_hlvr_grenade_frag', weight = 0.02 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.6 },
        { class = 'item_hlvr_clip_shotgun_multiple', weight = 0.1 },
    },
    -- 3rd floor (construction)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        { class = 'item_hlvr_clip_energygun_multiple', weight = 0.1 },
        { class = 'item_healthvial', weight = 0.5 },
        { class = 'item_hlvr_grenade_frag', weight = 0.02 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.6 },
        { class = 'item_hlvr_clip_shotgun_multiple', weight = 0.1 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.5 },
    },
    -- 4th floor (white arena)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        { class = 'item_hlvr_clip_energygun_multiple', weight = 0.15 },
        { class = 'item_healthvial', weight = 0.6 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.7 },
        { class = 'item_hlvr_clip_shotgun_multiple', weight = 0.15 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.5 },
    },
}

function GetItemWeightTotal(index)
    local weight_sum = 0
    for _,v in ipairs(ItemPool[index]) do
        weight_sum = weight_sum + v.weight
    end
    return weight_sum
end

function GetRandomItem(index)
    local weight_sum = GetItemWeightTotal(index)
    local weight_remaining = RandomFloat(0, weight_sum)
    for _,v in ipairs(ItemPool[index]) do
        weight_remaining = weight_remaining - v.weight
        if weight_remaining < 0 then
            return v.class
        end
    end
end

--local function ends_with(str, ending)
--    return ending == "" or str:sub(-#ending) == ending
--end

function SpawnItems(target_name, amount, index)
    local targets = Entities:FindAllByName(target_name..'*')
    if #targets == 0 then
        print('Attempt to spawn ammo - No target entity found!')
        return
    end

    for i=0,amount do
        -- Grab a random target
        if #targets == 0 then
            print('Attempt to spawn ammo - Ran out of targets! '..(amount -  i)..' left.')
            return
        end
        local pos = RandomInt(1,#targets)
        local target = targets[pos]
        table.remove(targets, pos)

        local class = GetRandomItem(index)

        -- Which ammo does this target spawn?
        --local kind = 'item_hlvr_clip_energygun'
        --if ends_with(target:GetName(), 'shotgun') then kind = 'item_hlvr_clip_shotgun_single'
        --elseif ends_with(target:GetName(), 'rapidfire') then kind = 'item_hlvr_clip_rapidfire'
        --elseif ends_with(target:GetName(), 'healthpen') then kind = 'item_healthvial'
        --end

        -- Spawn the ammo with random angles
        SpawnEntityFromTableSynchronous(class, {
            origin = target:GetOrigin(),
            angles = RandomInt(0,359)..' '..RandomInt(0,359)..' '..RandomInt(0,359)
        })
        -- spawn second shotgun ammo
        if class == 'item_hlvr_clip_shotgun_single' then
            SpawnEntityFromTableSynchronous(class, {
                origin = target:GetOrigin(),
                angles = RandomInt(0,359)..' '..RandomInt(0,359)..' '..RandomInt(0,359)
            })
        end
    end
end

function SpawnKeycard(target_name, keycard_name, keycard_color, keycard_skin)
    keycard_color = keycard_color or '255 255 255'
    keycard_skin = keycard_skin or 'default'

    local targets = Entities:FindAllByName(target_name)
    print('Found',#targets,'with name',target_name)
    if #targets == 0 then
        print('Attempt to spawn keycard - No target entity found!')
        return
    end

    -- Grab a random target
    local rnd = RandomInt(1,#targets)
    print('chose',rnd)
    local target = targets[rnd]

    -- Spawn keycard
    SpawnEntityFromTableSynchronous('prop_physics', {
        origin = target:GetOrigin(),
        angles = RandomInt(0,120)..' '..RandomInt(0,120)..' '..RandomInt(0,120),

        damagefilter = '@filter_damage_keycard',
        targetname = keycard_name,
        model = 'models/props/misc/keycard_001.vmdl',
        skin = keycard_skin,
        rendercolor = keycard_color..' 255',
        CanDepositInItemHolder = '1'
    })
    debugoverlay:Sphere(target:GetOrigin(), 16, 0, 255, 0, 255, true, 60)
end

