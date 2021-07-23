

--print("KEYCARD")
thisEntity:RedirectOutput("OnPlayerPickup", "OnPlayerPickup", thisEntity)

function OnPlayerPickup()
    local name = thisEntity:GetName()
    --print("Pickup", name)
    if name == "@keycard_1st_floor" then
        DoEntFire("@1stflr_found_key", "Trigger", "", 0, thisEntity, thisEntity)
        --print("@1stflr_found_key")
    elseif name == "@keycard_2nd_floor" then
        DoEntFire("@2ndflr_found_key", "Trigger", "", 0, thisEntity, thisEntity)
        --print("@2ndflr_found_key")
    elseif name == "@keycard_3rd_floor" then
        DoEntFire("@3rdflr_found_key", "Trigger", "", 0, thisEntity, thisEntity)
        --print("@3rdflr_found_key")
    elseif name == "@keycard_4th_floor" then
        DoEntFire("@4thflr_found_key", "Trigger", "", 0, thisEntity, thisEntity)
    end
end
