require "thelist"


local COLLECTOR_TYPE = "thelist-collector"
local ZONE_SIZE = 15
local ZONE_SURFACE = "nauvis"
-- I don't know if the factorio API actually exports this anywhere
local TICKS_PER_SECOND = 60

local DISPLAY_SIZE = 2
local RED = {r=1}
local ORANGE = {r=1, g=0.5}
local YELLOW = {r=1, g=1}
local GREEN = {g=1}

-- 5 minutes added to the timer each time an item is added
local PER_ROUND = 5

-- you get an additional 5 minutes grace time when the game starts
local STARTING_GRACE = 1

local POINTS = nil


function create_gui(player)
  -- create a UI element
  local frame = player.gui.left.add{
    type="frame",
    name="thelist_ui",
    direction="vertical",
    caption="The List",
  }

  -- create UI element that will contain the timer
  frame.add{type="flow", direction="vertical", name="next_things"}

  -- add a refresh hook for this player
  script.on_event(defines.events.on_tick,
                  function(e)
                    if (e.tick % 10) == 0 then
                      refresh_gui(player)
                    end
                  end)
end


function refresh_gui(player)
  update_tally((game.tick % TICKS_PER_SECOND) == 0)

  local frame = player.gui.left.thelist_ui

  -- if we are out of time, end the game
  if game.tick >= global.TheTimer then
    players_lose()
    return
  end

  -- show how much time is left on the timer
  local seconds = math.floor((global.TheTimer - game.tick) / 60)
  local minutes = 0
  while seconds > 59 do
    seconds = seconds - 60
    minutes = minutes + 1
  end
  if minutes < 1 then
    if (seconds % 2) == 0 then
      frame.style.font_color = RED
    else
      frame.style.font_color = ORANGE
    end
  elseif minutes < PER_ROUND then
    frame.style.font_color = YELLOW
  else
    frame.style.font_color = GREEN
  end
  frame.caption = string.format("Level %d of %d - %d:%02d",
                                global.ThePointer,
                                global.LastItem,
                                minutes,
                                seconds)

  -- destroy all children of the next_thigs UI
  local next_things = player.gui.left.thelist_ui.next_things
  for _, name in pairs(next_things.children_names) do
    next_things[name].destroy()
  end

  -- list the next [N] upcoming items
  for i = global.ThePointer, global.ThePointer + DISPLAY_SIZE do
    if i > global.LastItem then
      break
    end

    -- how much more is needed?
    local item = global.TheList[i][1]
    local remaining = global.TheList[i][2]

    -- make a horizontal frame for this item
    local hor = next_things.add{type="flow", direction="horizontal", name="h_"..item}
    hor.add{type="sprite", name="thesprite", sprite="item/"..item}
    hor.add{type="label", name="thelabel", caption=remaining}
  end

  -- FIXME: add a button shows instructions on how to play
end


local function set_up_global_state()
  -- create the global TheList var with a queue of things that need to be supplied
  global.TheList = what_is_the_list()
  global.ThePointer = 1
  global.LastItem = #global.TheList

  -- set the timer for the first item to 10 minutes (put this in a global too)
  global.TheTimer = TICKS_PER_SECOND * 60 * (PER_ROUND + STARTING_GRACE)
end


local function spawn_collector(surface, force)
  local rand_x = math.random(5,ZONE_SIZE)
  local rand_y = math.random(5,ZONE_SIZE)
  if math.random() <= 0.5 then
    rand_x = rand_x * -1
  end
  if math.random() <= 0.5 then
    rand_y = rand_y * -1
  end

  -- set tiles at that location to ensure the collector can be spawned
  local tiles = {}
  for x = rand_x - 2, rand_x + 2 do
    for y = rand_y - 2, rand_y + 2 do
      table.insert(tiles, {name="dirt", position={x,y}})
    end
  end
  surface.set_tiles(tiles)

  -- destroy any entities inside the random area
  local ents = surface.find_entities({{rand_x-1, rand_y-1}, {rand_x+1, rand_y+1}})
  for _, ent in pairs(ents) do
    ent.destroy()
  end

  entity = surface.create_entity{name=COLLECTOR_TYPE,
                                 position={rand_x, rand_y},
                                 force=force}
  return entity.position
end


local function spawn_entities()
  local surface = game.surfaces[ZONE_SURFACE]
  local force = game.forces["player"]

  -- spawn the collector chest somewhere close to the player
  spawn_collector(surface, force)

  -- put hazard concrete tile in a 100x100 square around the player, but don't panic if it doesn't work
  local tiles = {}
  for x = -ZONE_SIZE, ZONE_SIZE do
    table.insert(tiles, {name="hazard-concrete-left", position={x,-ZONE_SIZE}})
    table.insert(tiles, {name="hazard-concrete-left", position={x,ZONE_SIZE}})
  end
  for y = 1 - ZONE_SIZE, ZONE_SIZE - 1 do
    table.insert(tiles, {name="hazard-concrete-left", position={-ZONE_SIZE,y}})
    table.insert(tiles, {name="hazard-concrete-left", position={ZONE_SIZE,y}})
  end

  surface.set_tiles(tiles)
end



local function add_hooks()
  if not global.mod_active then
    return
  end

  script.on_event(defines.events.on_built_entity,
                  function(e)
                    local entity = e.created_entity
                    local player = game.players[e.player_index]
                    if entity.name == COLLECTOR_TYPE then
                      thelist_cancel_collector(entity, player, nil)
                    end
                  end)

  script.on_event(defines.events.on_robot_built_entity,
                  function(e)
                    local entity = e.created_entity
                    local force = e.robot.force
                    if entity.name == COLLECTOR_TYPE then
                      thelist_cancel_collector(entity, nil, force)
                    end
                  end)

  -- add a hook to re-register the gui_refresh for each player
  script.on_event(defines.events.on_tick,
                  function(e)
                    if (e.tick % 10) == 0 then
                      for _, player in pairs(game.players) do
                        refresh_gui(player)
                      end
                    end
                  end)
end


function thelist_cancel_collector(entity, player, force)
  -- where is the entity?
  surface = entity.surface
  position = entity.position

  if (surface.name == ZONE_SURFACE
      and position.x <= ZONE_SIZE+1
      and position.x > -ZONE_SIZE
      and position.y <= ZONE_SIZE+1
      and position.y > -ZONE_SIZE) then
    -- there is no reason to cancel the placement
    return false
  end

	-- destroy the entity
  entity.destroy()
  -- put an item for it on the ground where it used to be
  stack = {name=COLLECTOR_TYPE, count=1}
  surface.spill_item_stack(position, stack)

  if player then
    player.print({"thelist-collector-not-allowed-here"})
  end
  if force then
    force.print({"thelist-collector-not-allowed-here"})
  end
  -- the entity placement has been cancelled
  return true
end


function update_tally(refresh_points)
  -- find all of the collection points on the map
  if refresh_points then
    local surface = game.surfaces[ZONE_SURFACE]
    local tl = {-2-ZONE_SIZE,-2-ZONE_SIZE}
    local br = {2+ZONE_SIZE,2+ZONE_SIZE}
    POINTS = surface.find_entities_filtered{area={tl, br},
                                            name=COLLECTOR_TYPE}
  end

  -- what item are we looking for?
  local lookfor = {}
  for idx = global.ThePointer, global.ThePointer + DISPLAY_SIZE do
    if idx <= global.LastItem then
      local item = global.TheList[idx][1]
      local remaining = global.TheList[idx][2]
      lookfor[item] = {remaining, idx}
    end
  end

  for _, ent in pairs(POINTS) do
    local inv = ent.get_inventory(defines.inventory.chest)
    for item, qty in pairs(inv.get_contents()) do
      if lookfor[item] then
        -- take stuff out of the container and put it towards the goal
        local goal = lookfor[item][1]

        local remove = qty
        if remove > goal then
          remove = goal
        end

        if remove then
          -- remove the items
          inv.remove({name=item, count=remove})
          -- update the goal
          lookfor[item][1] = goal - remove
        end
      end
    end

    -- go through the goals
    for item, detail in pairs(lookfor) do
      if detail[1] == 0 and detail[2] == global.ThePointer then
        -- we finished a goal, advance over this item and add 5 minutes to the timer
        global.ThePointer = global.ThePointer + 1
        global.TheTimer = global.TheTimer + (TICKS_PER_SECOND * 60 * PER_ROUND)
      else
        -- update the count remaining in the main list
        global.TheList[detail[2]][2] = detail[1]
      end
    end

    -- if there are no more goals, produce victory screen and we're done
    if global.ThePointer > global.LastItem then
      players_win()
    end
  end
end


script.on_init(function()
	-- a map has been started or loaded which didn't have TheList active.
  if game.tick == 0 then
    global.mod_active = true

    spawn_entities()
    set_up_global_state()
    add_hooks()
  else
    global.mod_active = false
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  if global.mod_active then
    create_gui(game.players[event.player_index])
  end
end)

script.on_load(function()
	-- a map has been loaded which already has this mod active.
  -- FIXME: what do we use instead of this?
  if global.mod_active then
    -- we just need to add the event hooks and GUI again
    add_hooks()
  end
end)

function players_win()
  --message = "You won!"
  --for _, player in pairs(game.players) do
    -- FIXME: add statistics about how much stuff collected, time left, etc
    --player.set_ending_screen_data(message)
  --end
  game.set_game_state({game_finished=true,
                       player_won=true,
                       next_level=nil,
                       can_continue=false})
end

function players_lose()
  game.set_game_state({game_finished=true,
                       player_won=false,
                       next_level=nil,
                       can_continue=false})
end
