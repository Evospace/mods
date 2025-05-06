local ComplexEleectricity = {}

function ComplexEleectricity.pre_init()
end

function ComplexEleectricity.init()
    print("Simple electricity")


    for _, material in pairs(Vlib.tier_material) do
        local gen = StaticBlock.find(material.."Generator")
        if gen ~= nil then
            print(material.."Generator".." found; simplify electricity")
            local old_logic = gen.lua.logic_init

            ---@param self BlockLogic
            gen.lua.logic_init = function(self)
                old_logic(self)
                local acc = ResourceAccessor.cast(self:find_accessor("rao"))
                if acc ~= nil then
                    acc.channel = "LV"
                    acc.cover = StaticCover.find("ElectricityOutput")
                end
                local crafter = AbstractCrafter.cast(self)
                crafter.energy_output_inventory.item = StaticItem.find("MV")
            end
        end
    end

    local list = {"CopperConnector","OFCCable", "SCable", "GCable", "ACable", "YBCOCable", "PCable", "TNCable", "ABCCOCable"}

    for _, name in pairs(list) do
        local block = StaticBlock.find(name)
        if block ~= nil then
            print(name.." found; simplify electricity")
            local old_fn = block.lua.logic_init

            ---@param self BlockLogic
            block.lua.logic_init = function(self)
                old_fn(self)
                local cable = ConductorBlockLogic.cast(self)
                cable.resistance = 0
            end
        end
    end
end

function ComplexEleectricity.post_init()
end

db:mod(ComplexEleectricity)
