if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/207anti" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "SCP Anti 207"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = "Good for your health, bad for your motor skills."
SWEP.Category = "SCP: SL"

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/sweps/scpsl/207/v_anti207.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/207/w_anti207.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 5
SWEP.SlotPos = 5
SWEP.DrawAmmo = true

SWEP.Primary.Ammo = "scp-207"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local HealAmount = 0
local ArmorAmount = 0
local HealTime = 4

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

    self:SendWeaponAnim(ACT_VM_DRAW)
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = 0
	self.InitializeHealing = 0
	self.vmcamera = nil

	-- self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_anti207") end -- Reminder
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()

    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_anti207" then -- Reminder
            owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + HealAmount))
            owner:SetArmor(math.min(owner:GetMaxArmor(), owner:Armor() + ArmorAmount))
            owner:RemoveAmmo(1, "scp-207") -- Reminder
            -- owner:EmitSound("scpsl_medkit_use_03")
            weapon:Deploy()
        end
    end
end

function ApplyAnti207Buff(owner, swep)
    if owner.ConsumedAnti207 == 2 then return end
	
	owner.ConsumedAnti207 = owner.ConsumedAnti207 + 1
	
	if not owner:HaveEffect("SCPAntiCola1") and not owner:HaveEffect("SCPAntiCola2")then
        owner:ApplyEffect("SCPAntiCola1", math.huge)
    elseif owner:HaveEffect("SCPAntiCola1") then
        owner:ApplyEffect("SCPAntiCola2", math.huge)
        owner:SoftRemoveEffect("SCPAntiCola1")
    end
	
	if owner.Consumed207 ~= 0 then
		local explosionPos = owner:GetPos()
                
        local effectData = EffectData()
        effectData:SetOrigin(explosionPos)
        effectData:SetScale(1) -- Scale of the explosion
        effectData:SetRadius(300) -- Explosion radius
        effectData:SetMagnitude(100) -- Explosion magnitude
        util.Effect("HelicopterMegaBomb", effectData, true, true)

        owner:EmitSound("BaseExplosionEffect.Sound", 100, 100)

        if owner:Alive() then owner:Kill() end
        util.BlastDamage(owner, owner, explosionPos, 150, 350)
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
    if self.InitializeHealing == 1 then
	    self.InitializeHealing = 0
		self:SetNextPrimaryFire(CurTime() + 0)
		self:Deploy()
	else
        local owner = self:GetOwner()
        local startPos = owner:GetShootPos()
        local aimVec = owner:GetAimVector()
        local endPos = startPos + (aimVec * 110)

        local trace = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = owner
        })
        if trace.HitPos then
            local ENT = ents.Create("weapon_scpsl_anti207")
            if IsValid(ENT) then
                ENT:SetPos(trace.HitPos + trace.HitNormal * 5)
                ENT:Spawn()
            end
        end
	    owner:RemoveAmmo(1, "scp-207")
	    if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_anti207") end -- Reminder
	end
end

function SWEP:Think()
	local owner = self.Owner
    -- if self.Idle == 0 and self.IdleTimer <= CurTime() then -- Idle Sequence
		-- self:SendWeaponAnim(ACT_VM_IDLE)  
        -- self.Idle = 1
    -- end
	
	if self.InitializeHealing == 1 and self.IdleTimer <= CurTime() then
	    if ( IsValid(owner) && SERVER ) then
            Heal(owner, self)
			if InitializeSEF == true then ApplyAnti207Buff(owner, swep) end
		end
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
			local offsetVec = Vector(2, -1, -1)
			local offsetAng = Angle(180, 0, 0)
			
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

