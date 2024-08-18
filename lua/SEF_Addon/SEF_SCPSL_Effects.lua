--[[
-----------------------------------------------------------------------------------------------------
SEF Status Effects
-----------------------------------------------------------------------------------------------------
]]
StatusEffects.Panacea = {
    Name = "Panacea",
    Icon = "SEF_Icons/ThePanacea.png",
    Desc = "The cure to all disease.",
	Type = "BUFF",
    Effect = function(ent, time)   
		for effectName, effectData in pairs(EntActiveEffects[ent:EntIndex()]) do
            if StatusEffects[effectName].Type == "DEBUFF" then
			    ent:RemoveEffect(effectName)
			end
		end
		
		if ent:HaveEffect("SCPCola1") then
            ent:SoftRemoveEffect("SCPCola1")
            if ent.SCPCola1PreBuff ~= nil then
                ent:SetRunSpeed(ent.SCPCola1PreBuff)
            end
        elseif ent:HaveEffect("SCPCola2") then
            ent:SoftRemoveEffect("SCPCola2")
            if ent.SCPCola1PreBuff ~= nil then
                ent:SetRunSpeed(ent.SCPCola1PreBuff)
            end
        elseif ent:HaveEffect("SCPCola3") then
            ent:SoftRemoveEffect("SCPCola3")
            if ent.SCPCola1PreBuff ~= nil then
                ent:SetRunSpeed(ent.SCPCola1PreBuff)
            end
        end
		
		if ent:HaveEffect("SCPAntiCola1") then
            ent:SoftRemoveEffect("SCPAntiCola1")
            if ent.SCPCola1PreBuff ~= nil then
                ent:SetRunSpeed(ent.SCPCola1PreBuff)
            end
        elseif ent:HaveEffect("SCPAntiCola2") then
            ent:SoftRemoveEffect("SCPAntiCola2")
            if ent.SCPCola1PreBuff ~= nil then
                ent:SetRunSpeed(ent.SCPCola1PreBuff)
            end
        end
		
		ent.Consumed207 = 0
		ent.ConsumedAnti207 = 0
    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPCola1 = {
    Name = "SCP-207 Effect [Lv. 1]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
	Type = "BUFF",
    Effect = function(ent, time) 
        if not ent.SCPCola1PreBuff then
            ent.SCPCola1PreBuff = ent:GetRunSpeed()
            ent.SCPCola1Timer = CurTime()
        end
        local TimeLeft = ent:GetTimeLeft("SCPCola1")

        if TimeLeft > 0.5 then
            ent:SetRunSpeed(ent.SCPCola1PreBuff + (ent.SCPCola1PreBuff / 100 * 15))
            if CurTime() >= ent.SCPCola1Timer then
			    ent:SetHealth(math.min(ent:Health() - ( 1 * ent.Consumed207 ), ent:GetMaxHealth()))
                ent.SCPCola1Timer = CurTime() + 1
            end
        else
            ent:SetRunSpeed(ent.SCPCola1PreBuff)
            ent.SCPCola1PreBuff = nil
            ent.SCPCola1Timer = nil
        end
		
		if ent:Health() <= 0 then
            ent:Kill()
        end

    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPCola2 = {
    Name = "SCP-207 Effect [Lv. 2]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
	Type = "BUFF",
    Effect = function(ent, time) 
        if not ent.SCPCola2PreBuff then
            ent.SCPCola2PreBuff = ent:GetRunSpeed()
            ent.SCPCola2Timer = CurTime()
        end
        local TimeLeft = ent:GetTimeLeft("SCPCola2")

        if TimeLeft > 0.1 then
            ent:SetRunSpeed(ent.SCPCola1PreBuff + (ent.SCPCola1PreBuff / 100 * 30))
            if CurTime() >= ent.SCPCola2Timer then
                ent:SetHealth(math.min(ent:Health() - ( 1 * ent.Consumed207 ), ent:GetMaxHealth()))
                ent.SCPCola2Timer = CurTime() + 1 
            end
        else
            ent:SetRunSpeed(ent.SCPCola2PreBuff)
            ent.SCPCola2PreBuff = nil
            ent.SCPCola2Timer = nil
        end
		
		if ent:Health() <= 0 then
            ent:Kill()
        end

    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPCola3 = {
    Name = "SCP-207 Effect [Lv. 3]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
	Type = "BUFF",
    Effect = function(ent, time) 
        if not ent.SCPCola3PreBuff then
            ent.SCPCola3PreBuff = ent:GetRunSpeed()
            ent.SCPCola3Timer = CurTime()
        end
        local TimeLeft = ent:GetTimeLeft("SCPCola3")

        if TimeLeft > 0.1 then
            ent:SetRunSpeed(ent.SCPCola1PreBuff + (ent.SCPCola1PreBuff / 100 * 45))
            if CurTime() >= ent.SCPCola3Timer then
                ent:SetHealth(math.min(ent:Health() - ( 1 * ent.Consumed207 ), ent:GetMaxHealth()))
                ent.SCPCola3Timer = CurTime() + 1 
            end
        else
            ent:SetRunSpeed(ent.SCPCola3PreBuff)
            ent.SCPCola3PreBuff = nil
            ent.SCPCola3Timer = nil
        end
		
		if ent:Health() <= 0 then
            ent:Kill()
        end

    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPAntiCola1 = {
    Name = "Anti SCP-207 Effect [Lv. 1]",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "Good for your health, bad for your motor skills. Will save your life in a pinch.",
	Type = "BUFF",
    Effect = function(ent, time) 
        if not ent.SCPAntiCola1PreBuff then
            ent.SCPAntiCola1PreBuff = ent:GetRunSpeed()
            ent.SCPAntiCola1Timer = CurTime()
        end
        local TimeLeft = ent:GetTimeLeft("SCPAntiCola1")

        if TimeLeft > 0.5 then
            ent:SetRunSpeed(ent.SCPAntiCola1PreBuff - (ent.SCPAntiCola1PreBuff / 100 * 5 ))
            if CurTime() >= ent.SCPAntiCola1Timer then
                ent:SetHealth(math.min(ent:Health() + 1, ent:GetMaxHealth()))
                ent.SCPAntiCola1Timer = CurTime() + 1
            end

            if ent:Health() <= 1 then
                ent:RemoveEffect("SCPAntiCola1")
                ent:ApplyEffect("SCPAntiColaImmunity", 3)
            end
        else
            ent:SetRunSpeed(ent.SCPAntiCola1PreBuff)
            ent.SCPAntiCola1PreBuff = nil
            ent.SCPAntiCola1Timer = nil
        end

    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPAntiCola2 = {
    Name = "Anti SCP-207 Effect [Lv. 2]",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "Good for your health, bad for your motor skills. Will save your life in a pinch.",
	Type = "BUFF",
    Effect = function(ent, time) 
        if not ent.SCPAntiCola2PreBuff then
            ent.SCPAntiCola2PreBuff = ent:GetRunSpeed()
            ent.SCPAntiCola2Timer = CurTime()
        end
        local TimeLeft = ent:GetTimeLeft("SCPAntiCola2")

        if TimeLeft > 0.5 then
            ent:SetRunSpeed(ent.SCPAntiCola1PreBuff - (ent.SCPAntiCola1PreBuff / 100 * 15 ))
            if CurTime() >= ent.SCPAntiCola2Timer then
                ent:SetHealth(math.min(ent:Health() + 3, ent:GetMaxHealth()))
                ent.SCPAntiCola2Timer = CurTime() + 1 
            end 
            if ent:Health() <= 1 then
                ent:SoftRemoveEffect("SCPAntiCola2")
                ent:ApplyEffect("SCPAntiColaImmunity", 3)
            end

        else
            ent:SetRunSpeed(ent.SCPAntiCola2PreBuff)
            ent.SCPAntiCola2PreBuff = nil
            ent.SCPAntiCola2Timer = nil
        end

    end,
    HookType = "",
    HookFunction = function() end
}

StatusEffects.SCPAntiColaImmunity = {
    Name = "Anti SCP-207 Immunity",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "You are saved... for now...",
	Type = "BUFF",
    Effect = function(ent, time)
        if not ent.SCPAntiColaSaved then
            ent:SetHealth(1)
            ent.SCPAntiColaSaved = true
        end
        
        local TimeLeft = ent:GetTimeLeft("SCPAntiColaImmunity")

        if TimeLeft < 0.01 then
            ent.SCPAntiColaSaved = nil
        end
    end,
    HookType = "EntityTakeDamage",
    HookFunction = function(target, dmginfo) 
        if IsValid(target) and target:HaveEffect("SCPAntiColaImmunity") then
            dmginfo:SetDamage(0)
        end
    end
}