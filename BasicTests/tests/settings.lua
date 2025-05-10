-- tests/setting_tests.lua
-- Unit tests for the Setting class binding.

return function(lib)
    lib.log("Running Setting tests")

    --------------------------------------------------
    -- 0. Helpers
    --------------------------------------------------
    local function dummy_action(setting)
        return "action executed"
    end

    local function new_setting()
        local s = Setting.new("TestSetting")
        db:reg(s)
        return s
    end

    --------------------------------------------------
    -- 1. Construction
    --------------------------------------------------
    ---@class Setting
    local setting
    lib.assert_true(pcall(function() setting = new_setting() end), "Create and register Setting")

    --------------------------------------------------
    -- 2. Boolean / string / int properties
    --------------------------------------------------
    local bools = { {"restart", true} }
    for _, t in ipairs(bools) do
        local key, val = unpack(t)
        lib.assert_true(pcall(function() setting[key] = val end), "Set "..key)
        lib.assert_eq(setting[key], val, "Get "..key)
    end

    local strings = {
        {"label",     "Very Loud Music"},
        {"type",      "slider"},
        {"category",  "audio"},
        {"string_value", "High"},
        {"default_string_value", "Medium"},
    }
    for _, t in ipairs(strings) do
        local key, val = unpack(t)
        lib.assert_true(pcall(function() setting[key] = val end), "Set "..key)
        lib.assert_eq(setting[key], val, "Get "..key)
    end

    local ints = {
        {"int_value",          42},
        {"int_default_value",  10},
        {"min_value",          0},
        {"max_value",          100},
    }
    for _, t in ipairs(ints) do
        local key, val = unpack(t)
        lib.assert_true(pcall(function() setting[key] = val end), "Set "..key)
        lib.assert_eq(setting[key], val, "Get "..key)
    end

    --------------------------------------------------
    -- 3. string_options (array of strings)
    --------------------------------------------------
    local opts = {"Low", "Medium", "High"}
    lib.assert_true(pcall(function() setting.string_options = opts end), "Set string_options")
    -- Compare length and each element
    lib.assert_eq(#setting.string_options, #opts, "string_options length")
    for i, v in ipairs(opts) do
        lib.assert_eq(setting.string_options[i], v, "string_options["..i.."]")
    end

    --------------------------------------------------
    -- 4. key_binding + default_key (custom accessors)
    --------------------------------------------------
    lib.assert_true(pcall(function() setting.key_binding = "Ctrl+M" end), "Set key_binding")
    lib.assert_eq(setting.key_binding, "Ctrl+M", "Get key_binding")

    lib.assert_true(pcall(function() setting.default_key = "Alt+Shift+D" end), "Set default_key")
    lib.assert_eq(setting.default_key, "Alt+Shift+D", "Get default_key")

    --------------------------------------------------
    -- 5. set_action / get_action callbacks
    --------------------------------------------------
    lib.assert_true(pcall(function() setting.set_action = dummy_action end), "Assign set_action")
    lib.assert_eq(type(setting.set_action), "function", "set_action returns function")
    lib.assert_eq(setting.set_action(setting), "action executed", "set_action executes correctly")

    --------------------------------------------------
    -- 6. Static method update_widgets
    --------------------------------------------------
    lib.assert_true(pcall(function() Setting.update_widgets() end), "Static call update_widgets")

    lib.assert_db_remove(setting)
end