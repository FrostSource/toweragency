
local ShrinkMultiplier = ShrinkMultiplier or 0.9
local GrowMultiplier = GrowMultiplier or 1.05

function ShrinkFast()
    ShrinkMultiplier = 0.9
    thisEntity:SetThink(ShrinkThink, 'ShrinkThink', 0)
end
function ShrinkSlow()
    ShrinkMultiplier = 0.995
    print('SHRINK SLOW')
    thisEntity:SetThink(ShrinkThink, 'ShrinkThink', 0)
end

function ShrinkThink()
    local scale = thisEntity:GetAbsScale()
    --print('scale of shrinker', scale)
    if scale > 0.02 then
        thisEntity:SetAbsScale(scale * ShrinkMultiplier)
        return 0
    end
    DoEntFireByInstanceHandle(thisEntity, 'FireUser1', '', 0, nil, nil)
end

function GrowFast()
    GrowMultiplier = 1.05
    thisEntity:SetThink(GrowThink, 'GrowThink', 0)
end
function GrowSlow()
    GrowMultiplier = 1.02
    thisEntity:SetThink(GrowThink, 'GrowThink', 0)
end

function GrowThink()
    local scale = thisEntity:GetAbsScale()
    if scale < 1 then
        thisEntity:SetAbsScale(scale * GrowMultiplier)
        return 0
    end
    DoEntFireByInstanceHandle(thisEntity, 'FireUser2', '', 0, nil, nil)
end