AddCSLuaFile()

--[[
-----------------------------------------------------------------------------------------------------
Particle Cache
-----------------------------------------------------------------------------------------------------
]]
if CLIENT then
   game.AddParticles("particles/ep2/antlion_gib_02.pcf")
   
   PrecacheParticleSystem("antlion_gib_02_slime")
   PrecacheParticleSystem("antlion_gib_02_juice")
end

--[[
-----------------------------------------------------------------------------------------------------
Ammo Tables
-----------------------------------------------------------------------------------------------------
]]

game.AddAmmoType( {
name = "scp-207",
} )
game.AddAmmoType( {
name = "scp-500",
} )
game.AddAmmoType( {
name = "painkillers",
} )
game.AddAmmoType( {
name = "medkit",
} )
game.AddAmmoType( {
name = "injector",
} )
game.AddAmmoType( {
name = "scp-1853",
} )
game.AddAmmoType( {
name = "scp-330",
} )

--[[
-----------------------------------------------------------------------------------------------------
Sound Tables
-----------------------------------------------------------------------------------------------------
]]

---- Other
-- Medkit
-- PainKillers
-- Adrenaline
-- SCP_500
-- SCP_207
-- SCP_1853
-- SCP_330

----------------------------------------------------------------------------------------- Other

sound.Add( {
    name = "scpsl_cooldown",
    channel = CHAN_STATIC,
    volume = 0.3,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/Cooldown_B_1_second.wav",
    }
} )

--------------------------------------- Medkit

sound.Add( {
    name = "scpsl_medkit_equip",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/medkit/Medkit Equip.wav",
    }
} )
sound.Add( {
    name = "scpsl_medkit_use_01",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {105, 105},
    sound = {
        "weapons/scpsl/medkit/Medkit Use_01.wav",
    }
} )
sound.Add( {
    name = "scpsl_medkit_use_02",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {105, 105},
    sound = {
        "weapons/scpsl/medkit/Medkit Use_02.wav",
    }
} )
sound.Add( {
    name = "scpsl_medkit_use_03",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 65,
    pitch = {105, 105},
    sound = {
        "weapons/scpsl/medkit/Medkit Use_03.wav",
    }
} )

--------------------------------------- PainKillers

sound.Add( {
    name = "scpsl_pills_equip",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/painkillers/Painkillers_Equip.wav",
    }
} )
sound.Add( {
    name = "scpsl_pills_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/painkillers/Painkillers_Use.wav",
    }
} )


--------------------------------------- Adrenaline

sound.Add( {
    name = "scpsl_adrenaline_equip",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/injector/Adrenaline_Equip.wav",
    }
} )
sound.Add( {
    name = "scpsl_adrenaline_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/injector/Adrenaline_Use.wav",
    }
} )


--------------------------------------- SCP_500

sound.Add( {
    name = "scpsl_500_equip",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/500/SCP_500_Equip.wav",
    }
} )

sound.Add( {
    name = "scpsl_500_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/500/SCP_500_Use.wav",
    }
} )

--------------------------------------- SCP_207

sound.Add( {
    name = "scpsl_207_equip",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/207/207_Equip.wav",
    }
} )

sound.Add( {
    name = "scpsl_207_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 105},
    sound = {
        "weapons/scpsl/207/207_Use.wav",
    }
} )

sound.Add( {
    name = "scpsl_A207_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 105},
    sound = {
        "weapons/scpsl/207/A207_USE_1.wav",
    }
} )

--------------------------------------- SCP_1853

sound.Add( {
    name = "scpsl_1853_equip",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/1853/1853_Equip.wav",
    }
} )
sound.Add( {
    name = "scpsl_1853_use",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/1853/1853_Use.wav",
    }
} )
sound.Add( {
    name = "scpsl_1853_dangerinc",
    channel = CHAN_STATIC,
    volume = 0.75,
    level = 55,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/1853/1853_Danger_Increase.wav",
    }
} )
sound.Add( {
    name = "scpsl_1853_dangerdec",
    channel = CHAN_STATIC,
    volume = 0.35,
    level = 55,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/1853/1853_Danger_Decrease.wav",
    }
} )
sound.Add( {
    name = "scpsl_1853_heartbeat",
    channel = CHAN_STATIC,
    volume = 0.75,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/1853/1853_Subtle_Heartbeat_" .. math.random(1,3) .. ".wav", 
    }
} )

--------------------------------------- SCP_330

sound.Add( {
    name = "scpsl_330_draw",
    channel = CHAN_STATIC,
    volume = 0.3,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/330/Candy_Equip.wav",
    }
} )
sound.Add( {
    name = "scpsl_330_start",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 115},
    sound = {
        "weapons/scpsl/330/Candy_Start.wav",
    }
} )
sound.Add( {
    name = "scpsl_330_eat",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/330/Candy_Eat.wav",
		"weapons/scpsl/330/Candy_Crunch.wav",
    }
} )
sound.Add( {
    name = "scpsl_330_crunch",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/330/Candy_Crunch.wav",
    }
} )