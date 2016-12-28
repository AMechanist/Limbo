if CLIENT then
	include('limbo_init.lua')

	local LimboStatus = {}
	local PropLimboStatus = {}
	local Cmdls = {}

	local meta = FindMetaTable("Player")

	function meta:IsLimbo()
		if #LimboStatus>0 then
			return LimboStatus[LocalPlayer():EntIndex()]
		else
			return false
		end
	end

	function meta:GetLimbo()
		if LimboStatus[self:EntIndex()] ~= nil then
			return LimboStatus[self:EntIndex()]
		else
			return false
		end
	end

	function GetPropLimbo(ent)
		if PropLimboStatus[ent:EntIndex()] ~= nil then
			return PropLimboStatus[ent:EntIndex()]
		else
			return false
		end
	end

	function meta:GhostProp(mdl,pos,angs,cl,mat)
		c_Model = ents.CreateClientProp()
		c_Model:SetPos( pos )
		c_Model:SetMaterial( mat )
		c_Model:SetColor( cl )
		c_Model:SetModel( mdl )
		c_Model:SetAngles( angs )
		c_Model:Spawn()

		--c_Model:PhysicsInit(SOLID_VPHYSICS)
		--c_Model:SetSolid(SOLID_VPHYSICS)
		--local phys = c_Model:GetPhysicsObject() 
		--phys:Wake()
		--c_Model:SetMoveType(MOVETYPE_VPHYSICS)

		table.insert(Cmdls,c_Model)
	end


	local emitter
	hook.Add("RenderScreenspaceEffects", "RenderScreenspaceEffects_Ghost", function()
		if LocalPlayer():IsLimbo() then
			local tbl = {
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg" ] = 0,
				["$pp_colour_addb" ] = 0,
				["$pp_colour_brightness" ] = -0.01,
				["$pp_colour_contrast" ] = 1,
				["$pp_colour_colour" ] = 0,
				["$pp_colour_mulr" ] = 0.05,
				["$pp_colour_mulg" ] = 0.05,
				["$pp_colour_mulb" ] = 0.05
			}
			DrawColorModify(tbl)
			cam.Start3D(EyePos(), EyeAngles())
				for k,v in pairs(player.GetAll()) do
					--if v:IsLimbo() and v:Alive() then
						--render.SuppressEngineLighting( true )
						--render.SetColorModulation(1,1,1)
						--if emitter then
							--emitter:Draw()
						--end
						--v:DrawModel()
						--render.SuppressEngineLighting( false )
					--end
				end
			cam.End3D()
		end
	end)

	hook.Add("Think","ShouldRender",function()
		for k,v in pairs(ents.FindByClass("Limbo_Field*")) do
			if LocalPlayer():GetPos():Distance(v:GetPos())<1300 then
				MaxFlakes = 200

				parts = {}

				if(table.Count(parts) < MaxFlakes) then
					Col = Color(255,255,255,255)
						
					local em = ParticleEmitter(LocalPlayer():GetPos())
					local part = em:Add("particle/snow",v:GetPos()+Vector(math.Rand(-350,350),math.Rand(-350,350),-5))
					table.insert(parts,part)

					if part then
						part:SetColor(Col.r,Col.g,Col.b)
						part:SetRoll(math.random(0, 2*3.141596))
						part:SetStartSize(math.random(1, 2))
							
						part:SetCollide(1)
						part:SetLifeTime(0)
						part:SetDieTime(20)
						part:SetEndSize(part:GetStartSize())
						part:SetEndAlpha(25)
							
						part:SetVelocity(Vector(0,0,math.random(35,45)))
							
					end
					//kills the emmiter
					em:Finish()
				end
			end
		end
		
		for k,v in pairs(LimboStatus) do 
			if !IsValid(ents.GetByIndex(tonumber(k))) then
				table.remove(LimboStatus,k)
			end

			if v then
				if IsValid(ents.GetByIndex(tonumber(k))) then
					ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_NONE)
					ents.GetByIndex(tonumber(k)):SetNoDraw(true)
				else
					--table.remove(props,v)
				end
			else
				if IsValid(ents.GetByIndex(tonumber(k))) then
					ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_NORMAL)
					ents.GetByIndex(tonumber(k)):SetNoDraw(false)
				else
					--table.remove(props,v)
				end
			end
		end

		for k,v in pairs(player.GetAll()) do
			if v:GetLimbo() and v~=LocalPlayer() and LocalPlayer():IsLimbo() then
				v:SetRenderMode(RENDERMODE_NONE)
				v:SetNoDraw(true)

				MaxFlakes = 10

				parts = {}

				if(table.Count(parts) < MaxFlakes) then
					Col = Color(10,10,10,160)
						
					local em = ParticleEmitter(LocalPlayer():GetPos())
					local part = em:Add("particle/snow",v:GetPos()+Vector(math.Rand(-5,5),math.Rand(-5,5),40+math.Rand(-5,5)))
					table.insert(parts,part)

					if part then
						part:SetColor(Col.r,Col.g,Col.b)
						part:SetRoll(math.random(0, 2*3.141596))
						part:SetStartSize(math.random(30, 35))
							
						part:SetCollide(1)
						part:SetLifeTime(4)
						part:SetDieTime(7)
						part:SetEndSize(0)
						part:SetEndAlpha(25)
							
						part:SetVelocity(Vector(0,0,0))
							
					end
					//kills the emmiter
					em:Finish()
				end
			end
		end

		if LocalPlayer():IsLimbo() then
			MaxFlakes = 90

			parts = {}

			if(table.Count(parts) < MaxFlakes) then
				Col = Color(0,0,0,255)
					
				local em = ParticleEmitter(LocalPlayer():GetPos())
				local part = em:Add("particle/snow",LocalPlayer():GetPos()+Vector(math.Rand(-300,300),math.Rand(-300,300),20))
				table.insert(parts,part)

				if part then
					part:SetColor(Col.r,Col.g,Col.b)
					part:SetRoll(math.random(0, 2*3.141596))
					part:SetStartSize(math.random(0.5, 1))
						
					part:SetCollide(1)
					part:SetLifeTime(0)
					part:SetDieTime(20)
					part:SetEndSize(part:GetStartSize())
					part:SetEndAlpha(25)
						
					part:SetVelocity(Vector(0,0,math.random(5,15)))
						
				end
				//kills the emmiter
				em:Finish()
			end

			for k,v in pairs(PropLimboStatus) do
				if !IsValid(ents.GetByIndex(tonumber(k))) then
					table.remove(PropLimboStatus,k)
				end

				if v and IsValid(ents.GetByIndex(tonumber(k))) then
					--ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_None)
					ents.GetByIndex(tonumber(k)):SetNoDraw(true)
				elseif IsValid(ents.GetByIndex(tonumber(k))) and !ents.GetByIndex(tonumber(k)):IsWeapon() then
					--ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_NONE)
					ents.GetByIndex(tonumber(k)):SetNoDraw(true)
				end
			end
		else
			for k,v in pairs(PropLimboStatus) do
				if !IsValid(ents.GetByIndex(tonumber(k))) then
					table.remove(PropLimboStatus,k)
				end

				if v and IsValid(ents.GetByIndex(tonumber(k))) and ents.GetByIndex(tonumber(k)):IsVehicle()~=true then
					ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_NONE)
					ents.GetByIndex(tonumber(k)):SetNoDraw(true)
				elseif IsValid(ents.GetByIndex(tonumber(k))) then
					ents.GetByIndex(tonumber(k)):SetRenderMode(RENDERMODE_NORMAL)
					ents.GetByIndex(tonumber(k)):SetNoDraw(false)
				end
			end
		end
	end)


	net.Receive("Limbo",function()
		local row = net.ReadBool()
		local index = net.ReadString()
		local bool = net.ReadBool()
		local entindex = tonumber(net.ReadString())
		local clear = net.ReadBool()

		if clear==true then
			LimboStatus = {}

			if player.GetAll()[entindex] ==  LocalPlayer() and bool then
				LocalPlayer():SetDSP( 17, false )

				surface.PlaySound( "sound/music/Ambience.mp3" )

				for k,v in pairs(ents.FindByClass( "prop_*" )) do
					--LocalPlayer():GhostProp(v:GetModel(),v:GetPos(),v:GetAngles(),v:GetColor(),v:GetMaterial())
				end
			elseif player.GetAll()[entindex] ==  LocalPlayer() and bool==false then
				LocalPlayer():SetDSP( 0, false )

				LocalPlayer():ConCommand("stopsound")

				for k,v in pairs(Cmdls) do
					if IsValid(v) then
						v:Remove()
					end

					if k==#Cmdls then
						Cmdls = {}
					end
				end
			end
		end

		LimboStatus[tonumber(index)] = row
	end)

	net.Receive("PropLimbo",function()
		local row = net.ReadBool()
		local index = net.ReadString()
		local clear = net.ReadBool()

		if clear==true then
			PropLimboStatus = {}
		end

		PropLimboStatus[tonumber(index)] = row
	end)
end