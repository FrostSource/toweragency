
function Spawn(spawnkeys)
    thisEntity:SetContext("modelchange", spawnkeys:GetValue("modelchange"), 0)
    thisEntity:Attribute_SetIntValue("fadeondeath", spawnkeys:GetValue("fadeondeath"))
end

function Activate()
    print(thisEntity:GetContext("modelchange"))
    if thisEntity:GetContext("modelchange") then
        ListenToGameEvent("npc_ragdoll_created", NPCRagdollCreated, nil)
    end
    --thisEntity:SetThink(Gag, "Gag", 0)
end

--function Gag()
--    DoEntFireByInstanceHandle(thisEntity, "CancelSpeech", "", 0, nil, nil)
    --print('gag')
--    return 0
--end

function NPCRagdollCreated(data)
    local npc = EntIndexToHScript(data.npc_entindex)
    if npc == thisEntity then
        local r = EntIndexToHScript(data.ragdoll_entindex)
        local name = DoUniqueString("")
        r:SetRenderAlpha(0)
        r:SetEntityName(name)
        --crashes game
        --r:SetModel("models/characters/gman/gman.vmdl")
        --for i=1,10 do
        --    StopSoundOn("vo.combine.grunt.die_0"..i, npc)
            --vo.combine.grunt.die_by_player_18 - 23
        --end

        SpawnEntityFromTableSynchronous("prop_dynamic", {
            targetname = name .. "merge",
            parentname = name,
            parentAttachmentName = "!bonemerge",
            useLocalOffset = 1,
            --model = "models/characters/gman/gman.vmdl",
            model = npc:GetContext("modelchange"),
            solid = 0
        })

        if npc:Attribute_GetIntValue("fadeondeath", 0) then
            local d = SpawnEntityFromTableSynchronous("env_entity_dissolver",{})
            --DoEntFireByInstanceHandle(d, "Dissolve", name, 0, nil, nil)
            DoEntFireByInstanceHandle(d, "Dissolve", name .. "merge", 0, nil, nil)
            DoEntFire(name, "kill", "", 2, nil, nil)
        end
    end
end


