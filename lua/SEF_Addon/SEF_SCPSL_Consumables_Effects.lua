--[[
-----------------------------------------------------------------------------------------------------
SEF Status Effects
-----------------------------------------------------------------------------------------------------
]]
StatusEffects.SCP1853 = {
    Name = "SCP-1853",
    Icon = "SEF_Icons/SCPSL1853.png",
    Desc = "Increases motor skills when in danger.",
	Type = "BUFF",
    Effect = function(ent, time)   
        ent.Consumed1853 = 1
    end
}

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
        elseif ent:HaveEffect("SCPCola2") then
            ent:SoftRemoveEffect("SCPCola2")
        elseif ent:HaveEffect("SCPCola3") then
            ent:SoftRemoveEffect("SCPCola3")
        end
		
		if ent:HaveEffect("SCPAntiCola1") then
            ent:SoftRemoveEffect("SCPAntiCola1")
        elseif ent:HaveEffect("SCPAntiCola2") then
            ent:SoftRemoveEffect("SCPAntiCola2")
        end
		
		if ent:HaveEffect("SCP1853") then ent:SoftRemoveEffect("SCP1853") end
		
		ent.Consumed207 = 0
		ent.ConsumedAnti207 = 0
		ent.Consumed1853 = 0
    end
}

StatusEffects.SCPCola1 = {
    Name = "SCP-207 Effect [Lv. 1]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
    Type = "BUFF",
    EffectBegin = function(ent)

        local speedIncrease = EntBaseStats[ent].RunSpeed * 0.15

        if ent.SCPCola1LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola1LastAdded)
        end
        BaseStatAdd(ent, "RunSpeed", speedIncrease)
        ent.SCPCola1LastAdded = speedIncrease
    end,
    EffectEnd = function(ent)
        if ent.SCPCola1LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola1LastAdded)
            ent.SCPCola1LastAdded = nil
        end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPCola1Timer or 0) then
            ent:SetHealth(math.max(ent:Health() - (1 * (ent.Consumed207 or 1)), 0))
            ent.SCPCola1Timer = CurTime() + 1
        end

        if ent:Alive() and ent:Health() <= 0 then
            ent:Kill()
        end
    end
}


StatusEffects.SCPCola2 = {
    Name = "SCP-207 Effect [Lv. 2]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
    Type = "BUFF",
    EffectBegin = function(ent)
        local speedIncrease = EntBaseStats[ent].RunSpeed * 0.30

        if ent.SCPCola2LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola2LastAdded)
        end

        BaseStatAdd(ent, "RunSpeed", speedIncrease)
        ent.SCPCola2LastAdded = speedIncrease
    end,
    EffectEnd = function(ent)
        if ent.SCPCola2LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola2LastAdded)
            ent.SCPCola2LastAdded = nil
        end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPCola2Timer or 0) then
            ent:SetHealth(math.max(ent:Health() - (1 * (ent.Consumed207 or 1)), 0))
            ent.SCPCola2Timer = CurTime() + 1
        end

        if ent:Alive() and ent:Health() <= 0 then
            ent:Kill()
        end
    end
}


StatusEffects.SCPCola3 = {
    Name = "SCP-207 Effect [Lv. 3]",
    Icon = "SEF_Icons/SCPSL207.png",
    Desc = "Harmfully increase motor skills.",
    Type = "BUFF",
    EffectBegin = function(ent)
        local speedIncrease = EntBaseStats[ent].RunSpeed * 0.45

        if ent.SCPCola3LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola3LastAdded)
        end

        BaseStatAdd(ent, "RunSpeed", speedIncrease)
        ent.SCPCola3LastAdded = speedIncrease
    end,
    EffectEnd = function(ent)
        if ent.SCPCola3LastAdded then
            BaseStatRemove(ent, "RunSpeed", ent.SCPCola3LastAdded)
            ent.SCPCola3LastAdded = nil
        end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPCola3Timer or 0) then
            ent:SetHealth(math.max(ent:Health() - (1 * (ent.Consumed207 or 1)), 0))
            ent.SCPCola3Timer = CurTime() + 1
        end

        if ent:Alive() and ent:Health() <= 0 then
            ent:Kill()
        end
    end
}


-- Anti SCP-207 Effect [Lv. 1]
StatusEffects.SCPAntiCola1 = {
    Name = "Anti SCP-207 Effect [Lv. 1]",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "Good for your health, bad for your motor skills. Will save your life in a pinch.",
    Type = "BUFF",
    EffectBegin = function(ent)
        local speedDecrease = EntBaseStats[ent].RunSpeed * 0.05

        if ent.SCPAntiCola1LastAdded then
            BaseStatAdd(ent, "RunSpeed", ent.SCPAntiCola1LastAdded)
        end

        BaseStatRemove(ent, "RunSpeed", speedDecrease)
        ent.SCPAntiCola1LastAdded = speedDecrease
    end,
    EffectEnd = function(ent)
        if ent.SCPAntiCola1LastAdded then
            BaseStatAdd(ent, "RunSpeed", ent.SCPAntiCola1LastAdded)
            ent.SCPAntiCola1LastAdded = nil
        end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPAntiCola1Timer or 0) then
            ent:SetHealth(math.min(ent:Health() + 1, ent:GetMaxHealth()))
            ent.SCPAntiCola1Timer = CurTime() + 1
        end

        if ent:Health() <= 1 then
            ent:SoftRemoveEffect("SCPAntiCola1")
            ent:ApplyEffect("SCPAntiColaImmunity", 3)
        end
    end
}

StatusEffects.SCPAntiCola2 = {
    Name = "Anti SCP-207 Effect [Lv. 2]",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "Good for your health, bad for your motor skills. Will save your life in a pinch.",
    Type = "BUFF",
    EffectBegin = function(ent)
        local speedDecrease = EntBaseStats[ent].RunSpeed * 0.15

        if ent.SCPAntiCola2LastAdded then
            BaseStatAdd(ent, "RunSpeed", ent.SCPAntiCola2LastAdded)
        end

        BaseStatRemove(ent, "RunSpeed", speedDecrease)
        ent.SCPAntiCola2LastAdded = speedDecrease
    end,
    EffectEnd = function(ent)
        if ent.SCPAntiCola2LastAdded then
            BaseStatAdd(ent, "RunSpeed", ent.SCPAntiCola2LastAdded)
            ent.SCPAntiCola2LastAdded = nil
        end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPAntiCola2Timer or 0) then
            ent:SetHealth(math.min(ent:Health() + 3, ent:GetMaxHealth()))
            ent.SCPAntiCola2Timer = CurTime() + 1
        end

        if ent:Health() <= 1 then
            ent:SoftRemoveEffect("SCPAntiCola2")
            ent:ApplyEffect("SCPAntiColaImmunity", 3)
        end
    end
}

-- StatusEffects.SCPAntiColaImmunity = {
    -- Name = "Anti SCP-207 Immunity",
    -- Icon = "SEF_Icons/SCPSL207Anti.png",
    -- Desc = "You are saved... for now...",
	-- Type = "BUFF",
    -- Effect = function(ent, time)
        -- if not ent.SCPAntiColaSaved then
            -- ent:SetHealth(1)
            -- ent.SCPAntiColaSaved = true
        -- end
        
        -- local TimeLeft = ent:GetTimeLeft("SCPAntiColaImmunity")

        -- if TimeLeft < 0.1 then
            -- ent.SCPAntiColaSaved = nil
        -- end
    -- end,
    -- ServerHooks = {
        -- {
            -- HookType = "EntityTakeDamage",
            -- HookFunction = function(target, dmginfo) 
                -- if IsValid(target) and target:HaveEffect("SCPAntiColaImmunity") then
                    -- dmginfo:SetDamage(0)
                -- end
            -- end

        -- }
    -- }
-- }