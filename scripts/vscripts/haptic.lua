
--[[ function DoHaptic0(d1,d2,d3)
    print('d1:')
    if d1 ~= nil then
        for key, value in pairs(d1) do
            print(key, value)
        end
    end
    print('d2:')
    if d2 ~= nil then
        for key, value in pairs(d2) do
            print(key, value)
        end
    end
    print('d3:')
    if d3 ~= nil then
        for key, value in pairs(d3) do
            print(key, value)
        end
    end
    local hand0 = Entities:GetLocalPlayer():GetHMDAvatar():GetVRHand(0)
    local hand1 = Entities:GetLocalPlayer():GetHMDAvatar():GetVRHand(1)
    print(hand0)
    print(hand1)
end ]]

local function GetHand(activator)
    local hmd = Entities:GetLocalPlayer():GetHMDAvatar()
    local hand0 = hmd:GetVRHand(0)
    local hand1 = hmd:GetVRHand(1)
    if activator == hand0 then
        return hand0
    elseif activator == hand1 then
        return hand1
    end
end

function DoHaptic0(data)
    local hand = GetHand(data.activator)
    hand:FireHapticPulse(0)
end
function DoHaptic1(data)
    local hand = GetHand(data.activator)
    hand:FireHapticPulse(1)
end
function DoHaptic2(data)
    local hand = GetHand(data.activator)
    hand:FireHapticPulse(2)
end
