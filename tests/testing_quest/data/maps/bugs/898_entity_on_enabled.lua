local map = ...
local game = map:get_game()

local entities = { enemy, custom_entity, block }

function entity_on_enabled(entity)

  entity.enabled_count = (entity.enabled_count or 0) + 1
end

function entity_on_disabled(entity)

  entity.disabled_count = (entity.disabled_count or 0) + 1
end

for _, entity in ipairs(entities) do
  entity.on_enabled = entity_on_enabled
  entity.on_disabled = entity_on_disabled
end

function map:on_started()

  for _, entity in ipairs(entities) do
    entity:set_enabled(false)
  end

  for _, entity in ipairs(entities) do
    entity:set_enabled(true)
  end
end

function map:on_opening_transition_finished()

  for _, entity in ipairs(entities) do
    assert_equal(entity.enabled_count or 0, 1)
    assert_equal(entity.disabled_count or 0, 1)
  end
  sol.main.exit()
end