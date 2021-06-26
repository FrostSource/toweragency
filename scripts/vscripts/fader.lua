
AmountToFadePerFrame = AmountToFadePerFrame or 0
TargetFadeValue = TargetFadeValue or 0
TargetToFade = TargetToFade or nil
CurrentFadeValue = 0

function FadeByModel(class, model)
    local ents = Entities:FindAllByClassname(class)
    for _,ent in ipairs(ents) do
        if ent:GetModelName() == model then
            DoEntFireByInstanceHandle(ent, 'FadeAndRemove', '', 0, nil, nil)
            print('found model to fade')
        end
        --SpawnEntityFromTableSynchronous("point_entity_fader", {
        --    target = "",
        --    curve = "<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:generic:version{7412167c-06e9-4698-aff2-e63eb59037e7} -->\n{\n\tm_spline = \n\t[\n\t\t{\n\t\t\tx = 0.0\n\t\t\ty = 1.0\n\t\t\tm_flSlopeIncoming = -1.0\n\t\t\tm_flSlopeOutgoing = -1.0\n\t\t},\n\t\t{\n\t\t\tx = 1.0\n\t\t\ty = 0.0\n\t\t\tm_flSlopeIncoming = -1.0\n\t\t\tm_flSlopeOutgoing = -1.0\n\t\t},\n\t]\n\tm_tangents = \n\t[\n\t\t{\n\t\t\tm_nIncomingTangent = \"CURVE_TANGENT_SPLINE\"\n\t\t\tm_nOutgoingTangent = \"CURVE_TANGENT_SPLINE\"\n\t\t},\n\t\t{\n\t\t\tm_nIncomingTangent = \"CURVE_TANGENT_SPLINE\"\n\t\t\tm_nOutgoingTangent = \"CURVE_TANGENT_SPLINE\"\n\t\t},\n\t]\n\tm_vDomainMins = [ 0.0, 0.0 ]\n\tm_vDomainMaxs = [ 1.0, 1.0 ]\n}"
        --})
    end
    print('after model fade')
end

function FadeTarget(name, from, to, frames)
    local ent = Entities:FindByName(nil, name)
    if IsValidEntity(ent) then
        ent:SetRenderAlpha(from)
        TargetToFade = ent
        TargetFadeValue = to
        AmountToFadePerFrame = (to - from) / frames
        --print('AmountToFadePerFrame', AmountToFadePerFrame)
        thisEntity:SetThink(FadeThink, 'FadeThink', 0)
    end
end

function FadeThink()
    CurrentFadeValue = CurrentFadeValue + AmountToFadePerFrame
    --DoEntFireByInstanceHandle(thisEntity, 'FireUser4', CurrentFadeValue..'', 0, nil, nil)
    --print('check valid')
    if IsValidEntity(TargetToFade) then
        local a = TargetToFade:GetRenderAlpha()
        if a - (a % 1) >= TargetFadeValue then
            TargetToFade:SetRenderAlpha(TargetFadeValue)
            TargetToFade = nil
            return
        end
        TargetToFade:SetRenderAlpha(a + AmountToFadePerFrame)
        --print('changing fade', a + AmountToFadePerFrame)
    end
    return 0
    --print('end think')
end

-- outputs to user4
function FadeValueOutput(from, to, frames)
    CurrentFadeValue = from
    TargetFadeValue = to
    AmountToFadePerFrame = (to - from) / frames
    thisEntity:SetThink(FadeThink, 'FadeThink', 0)
end

-- local id = Convars:GetBool('hlvr_left_hand_primary') and 1 or 0;
-- local hand = Entities:GetLocalPlayer():GetHMDAvatar():GetVRHand(id);
-- thisEntity:SetParent(hand, '');
-- thisEntity:SetLocalAngles(0, 180, 0);
-- if id == 0 then
--     thisEntity:SetLocalOrigin(Vector(-3, -3.5, -0.2));
-- else
--     thisEntity:SetLocalOrigin(Vector(-3, 3.5, -0.2));
-- end
