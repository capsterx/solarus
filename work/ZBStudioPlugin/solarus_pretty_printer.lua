if not sol then return end --dont do anything if this is not launched is solarus

local function copy_table(src)
  local dst = {}
  for k,v in pairs(src) do
    dst[k] = v
  end
  return dst
end

local function add_pretty_print(meta)  
  local function pget(obj,getter)
    local function table_unwrap(t)
      if not t[2] then return t[1] end
      return t
    end
    
    local t = {pcall(getter,obj)}
    if t[1] then
      table.remove(t,1)
      return table_unwrap(t)
    end
    return getter
  end
  
  -- add serialize function to be picked by 'serpent'
  function meta.__serialize(obj,already_serialized)
    local already_serialized = already_serialized or {}
    already_serialized[obj] = true
    local t = copy_table(debug.getregistry()['sol.userdata_tables'][obj] or {})
    t.type = sol.main.get_type(obj)
    --add all properties found in the object :
    
    for k,v in pairs(meta) do
      if type(k) == 'string' and type(v) == 'function' then
        local prop = k:match("get_(.*)")
        if prop then
          if not t[prop] then
            t[prop] = pget(obj,v) or "nil"
          elseif not t[k] then
            t[k] = v
          else
          end
        end
        local pred = k:match("(is_.*)")
        if pred then
          if not t[k] then
            t[k] = pget(obj,v)
          end
        end
      end
    end
    
    
    return t
  end
end

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
  "custom_entity"
}

-- Add the register_event function to all userdata types.
for _, type in ipairs(types) do
  local meta = sol.main.get_metatable(type)
  assert(meta ~= nil)
  add_pretty_print(meta)
end