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
        if not ent.Consumed1853 or ent.Consumed1853 == 0 then
            ent.Consumed1853 = 1
            ent.StackDepleteTime = 20
            ent.Danger1853Stacks = 0
            ent.Danger1853Timer = CurTime() 
			ent.LastDamageTimer = CurTime() + 5
			ent.TotalDamage = 0
        end

        if ent.Consumed1853 == 1 then
            if ent.Danger1853Stacks >= 5 then
                ent:StartLoopingSound("scpsl_1853_heartbeat")
            end

            if ent.Danger1853Timer <= CurTime() then
                if ent.Danger1853Stacks > 0 then
                    ent:EmitSound("scpsl_1853_dangerdec")
                end
                ent.Danger1853Stacks = math.max(0, ent.Danger1853Stacks - 1)
                ent.Danger1853Timer = CurTime() + ent.StackDepleteTime

                if ent.Danger1853Stacks > 0 then
                    ent:ApplyEffect("Haste", 20, (20 * ent.Danger1853Stacks), 1)
                end
            end
        end

        if (ent:HaveEffect("SCPCola1") or ent:HaveEffect("SCPCola2") or ent:HaveEffect("SCPCola3")) or (ent:HaveEffect("SCPAntiCola1") or ent:HaveEffect("SCPAntiCola2")) then
            ent:ApplyEffect("Poison", math.huge, 8, 2)
        end
    end,
    ServerHooks = {
        {
            HookType = "EntityTakeDamage",
            HookFunction = function(ent, dmginfo)
                if ent:HaveEffect("SCP1853") then
				    
					ent.TotalDamage = ent.TotalDamage + dmginfo:GetDamage()
					ent.LastDamageTimer = CurTime() + 5
		            if ent.LastDamageTimer <= CurTime() then
		                ent.TotalDamage = 0 
		            end
                    if dmginfo:GetDamage() >= 10 or ent.TotalDamage >= 20 then
					    ent.TotalDamage = 0 
                        ent.Danger1853Stacks = math.min(ent.Danger1853Stacks + 1, 5)
                        ent:ApplyEffect("Haste", 20, (20 * ent.Danger1853Stacks), 1)
						ent:EmitSound("scpsl_1853_dangerinc")	
                    end
                end
            end
        }
    },
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
            ent:SetHealth(math.max(ent:Health() - (2)))
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
            ent:SetHealth(math.max(ent:Health() - (3)))
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
		BaseStatRemove(ent, "RunSpeed", 30)
    end,
    EffectEnd = function(ent)
	    if not ent:HaveEffect("SCPAntiCola2") then
	    BaseStatReset(ent, "RunSpeed", 30)
		end
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPAntiCola1Timer or 0) then
		    if ent:HaveEffect("Poison") then return end
            if not ent:HaveEffect("TempShield") then
                ent:ApplyEffect("TempShield", math.huge, 1)
            elseif ent:HaveEffect("TempShield") and ent:GetSEFStacks("TempShield") < 20 then
                ent:AddSEFStacks("TempShield", 1)
            end
			ent:SetHealth(math.min(ent:Health() + 1, ent:GetMaxHealth()))
            ent.SCPAntiCola1Timer = CurTime() + 1
        end
    end
}

StatusEffects.SCPAntiCola2 = {
    Name = "Anti SCP-207 Effect [Lv. 2]",
    Icon = "SEF_Icons/SCPSL207Anti.png",
    Desc = "Good for your health, bad for your motor skills. Will save your life in a pinch.",
    Type = "BUFF",
    EffectBegin = function(ent)
        BaseStatRemove(ent, "RunSpeed", 50)
    end,
    EffectEnd = function(ent)
        BaseStatReset(ent, "RunSpeed", 80)
    end,
    Effect = function(ent, time)
        if CurTime() >= (ent.SCPAntiCola1Timer or 0) then
		    if ent:HaveEffect("Poison") then return end
            if not ent:HaveEffect("TempShield") then
                ent:ApplyEffect("TempShield", math.huge, 1)
            elseif ent:HaveEffect("TempShield") and ent:GetSEFStacks("TempShield") < 40 then
                ent:AddSEFStacks("TempShield", 1)
            end
			
			ent:SetHealth(math.min(ent:Health() + 3, ent:GetMaxHealth()))
            ent.SCPAntiCola1Timer = CurTime() + 1
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