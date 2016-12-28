AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
	v = self:GetPos()

	--local vPoint = v
	--local effectdata = EffectData()
	--effectdata:SetOrigin( vPoint )
	--effectdata:SetRadius( 5000 )
	--effectdata:SetColor(0)
	--util.Effect( "VortDispel", effectdata )
 
	self:SetModel( "models/props_wasteland/light_spotlight01_lamp.mdl" )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetMoveType(MOVETYPE_NONE)   -- after all, gmod is a physics
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		--phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
	self:SetNoDraw(true)

	v = self:GetPos()

	for b,c in pairs(player.GetAll()) do
		if c:GetPos():Distance(v)<350 and c.LimboPunish==false and c:GetLimbo() then
			c:ConCommand("limbo_toggle")
		end
	end

	for b,c in pairs(ents.FindByClass("Limbo_Rift*")) do
		if c:GetPos():Distance(v)<350 then
			c:Remove()
		end
	end
end
 