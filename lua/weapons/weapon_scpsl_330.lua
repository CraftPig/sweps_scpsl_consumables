if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/330" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "SCP 330 Candies"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = "A bag of candies that apply random buffs."
SWEP.Category = "SCP"

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/sweps/scpsl/330/v_330.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/330/w_330.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 9
SWEP.DrawAmmo = true

SWEP.Primary.Ammo = "scp-330" 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local InitializeSEF = false

function SWEP:Initialize()
    self:SetHoldType("slam")
	
	local FilePathSEF = "lua/SEF/SEF_Functions.lua"
    if file.Exists(FilePathSEF, "GAME") then
        InitializeSEF = true
    else
        InitializeSEF = false
    end
end  

function SWEP:Deploy()
    local owner = self:GetOwner() 
	
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = 0
	self.InitializeEating = 0
	self.Eating = 0
	
	owner:GetViewModel():SetBodygroup(0, 0)
	owner:GetViewModel():SetBodygroup(1, 0)

    self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 0)
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then
        owner:StripWeapon("weapon_scpsl_330")
	end

	-- if owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
end

function SWEP:PrimaryAttack()
    local owner = self.Owner
    if owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
	
	self.InitializeEating = 1

	self:SendWeaponAnim(ACT_VM_HOLSTER)
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()

    self:SetNextPrimaryFire(CurTime() + self.IdleTimer) -- Prevent Primary fire
	
	SetCandy = math.random(1, 100)
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()
	local BlueCandyArmor = 30
	local GreenCandyRegen = 1
	local GreenCandyRepeat = 120
	local PurpleCandyRegen = 1
	local PurpleCandyRepeat = 20
	local RainbowCandyHealth = 15
	local RainbowCandyArmor = 10
	local RedCandyRegen = 9
	local RedCandyRepeat = 5
	local YellowCandyHealth = 35

    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_330" then
		if InitializeSEF == false then return end
		
		------------------------------------------------------------------------------------------------------ Stupid Decision Tree
		    if SetCandy <= 16 then -- blue
			    owner:ApplyEffect("Energized", 1, 30, 1)
			elseif SetCandy <= 32 then -- green
			    owner:ApplyEffect("Healing", 80, 1, 1)
				owner:ApplyEffect("Tenacity", 30)
			elseif SetCandy <= 48 then -- purple
			    owner:ApplyEffect("Healing", 15, 1, 1)
				owner:ApplyEffect("Endurance", 15)
			elseif SetCandy <= 64 then -- rainbow
			    owner:ApplyEffect("Energized", 1, 15, 1)
				owner:ApplyEffect("Healing", 1, 15, 1)
				owner:ApplyEffect("Tenacity", 3)
			elseif SetCandy <= 80 then -- red
			    owner:ApplyEffect("Healing", 5, 9, 1)
			elseif SetCandy <= 96 then -- yellow
			    owner:ApplyEffect("Haste", 20, 40)
			else -- pink
                local explosionPos = owner:GetPos()
                
                local effectData = EffectData()
                effectData:SetOrigin(explosionPos)
                effectData:SetScale(1) -- Scale of the explosion
                effectData:SetRadius(300) -- Explosion radius
                effectData:SetMagnitude(100) -- Explosion magnitude
                util.Effect("HelicopterMegaBomb", effectData, true, true)

                owner:EmitSound("BaseExplosionEffect.Sound", 100, 100)

                util.BlastDamage(owner, owner, explosionPos, 300, 300)
            end
		------------------------------------------------------------------------------------------------------ End Decision Tree 
            owner:RemoveAmmo(1, "scp-330")
            weapon:Deploy()
        end
    end
end

function SWEP:Think()
    local owner = self.Owner
	
    if self.Idle == 0 and self.IdleTimer <= CurTime() then -- Idle Sequence
		self:SendWeaponAnim(ACT_VM_IDLE)  
        self.Idle = 1
    end
	
	if self.InitializeEating == 1 and self.IdleTimer <= CurTime() then -- Initialize Eating sequence
	    self.InitializeEating = 0
	------------------------------------------------------------------------------------------------------ Stupid Decision Tree	
		owner:GetViewModel():SetBodygroup(0, 1)
		self:EmitSound("scpsl_330_eat")
		if SetCandy <= 16 then -- blue
            owner:GetViewModel():SetBodygroup(1, 1)
		elseif SetCandy <= 32 then -- green
            owner:GetViewModel():SetBodygroup(1, 2)
		elseif SetCandy <= 48 then -- purple
            owner:GetViewModel():SetBodygroup(1, 3)
		elseif SetCandy <= 64 then -- rainbow
            owner:GetViewModel():SetBodygroup(1, 4)
		elseif SetCandy <= 80 then -- red
            owner:GetViewModel():SetBodygroup(1, 5)
		elseif SetCandy <= 96 then -- yellow
            owner:GetViewModel():SetBodygroup(1, 6)
		else -- pink
            owner:GetViewModel():SetBodygroup(1, 7)
		end
		------------------------------------------------------------------------------------------------------ End Decision Tree 
	    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
		self.Eating = 1
	end
	
	if self.Eating == 1 and self.IdleTimer <= CurTime() then -- Call heal and reset
	    self.Eating = 0	
	    Heal(owner, self, weapon)		
	end
end

function SWEP:PostDrawViewModel( vm )
    local attachment = vm:GetAttachment(1)
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
			local offsetVec = Vector(3, -2, 1)
			local offsetAng = Angle(0, 60, -200)
			
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

function SWEP:Holster()
	return true
end