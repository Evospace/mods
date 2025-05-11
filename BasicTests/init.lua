local lib = require('common')

local BasicTestsMod = {}

-- Test initialization
function BasicTestsMod.init()
    lib.log("Initializing BasicTestsMod")

    db:from_table({
        class = "Setting",
        category = "BasicTests",
        type = "Buttons",

        default_string_value = "High",
        string_options = {"Run tests"},
        ---@param setting Setting
        set_action = function(setting)
            BasicTestsMod.pre_init()
        end,

        label = "BasicTests",
        name = "BasicTests",
    })
end


function BasicTestsMod.pre_init()

    lib:reset()

    require('tests/inventory')(lib)
    require('tests/static_prop')(lib)
    require('tests/settings')(lib)
    require('tests/recipe')(lib)
    require('tests/props')(lib)
    require('tests/block')(lib)

    print("Passed: "..lib.passedCounter)
    if lib.failedCounter > 0 then
        print_err("Failed: "..lib.failedCounter)
    else
        print("All passed!")
    end
end

function BasicTestsMod.post_init()
    lib.log("Post-initialization of BasicTestsMod")
end

-- Registering mod
lib.log("Registering BasicTestsMod")
db:mod(BasicTestsMod)
