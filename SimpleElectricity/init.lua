local ComplexEleectricity = {}

function ComplexEleectricity.pre_init()
end

local function slice_except_first(arr)
    local result = {}
    for i = 2, #arr do
        result[#result + 1] = arr[i]
    end
    return result
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
            end
        end

        local bat = StaticBlock.find(material.."BatteryBox")
        if bat ~= nil then
            print(material.."BatteryBox".." found; simplify electricity")
            local old_logic = bat.lua.logic_init

            ---@param self BlockLogic
            bat.lua.logic_init = function(self)
                old_logic(self)
                local cond = ConductorBlockLogic.cast(self)
                cond.resistance = 0
            end
        end
    end

    for _, name in pairs(Vlib.cable_array) do
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

    local rem = {"Transformer", "GoldCable", "AluminiumCable"}

    for _, name in pairs(rem) do
        db:remove(StaticResearch.find(name))
    end

    local rem2 = {"TransformerLVMV", "TransformerMVLV"}

    for _, name in pairs(rem2) do
        db:remove(StaticItem.find(name))
        db:remove(StaticBlock.find(name))
    end

    for _, name in pairs(slice_except_first(Vlib.cable_array)) do
        db:remove(StaticItem.find(name))
        db:remove(StaticBlock.find(name))
    end
end

function ComplexEleectricity.post_init()
end

db:mod(ComplexEleectricity)
