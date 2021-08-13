
function Activate()
    if thisEntity:IsNPC() then
        ListenToGameEvent("npc_ragdoll_created", NPCRagdollCreated, nil)
    elseif thisEntity:GetClassname() == "prop_physics" then
        thisEntity:RedirectOutput("OnBreak", "OnBreak", thisEntity)
    end
end

function OnBreak()
    
end

function NPCRagdollCreated(data)
    local npc = EntIndexToHScript(data.npc_entindex)
    local ragdoll = EntIndexToHScript(data.ragdoll_entindex)

    if npc == thisEntity then
        local name = DoUniqueString("")
        ragdoll:SetEntityName(name)
        for _,child in ipairs(npc:GetChildren()) do
            local c = child:GetClassname()
            if c == "item_hlvr_grenade_frag" or c == "item_hlvr_clip_energygun" then
                SpawnEntityFromTableSynchronous(c, {
                    origin = child:GetOrigin(),
                    angles = child:GetAngles()
                })
                child:Kill()
            end
        end
        local d = SpawnEntityFromTableSynchronous("env_entity_dissolver",{})
        DoEntFireByInstanceHandle(d, "Dissolve", name, 0, nil, nil)
        --DoEntFireByInstanceHandle(ragdoll, "Kill", "", 0, nil, nil)
        --ragdoll:Kill()
        -- local fader = SpawnEntityFromTableSynchronous("point_entity_fader",{
        --     target = name,
        --     curve = [[<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:generic:version{7412167c-06e9-4698-aff2-e63eb59037e7} -->
        --     {
        --         m_spline = 
        --         [
        --             {
        --                 x = 0.0
        --                 y = 1.0
        --                 m_flSlopeIncoming = -1.0
        --                 m_flSlopeOutgoing = -1.0
        --             },
        --             {
        --                 x = 5.0
        --                 y = 0.0
        --                 m_flSlopeIncoming = -1.0
        --                 m_flSlopeOutgoing = -1.0
        --             },
        --         ]
        --         m_tangents = 
        --         [
        --             {
        --                 m_nIncomingTangent = "CURVE_TANGENT_SPLINE"
        --                 m_nOutgoingTangent = "CURVE_TANGENT_SPLINE"
        --             },
        --             {
        --                 m_nIncomingTangent = "CURVE_TANGENT_SPLINE"
        --                 m_nOutgoingTangent = "CURVE_TANGENT_SPLINE"
        --             },
        --         ]
        --         m_vDomainMins = [ 0.0, 0.0 ]
        --         m_vDomainMaxs = [ 5.0, 1.0 ]
        --     }]]
        -- })
        -- DoEntFireByInstanceHandle(fader, "Start", "", 0, nil, nil)
    end
end