if SERVER then
	AddCSLuaFile("autorun/limbo_cl.lua")

	util.AddNetworkString( "PropLimbo" )
	util.AddNetworkString( "Limbo" )

	timer.Simple(10,function()
		ULib.ucl.registerAccess( "limbo_access", ULib.ACCESS_ADMIN, "Ability to sentence players to Limbo, or go there yourself.", "Limbo" )
	end)

	LimboStatus = {}
	PropLimboStatus = {}
	Rift = {}
	RiftTime = {}
	RiftOwner = {}

	local meta = FindMetaTable("Player")

	function meta:SetLimbo(bool)
		LimboStatus[self:EntIndex()] = bool

		self:SetNWBool("Hidden",bool)

		if bool then
			self:RemoveAllItems()
		end

		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "TimeRev", effectdata )

		for k,v in pairs(LimboStatus) do
			net.Start("Limbo")
				net.WriteBool(v)
				net.WriteString(tostring(k))
				net.WriteBool(bool)
				net.WriteString(tostring(self:EntIndex()))
				if k==1 then
					net.WriteBool(true)
				else
					net.WriteBool(false)
				end
			net.Broadcast()
		end
	end

	function meta:GetLimbo()
		if LimboStatus[self:EntIndex()] ~= nil then
			return LimboStatus[self:EntIndex()]
		else
			return false
		end
	end

	function SetPropLimbo(ent,bool)
		PropLimboStatus[ent:EntIndex()] = bool

		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "TimeRev", effectdata )

		for k,v in pairs(PropLimboStatus) do
			net.Start("PropLimbo")
				net.WriteBool(v)
				net.WriteString(tostring(k))
				if k==1 then
					net.WriteBool(true)
				else
					net.WriteBool(false)
				end
			net.Broadcast()
		end
	end

	function GetPropLimbo(ent)
		if PropLimboStatus[ent:EntIndex()] ~= nil then
			return PropLimboStatus[ent:EntIndex()]
		else
			return false
		end
	end

	for k,v in pairs(player.GetAll()) do
		v:SetLimbo(false)
		v.LimboPunish = false

		v.OldPos = Vector(0,0,0)
		v.LToggle = false
		v.Rift = false
	end

	hook.Add( "PlayerInitialSpawn", "some_unique_name", function(v)
		v:SetLimbo(false)
		v.LimboPunish = false

		v.OldPos = Vector(0,0,0)
		v.LToggle = false
		v.Rift = false
	end)

	hook.Add( "PlayerSay", "chatCommand", function( ply, text, public )
		local check = false

		if string.lower(text) == "!limbo" and ply:GetLimbo() == true and check == false and ply.LimboPunish==false then
			ply:SetLimbo(false)

			for k,v in pairs(ply.OWeapons) do
				ply:Give(tostring(v))
			end

			check = true
		end

		if string.lower(text) == "!limbo" and ply:GetLimbo() == false and check == false and ply.LimboPunish==false then
			ply.OWeapons = {}
			
			for k,v in pairs(ply:GetWeapons()) do
				table.insert(ply.OWeapons,v:GetClass())
			end

			ply:SetLimbo(true)

			check = true
		end

		if ULib.ucl.query( ply, "limbo_access" )  then 

			text = string.Explode(" ",text)

			if string.lower(text[1])=="!limbo" and string.lower(text[2])~=nil then

				local time = tonumber(string.lower(text[2]))

				table.remove(text,1)
				table.remove(text,1)

				text = string.Implode(" ",text)

				for k,v in pairs(player.GetAll()) do

					if string.lower(text) == string.lower(v:Nick()) then

						timer.Simple(2,function()
							PrintMessage( HUD_PRINTTALK, v:Nick().." Has Been Sentenced To Limbo For "..tostring(time).. " Seconds." )
						end)

						v.LimboTimer = time
						v.LimboPunish = true

						v:SetLimbo(true)

						timer.Simple(time,function()
							if IsValid(v) and v~=nil then
								PrintMessage( HUD_PRINTTALK, v:Nick().." Has Been Released From Limbo." )

								v:SetLimbo(false)

								v.LimboTimer = 0
								v.LimboPunish = false
							end
						end)

						break
					end
				end
			end
		end
	end)

	concommand.Add( "limbo_toggle", function( ply, cmd, args )
		local check = false

		--ply:ConCommand("pac_clear_parts")

		if ply:GetLimbo() == true and check == false and ply.LimboPunish==false  then
			ply:SetLimbo(false)

			for k,v in pairs(ply.OWeapons) do
				ply:Give(tostring(v))
			end

			check = true
		end

		if ply:GetLimbo() == false and check == false and ply.LimboPunish==false  then
			ply.OWeapons = {}
			
			for k,v in pairs(ply:GetWeapons()) do
				table.insert(ply.OWeapons,v:GetClass())
			end

			ply:SetLimbo(true)

			check = true
		end
	end )

	hook.Add("EntityTakeDamage","interlayering_damageprevention",function( target, dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and target:IsPlayer() then
			if (target:GetLimbo()~=nil and dmginfo:GetAttacker():GetLimbo()~=nil) then
				if (dmginfo:GetAttacker():GetLimbo()==target:GetLimbo()) then
					dmginfo:ScaleDamage(1)
				else
					dmginfo:ScaleDamage(0)
				end
			end
		else
			dmginfo:ScaleDamage(1)
		end
	end)

	hook.Add( "PlayerSpawnProp", "Prop_SetLayer", function(ply,mdl,ent)

		if ply:GetLimbo() == true then
			return false
		end
	end)

	hook.Add( "Think", "Gravity", function()
		for k,v in pairs(PropLimboStatus) do
			if !IsValid(ents.GetByIndex(tonumber(k))) then
				table.remove(PropLimboStatus,k)
			end
		end

		for k,v in pairs(LimboStatus) do
			if !IsValid(ents.GetByIndex(tonumber(k))) then
				table.remove(LimboStatus,k)
			end
		end

		for k,v in pairs(player.GetAll()) do
			if v:GetLimbo() then
				v:SetCollisionGroup( 1 )
				v:SetGravity(0)
			else
				v:SetCollisionGroup( 0 )
				v:SetGravity(0)
			end
		end
	end)

	hook.Add("PlayerFootstep","MuteFootSteps",function( ply, pos, foot, sound, volume, rf )
		if ply:GetLimbo() then
			return true -- Don't allow default footsteps
		end
	end)


	hook.Add("PlayerCanPickupWeapon", "WeaponSpawningPrevention", function( ply, class, wep )
		if ply:GetLimbo() then
			return false
		else
			return true
		end
	end)
end