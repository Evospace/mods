local CustomizableStackSize = {
    stack_size = 20
}

function CustomizableStackSize.init()
end

function CustomizableStackSize.pre_init()
    db:from_table({
        class = "Setting",
        category = "StackSize",
        type = "Slider",
        max_value = 100,
        min_value = 1,
        int_default_value = 20,
        ---@param setting Setting
        set_action = function(setting)
           local value = setting.int_value
           CustomizableStackSize.stack_size = value
           print("set stack size multiplier "..value)
        end,
        label = "StaskSize",
        name = "StaskSize",
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