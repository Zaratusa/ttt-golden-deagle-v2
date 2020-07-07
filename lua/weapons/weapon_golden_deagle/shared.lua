--- Author informations ---
SWEP.Author = "Zaratusa"
SWEP.Contact = "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
else
	SWEP.PrintName = "Golden Deagle"
	SWEP.Slot = 1
end

--- Default GMod values ---
SWEP.Base = "weapon_base"
SWEP.Category = "Counter-Strike: Source"
SWEP.Purpose = "Shoot with style."
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.6
SWEP.Primary.Recoil = 6
SWEP.Primary.Cone = 0.02
SWEP.Primary.Damage = 37
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Sound = Sound("Golden_Deagle.Single")

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

--- Model settings ---
SWEP.HoldType = "pistol"

SWEP.UseHands = true
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 85
SWEP.ViewModel = Model("models/weapons/zaratusa/golden_deagle/v_golden_deagle.mdl")
SWEP.WorldModel = Model("models/weapons/zaratusa/golden_deagle/w_golden_deagle.mdl")

function SWEP:Initialize()
	self:SetDeploySpeed(self.DeploySpeed)

	if (self.SetHoldType) then
		self:SetHoldType(self.HoldType or "pistol")
	end

	PrecacheParticleSystem("smoke_trail")
end

function SWEP:PrimaryAttack(worldsnd)
	if (self:CanPrimaryAttack()) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

		local owner = self:GetOwner()
		owner:GetViewModel():StopParticles()

		if (not worldsnd) then
			self:EmitSound(self.Primary.Sound)
		elseif SERVER then
			sound.Play(self.Primary.Sound, self:GetPos())
		end

		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		self:TakePrimaryAmmo(1)

		if (IsValid(owner) and not owner:IsNPC() and owner.ViewPunch) then
			owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		end

		timer.Simple(0.5, function() if (IsValid(self) and IsValid(self:GetOwner())) then ParticleEffectAttach("smoke_trail", PATTACH_POINT_FOLLOW, self:GetOwner():GetViewModel(), 1) end end)
	end
end

function SWEP:SecondaryAttack()
end


function SWEP:Holster()
	if (IsValid(self:GetOwner())) then
		local vm = self:GetOwner():GetViewModel()
		if (IsValid(vm)) then
			vm:StopParticles()
		end
	end
	return true
end
