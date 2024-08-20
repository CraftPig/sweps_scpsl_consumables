if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/500" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "SCP 500"
SWEP.Author = "Craft_Pig"
SWEP.Purpose = "The Panacea. Instantly restores all health and cures most afflictions."
SWEP.Category = "SCP"

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/sweps/scpsl/500/v_500.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/500/w_500.mdl"
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawAmmo = true

SWEP.Primary.Ammo = "scp-500" 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

local HealAmount = 100
local ArmorAmount = 0
local HealTime = 1.8

local RegenAmount = 5
local RegenDuration = 20

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

    self:SendWeaponAnim(ACT_VM_DRAW)
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = 0
	self.InitializeHealing = 0

	-- self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	
	if owner:GetAmmoCount(self.Primary.Ammo) == 0 then owner:StripWeapon("weapon_scpsl_500") end -- Reminder
	
	return true
end

local function Heal(owner, weapon)
    local activeWeapon = owner:GetActiveWeapon()

    if IsValid(weapon) then
        if IsValid(owner) and SERVER and activeWeapon:GetClass() == "weapon_scpsl_500" then -- Reminder		
			if InitializeSEF == true then
			    owner:ApplyEffect("Healing", 1, 100, 1)
				owner:ApplyEffect("Panacea", 10)
				-- owner:SoftRemoveEffect("Exposed") 
			else
                owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + HealAmount))
                owner:SetArmor(math.min(owner:GetMaxArmor(), owner:Armor() + ArmorAmount))
			end
			
			if ( owner.Consumed1853 == 1 or owner.Consumed207 > 0 or owner.ConsumedAnti207 > 0 or owner.HasDrinkSCP207 == true ) then
			    if owner.Consumed1853 == 1 then owner:ChatPrint("Cured SCP 1853's effects") end
				if owner.Consumed207 ~= 0 or owner.HasDrinkSCP207 == true then owner:ChatPrint("Cured SCP 207's effects") end
				if owner.ConsumedAnti207 ~= 0 then owner:ChatPrint("Cured SCP Anti-207's effects") end
				hook.Run("ResetBuffsSCPSL", owner)
				owner:EmitSound("scpsl_cooldown")
			end
			owner:RemoveAmmo(1, "scp-500") -- Reminder
			weapon:Deploy()
        end
    end
end

local function Regenerate(owner, weapon)
    timer.Create("TimerHealthRegenPainkillersSCPSL", 0.5, RegenDuration, function()
        if IsValid(owner) and owner:Alive() then
            owner:SetHealth(math.min(owner:Health() + RegenAmount, owner:GetMaxHealth()))
        else
            timer.Remove("TimerHealthRegenPainkillersSCPSL")
        end
    end)
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
			Regenerate(owner, weapon)
		end
	end
end

-- function SWEP:CalcView(ply, pos, ang, fov) -- Attach view to attachment
    -- local vm = ply:GetViewModel()
    -- if not IsValid(vm) then return pos, ang end

    -- local attachmentID = 1 
    -- local attachment = vm:GetAttachment(attachmentID)

    -- if attachment then
        -- local attachmentPos = attachment.Pos
        -- local attachmentAng = attachment.Ang

        -- local offsetPos = pos + (attachmentPos - vm:GetPos())
        -- local offsetAng = ang + (attachmentAng - vm:GetAngles())

        -- pos = 1
        -- ang = offsetAng
    -- end

    -- return pos, ang, fov
-- end

function SWEP:SecondaryAttack()
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(4, -1, -1)
			local offsetAng = Angle(0, -130, -90)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

	    -- if ( IsValid(owner) && SERVER ) then 
			
			-- Heal(owner, self)
			-- Regenerate(owner, self)
			
			-- if ( owner.Consumed1853 == 1 or owner.Consumed207 > 0 or owner.ConsumedAnti207 > 0 or owner.HasDrinkSCP207 == true ) then
			
			    -- if owner.Consumed1853 == 1 then owner:ChatPrint("Cured SCP 1853's effects") end
				-- if owner.Consumed207 ~= 0 or owner.HasDrinkSCP207 == true then owner:ChatPrint("Cured SCP 207's effects") end
				-- if owner.ConsumedAnti207 ~= 0 then owner:ChatPrint("Cured SCP Anti-207's effects") end
			
				-- hook.Run("ResetBuffsSCPSL", owner)
				
				-- if IsSCP207TheRealEntityValid == true and owner.HasDrinkSCP207 == true then
		        -- scp_207.CureEffect(self:GetOwner())
				-- owner.HasDrinkSCP207 = nil
		        -- end
				
				-- owner:EmitSound("scpsl_cooldown")

