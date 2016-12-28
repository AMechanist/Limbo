
hook.Add("Initialize","Init",function()
	AddCSLuaFile( "autorun/limbo_cl.lua" )
	include("autorun/limbo_sv.lua")
	resource.AddFile("sound/music/Ambience.mp3")
end)

AddCSLuaFile( "autorun/limbo_cl.lua" )
include("autorun/limbo_sv.lua")
resource.AddFile("sound/music/Ambience.mp3")
