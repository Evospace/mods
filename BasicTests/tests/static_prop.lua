-- tests/staticprop_tests.lua
return function(lib)
    lib.log("Running StaticProp tests")

    --------------------------------------------------
    -- 1. Construction
    --------------------------------------------------
    local prop
    local ok, err = pcall(function()
        prop = StaticProp.new("TestProp01")
        db:reg(prop)
    end)
    lib.assert_true(ok and prop, "Creating and registering StaticProp: "..(err or ""))

    --------------------------------------------------
    -- 2. Numeric properties
    --------------------------------------------------
    local numeric = {
        {"project_to_terrain_power", 0.75},
        {"additive_elevation",      1.2},
        {"cull_begin",              100},
        {"cull_end",                300},
        {"maximum_height",          50},
        {"minimum_height",          -2},
        {"break_chance",            17},
    }

    for _, t in ipairs(numeric) do
        local key, val = t[1], t[2]
        lib.assert_true(pcall(function() prop[key] = val end), "Set "..key)
        lib.assert_eq(prop[key], val, "Get "..key)
    end

    --------------------------------------------------
    -- 3. Boolean properties
    --------------------------------------------------
    local boolean = {
        {"floating",     true},
        {"is_big",       true},
        {"no_collision", true},
        {"is_emitting",  true},
    }

    for _, t in ipairs(boolean) do
        local key, val = t[1], t[2]
        lib.assert_true(pcall(function() prop[key] = val end), "Set "..key)
        lib.assert_eq(prop[key], val, "Get "..key)
    end

    --------------------------------------------------
    -- 4. Mesh property
    --------------------------------------------------
    ok, err = pcall(function()
        local meshItem = StaticMesh.load("/Engine/EngineMeshes/Cube")
        prop.mesh = meshItem
    end)
    lib.assert_true(ok, "Assign mesh to StaticProp: "..(err or ""))
    lib.assert_eq(prop.mesh.name, "Cube", "Mesh assigned correctly")
end