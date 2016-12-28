EFFECT.emitter = nil
EFFECT.Position = Vector(0,0,0)
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()	
	self.emitter = ParticleEmitter( self.Position )
	
	for i=1,20 do

			local particle = self.emitter:Add( "particle/snow", self.Position + Vector(	math.random( -20, 20 ),math.random( -20, 20 ),math.random( 0, 90 )) )	

				particle:SetVelocity( Vector( math.random(1,-1), math.random(1,-1), math.random(1,-1)))
				particle:SetDieTime(3)
				particle:SetStartAlpha(60)
				particle:SetEndAlpha(60)
				particle:SetStartSize(10)
				particle:SetEndSize(0)
				particle:SetRoll( math.Rand( -10,10  ) )
				particle:SetRollDelta(math.Rand( -2, 2 ))
				particle:SetColor( Color(255, 255, 255,60))			
	end

	for i=1,20 do

		local particle = self.emitter:Add( "Effects/strider_pinch_dudv", self.Position + Vector(	math.random( -20, 20 ),math.random( -20, 20 ),math.random( 0, 90 )) )	

			particle:SetVelocity( Vector(math.random(1,-1), math.random(1,-1), math.random(1,-1)))
			particle:SetDieTime(1)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.random( 10, 30 ))
			particle:SetEndSize(0)
			particle:SetRoll( math.Rand( -10,10  ) )
			particle:SetRollDelta(math.Rand( -2, 2 ))
			particle:SetColor( 60, 60, 60)			
	end
	
	self.emitter:Finish()
end

function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end


