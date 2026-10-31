local Vlib = require('@VanillaLib')

local DayAndNightSolar = {}

local function day_and_night(name)
    local base = StaticBlock.find(name).logic_init
    return {
        logic_init = function(self)
            base(self)
            EnvironmentCrafter.cast(self).follows_sun = false
        end,
    }
end

function DayAndNightSolar.post_init()
    Vlib.FillBlock("SmallSolarPanel", day_and_night)
    Vlib.FillBlock("SolarPanel", day_and_night)
end

db:mod(DayAndNightSolar)
