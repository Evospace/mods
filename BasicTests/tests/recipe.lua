-- tests/recipe_tests.lua
-- Unit tests for the Recipe class binding.

return function(lib)
    lib.log("Running Recipe tests")

    --------------------------------------------------
    -- 0. Helpers
    --------------------------------------------------
    local function new_recipe()
        local r = Recipe.new("TestRecipe")
        db:reg(r)
        return r
    end

    --------------------------------------------------
    -- 1. Construction
    --------------------------------------------------
    ---@class Recipe
    local recipe
    lib.assert_true(pcall(function() recipe = new_recipe() end),
        "Create and register Recipe")

    --------------------------------------------------
    -- 2. Scalar read/write properties
    --------------------------------------------------
    local scalars = {
        {"ticks",          120},     -- duration in ticks
        {"default_locked", true},
        {"locked",         false},
        {"productivity",   25},
        {"start_tier",     2},
        {"tier",           1}
    }

    for _, t in ipairs(scalars) do
        local key, val = unpack(t)
        lib.assert_true(pcall(function() recipe[key] = val end),
            "Set "..key)
        lib.assert_eq(recipe[key], val, "Get "..key)
    end

    --------------------------------------------------
    -- 3. Table properties: input / output
    --    We use explicit StaticItem objects
    --------------------------------------------------
    -- 3.1  Helper: create (and register) items once
    ---@class StaticItem
    local iron        = StaticItem.new("TestIronPlate")  ; db:reg(iron)
    ---@class StaticItem
    local copperWire  = StaticItem.new("TestCopperWire") ; db:reg(copperWire)
    ---@class StaticItem
    local circuit     = StaticItem.new("TestCircuit")    ; db:reg(circuit)

    -- 3.2  Add items through the accessor
    local input_items  = { {iron,       2},
                           {copperWire, 4} }

    local output_items = { {circuit,    1} }

    for _, pair in ipairs(input_items) do
        lib.assert_true(
            pcall(function() return recipe.input:add(pair[1], pair[2]) end),
            "input:add '"..pair[1].name.."'"
        )
    end
    lib.assert_eq(recipe.input.size, #input_items, "input slot count")

    for _, pair in ipairs(output_items) do
        lib.assert_true(
            pcall(function() return recipe.output:add(pair[1], pair[2]) end),
            "output:add '"..pair[1].name.."'"
        )
    end
    lib.assert_eq(recipe.output.size, #output_items, "output slot count")


    lib.assert_db_remove(recipe)
    lib.assert_db_remove(iron)
    lib.assert_db_remove(copperWire)
    lib.assert_db_remove(circuit)
end