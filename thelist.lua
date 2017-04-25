function what_is_the_list()
  local L = {}

  -- BASIC RESOURCES
  L[1+#L] = {"coal",       100}
  L[1+#L] = {"stone",      200}
  L[1+#L] = {"iron-ore",   300}
  L[1+#L] = {"copper-ore", 400}

  L[1+#L] = {"stone-brick",     200}
  L[1+#L] = {"copper-plate",    250}
  L[1+#L] = {"iron-plate",      500}
  -- I hope you were getting your steel production underway!

  -- basic recipes
  L[1+#L] = {"iron-stick",          100}
  L[1+#L] = {"iron-gear-wheel",     250}
  L[1+#L] = {"burner-inserter",     500}
  L[1+#L] = {"pipe",                1000}
  L[1+#L] = {"pipe-to-ground",      1000}
  L[1+#L] = {"copper-cable",        3000}
  L[1+#L] = {"raw-wood"             250}
  L[1+#L] = {"wood",                250}
  L[1+#L] = {"wooden-chest",        500}
  L[1+#L] = {"small-electric-pole", 1000}
  L[1+#L] = {"electronic-circuit",  1000}

  -- BASIC RESOURCES
  L[1+#L] = {"coal",       1000}
  L[1+#L] = {"stone",      1000}
  L[1+#L] = {"iron-ore",   1000}
  L[1+#L] = {"copper-ore", 1000}

  L[1+#L] = {"landfill",            100}
  L[1+#L] = {"stone-wall",          500}
  L[1+#L] = {"stone-furnace",       1000}
  L[1+#L] = {"burner-mining-drill", 2000}
  L[1+#L] = {"boiler",              3000}

  -- time to start making steel
  L[1+#L] = {"steel-plate",     100}

  -- tier 1 belts
  L[1+#L] = {"transport-belt",   1000}
  L[1+#L] = {"underground-belt", 1000}
  L[1+#L] = {"splitter",         250}

  -- simple devices made from metal/copper/stone
  L[1+#L] = {"electric-mining-drill", 1000}
  L[1+#L] = {"offshore-pump",         2000}
  L[1+#L] = {"steam-engine",          3000}
  L[1+#L] = {"inserter",              1000}
  L[1+#L] = {"long-handed-inserter",  1000}
  L[1+#L] = {"fast-inserter",         1000}
  L[1+#L] = {"filter-inserter",       1000}

  L[1+#L] = {"concrete",              1500}
  L[1+#L] = {"hazard-concrete",       2000}

  -- BASIC RESOURCES
  L[1+#L] = {"coal",       10000}
  L[1+#L] = {"stone",      10000}
  L[1+#L] = {"iron-ore",   15000}
  L[1+#L] = {"copper-ore", 15000}

  -- bullet-based weapons / turrets
  L[1+#L] = {"pistol",                   100}
  L[1+#L] = {"submachine-gun",           100}
  L[1+#L] = {"firearm-magazine",         1000}
  L[1+#L] = {"gun-turret",               1000}
  L[1+#L] = {"piercing-rounds-magazine", 500}

  -- logic components
  L[1+#L] = {"red-wire",              1000}
  L[1+#L] = {"green-wire",            1000}
  L[1+#L] = {"arithmetic-combinator", 2000}
  L[1+#L] = {"decider-combinator",    3000}
  L[1+#L] = {"constant-combinator",   4000}
  L[1+#L] = {"power-switch",          5000}

  -- you'd better have assembly machines making assembly machines by now
  L[1+#L] = {"lab",                  1000}
  L[1+#L] = {"assembling-machine-1", 1000}
  L[1+#L] = {"assembling-machine-2", 1000}
  L[1+#L] = {"steel-furnace",        1000}

  -- tier 2 belts
  L[1+#L] = {"fast-transport-belt",   5000}
  L[1+#L] = {"fast-splitter",         5000}
  L[1+#L] = {"fast-underground-belt", 5000}

  -- energy-related tech
  L[1+#L] = {"big-electric-pole",                1000}
  L[1+#L] = {"medium-electric-pole",             2000}
  L[1+#L] = {"substation",                       1000}

  -- BASIC RESOURCES
  L[1+#L] = {"raw-wood",   800}
  L[1+#L] = {"coal",       50000}
  L[1+#L] = {"stone",      60000}
  L[1+#L] = {"iron-ore",   70000}
  L[1+#L] = {"copper-ore", 80000}

  -- chests
  L[1+#L] = {"iron-chest",  10000}
  L[1+#L] = {"steel-chest", 5000}
  L[1+#L] = {"logistic-chest-passive-provider",  10000}
  L[1+#L] = {"logistic-chest-active-provider",   10000}
  L[1+#L] = {"logistic-chest-storage",           10000}
  L[1+#L] = {"logistic-chest-requester",         10000}
  L[1+#L] = {"roboport",                         100}
  L[1+#L] = {"flying-robot-frame",               200}
  L[1+#L] = {"logistic-robot",                   300}
  L[1+#L] = {"construction-robot",               400}

  -- tier 3 belts
  L[1+#L] = {"express-transport-belt",   1000}
  L[1+#L] = {"express-splitter",         1000}
  L[1+#L] = {"express-underground-belt", 1000}

  -- tier 3 tech
  L[1+#L] = {"assembling-machine-3", 2000}
  L[1+#L] = {"electric-furnace",     3000}
  L[1+#L] = {"accumulator",          4000}

  return L
end
