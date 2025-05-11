-- tests/staticblock_tests.lua
-- Unit tests for the StaticBlock binding.

return function(lib)
    lib.log("Running StaticBlock tests")

    --------------------------------------------------
    -- 0. Helpers
    --------------------------------------------------
    local function new_block()
        local b = StaticBlock.new("test_static_block")
        db:reg(b)
        return b
    end

    local function vec3(x, y, z)
        return Vec3.new(x, y, z)          -- wrapper for clarity
    end

    --------------------------------------------------
    -- 1. Construction
    --------------------------------------------------
    local block
    lib.assert_true(pcall(function() block = new_block() end),
        "Create and register StaticBlock")

    --------------------------------------------------
    -- 2. Scalar & string properties
    --------------------------------------------------
    lib.assert_true(pcall(function()
        block.tier  = 3
        block.level = 7
        block.replace_tag = "metallic"
    end), "Set tier, level, replace_tag")

    lib.assert_eq(block.tier,  3,          "Get tier")
    lib.assert_eq(block.level, 7,          "Get level")
    lib.assert_eq(block.replace_tag, "metallic", "Get replace_tag")

    --------------------------------------------------
    -- 3. Colour vectors
    --------------------------------------------------
    local side = vec3(0.1, 0.6, 0.2)
    local top  = vec3(0.8, 0.3, 0.1)

    lib.assert_true(pcall(function()
        block.color_side = side
        block.color_top  = top
    end), "Assign color vectors")

    lib.assert_eq(block.color_side.x, side.x, "color_side.x")
    lib.assert_eq(block.color_top.z,  top.z,  "color_top.z")

    --------------------------------------------------
    -- 4. Lua config table
    --------------------------------------------------
    local cfg = { foo = 42, bar = "baz" }
    lib.assert_true(pcall(function() block.lua = cfg end),
        "Assign lua table")
    lib.assert_eq(block.lua.foo, 42, "lua.foo value")

    --------------------------------------------------
    -- 5. Sub-block positions container
    --------------------------------------------------
    -- Each element is a Vec3i (or Vec3) with integer coords
    local subs = { vec3(0,0,0), vec3(1,0,0), vec3(0,1,0) }

    lib.assert_true(pcall(function() block.sub_blocks = subs end),
        "Assign sub_blocks table")
    lib.assert_eq(#block.sub_blocks, #subs, "sub_blocks size")

    --------------------------------------------------
    -- 6. Class-type properties: ensure readable (may be nil)
    --------------------------------------------------
    lib.assert_true(block.logic    == nil or type(block.logic)    == "userdata",
        "logic is userdata or nil")
    lib.assert_true(block.actor    == nil or type(block.actor)    == "userdata",
        "actor is userdata or nil")
    lib.assert_true(block.selector == nil or type(block.selector) == "userdata",
        "selector is userdata or nil")
    lib.assert_true(block.tesselator == nil or type(block.tesselator) == "userdata",
        "tesselator is userdata or nil")
end