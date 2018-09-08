-- Lua script of map custom_state.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

local hero_meta = sol.main.get_metatable("hero")

local function assert_method(obj,method_name,fname)
  assert(obj)
  local fom = "method" or fname
  if type(obj[method_name]) ~= "function" then
    error('object has no ' .. fom .. ' named "' .. method_name .. '"')
  end
end


local function test_interface_presence()
  --Test for api functions
  assert_method(sol.state, "create","function")
  --Test for api methods
  assert_method(hero_meta, "start_state")
  assert_method(hero_meta, "get_state")
  assert_method(hero_meta, "get_custom_state")
end


local function test_state_methods_presence()
  local methods = {
    "get_description",
    "set_description",
    "get_entity",
    "get_map",
    "get_game",
    "is_started",
    "is_stopping",
    "is_visible",
    "set_visible",
    "get_draw_override",
    "set_draw_override",
    "is_direction_locked",
    "set_direction_locked",
    "get_can_control_movement",
    "set_can_control_movement",
    "is_affected_by_ground",
    "set_affected_by_ground",
    "get_is_touching_ground",
    "set_is_touching_ground",
    "get_can_come_from_bad_ground",
    "set_can_come_from_bad_ground",
    "get_are_collision_ignored",
    "set_are_collision_ignored",
    "get_can_traverse_ground",
    "set_can_traverse_ground",
    "is_affected_by",
    "set_affected_by",
    "get_can_traverse",
    "set_can_traverse",
    "is_teletransporter_delayed",
    "set_teletransporter_delayed",
    "get_can_persist_on_stream",
    "set_can_persist_on_stream",
    "get_can_be_hurt",
    "set_can_be_hurt",
    "get_can_use_sword",
    "set_can_use_sword",
    "get_can_use_shield",
    "set_can_use_shield",
    "get_can_use_item",
    "set_can_use_item",
    "get_can_pick_treasure",
    "set_can_pick_treasure",
    "get_can_take_stairs",
    "set_can_take_stairs",
    "get_can_take_jumper",
    "set_can_take_jumper",
    "get_previous_carried_object_behavior",
    "set_previous_carried_object_behavior",
  }

  --test if all method are present in the test state
  local test_state = sol.state.create("test_state")
  for _,m in ipairs(methods) do
    assert_method(test_state,m)
  end
end

-- Test if two arrays match and else raise an error
local function table_match(story,expected,results)
  local function print_error(errs)
    local err = format_value(story) .. " Failed\nExpected | Got\n"
    for i,v in ipairs(expected) do
      err  = err .. "\n" .. (errs and "->" or "") .. format_value(v) .. " | " .. format_value(results[i])
    end
    error(err)
  end
  local should_err
  local errs = {}
  for i,v in ipairs(expected) do
    if v ~= results[v] then
      should_err = true
      errs[i] = true
    end
  end
  if should_err then
    print_error(errs)
  end
end


-- execute the test directly and compare results
local function test(story,test,...)
  local results = {test()}
  local expected = {...}
  table_match(story,expected,results)
end

-- test all state methods behaviour
local function test_state_methods(cont)
  local state

  test("creating blank state",
       function()
         state = sol.state.create("test_description")
  end)

  test("getting state description",
       function() return state:get_description() end,
       "test_description")

  test("start blank state",
       function() hero:start_state(state) end)


  test("getting state entity",
       function() return state:get_entity() end,
       hero)

  test("getting state map",
       function() return state:get_map() end,
       map)

  test("getting state game",
       function() return state:get_game() end,
       game)

  test("state is started",
       function() return state:is_started() end,
       true)

  test("state is not stopping",
       function() return state:is_stopping() end,
       false)

  local old_state = state
  test("changing state make old state stopping",
       function()
         state = sol.state.create()
         return old_state:is_stopping()
       end,
       true)

  test("old state is not started",
       function() return old_state:is_started() end,
       false)

  --wait a bit
  later(function()
      test("after a while new state is started",
           function() return state:is_started() end,
           true)

      --test the given setter with several values
      local function test_setter(name,set,get,...)
        local vals = {...}
        for _,v in ipairs(vals) do
          test("setting '" .. name .. "' to " .. format_value(v),
               function() state[set .. name](state,v) end)
          test("getting '" .. name .. "', should be " .. format_value(v),
               function() return state[get .. name](state) end,
               v)
        end
      end

      local function test_setis(name,...)
        test_setter(name,"set_","is_",...)
      end

      local function test_setget(name,...)
        test_setter(name,"set_","get_",...)
      end

      -- TODO verify setters getter usage here

      --test all getter setter without callbacks
      test_setis("visible",true,false)
      test_setget("draw_override",function() end)
      test_setis("direction_locked",true,false)

      test_setget("can_control_movement",true,false)
      test_setis("affected_by_ground","empty","deep_water","lava","hole","ice","prickles")
      test_setget("can_come_from_bad_ground",true,false)
      test_setget("are_collisions_ignored",true,false)
      test_setis("teletransporter_delayed",true,false)
      test_setget("can_persist_on_stream",true,false)
      test_setget("can_be_hurt",true,false)
      test_setget("can_use_sword",true,false)
      test_setget("can_use_shield",true,false)
      test_setget("can_use_item",true,false)
      test_setget("can_pick_treasure",true,false)
      test_setget("can_take_stairs",true,false)
      test_setget("can_take_jumper",true,false)
      test_setget("previous_carried_object_behavior","throw","destroy","keep")

      cont()
  end)
end

--test the testing utility function
local function testtest()
  test("test the test utility",
       function() return 1,2 end,
       1,2)

  local function fail()
    test("fail the test",
         function() return 1,2 end,
         3,4)
  end

  local status, err = pcall(fail)
  assert(not status)
  assert_equal(type(err),"string")
  print("good error : " .. err)
end

-- make function for testing events on a given state
local function make_test_event_utility(state)
  state.pending_events = {}
  state.raised_events = {}

  --test wether all pending events have been called
  function state:collect_events()
    local unraised_events = {}
    local has_unraised = false
    for name,story in pairs(state.pending_events) do
      if story and not state.raised_events[name] then
        unraised_events[name] = story
        has_unraised = true
      end
    end
    if has_unraised then
      local err = "Unraised events :"
      for name,story in pairs(unraised_events) do
        err = err .. "\n" .. k .. " ('" .. story .. "')"
      end
      error(err)
    end
    state.pending_events = {}
    state.raised_events = {}
  end

  local function test_event(story,name,...)
    local expected = {...}
    state.pending_events[name] = story

    state[name] = function(self,...)
      local results = {...}
      state.raised_events[name] = true
      table_match(story,expected,results) --test if the results are the expected ones
      state[name] = nil --remove callback
    end
  end
  return test_event
end

--test a state launched just at map start
local function test_start_state()
  local first_state = sol.state.create("first")

  hero:start_state(first_state)

  local early_test_state = sol.state.create("early")
  local first_test_event = make_test_event_utility(first_state)

  first_test_event("on_finished is called when a new state is launched",
                   "on_finished",
                   "early",early_test_state)


  local test_event = make_test_event_utility(state)

  local camera = map:get_camera()

  --test of basic early events
  test_event("on_started is called when state is started",
             "on_started",
             "first",first_state)

  test_event("on_update is called at least once",
             "on_update")

  test_event("on_pre_draw is called at least once",
             "on_pre_draw",
             camera)

  test_event("on_post_draw is called at least once",
             "on_post_draw",
             camera)

  test_event("on_opening_transition is called when state is launched in on created",
             "on_map_opening_transition_finished")

  hero:start_state(early_test_state)
  --Verify events have been called for the very first state
  first_state:collect_events()
end

--test event related to game suspention and call continuation cont
local function test_pause_events(cont)
  local pause_state = sol.state.create("pause")
  hero:start_state(pause_state)
  local test_event = make_test_event_utility(pause_state)
  test_event("on_suspended is called when game is suspended",
             "on_suspended",
             true)
  later(function()
      pause_state:collect_events()
      test_event("on_suspended is called with false when game is resumed",
                 "on_suspended",
                 false)
      later(function()
          pause_state:collect_events()
          cont()
      end)
      map:get_game():set_suspended(false)
  end)
  map:get_game():set_suspended(true)
end

--test events related to movement and call continuation cont
local function test_move_events(cont)
  local move_state = sol.state.create("move")
  hero:start_state(move_state)
  local test_event = make_test_event_utility(state)
  local old_pos = {hero:get_position()}
  test_event("on_layer_changed is called when layer change",
             "on_layer_changed")
  hero:set_layer(1)
  test_event("on_position_changed is called when position is modified",
             "on_position_changed")
  test_event("on_ground_changed is called when ground has changed",
             "on_ground_changed")
  hero:set_position(table_marker:get_position())

  --check previous events have been called
  move_state:collect_events()


  --setup sensors behaviour
  function begin_move_sensor:on_activated()
    test_event("on_movement_changed is called when the player press a direction",
               "on_movement_changed")
    game:simulate_command_pressed("right")
  end
  function turn_down_sensor:on_activated()
    game:simulate_command_released("right")
    game:simulate_command_pressed("down")
    test_event("on_jumper_activated is callled when a jumper is taken and jumper is given",
               "on_jumper_activated",
               test_jumper)

    test_event("on_obstacle_reached is called when the player reaches a wall",
               "on_obstacle_reached")
  end
  function map_end_sensor:on_activated()
    later(function()
        test_event("on_movement_finished is called when the player stop",
                   "on_movement_finished")
        game:simulate_command_released("down")
        move_state:collect_events()
        cont()
    end)
  end

  --set the hero at small path beginning
  hero:set_position(begin_move_sensor:get_position())
end

local function test_command_events(cont)
  local command_state = sol.state.create("commands")
  hero:start_state(command_state)
  local test_event = make_test_event_utility(command_state)
  test_event("on_command_pressed receive commands",
             "on_command_pressed",
             "right")
  game:simulate_command_pressed("right")
  later(function()
      test_event("on_command_released receive commands",
                 "on_command_released",
                 "right")
      game:simulate_command_released("right")
      later(function()
          command_state:collect_events()
          cont()
      end)
  end)
end

local function test_key_events(cont)
  local key_state = sol.state.create("keys")
  hero:start_state(key_state)
  local test_event = make_test_event_utility(key_state)
  local key = "A"
  test_event("on_key_pressed receive keys",
             "on_key_pressed",
             key)
  sol.input.simulate_key_pressed(key)
  later(function()
      test_event("on_key_released receive keys",
                 "on_key_released",
                 key)
      sol.input.simulate_key_released(key)
      later(function()
          key_state:collect_events()
          cont()
      end)
  end)
end

local function test_map_change(cont)
  local map_state = sol.state.create("map")
  hero:start_state(map_state)
  local test_event = make_test_event_utility(map_state)
  test_event("on_map_finished is called when map is leaved",
             "on_map_finished",
             map)
  test_event("on_map_changed is called when changing map",
             "on_map_changed")
  test_event("on_map_started is called when new map starts",
             "on_map_started")
  hero:teleport("custom_state/end_map")
end

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  testtest()

  test_interface_presence()
  test_state_methods_presence()

  test_start_state()

  --sol.main.exit()
end

--create a chain of tests of the form test(cont)
local function test_chain(test,...)
  local other_tests = {...}
  if test then
    test(function()
        test_chain(unpack(other_tests))
    end)
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()
  local early_test_state = hero:get_custom_state()
  assert_equal(sol.main.get_type(early_test_state), "state")

  later(function()
      --Test if all events have been called
      early_test_state:collect_events()
      test_chain(
        test_state_methods,
        test_pause_events,
        test_command_events,
        test_key_events,
        test_move_events,
        test_map_change
      )
  end)
end
