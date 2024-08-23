if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/injector_yellow" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "Rage Injector"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = [[
Provides 40 Temporary Armor
Grants +40 Units of Movespeed
]]
SWEP.Category = "SCP: SL"

SWEP.ViewModelFOV = 70
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
local InitializeSEF = false
local DischargeTime = nil

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

	-- self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	
	timer.Simple(0.05, function()
        if IsValid(self) and IsValid(self.Owner) then
            local vm = self.Owner:GetViewModel()
            if IsValid(vm) then
                vm:SetSkin(3) 
            end
        end
    end)
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_injector_yellow") end
	
	return true
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()
    
	
    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_injector_yellow" then
        
			if InitializeSEF == true then
				    -- owner:ApplyEffect("Energized", 5, 1, 1)
				    owner:ApplyEffect("Bloodlust", 45, 15, 5)
			else
                owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + HealAmount))
                owner:SetArmor(math.min(owner:GetMaxArmor(), owner:Armor() + ArmorAmount))
			end
            owner:RemoveAmmo(1, "injector")
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
    if CLIENT then return end
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
            local ENT = ents.Create("weapon_scpsl_injector_yellow")
            if IsValid(ENT) then
                ENT:SetPos(trace.HitPos + trace.HitNormal * 5)
                ENT:Spawn()
            end
        end
	    owner:RemoveAmmo(1, "injector")
	    if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_injector_yellow") end -- Reminder
	end
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

	WorldModel:SetSkin(3)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			local offsetVec = Vector(3, -1, -0)
			local offsetAng = Angle(-90, 90, 0)
			
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