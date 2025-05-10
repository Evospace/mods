local lib = {
    passedCounter = 0,
    failedCounter = 0
}

function lib.reset(self)
    self.passedCounter = 0
    self.failedCounter = 0
end

function lib.log(message)
    print("[TestLog] " .. message)
    lib.passedCounter = lib.passedCounter + 1
end

function lib.log_error(message)
    print_err("[TestLog] " .. message)
    lib.failedCounter = lib.failedCounter + 1
end

function lib.assert_eq(actual, expected, message, epsilon)
    local eps = epsilon or 1e-6
    local pass

    if type(actual) == "number" and type(expected) == "number" then
        pass = math.abs(actual - expected) <= eps
    else
        pass = (actual == expected)
    end

    if pass then
        lib.log("PASS: " .. message)
    else
        lib.log_error("FAIL: " .. message ..
            " (Expected: " .. tostring(expected) ..
            ", Got: " .. tostring(actual) ..
            (type(actual) == "number" and type(expected) == "number"
                and ", Epsilon: " .. tostring(eps) or "") .. ")")
    end
end

function lib.assert_ne(actual, expected, message)
    if actual ~= expected then
        lib.log("PASS: " .. message)
    else
        lib.log_error("FAIL: " .. message .. " (Expected different from: " .. tostring(expected) .. ")")
    end
end

function lib.assert_true(value, message)
    if value then
        lib.log("PASS: " .. message)
    else
        lib.log_error("FAIL: " .. message .. " (Expected true, got false)")
    end
end

function lib.assert_false(value, message)
    if not value then
        lib.log("PASS: " .. message)
    else
        lib.log_error("FAIL: " .. message .. " (Expected false, got true)")
    end
end

function lib.assert_db_remove(value)
    local name = nil
    if value ~= nil then name = value.name end

    local success, _ = pcall(function()
        db:remove(value)
    end)
    lib.assert_true(success and name, "Removing "..name)
end



return lib