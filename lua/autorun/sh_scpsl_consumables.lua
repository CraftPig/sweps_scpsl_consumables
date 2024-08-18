if SERVER then
    local StackDepleteTime = 20
	local TotalDamage = 0
	local LastDamageTimer = 5
	local PoisonTime = 5
	
	-- hook.Add("PlayerInitialSpawn", "HookInitializeDangerSpawn", function(owner) -- Get Default Values
	    
	-- end)
	
	local function ResetBuffs(owner) 
		owner.Consumed1853 = 0
		owner.Consumed207 = 0
		owner.ConsumedAnti207 = 0
        owner.Danger1853Stacks = 0
		owner.Danger1853Timer = CurTime() 
		owner.Decay207Timer = CurTime() 
		owner.RegenAnti207Timer = CurTime() 
		
		owner:SetJumpPower(owner.DefaultJumpHeightSCPSL)
        owner:SetRunSpeed(owner.DefaultRunSpeedSCPSL)
    end

    local function ApplyPoison(owner)
        if owner:Health() > 0 and owner:Alive() then
            owner:SetHealth(owner:Health() - 15)
            if owner:Health() <= 0 then owner:Kill() end
        end
    end
	
	hook.Add("PlayerSpawn", "HookResetStatusSCPSL", function(owner) -- Buffs Fallback		
        ResetBuffs(owner)
		owner.DefaultJumpHeightSCPSL = owner:GetJumpPower()  
        owner.DefaultRunSpeedSCPSL = owner:GetRunSpeed()	
    end)
    
    hook.Add("PlayerInitialSpawn", "HookInitializeStatusSCPSL", function(owner) -- Buffs Fallback		
        owner.DefaultJumpHeightSCPSL = owner:GetJumpPower()  
        owner.DefaultRunSpeedSCPSL = owner:GetRunSpeed()
		ResetBuffs(owner) 
    end)

	hook.Add("EntityTakeDamage", "HookManageDamageSCPSL", function(owner, dmginfo)
    
	    if owner.Consumed1853 == 1 then
		TotalDamage = TotalDamage + dmginfo:GetDamage()
		LastDamageTimer = CurTime() + 5
		if LastDamageTimer <= CurTime() then
		    TotalDamage = 0 
		end
			if dmginfo:GetDamage() >= 10 or TotalDamage >= 20 then -- If 10 Damage was taken
			    owner.Danger1853Stacks = math.min(owner.Danger1853Stacks + 1, 5)
                owner:EmitSound("scpsl_1853_dangerinc")	
				owner.Danger1853Timer = CurTime() + StackDepleteTime -- Reset Deplete Timer
				
				TotalDamage = 0 

                -- owner:ChatPrint(owner.Danger1853Stacks ) -- Debug					
			end
		end
	end)

	hook.Add("Think", "HookManageThinkSCPSL", function()

        for _, owner in pairs(player.GetAll()) do -- Get all players
            if owner.Consumed1853 == 1 then -- 1853 stuff
                if owner.Danger1853Stacks == 5 then
                    owner:StartLoopingSound("scpsl_1853_heartbeat")
                end

                if owner.Danger1853Timer <= CurTime() then -- Reduce Danger stacks
                    if owner.Danger1853Stacks > 0 then
                        owner:EmitSound("scpsl_1853_dangerdec")
                    end
                    owner.Danger1853Stacks = math.max(0, owner.Danger1853Stacks - 1)
                    owner.Danger1853Timer = CurTime() + StackDepleteTime
                end

                if owner.Danger1853Timer > 19 then -- Update 1853 stats
                    owner:SetJumpPower(owner.DefaultJumpHeightSCPSL * (1 + 0.1 * owner.Danger1853Stacks))
                    owner:SetRunSpeed(owner.DefaultRunSpeedSCPSL * (1 + 0.05 * owner.Danger1853Stacks))
                end
            end

            if owner.Consumed1853 == 1 and (owner.Consumed207 > 0 or owner.ConsumedAnti207 > 0) and PoisonTime <= CurTime() then -- Apply Poison 
                PoisonTime = CurTime() + 5
                ApplyPoison(owner)
            end
        end
    end)
	
	hook.Add("ResetBuffsSCPSL", "HookReset1853Buffs", function(owner) -- Remove all buffs
		ResetBuffs(owner)
	end)
end	
	
	
	-- hook.Add("EntityTakeDamage", "ApplyDangerBuff", function(target, dmginfo)
        -- if not target:IsPlayer() then return end
        -- local owner = target

        -- if owner.Consumed1853 == 1 then
           -- -- Check if player takes 10 or more damage
            -- if dmginfo:GetDamage() >= 10 then
                -- local damageTaken = math.floor(dmginfo:GetDamage() / 10)
                -- owner.DangerStacks = owner.DangerStacks + damageTaken
                -- owner.DangerStackTime = CurTime()
                -- owner:ChatPrint("Danger stacks: " .. owner.DangerStacks)
                -- net.Start("DangerStatusUpdate")
                -- net.WriteInt(owner.DangerStacks, 16)
                -- net.Send(owner)
            -- end
        -- end
    -- end)
	
	-- hook.Add("Think", "ManageDangerStacks", function()
        -- for _, owner in pairs(player.GetAll()) do
            -- if owner.Consumed1853 == 1 then
                -- if CurTime() - owner.DangerStackTime >= 10 then
                    -- owner.DangerStacks = math.max(0, owner.DangerStacks - 1)
                    -- owner.DangerStackTime = CurTime()
                    -- owner:ChatPrint("Danger stacks decreased. Current stacks: " .. owner.DangerStacks)
                    -- net.Start("DangerStatusUpdate")
                    -- net.WriteInt(owner.DangerStacks, 16)
                    -- net.Send(owner)
                -- end
            -- end
        -- end
    -- end)







-- local lastPrintTime = 0

-- local function Think1853()
    -- local currentTime = CurTime() 

    -- if currentTime - lastPrintTime >= 1 then
        -- print("One second has passed!")
        -- lastPrintTime = currentTime
    -- end

    -- return true
-- end

-- local function Initialize1853()
    -- hook.Add("Think", "HookThink1853", Think1853)
    -- print("Owner:", owner:Nick(), "SteamID:", owner:SteamID())
-- end

-- hook.Add("Initialize1853", "HookInitialize1853", Initialize1853)

-- hook.Remove("Think", "HookThink1853", Think1853)  

-- hook.Run("Initialize1853", swep:GetOwner())