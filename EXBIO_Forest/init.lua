local EXBIO_Forest = {}

function EXBIO_Forest.init()
    local wg = LuaWorldGenerator.new("EXBIO_ForestGenerator")

    local bf = BiomeFamily.new("EXBIO_Forest")
    bf.sub_biomes = { Biome.find("ForestBiomeFamily") }

    local height = HeightGenerator.new("EXBIO_Height1")
    local noise = NoiseGenerator.new("EXBIO_Noise1")
    noise:set_frequency(0.03)
    noise.min = 2
    noise.max = 10

    height:add_noise(noise)

    wg.biome_family = bf
    wg.height = height

    wg = LuaWorldGenerator.new("EXBIO_ForestGeneratorFlat")

    bf = BiomeFamily.new("EXBIO_Forest_Flat")
    bf.sub_biomes = { Biome.find("ForestBiomeFamily") }

    height = HeightGenerator.new("EXBIO_Height2")
    noise = NoiseGenerator.new("EXBIO_Noise2")
    noise:set_frequency(0.005)
    noise.min = 2
    noise.max = 3

    height:add_noise(noise)

    wg.biome_family = bf
    wg.height = height
end

function EXBIO_Forest.pre_init()
end

function EXBIO_Forest.post_init()
end

db:mod(EXBIO_Forest)
