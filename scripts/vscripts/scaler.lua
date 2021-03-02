
function Shrink()
    thisEntity:SetThink(ShrinkThink, 'ShrinkThink', 0)
end

function ShrinkThink()
    local scale = thisEntity:GetAbsScale()
    if scale > 0.05 then
        thisEntity:SetAbsScale(scale * 0.9)
        return 0
    end
    DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end

function Grow()
    thisEntity:SetThink(GrowThink, 'GrowThink', 0)
end

function GrowThink()
    local scale = thisEntity:GetAbsScale()
    if scale < 1 then
        thisEntity:SetAbsScale(scale * 1.05)
        return 0
    end
    DoEntFireByInstanceHandle(thisEntity, 'FireUser2', '', 0, nil, nil)
end