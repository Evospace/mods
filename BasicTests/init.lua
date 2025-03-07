local BasicTestsMod = {}

-- Helper functions for logging and assertions
local function log(message)
    print("[TestLog] " .. message)
end

local function assert_eq(actual, expected, message)
    if actual == expected then
        log("PASS: " .. message)
    else
        log("FAIL: " .. message .. " (Expected: " .. tostring(expected) .. ", Got: " .. tostring(actual) .. ")")
    end
end

local function assert_ne(actual, expected, message)
    if actual ~= expected then
        log("PASS: " .. message)
    else
        log("FAIL: " .. message .. " (Expected different from: " .. tostring(expected) .. ")")
    end
end

local function assert_true(value, message)
    if value then
        log("PASS: " .. message)
    else
        log("FAIL: " .. message .. " (Expected true, got false)")
    end
end

local function assert_false(value, message)
    if not value then
        log("PASS: " .. message)
    else
        log("FAIL: " .. message .. " (Expected false, got true)")
    end
end

-- Test initialization
function BasicTestsMod.init()
    log("Initializing BasicTestsMod")
    
    local success, _ = pcall(function()
        db:reg(StaticItem.new("TestItem"))
    end)
    assert_true(success, "Registering TestItem")

	---@type StaticItem
	local item
	local success, _ = pcall(function()
        item = StaticItem.find("TestItem")
    end)
    assert_true(success, "Finding TestItem")
    
	---@type AutosizeInventory
    local inv
    success, _ = pcall(function()
        inv = AutosizeInventory.new_simple()
    end)
    assert_true(success and inv ~= nil, "Creating AutosizeInventory")
    
	local itemCount = 4
    success, _ = pcall(function()
        inv:add(item, itemCount)
    end)
    assert_true(success, "Adding item to inventory")

	---@type ItemData
	local itemData
	success, _ = pcall(function()
        itemData = inv:get(1)
    end)
	assert_true(success, "Adding item to inventory")
    assert_eq(itemData.item, item, "Added item test")
	assert_eq(itemData.count, itemCount, "Added item test")
end

function BasicTestsMod.pre_init()
    log("Pre-initialization of BasicTestsMod")
end

function BasicTestsMod.post_init()
    log("Post-initialization of BasicTestsMod")
end

-- Registering mod
log("Registering BasicTestsMod")
db:mod(BasicTestsMod)
