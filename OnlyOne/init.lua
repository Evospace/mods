local OnlyOne = {}

function OnlyOne.init()
end

function OnlyOne.pre_init()
end

function OnlyOne.post_init()
    for index, proto in pairs(db:objects()) do
        local item = StaticItem.cast(proto)
        if item ~= nil then
            local ns = 1
            print('Stack size for ' .. item.name .. ' from ' .. item.stack_size .. ' to '.. ns)
            item.stack_size = ns
        end
    end
end

db:mod(OnlyOne)