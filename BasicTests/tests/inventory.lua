return function(lib) 
    lib.log("Pre-initialization of BasicTestsMod")

    local success, _ = pcall(function()
        db:reg(StaticItem.new("TestItem"))
    end)
    lib.assert_true(success, "Registering TestItem")

	---@class StaticItem
	local item
	local success, _ = pcall(function()
        item = StaticItem.find("TestItem")
    end)
    lib.assert_true(success, "Finding TestItem")
    lib.assert_ne(item, nil, "TestItem is found")
    
	---@class AutosizeInventory
    local inv
    success, _ = pcall(function()
        inv = AutosizeInventory.new_simple()
    end)
    lib.assert_true(success and inv ~= nil, "Creating AutosizeInventory")
    
	local itemCount = 4
    success, _ = pcall(function()
        inv:add(item, itemCount)
    end)
    lib.assert_true(success, "Adding item to inventory")

	---@class ItemData
	local itemData
	success, _ = pcall(function()
        itemData = inv:get(0)
    end)
	lib.assert_true(success, "Adding item to inventory")
    lib.assert_eq(itemData.item, item, "Added item test")
	lib.assert_eq(itemData.count, itemCount, "Added item test")

    success, _ = pcall(function()
        inv:sub(item, itemCount)
    end)
    lib.assert_true(success, "Remoiving item from inventory")

    pcall(function()
        itemData = inv:get(0)
    end)
    lib.assert_eq(itemData.count, 0, "Removed item test")

    local size
    pcall(function()
        size = inv.size
    end)
    lib.assert_eq(size, 1, "Inventory size 1")

    lib.assert_db_remove(item)
end