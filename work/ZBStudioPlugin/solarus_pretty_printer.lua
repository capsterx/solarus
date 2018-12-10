if not sol then return end --dont do anything if this is not launched is solarus

local function copy_table(src)
  local dst = {}
  for k,v in pairs(src) do
    dst[k] = v
  end
  return dst
end

local function add_pretty_print(name,meta,properties)  
  local function get(obj,getter)
    local function table_unwrap(t)
      if not t[2] then return t[1] end
      return t
    end
    local t = {getter(obj)}
    if t[1] == nil then return "nil" end
    return table_unwrap(t)
  end
  
  -- add serialize function to be picked by 'serpent'
  function meta.__serialize(obj)
    local t = copy_table(debug.getregistry()['sol.userdata_tables'][obj] or {})
    t.type = sol.main.get_type(obj)
    --add all properties found in the object :
    
    for _,pname in ipairs(properties) do
      local val = get(obj,meta[pname])
      local pget = pname:match"get_(.*)"
      if pget then
        t[pget] = val
      end
      local isget = pname:match"is_(.*)"
      if isget then
        t[isget] = val
      end
      local hasget = pname:match"(has_.*)"
      if hasget then
        t[hasget] = val
      end
    end
    
    t.metatable = meta
    return t
  end
end

local function entity(...)
  return {"get_type","get_map","get_game","get_size","get_origin","get_position","get_center_position","get_facing_position","get_facing_entity","get_ground_position","get_ground_below","get_bounding_box","get_layer","get_draw_override","get_weight", "get_controlling_stream", "get_movement", "get_properties","is_enabled","is_drawn_in_y_order","is_visible",...}
end

local function drawable(...)
  return {"get_rotation","get_scale","get_transformation_origin","get_blend_mode","get_shader","get_opacity","get_xy","get_movement",...}
end

local function movement(...)
  return {"get_xy","get_ignore_suspend","get_ignore_obstacles","get_direction4",...}
end

local properties = {
  game = {"get_map","get_hero","get_starting_location","get_life","get_max_life","get_money","get_max_money","get_magic","get_max_magic",
    "is_started","is_suspended","is_paused","is_pause_allowed","is_dialog_enabled","is_game_over_enabled"},
  map = {"get_id","get_game","get_world","get_floor","get_min_layer","get_max_layer","get_size","get_location","get_tileset","get_music","get_camera","get_crystal_state","get_hero"},
  item = {"get_name","get_map","get_savegame_variable","get_amount_savegame_variable","get_can_disappear"}, --TODO: complete
  surface = drawable("get_size"),
  text_surface = drawable("get_horizontal_alignment","get_vertical_alignment","get_font","get_rendering_mode","get_color","get_font_size","get_text","get_size"),
  sprite = drawable("get_animation_set","get_animation","is_animation_started","get_direction","get_num_directions","get_frame","get_num_frames","get_frame_delay","get_size","get_origin","get_frame_src_xy","is_paused","get_ignore_suspend"),
  timer = {"is_with_sound","is_suspended","is_suspended_with_map","get_remaining_time"},
  movement = movement(), --TODO complete
  straight_movement = movement(),
  target_movement = movement(),
  random_movement = movement(),
  path_movement = movement(),
  random_path_movement = movement(),
  path_finding_movement = movement(),
  circle_movement = movement(),
  jump_movement = movement(),
  pixel_movement = movement(),
  hero = entity("get_direction","get_walking_speed","get_solid_ground_position","get_animation","get_tunic_sprite_id","get_sword_sprite_id","get_sword_sound_id","get_shield_sprite_id","is_invincible","get_carried_object","get_state","get_state_object"),
  dynamic_tile = entity("get_pattern_id"),
  teletransporter = entity("get_sound","get_transition","get_destination_map","get_destination_name"),
  destination = entity("get_starting_location_mode"),
  pickable = entity("get_followed_entity","get_falling_height","get_treasure"),
  destructible = entity("get_treasure","get_destruction_sound","get_can_be_cut","get_can_explode","get_can_regenerate","get_damage_on_enemies","get_modified_ground"),
  carried_object = entity("get_damage_on_enemies","get_destruction_sound"),
  chest = entity("is_open","get_treasure"),
  shop_treasure = entity(),
  enemy = entity("get_breed","get_life","get_damage","is_pushed_back_when_hurt","get_push_hero_on_sword","get_can_hurt_hero_running","get_hurt_style","get_dying_sprite_id","get_can_attack","get_minimum_shield_needed","is_traversable","get_attacking_collision_mode","has_layer_independent_collisions","get_obstacle_behavior","is_immobilized"),
  npc = entity("is_traversable"),
  block = entity("is_pushable","is_pullable","get_max_moves"),
  jumper = entity(),
  switch = entity("is_walkable","is_activated","is_locked"),
  sensor = entity(),
  separator = entity(),
  wall = entity(),
  crystal = entity(),
  crystal_block = entity(),
  stream = entity("get_direction","get_speed","get_allow_movement","get_allow_attack","get_allow_item"),
  door = entity("is_open","is_opening","is_closed","is_closing"),
  stairs = entity("get_direction","is_inner"),
  bomb = entity(),
  explosion = entity(),
  fire = entity(),
  arrow = entity(),
  hookshot = entity(),
  boomerang = entity(),
  camera = entity("get_position_on_screen","get_state","get_tracked_entity","get_surface"),
  custom_entity = entity("get_model","get_direction","is_tiled","has_layer_independent_collisions","get_modified_ground","get_follow_streams"),
  state = {},
  shader = {"get_id","get_vertex_file","get_vertex_source","get_fragment_file","get_fragment_source","get_scaling_factor"}
}


local types = {
  "game",
  "map",
  "item",
  "surface",
  "text_surface",
  "sprite",
  "timer",
  "movement",
  "straight_movement",
  "target_movement",
  "random_movement",
  "path_movement",
  "random_path_movement",
  "path_finding_movement",
  "circle_movement",
  "jump_movement",
  "pixel_movement",
  "hero",
  "dynamic_tile",
  "teletransporter",
  "destination",
  "pickable",
  "destructible",
  "carried_object",
  "chest",
  "shop_treasure",
  "enemy",
  "npc",
  "block",
  "jumper",
  "switch",
  "sensor",
  "separator",
  "wall",
  "crystal",
  "crystal_block",
  "stream",
  "door",
  "stairs",
  "bomb",
  "explosion",
  "fire",
  "arrow",
  "hookshot",
  "boomerang",
  "camera",
  "custom_entity",
  "state",
  "shader"
}

local function check_props(name,meta,props)
  for _,p in ipairs(props) do
    if not (type(meta[p]) == 'function') then
      error(string.format("object %s has no property called %s",name,p))
    end
  end
end

-- Add the register_event function to all userdata types.
for _, type in ipairs(types) do
  local meta = sol.main.get_metatable(type)

  assert(meta ~= nil)
  local props = properties[type] or {}
  check_props(type,meta,props)
  add_pretty_print(type,meta,props)
end

print("Successfully registered all pretty printers")
