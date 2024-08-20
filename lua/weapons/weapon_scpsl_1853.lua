if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/1853" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "SCP 1853"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = "Increased dexterity and weapon handling when your life is in danger."
SWEP.Category = "SCP"

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/sweps/scpsl/1853/v_1853.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/1853/w_1853.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 5
SWEP.SlotPos = 6
SWEP.DrawAmmo = true

SWEP.Primary.Ammo = "scp-1853"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local HealAmount = 1
local ArmorAmount = 0

function SWEP:Initialize()
    self:SetHoldType("slam")
end  

function SWEP:Deploy()
    local owner = self:GetOwner() 

    self:SendWeaponAnim(ACT_VM_DRAW)
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = 0
	self.InitializeHealing = 0

	-- self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_1853") end -- Reminder
	
	return true
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()

    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_1853" then -- Reminder
            owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + HealAmount))
            owner:SetArmor(math.min(owner:GetMaxArmor(), owner:Armor() + ArmorAmount))
            owner:RemoveAmmo(1, "scp-1853") -- Reminder
            -- owner:EmitSound("scpsl_medkit_use_03")
            weapon:Deploy()
        end
    end
end

function Apply1853Buff(owner, swep)
    if owner.Consumed1853 == 1 then return end
	if SERVER then owner:ApplyEffect("SCP1853", math.huge) end 
	if owner.Consumed207 == 0 and owner.Consumed1853 == 0 and owner.ConsumedAnti207 == 0 then
	    owner.DefaultJumpHeightSCPSL = owner:GetJumpPower()  
        owner.DefaultRunSpeedSCPSL = owner:GetRunSpeed()
	end
end

function SWEP:PrimaryAttack()
    local owner = self.Owner

    if owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
	
	if SERVER then
	    if owner:HaveEffect("Panacea") then return end
	end

    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0)
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.InitializeHealing = 1
	self.Idle = 1
end
function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local owner = self.Owner
    if self.Idle == 0 and self.IdleTimer <= CurTime() then -- Idle Sequence
		self:SendWeaponAnim(ACT_VM_IDLE)  
        self.Idle = 1
    end
	
	if self.InitializeHealing == 1 and self.IdleTimer <= CurTime() then
	    if IsValid(self) then
            Heal(owner, self)
			Apply1853Buff(owner, swep)
		end
	end
end

function SWEP:PostDrawViewModel( vm )
    local attachment = vm:GetAttachment(2)
    if attachment then
        self.vmcamera = vm:GetAngles() - attachment.Ang
    else
        self.vmcamera = Angle(0, 0, 0) 
    end
end

function SWEP:CalcView( ply, pos, ang, fov )
	self.vmcamera = self.vmcamera or Angle(0, 0, 0)  
    return pos, ang + self.vmcamera, fov
end

if CLIENT then -- Worldmodel offset
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			local offsetVec = Vector(-8, -3, -14)
			local offsetAng = Angle(-90, 0, 0)
			
			local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
			self:DrawModel()
		end

		WorldModel:DrawModel()

	end
end

-- function SWEP:Holster()
    -- hook.Remove("PlayerDeath", "DMGBuff")
	
	-- return true
-- end

-- if CLIENT then
    -- owner:ChatPrint("You have consumed SCP-1853.")
-- end

    -- local HookPlayerDeath = "IfPlayerDied_1853" .. self:EntIndex()
	-- local HookPlayerDamage = "IfPlayerTookDamage_1853" .. self:EntIndex()
	
	-- self.Danger = 0
	-- self.TimerDecDanger = 0
	
	-- hook.Add("EntityTakeDamage", HookPlayerDamage, function(target, dmginfo)
        -- if target == owner then
		
		-- local damage = dmginfo:GetDamage()
			-- if damage == 10 then
			    -- self.Danger = self.Danger + 1
			-- end
        -- end
    -- end)

    -- hook.Add("PlayerDeath", HookPlayerDeath, function(victim, inflictor, attacker)
        -- if victim == owner then
           
            -- hook.Remove("PlayerDeath", HookPlayerDeath)
            -- hook.Remove("EntityTakeDamage", HookPlayerDamage)
            -- hook.Remove("PlayerTick", HookPlayerThink)
        -- end
    -- end)