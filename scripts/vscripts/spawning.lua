
local ItemPool = {
    -- 1st floor (base)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        --{ class = 'item_hlvr_clip_energygun_multiple', weight = 0.09, max = 1 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.7, max = 14 },
        { class = 'item_healthvial', weight = 0.2, max = 2 },
        { class = 'item_hlvr_grenade_frag', weight = 0.05, max = 1 },
    },
    -- 2nd floor (damaged)
    {
        { class = 'item_hlvr_clip_energygun', weight = 0.95 },
        --{ class = 'item_hlvr_clip_energygun_multiple', weight = 0.09, max = 1 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.7, max = 7 },
        { class = 'item_hlvr_clip_shotgun_pair', weight = 0.4, max = 4 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.5, max = 5 },
        { class = 'item_healthvial', weight = 0.2, max = 3 },
        { class = 'item_hlvr_grenade_frag', weight = 0.05, max = 1 },
    },
    -- 3rd floor (construction)
    {
        { class = 'item_hlvr_clip_energygun', weight = 0.9 },
        --{ class = 'item_hlvr_clip_energygun_multiple', weight = 0.08, max = 1 },
        { class = 'item_healthvial', weight = 0.33, max = 5 },
        { class = 'item_hlvr_grenade_frag', weight = 0.2, max = 3 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.6, max = 9 },
        { class = 'item_hlvr_clip_shotgun_pair', weight = 0.4, max = 4 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.7, max = 6 },
    },
    -- 4th floor (white arena)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        --{ class = 'item_hlvr_clip_energygun_multiple', weight = 0.15, max = 1 },
        { class = 'item_healthvial', weight = 0.5, max = 8 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.9, max = 7 },
        { class = 'item_hlvr_clip_shotgun_pair', weight = 0.6, max = 3 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.9, max = 6 },
    },
    -- DEPRECATED
    -- 4th floor (white arena RESTOCK)
    --{
    --    { class = 'item_hlvr_clip_energygun', weight = 1 },
    --    { class = 'item_hlvr_clip_energygun_multiple', weight = 0.3 },
    --    { class = 'item_hlvr_clip_shotgun_single', weight = 0.7 },
    --    { class = 'item_hlvr_clip_shotgun_pair', weight = 0.3 },
    --    { class = 'item_hlvr_clip_rapidfire', weight = 0.5 },
    --},
    -- 5th floor (ending)
    {
        { class = 'item_hlvr_clip_energygun', weight = 1 },
        --{ class = 'item_hlvr_clip_energygun_multiple', weight = 0.1, max = 1 },
        { class = 'item_healthvial', weight = 0.2, max = 2 },
        { class = 'item_hlvr_clip_shotgun_single', weight = 0.75 },
        { class = 'item_hlvr_clip_shotgun_pair', weight = 0.3 },
        { class = 'item_hlvr_clip_rapidfire', weight = 0.4 },
    },
}

ItemDistribution = {nil,nil,nil,nil,nil}
Weapon = {
    hand_use_controller = 0,
    hlvr_weapon_energygun = 1,
    hlvr_weapon_shotgun = 2,
    hlvr_weapon_rapidfire = 3
}

StoredItems = StoredItems or {
    energygun = 0,
    shotgun = 0,
    rapidfire = 0,
    hp = 0,
    grenade = 0,
}

local function SetCurrentWeapon(weapon)
    thisEntity:Attribute_SetIntValue("CurrentWeapon", Weapon[weapon])
end
local function GetCurrentWeapon()
    return thisEntity:Attribute_GetIntValue("CurrentWeapon", 0)
end
local function SaveStoredItems()
    thisEntity:Attribute_SetIntValue("StoredItemEnergygun", StoredItems.energygun)
    thisEntity:Attribute_SetIntValue("StoredItemShotgun", StoredItems.shotgun)
    thisEntity:Attribute_SetIntValue("StoredItemRapidfire", StoredItems.rapidfire)
    thisEntity:Attribute_SetIntValue("StoredItemHp", StoredItems.hp)
    thisEntity:Attribute_SetIntValue("StoredItemGrenade", StoredItems.grenade)
end
local function LoadStoredItems()
    StoredItems.energygun = thisEntity:Attribute_GetIntValue("StoredItemEnergygun", 0)
    StoredItems.shotgun = thisEntity:Attribute_GetIntValue("StoredItemShotgun", 0)
    StoredItems.rapidfire = thisEntity:Attribute_GetIntValue("StoredItemRapidfire", 0)
    StoredItems.hp = thisEntity:Attribute_GetIntValue("StoredItemHp", 0)
    StoredItems.grenade = thisEntity:Attribute_GetIntValue("StoredItemGrenade", 0)
end

function Activate(activateType)
    if activateType == 2 then
        LoadStoredItems()
        for k,v in pairs(StoredItems) do
            print(k,v)
        end
    end
    Convars:RegisterCommand("tower_item_distribution", PrintDistribution, "Show item distribution per floor.", 0)
    ListenToGameEvent("player_stored_item_in_itemholder", PlayerStoredItemInItemholder, nil)
    ListenToGameEvent("player_removed_item_from_itemholder", PlayerRemovedItemFromItemholder, nil)
    ListenToGameEvent("player_drop_ammo_in_backpack", PlayerDropAmmoInBackpack, nil)
    ListenToGameEvent("player_retrieved_backpack_clip", PlayerRetrievedBackpackClip, nil)
    ListenToGameEvent("weapon_switch", WeaponSwitch, nil)
    print("item pool count", #ItemPool)
end

function GetItemWeightTotal(index)
    local weight_sum = 0
    for _,v in ipairs(ItemPool[index]) do
        weight_sum = weight_sum + v.weight
    end
    return weight_sum
end

-- Returns TABLE of item values
function GetRandomItem(index)
    local weight_sum = GetItemWeightTotal(index)
    local weight_remaining = RandomFloat(0, weight_sum)
    for _,v in ipairs(ItemPool[index]) do
        weight_remaining = weight_remaining - v.weight
        if weight_remaining < 0 then
            return v
        end
    end
end

--local function ends_with(str, ending)
--    return ending == "" or str:sub(-#ending) == ending
--end

function SpawnItems(target_name, amount, index)
    local item_count = 0
    local targets = Entities:FindAllByName(target_name..'*')
    if #targets == 0 then
        print('Attempt to spawn ammo - No target entity found!')
        return
    end

    -- Keeping track of item count
    local itemCount = {}
    for _,v in ipairs(ItemPool[index]) do
        itemCount[v.class] = 0
    end

    for i=0,amount do
        -- Grab a random target
        if #targets == 0 then
            print('Attempt to spawn ammo - Ran out of targets! '..(amount -  i)..' left.')
            return
        end

        -- Choose info_target
        local pos = RandomInt(1,#targets)
        local target = targets[pos]

        -- Choose item
        local item = GetRandomItem(index)
        while item.max ~= nil and itemCount[item.class] >= item.max do
            item = GetRandomItem(index)
        end
        itemCount[item.class] = itemCount[item.class] + 1

        -- Remove target from availability
        table.remove(targets, pos)

        local class = item.class
        local count_per_this_item = 1
        if item.class == 'item_hlvr_clip_shotgun_pair' then
            class = 'item_hlvr_clip_shotgun_single'
            count_per_this_item = 2
        end

        -- Spawn the ammo with random angles
        for _ = 1, count_per_this_item do
            SpawnEntityFromTableSynchronous(class, {
                origin = target:GetOrigin(),
                --angles = RandomInt(0,359)..' '..RandomInt(0,359)..' '..RandomInt(0,359)
                angles = QAngle(RandomInt(0,359),RandomInt(0,359),RandomInt(0,359))
            })
        end

    end

    ItemDistribution[index] = itemCount
    if IsInToolsMode() then
        PrintDistribution(nil, index)
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
    local keycard = SpawnEntityFromTableSynchronous('prop_physics', {
        origin = target:GetOrigin(),
        --angles = RandomInt(0,120)..' '..RandomInt(0,120)..' '..RandomInt(0,120),
        angles = Vector(0,RandomInt(0,359),RandomInt(0,1)*180),

        damagefilter = '@filter_damage_keycard',
        targetname = keycard_name,
        model = 'models/props/misc/keycard_001.vmdl',
        skin = keycard_skin,
        rendercolor = keycard_color..' 255',
        CanDepositInItemHolder = '1'
    })
    --DoEntFireByInstanceHandle(keycard, "RunScriptCode", "DoIncludeScript('keycard.lua', thisEntity)", 0, nil, nil)
    DoIncludeScript('keycard.lua', keycard:GetPrivateScriptScope())

    --debugoverlay:Sphere(target:GetOrigin(), 16, 0, 255, 0, 255, true, 60)
end

function DebugShowKeycards()
    local cards = Entities:FindAllByModel("models/props/misc/keycard_001.vmdl")
    for _,card in ipairs(cards) do
        debugoverlay:Sphere(card:GetOrigin(), 16, 0, 255, 0, 255, true, 60)
    end
end

function PrintDistribution(_, index)
    index = tonumber(index)
    if index == nil then
        print("Please call command with a floor index for item distribution.")
    elseif ItemDistribution[index] == nil then
        print("Floor specified doesn't exist or hasn't been generated yet.")
    else
        print("Ammo distribution for floor "..index..":")
        for k,v in pairs(ItemDistribution[index]) do
            print("",k,v)
        end
    end
end

-- Ammo/Item tracking

function PlayerDropAmmoInBackpack(data)
    --print(data, data.ammotype)
    if data.ammotype == "Pistol" then
        StoredItems.energygun = StoredItems.energygun + 1
        --print("stored energygun", StoredItems.energygun)
    elseif data.ammotype == "Buckshot" then
        StoredItems.shotgun = StoredItems.shotgun + 1
        --print("stored shotgun", StoredItems.shotgun)
    elseif data.ammotype == "SMG1" then
        StoredItems.rapidfire = StoredItems.rapidfire + 1
        --print("stored rapidfire", StoredItems.rapidfire)
    end
    SaveStoredItems()
end

function PlayerRetrievedBackpackClip()
    local weapon = GetCurrentWeapon()
    if weapon == Weapon.hlvr_weapon_energygun or weapon == Weapon.hand_use_controller then
        StoredItems.energygun = StoredItems.energygun -1
        --print("Took out energygun", StoredItems.energygun)
    elseif weapon == Weapon.hlvr_weapon_shotgun then
        StoredItems.shotgun = StoredItems.shotgun - 1
        --print("Took out shotgun", StoredItems.shotgun)
    elseif weapon == Weapon.hlvr_weapon_rapidfire then
        StoredItems.rapidfire = StoredItems.rapidfire - 1
        --print("Took out rapidfire", StoredItems.rapidfire)
    else
        --print("Took out something?")
    end
    SaveStoredItems()
end

function WeaponSwitch(data)
    SetCurrentWeapon(data.item)
end

function PlayerStoredItemInItemholder(data)
    if data.item == "item_hlvr_grenade_frag" then
        StoredItems.grenade = StoredItems.grenade + 1
    elseif data.item == "item_healthvial" then
        StoredItems.hp = StoredItems.hp + 1
    end
    SaveStoredItems()
end

function PlayerRemovedItemFromItemholder(data)
    --print('wrist', data.item)
    if data.item == "item_hlvr_grenade_frag" then
        StoredItems.grenade = StoredItems.grenade - 1
    elseif data.item == "item_healthvial" then
        StoredItems.hp = StoredItems.hp - 1
    end
    SaveStoredItems()
end

local function OutputValue(caller, value)
    if caller:GetClassname() ~= "math_counter" then
        Warning("Warning: Entity requesting item count must be math_counter.")
        return
    end
    DoEntFireByInstanceHandle(caller, "SetValue", value.."", 0, nil, nil)
end

function GetEnergygunAmmo(data) 
    OutputValue(data.caller, StoredItems.energygun)
end
function GetShotgunAmmo(data)
    OutputValue(data.caller, StoredItems.shotgun)
end
function GetRapidfireAmmo(data)
    OutputValue(data.caller, StoredItems.rapidfire)
end
function GetHealthPens(data)
    OutputValue(data.caller, StoredItems.hp)
end
function GetGrenades(data)
    OutputValue(data.caller, StoredItems.grenade)
end


