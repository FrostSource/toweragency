
print("Broken tv activated")
thisEntity:RedirectOutput("OnPlayerPickup", "OnPlayerPickup", thisEntity)

function OnPlayerPickup()
    print("Broken tv has been picked up")
    DoEntFire("ending_tv_picked_up", "Trigger", "", 0, nil, nil)
    thisEntity:DisconnectRedirectedOutput("OnPlayerPickup", "OnPlayerPickup", thisEntity)
end
