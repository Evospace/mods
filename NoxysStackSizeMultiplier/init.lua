local NoxysStackSizeMultiplier = {}

function NoxysStackSizeMultiplier.init()
end

function NoxysStackSizeMultiplier.pre_init()
end

function NoxysStackSizeMultiplier.post_init()
    local ns, item
    for index, proto in pairs(db:objects()) do
        item = StaticItem.cast(proto)
        if item ~= nil and item.max_count > 1 and item.max_count < 999 then
            ns = item.max_count * 20
            print('Stack size for ' .. item:get_name() .. ' from ' .. item.max_count .. ' to '.. ns)
            item.max_count = ns
        end
    end
end

db:mod(NoxysStackSizeMultiplier)