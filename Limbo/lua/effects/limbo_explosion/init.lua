EFFECT.emitter = nil
EFFECT.Position = Vector(0,0,0)
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()	
	self.emitter = ParticleEmitter( self.Position )
	
	for i=1,200 do

			local particle = self.emitter:Add( "particle/snow", self.Position + Vector(	math.random( -20, 20 ),math.random( -20, 20 ),math.random( 0, 90 )) )	

				particle:SetVelocity( Vector( math.random(200,-200), math.random(200,-200), math.random(200,-200)))
				particle:SetDieTime(2)
				particle:SetStartAlpha(60)
				particle:SetEndAlpha(60)
				particle:SetStartSize(10)
				particle:SetEndSize(3)
				particle:SetRoll( math.Rand( -10,10  ) )
				particle:SetRollDelta(math.Rand( -2, 2 ))
				particle:SetColor( Color(40, 40, 40,20))	

				timer.Simple(1,function()
					particle:SetVelocity(-particle:GetVelocity())
				end)	
	end

	for i=1,200 do

		local particle = self.emitter:Add( "Effects/strider_pinch_dudv", self.Position + Vector(	math.random( -20, 20 ),math.random( -20, 20 ),math.random( 0, 90 )) )	

			particle:SetVelocity( Vector(math.random(50,-50), math.random(50,-50), math.random(50,-50)))
			particle:SetDieTime(7)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.random( 10, 30 ))
			particle:SetEndSize(1)
			particle:SetRoll( math.Rand( -10,10  ) )
			particle:SetRollDelta(math.Rand( -2, 2 ))
			particle:SetColor( 60, 60, 60)

			timer.Simple(1,function()
				particle:SetVelocity(-particle:GetVelocity())
			end)				
	end
	
	self.emitter:Finish()
end

function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end


