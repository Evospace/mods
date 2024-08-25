local EXBIO_Plains = {}

function EXBIO_Plains.init()
    local wg = LuaWorldGenerator.new("EXBIO_PlainsGenerator")

    local bf = BiomeFamily.new("EXBIO_Plains")
    bf.sub_biomes = { Biome.find("PlainBiomeFamily") }

    local height = HeightGenerator.new("EXBIO_Height3")
    local noise = NoiseGenerator.new("EXBIO_Noise3")
    noise:set_frequency(0.005)
    noise.min = 2
    noise.max = 6

    height:add_noise(noise)

    wg.biome_family = bf
    wg.height = height
end

function EXBIO_Plains.pre_init()
end

function EXBIO_Plains.post_init()
end

db:mod(EXBIO_Plains)
