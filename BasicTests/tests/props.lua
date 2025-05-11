-- tests/staticproplist_tests.lua
-- Unit tests for PropListData and StaticPropList bindings.

return function(lib)
    lib.log("Running StaticPropList / PropListData tests")

    --------------------------------------------------
    -- Helpers
    --------------------------------------------------
    local function new_prop(name)
        local p = StaticProp.new(name)
        db:reg(p)
        return p
    end

    local function new_prop_list()
        local pl = StaticPropList.new("test_prop_list")
        db:reg(pl)
        return pl
    end

    --------------------------------------------------
    -- 1. PropListData : chance + props
    --------------------------------------------------
    local d = PropListData.new()
    lib.assert_true(d ~= nil, "Create PropListData")

    -- 1.1 chance read / write
    lib.assert_true(pcall(function() d.chance = 0.42 end),
        "Set chance")
    lib.assert_eq(d.chance, 0.42, "Get chance")

    -- 1.2 props starts empty
    lib.assert_eq(#d.props, 0, "props initially empty")

    --------------------------------------------------
    -- 2. StaticPropList : data array
    --------------------------------------------------
    local lst = new_prop_list()
    lib.assert_true(lst ~= nil, "Create StaticPropList")

    -- 2.1 data starts empty
    lib.assert_eq(#lst.data, 0, "data initially empty")

    -- 2.2 Manually build PropListData, push StaticProps via C++ add()
    --     There is no public setter, so we use inventory-like helpers:
    local ironTree = new_prop("IronTree")
    local copperBush = new_prop("CopperBush")

    -- PropListData expects a vector of StaticProp*, so we fill it through
    -- the read–write table interface that luabridge gives us automatically.
    d.props = { ironTree, copperBush }      -- write-back supported by luabridge
    lib.assert_eq(d.props[1], ironTree,     "props[1] equals IronTree")
    lib.assert_eq(#d.props, 2,              "props size after push")

    -- Now add PropListData to StaticPropList via the same writable table
    lst.data = { d }
    lib.assert_eq(#lst.data, 1, "StaticPropList contains one PropListData")
    lib.assert_eq(lst.data[1].chance, 0.42, "Nested chance value propagated")
    lib.assert_eq(lst.data[1].props[2], copperBush,
                  "Nested props[2] equals CopperBush")
end