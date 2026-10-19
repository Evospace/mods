local DayAndNightSolar = {}

function DayAndNightSolar.post_init()
    for _, proto in pairs(db:objects()) do
        local block = StaticBlock.cast(proto)
        local environment = block ~= nil and block.logic ~= nil and block.logic:is_child_of(EnvironmentCrafter.get_class())
        local base = environment and block.logic_init or nil

        if base ~= nil then
            block.logic_init = function(self)
                base(self)
                local panel = EnvironmentCrafter.cast(self)
                if not panel.wind_powered then
                    panel.follows_sun = false
                end
            end
        end
    end
end

db:mod(DayAndNightSolar)
