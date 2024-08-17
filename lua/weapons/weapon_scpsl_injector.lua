if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/injector" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "Adrenaline"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = "Provides 40 Armor."
SWEP.Category = "SCP"

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/sweps/scpsl/injector/v_injector.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/injector/w_injector.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 7
SWEP.DrawAmmo = true
SWEP.Primary.Ammo = "injector"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local HealAmount = 0
local ArmorAmount = 40

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
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_injector") end
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()

    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_injector" then
            owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + HealAmount))
            owner:SetArmor(math.min(owner:GetMaxArmor(), owner:Armor() + ArmorAmount))
            owner:RemoveAmmo(1, "injector")
            -- owner:EmitSound("scpsl_medkit_use_03")
            weapon:Deploy()
        end
    end
end

function SWEP:PrimaryAttack()
    local owner = self.Owner

    if owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end

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
			local offsetVec = Vector(3, -0, -0)
			local offsetAng = Angle(180, 90, 0)
			
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