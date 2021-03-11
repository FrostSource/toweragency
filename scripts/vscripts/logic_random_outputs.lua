


function Spawn(spawnkeys)
    local sum = 0
    for i = 1, 16 do
        -- Set up key name
        local key = ((i < 10) and 'Case0' or 'Case')..i
        -- Convert key value to number
        local value = tonumber(spawnkeys:GetValue(key))
        if value ~= nil then
            print(value,type(value),key)
            -- Add new weight to attribute for loading
            thisEntity:Attribute_SetFloatValue('Weight'..i, value)
            -- and sum for calculations
            sum = sum + value
        end
    end
    -- Add total weight as attribute for loading
    thisEntity:Attribute_SetFloatValue('WeightSum', sum)

    -- Optionally listen for an output to so you don't have to remember function names
    thisEntity:RedirectOutput('OnUser1', 'RandomChance', thisEntity)
end

function SetWeightValue(name, value)
    thisEntity:Attribute_SetFloatValue(name, value)
    thisEntity:Attribute_SetFloatValue('WeightSum', thisEntity:Attribute_GetFloatValue('WeightSum', 0) + value)
end

function RandomChance()
    local weight_sum = thisEntity:Attribute_GetFloatValue('WeightSum', 0)
    local weight_remaining = RandomFloat(0, weight_sum)
    -- Loop through all applicable weights
    for i = 1, 16 do
        local weight = thisEntity:Attribute_GetFloatValue('Weight'..i, 0)
        if weight ~= 0 then
            weight_remaining = weight_remaining - weight
            if weight_remaining < 0 then
                -- Fire the OnCase.. for hammer logic
                --print('Firing case',i, ((i < 10) and 'OnCase0' or 'OnCase')..i)
                --DoEntFireByInstanceHandle(thisEntity, ((i < 10) and 'OnCase0' or 'OnCase')..i, '', 0, nil, nil)
                thisEntity:FireOutput(((i < 10) and 'OnCase0' or 'OnCase')..i, nil, nil, nil, 0)
            end
        end
    end
end