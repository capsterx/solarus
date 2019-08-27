-- Lua script of map bugs/1269_coroutines.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

local timeout = 5000

-- test if the event triggered by provoc closure is called and continue
-- with next_test if any
local function test_event(event_name,provoc,next_test)
  local magic = {} --magic token
  local coco = coroutine.create(
    function(cont)
      provoc(cont)
      local token = coroutine.yield() --resume engine execution
      assert(token == magic, "coroutine was resumed from the wrong place")
  end)
  local called
  local function assert_coco_suspended()
    if called then --don't do anything if event is called a second time
      return
    end
    --event has been triggered ! ensure it is not in the coroutine
    assert_equal(coroutine.status(coco),'suspended',string.format("'%s' has been called from a coroutine",event_name))
    coroutine.resume(coco,magic) --let the coroutine finish and verify resume spot
    called = true --mark event as called
    if next_test then next_test() end --run next test
  end
  sol.timer.start(map,timeout,
                  function()
                    assert(called,string.format("'%s' has not been called after %d [ms]",event_name,timeout))
  end)
  local status, err = coroutine.resume(coco,assert_coco_suspended)
  if not status then --VERY IMPORTANT, forward errors to main thread!
    error(err)
  end
end

--helper to forge event_tests
local function te(event_name,provoc,next_test)
  return function()
    test_event(event_name,provoc,next_test)
  end
end

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

local function timer_events(cont)
  test_event("timer timeout",
             function(cont)
               sol.timer.start(map,300,cont)
             end,
             cont
             )
end

local function dialog_events(cont)
  test_event("dialog_continuation",
                function(cont)
                  game:start_dialog("a",cont)
                  game:stop_dialog()
                end,
                cont
  )
end
-- test all sprite events from coroutines
local function sprite_events(cont)
  local sprite = dummy:get_sprite()
  test_event("on_animation_changed",
     function(cont)
       sprite.on_animation_changed = cont
       sprite:set_animation('jumping')
       sprite:set_animation('stopped')
     end,
     te("on_animation_finished",
        function(cont)
          sprite.on_animation_finished = cont
          sprite:set_animation('sword')
        end,
        te("on_direction_changed",
           function(cont)
             sprite.on_direction_changed = cont
             sprite:set_direction(2)
           end,
           te("on_frame_changed",
              function(cont)
                sprite.on_frame_changed = cont
                sprite:set_animation('sword')
              end,
              te("set_animation continuation",
                 function(cont)
                   sprite:set_animation("sword",cont)
                 end,
                 cont --continue to main test
              )
           )
        )
     )
  )
end

-- test common mouvement events from coroutines
local function movement_events(cont)
  test_event("on_position_changed",
             function(cont)
               local movement = sol.movement.create("straight")
               movement.on_position_changed = cont
               local t = {x=0,y=0}
               movement:start(t)
             end,
             te("movement end",
                function(cont)
                  local movement = sol.movement.create('target')
                  movement:set_target(40,40)
                  local t = {x=0,y=0}
                  movement:start(t,cont)
                end,
                te("on_obstacle_reached",
                   function(cont)
                     local movement = sol.movement.create("straight")
                     movement.on_obstacle_reached = function()
                       movement:stop()
                       cont()
                     end
                     movement:start(dummy)
                   end,
                   te("on_changed",
                      function(cont)
                        local movement = sol.movement.create("straight")
                        movement:set_speed(32)
                        local t = {x=0,y=0}
                        movement.on_changed = cont
                        movement:start(t)
                        sol.timer.start(map, 2000, function()
                            movement:set_speed(16)
                        end)
                      end,
                      te("on_finished",
                         function(cont)
                           local movement = sol.movement.create("target")
                           movement:set_target(40,40)
                           movement.on_finished = cont
                           local t = {x=0,y=0}
                           movement:start(t)
                         end,
                         cont -- continue to next test
                      )
                   )
                )
             )
  )
end

local function entity_events(cont)
  test_event("on_removed",
             function(cont)
               to_remove.on_removed = cont
               to_remove:remove()
             end,
             te("on_enabled",
                function(cont)
                  dummy.on_disabled = cont
                  dummy:set_enabled(false)
                end,
                te("on_disabled",
                   function(cont)
                     dummy.on_enabled = cont
                     dummy:set_enabled(true)
                   end,
                   te("on_supended",
                      function(cont)
                        dummy.on_suspended = cont
                        game:set_suspended(true)
                        sol.timer.start(game,50,function()
                                          game:set_suspended(false)
                        end)
                      end,
                      te("on_position_changed",
                         function(cont)
                           dummy.on_position_changed = cont
                           dummy:set_position(anchor:get_position())
                         end,
                         te("on_obstacle_reached",
                            function(cont)
                              dummy:set_position(anchor:get_position())
                              local movement = sol.movement.create("straight")
                              dummy.on_obstacle_reached = function()
                                movement:stop()
                                cont()
                              end
                              movement:start(dummy)
                            end,
                            te("on_movement_started",
                               function(cont)
                                 local movement = sol.movement.create("straight")
                                 dummy.on_movement_started = cont
                                 movement:start(dummy)
                               end,
                               te("on_movement_changed",
                                  function(cont)
                                    local movement = dummy:get_movement()
                                    dummy.on_movement_changed = cont
                                    movement:set_angle(math.pi*0.5)
                                  end,
                                  te("on_movement_finished",
                                     function(cont)
                                       dummy:set_position(20,20)
                                       local movement = sol.movement.create('target')
                                       movement:set_target(40,40)
                                       dummy.on_movement_finished = cont
                                       movement:start(dummy)
                                     end,
                                     cont
                                  )
                               )
                            )
                         )
                      )
                   )
                )
             )
  )
end

local function menu_events(cont)
  local menu = {}
  test_event("on_started",
             function(cont)
               menu.on_started = cont
               sol.menu.start(map,menu)
             end,
             te("on_finished",
                function(cont)
                  menu.on_finished = cont
                  sol.menu.stop(menu)
                end,
                cont
             )
  )
end

local function item_events(cont)
  local item = game:get_item("coroutine_handle")
  item:set_brandish_when_picked(false)
  test_event("on_suspended",
             function(cont)
               item.on_suspended = cont
               game:set_suspended(true)
               sol.timer.start(game,300,
                               function()
                                 game:set_suspended(false)
                               end
               )
             end,
             te("on_pickable_created",
                function(cont)
                  item.on_pickable_created = cont
                  map:create_pickable{
                    layer=0,
                    x=0,
                    y=0,
                    treasure_name="coroutine_handle",
                  }
                end,
                te("on_obtaining",
                   function(cont)
                     item.on_obtaining = cont
                     hero:start_treasure("coroutine_handle")
                     --game:stop_dialog()
                   end,
                   te("on_obtained",
                      function(cont)
                        item.on_obtained = cont
                        hero:start_treasure("coroutine_handle")
                        --game:stop_dialog()
                      end,
                      te("on_variant_changed",
                         function(cont)
                           item.on_variant_changed = cont
                           item:set_variant(2)
                         end,
                         te("on_amount_changed",
                            function(cont)
                              item.on_amount_changed = cont,
                              item:set_amount(42)
                              item:add_amount(1)
                            end,
                            te("on_using",
                               function(cont)
                                 item.on_using = cont,
                                 hero:start_item(item)
                               end,
                               cont
                            )
                         )
                      )
                   )
                )
             )
  )
end

local function game_events(cont)
  test_event("on_paused",
             function(cont)
               game.on_paused = cont
               game:set_paused(true)
               sol.timer.start(sol.main,200,function()
                                 game:set_paused(false)
               end)
             end,
             te("on_unpaused",
                function(cont)
                  game.on_unpaused = cont
                  game:set_paused(true)
                  sol.timer.start(sol.main,200,
                                  function()
                                    game:set_paused(false)
                  end)
                end,
                te("on_dialog_started",
                   function(cont)
                     game.on_dialog_started = cont
                     game:start_dialog("a")
                     game:stop_dialog()
                   end,
                   te("on_dialog_finished",
                      function(cont)
                        sol.timer.start(sol.main,200,function()
                          game.on_dialog_finished = cont,
                          game:start_dialog("a")
                          game:stop_dialog()
                        end)
                      end,
                      cont
                   )
                )
             )
  )
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

  --launch all events test in order
  test_chain(
    timer_events,
    dialog_events,
    sprite_events,
    movement_events,
    entity_events,
    menu_events,
    item_events,
    game_events,
    sol.main.exit
  )
end
