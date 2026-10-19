local Vlib = require('vlib')

local DrillingRigSpeed = {}

local function ticks_for(level)
    return math.floor(Vlib.mining.drill.ticks / 2 ^ level + 0.5)
end

function DrillingRigSpeed.post_init()
    for _, proto in pairs(db:objects()) do
        local block = StaticBlock.cast(proto)
        local rig = block ~= nil and block.logic ~= nil and block.logic:is_child_of(DrillingRig.get_class())
        local base = rig and block.logic_init or nil

        if base ~= nil then
            block.logic_init = function(self)
                base(self)
                local drill = DrillingMachineBase.cast(self)
                drill.ticks_per_item = ticks_for(drill.static_block.level)
            end

            print('DrillingRigSpeed: ' .. proto.name .. ' -> ' .. ticks_for(block.level) .. ' ticks per item')
        end
    end
end

db:mod(DrillingRigSpeed)
