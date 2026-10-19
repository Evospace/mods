local CustomizableStackSize = {
    stack_size = 20
}

function CustomizableStackSize.init()
end

function CustomizableStackSize.pre_init()
    Setting.reg("StaskSize", {
        category = "StackSize",
        type = "Slider",
        max = 100,
        min = 1,
        default = 20,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.value
           CustomizableStackSize.stack_size = value
           print("set stack size multiplier "..value)
        end,
        label = "StaskSize",
        restart = true,
     })
end

function CustomizableStackSize.post_init()
    for index, proto in pairs(db:objects()) do
        local item = StaticItem.cast(proto)
        if item ~= nil and item.stack_size > 1 and item.stack_size < 999 then
            local ns = item.stack_size * CustomizableStackSize.stack_size
            print('Stack size for ' .. item.name .. ' from ' .. item.stack_size .. ' to '.. ns)
            item.stack_size = ns
        end
    end
end

db:mod(CustomizableStackSize)