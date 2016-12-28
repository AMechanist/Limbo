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

	local vPoint = self:GetPos()+Vector(0,0,10)
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	effectdata:SetColor(255)
	util.Effect( "limbo_portal", effectdata )

	v = self:GetPos()

	for b,c in pairs(player.GetAll()) do
		if c:GetPos():Distance(v)<40 and c.LToggle == false then
			c.LToggle = true
			c:ConCommand("limbo_toggle")
		elseif c:GetPos():Distance(v)>50 and c.LToggle == true then
			c.LToggle = false
		end
	end
				
	for b,c in pairs(ents.GetAll()) do
		if !c:IsPlayer() and not self then
			if c:GetPos():Distance(v)<40 and (c.LToggle == false or c.LToggle == nil) and c:GetVelocity():Length() > 0 then
				c.LToggle = true
				SetPropLimbo(c,true)
			elseif c:GetPos():Distance(v)>100 and c.LToggle == true then
				c.LToggle = false
				SetPropLimbo(c,false)
			end
		end
	end

	--[[for b,c in pairs(ents.FindByClass("limbo_*")) do
		if c:GetPos():Distance(v)<100 and c!=self then
			local vPoint = LerpVector(0.5,self:GetPos(),c:GetPos())
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "TimeStart", effectdata )

			local vPoint = LerpVector(0.5,self:GetPos(),c:GetPos())
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "TimeStop", effectdata )

			local vPoint = self:GetPos()+Vector(0,0,10)
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "limbo_explosion", effectdata )

			pos = self:GetPos()
			cpos = c:GetPos()

			local explode = ents.Create( "env_explosion" ) //creates the explosion
			explode:SetPos(  LerpVector(0.5,self:GetPos(),c:GetPos()) )
			//This will be where the player is looking (using)
			explode:SetOwner( self.Owner ) // this sets you as the person who made the explosion
			explode:Spawn() //this actually spawns the explosion
			explode:SetKeyValue( "iMagnitude", "300" ) //the magnitude
			explode:Fire( "Explode", 0, 0 )
			explode:EmitSound( "impacts/explosion2.mp3", 400, 400 )
			explode:Fire( "Kill", "", 0 );

			timer.Simple(1,function()
				local vPoint = LerpVector(0.5,pos,cpos)
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "TimeStart", effectdata )

				local vPoint = LerpVector(0.5,pos,cpos)
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "TimeStop", effectdata )
			end)

			--for b,c in pairs( ents.FindByClass( "prop_*" ) ) do
				--if c:GetPos():Distance(v)<600 and c:IsWeapon() == false then
					--if c:IsPlayer() then
						--c:ConCommand("limbo_toggle")
					--else
						--SetPropLimbo(c,!GetPropLimbo(c))
					--end
				--end
			--end

			for b,c in pairs( player.GetAll() ) do
				if c:GetPos():Distance(v)<600 and c:IsWeapon() == false then
					if c:IsPlayer() then
						c:ConCommand("limbo_toggle")
					else
						SetPropLimbo(c,!GetPropLimbo(c))
					end
				end
			end

			self:Remove()
			c:Remove()
		end
	end]]--
end
 