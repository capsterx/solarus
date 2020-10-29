/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/AbilityInfo.h"
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/Debug.h"
#include "solarus/core/Equipment.h"
#include "solarus/core/EquipmentItem.h"
#include "solarus/core/Logger.h"
#include "solarus/core/Map.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/QuestProperties.h"
#include "solarus/core/Timer.h"
#include "solarus/core/Treasure.h"
#include "solarus/entities/Block.h"
#include "solarus/entities/CarriedObject.h"
#include "solarus/entities/Chest.h"
#include "solarus/entities/CustomEntity.h"
#include "solarus/entities/Destination.h"
#include "solarus/entities/Door.h"
#include "solarus/entities/Enemy.h"
#include "solarus/entities/EnemyAttack.h"
#include "solarus/entities/GroundInfo.h"
#include "solarus/entities/Npc.h"
#include "solarus/entities/Pickable.h"
#include "solarus/entities/Sensor.h"
#include "solarus/entities/ShopTreasure.h"
#include "solarus/entities/Switch.h"
#include "solarus/entities/Tileset.h"
#include "solarus/lua/ExportableToLuaPtr.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"
#include "solarus/core/Arguments.h"
#include <sstream>

namespace Solarus {

LuaContext* LuaContext::lua_context;

/**
 * \brief Creates a Lua context.
 * \param main_loop The Solarus main loop manager.
 */
LuaContext::LuaContext(MainLoop& main_loop):
  current_l(nullptr),
  main_loop(main_loop) {

}

/**
 * \brief Destroys this Lua context.
 */
LuaContext::~LuaContext() {

  this->exit();
}

/**
 * \brief Returns the LuaContext object that encapsulates a Lua state.
 * \param l A Lua state.
 * \return The LuaContext object encapsulating this Lua state.
 */
LuaContext& LuaContext::get() {
  Debug::check_assertion(lua_context,"No lua context available");
  return *lua_context;
}

/**
 * \brief Returns the internal Lua state encapsulated by this LuaContext object.
 * \return The internal Lua state.
 */
lua_State* LuaContext::get_internal_state() {
  return current_l;
}

/**
 * \brief Returns the internal Lua state encapsulated by this LuaContext object.
 * \return The internal Lua state.
 */
lua_State* LuaContext::get_main_state() {
  return main_l;
}

/**
 * \brief Returns the Solarus main loop object.
 * \return The main loop manager.
 */
MainLoop& LuaContext::get_main_loop() {
  return main_loop;
}

/**
 * \brief Initializes Lua.
 */
void LuaContext::initialize(const Arguments& args) {

  // Create an execution context.
  main_l = current_l = luaL_newstate();
  lua_atpanic(current_l, l_panic);
  luaL_openlibs(current_l);

  print_lua_version();

  // Associate this LuaContext object to the lua_State pointer.
  lua_context = this;

  // Create a table that will keep track of all userdata.
                                  // --
  lua_newtable(current_l);
                                  // all_udata
  lua_newtable(current_l);
                                  // all_udata meta
  lua_pushstring(current_l, "v");
                                  // all_udata meta "v"
  lua_setfield(current_l, -2, "__mode");
                                  // all_udata meta
  lua_setmetatable(current_l, -2);
                                  // all_udata
  lua_setfield(current_l, LUA_REGISTRYINDEX, "sol.all_userdata");
                                  // --

  // Allow userdata to be indexable if they want.
  lua_newtable(current_l);
                                  // udata_tables
  lua_setfield(current_l, LUA_REGISTRYINDEX, "sol.userdata_tables");
                                  // --

  // Create the sol table that will contain the whole Solarus API.
  lua_newtable(current_l);
  lua_setglobal(current_l, "sol");

  // Register the C++ functions and types accessible by Lua.
  register_modules();

  // Make require() able to load Lua files even from the
  // data.solarus or data.solarus.zip archive.
                                  // --
  lua_getglobal(current_l, "sol");
                                  // -- sol
  lua_pushcfunction(current_l, l_loader);
                                  // -- sol loader
  lua_setfield(current_l, -2, "loader");
                                  // -- sol
  luaL_dostring(current_l, "table.insert(package.loaders, 2, sol.loader)");
                                  // -- sol
  lua_pushnil(current_l);
                                  // -- sol nil
  lua_setfield(current_l, -2, "loader");
                                  // -- sol
  lua_pop(current_l, 1);
                                  // --

  // Make sure that stdout gets flushed when Lua scripts output new lines.
  // This is not always the case by default.
  luaL_dostring(current_l, "io.stdout:setvbuf(\"line\")");

  // Initially set the language if there is only one declared.
  const std::map<std::string, std::string>& languages = CurrentQuest::get_resources(ResourceType::LANGUAGE);
  if (languages.size() == 1) {
    CurrentQuest::set_language(languages.begin()->first);
  }

  Debug::check_assertion(lua_gettop(current_l) == 0, "Non-empty Lua stack after initialization");


  //Do the script passed as arg
  std::string arg_script = args.get_argument_value("-s");
  if(!arg_script.empty()) {
    Debug::warning("Running script arg \"" + arg_script + "\"");
    do_string(arg_script,"script argument (-s)");
  }

  // Execute the main file.
  do_file_if_exists("main");

  Debug::check_assertion(lua_gettop(current_l) == 0, "Non-empty Lua stack after running main.lua");

  main_on_started();
}

/**
 * \brief Cleans Lua.
 */
void LuaContext::exit() {

  if (current_l != nullptr) {
    // Call sol.main.on_finished() if it exists.
    main_on_finished();

    // Destroy unfinished objects.
    destroy_menus();
    destroy_timers();
    destroy_drawables();
    userdata_close_lua();

    // Finalize Lua.
    lua_close(current_l);
    //lua_contexts.erase(l);
    lua_context = nullptr;
    current_l = nullptr;
    main_l = nullptr;
  }
}

/**
 * \brief Updates the Lua world.
 *
 * This function is called at each cycle.
 * sol.main.on_update() is called if it exists.
 */
void LuaContext::update() {

  // Make sure the stack does not leak.
  Debug::check_assertion(lua_gettop(main_l) == 0,
      "Non-empty stack before LuaContext::update()"
  );

  Debug::check_assertion(current_l == main_l,
                         "Not on the main lua thread to execute lua update");

  update_drawables();

  Debug::check_assertion(current_l == main_l,
                         "Not on the main lua thread after updating drawable");
  update_movements();

  Debug::check_assertion(current_l == main_l,
                         "Not on the main lua thread after updating movements");

  update_menus();

  Debug::check_assertion(current_l == main_l,
                         "Not on the main lua thread after updating menus");

  update_timers();

  Debug::check_assertion(current_l == main_l,
                         "Not on the main lua thread after updating timers");

  // Call sol.main.on_update().
  main_on_update();

  //Call cross state callbacks
  while(!cross_state_callbacks.empty()) {
    const auto& f = cross_state_callbacks.front();
    f(current_l);
    cross_state_callbacks.pop();
  }

  current_l = main_l; //Ensure we run again on the main thread

  Debug::check_assertion(lua_gettop(main_l) == 0,
      "Non-empty stack after LuaContext::update()"
  );
}

/**
 * \brief Notifies Lua that an input event has just occurred.
 *
 * The appropriate callback in sol.main is notified.
 *
 * \param event The input event to handle.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::notify_input(const InputEvent& event) {

  Debug::check_assertion(lua_gettop(current_l) == 0,
      "Non-empty stack before LuaContext::notify_input()"
  );

  // Call the appropriate callback in sol.main (if it exists).
  const bool handled = main_on_input(event);

  Debug::check_assertion(lua_gettop(current_l) == 0,
      "Non-empty stack after LuaContext::notify_input()"
  );

  return handled;
}

/**
 * \brief Notifies Lua that a map has just been started.
 *
 * The Lua file of this map is automatically loaded.
 *
 * \param map The map started.
 * \param destination The destination point used if it is a normal one,
 * nullptr otherwise.
 */
void LuaContext::run_map(Map& map, const std::shared_ptr<Destination>& destination) {

  // Compute the file name, depending on the id of the map.
  std::string file_name = std::string("maps/") + map.get_id();

  // Load the map's code.
  if (load_file(file_name)) {
                                    // map_fun
    // Set a special environment to access map entities like global variables.
    lua_newtable(current_l);
                                    // map_fun env
    lua_newtable(current_l);
                                    // map_fun env env_mt
    push_map(current_l, map);
                                    // map_fun env env_mt map
    // Set our special __index function that gets entities on-demand.
    lua_pushcclosure(current_l, l_get_map_entity_or_global, 1);
                                    // map_fun env env_mt __index
    lua_setfield(current_l, -2, "__index");
                                    // map_fun env env_mt
    // We are changing the environment, so we need to also define __newindex
    // with its usual setting (the global table).
    lua_pushvalue(current_l, LUA_GLOBALSINDEX);
                                    // map_fun env env_mt _G
    lua_setfield(current_l, -2, "__newindex");
                                    // map_fun env env_mt
    lua_setmetatable(current_l, -2);
                                    // map_fun env
    lua_setfenv(current_l, -2);
                                    // map_fun

    // Run the map's code with the map userdata as parameter.
    push_map(current_l, map);
    call_function(1, 0, file_name.c_str());
  }

  // Call the map:on_started() callback.
  map_on_started(map, destination);
}

/**
 * \brief Notifies Lua that a map has just been suspended or resumed.
 * \param map A map.
 * \param suspended \c true if it is suspended, false if it is resumed.
 */
void LuaContext::notify_map_suspended(Map& map, bool suspended) {

  notify_timers_map_suspended(suspended);   // Notify timers.
  map_on_suspended(map, suspended);  // Call map:on_suspended()
}

/**
 * \brief Notifies the Lua world that an equipment item has just been created.
 *
 * The Lua file of this item is automatically loaded.
 *
 * \param item The item.
 */
void LuaContext::run_item(EquipmentItem& item) {

  // Compute the file name, depending on the id of the equipment item.
  std::string file_name = std::string("items/") + item.get_name();

  // Load the item's code.
  if (load_file(file_name)) {

    // Run it with the item userdata as parameter.
    push_item(current_l, item);
    call_function(1, 0, file_name.c_str());

    // Call the item:on_created() callback.
    item_on_created(item);
  }
}

/**
 * \brief Notifies the Lua world that an enemy has just been added to the map.
 *
 * The Lua file of this enemy is automatically loaded.
 *
 * \param enemy The enemy.
 */
void LuaContext::run_enemy(Enemy& enemy) {

  // Compute the file name, depending on enemy's breed.
  std::string file_name = std::string("enemies/") + enemy.get_breed();

  // Load the enemy's code.
  if (load_file(file_name)) {

    // Run it with the enemy userdata as parameter.
    push_enemy(current_l, enemy);
    call_function(1, 0, file_name.c_str());
  }

  // TODO parse Lua only once for each breed.
}

/**
 * \brief Notifies the Lua world that a custom entity has just been added to
 * the map.
 *
 * The Lua file of this entity if any is automatically loaded.
 *
 * \param custom_entity The custom entity.
 */
void LuaContext::run_custom_entity(CustomEntity& custom_entity) {

  const std::string& model = custom_entity.get_model();

  if (model.empty()) {
    // No Lua model file to run for this entity.
    return;
  }

  // Compute the file name depending on the model.
  std::string file_name = std::string("entities/") + model;

  // Load the entity's code.
  if (load_file(file_name)) {

    // Run it with the entity userdata as parameter.
    push_custom_entity(current_l, custom_entity);
    call_function(1, 0, file_name.c_str());
  }

  // TODO parse Lua only once for each model.
}

/**
 * \brief Notifies Lua that a dialog starts.
 * \param game The game.
 * \param dialog The dialog that is becoming active.
 * \param info_ref Lua ref to an optional info parameter to pass to
 * Lua, or an empty ref.
 * \return true if Lua handles the dialog, false otherwise.
 */
bool LuaContext::notify_dialog_started(
    Game& game,
    const Dialog& dialog,
    const ScopedLuaRef& info_ref
) {
  return game_on_dialog_started(game, dialog, info_ref);
}

/**
 * \brief Notifies Lua that a dialog is finished.
 * \param game The game.
 * \param dialog The dialog that was active.
 * \param callback_ref Lua ref of the function to call, or an empty ref.
 * \param status_ref Lua ref to a status value to pass to the callback.
 * "skipped" means that the dialog was canceled by the user.
 */
void LuaContext::notify_dialog_finished(
    Game& game,
    const Dialog& dialog,
    const ScopedLuaRef& callback_ref,
    const ScopedLuaRef& status_ref) {

  game_on_dialog_finished(game, dialog);

  // Execute the callback after game:on_dialog_finished()
  // because the callback may start another dialog.
  if (!callback_ref.is_empty()) {
    push_ref(current_l, callback_ref);
    if (!status_ref.is_empty()) {
      push_ref(current_l, status_ref);
    }
    else {
      // No status.
      lua_pushnil(current_l);
    }
    call_function(1, 0, "dialog callback");
  }
}

/**
 * \brief Shows a deprecation warning message if the quest format is recent enough.
 *
 * Does nothing if the quest format is older than the given version.
 * Does nothing if the message for this function was already shown once.
 *
 * \param version Solarus version (major and minor numbers) where the function
 *   becomes deprecated.
 * \param function_name A deprecated Lua function.
 * \param message A warning message explaining how to replace the call.
 */
void LuaContext::warning_deprecated(
    const std::pair<int, int>& version_deprecating,
    const std::string& function_name,
    const std::string& message
) {

  if (warning_deprecated_functions.find(function_name) !=
      warning_deprecated_functions.end()) {
    return;
  }

  if (CurrentQuest::is_format_at_least(version_deprecating)) {
    std::ostringstream oss;
    oss << "The function "<< function_name <<
           " is deprecated since Solarus " <<
           version_deprecating.first << "." <<
           version_deprecating.second << ". " <<
           message;
    Logger::warning(oss.str());
    warning_deprecated_functions.insert(function_name);
  }
}

/**
 * \brief Creates a reference to the Lua value on top of the stack and pops
 * this value.
 * \return The reference created, wrapped in an object that manages its
 * lifetime.
 */
ScopedLuaRef LuaContext::create_ref() {

  return LuaTools::create_ref(current_l);
}

/**
 * \brief Pushes onto the stack a Lua value from its reference.
 *
 * Pushes nil if the reference is empty.
 *
 * \param l A Lua state.
 * \param ref Reference to a Lua value.
 */
void LuaContext::push_ref(lua_State* l, const ScopedLuaRef& ref) {

  if (ref.is_empty()) {
    lua_pushnil(l);
    return;
  }

  //This is not needed anymore since several state (threads) can be active
  //Debug::check_assertion(ref.get_lua_state() == l, "Wrong Lua state");
  ref.push(l);
}

/**
 * \brief Returns whether a userdata has an entry with the specified key.
 *
 * Userdata can have entries like tables thanks to special __index and
 * __newindex metamethods.
 *
 * Version with const char*, better for performance if you don't have an
 * std::string representation of the key.
 *
 * \param userdata A userdata.
 * \param key String key to test.
 * \return \c true if this key exists on the userdata.
 */
bool LuaContext::userdata_has_field(
    const ExportableToLua& userdata, const char* key) const {

  // TODO since this function now also checks the metatable, check that
  // doing the work below instead of just returning true is still useful
  // for performance.
  // If not, kill this function.

  // First check the metatable of the type.
  if (userdata_has_metafield(userdata, key)) {
    return true;
  }

  // Check the userdata itself then.
  if (!userdata.is_with_lua_table()) {
    return false;
  }

  const auto& it = userdata_fields.find(&userdata);
  if (it == userdata_fields.end()) {
    return false;
  }

  return it->second.find(key) != it->second.end();
}

/**
 * \brief Returns whether a userdata has an entry with the specified key.
 *
 * Userdata can have entries like tables thanks to special __index and
 * __newindex metamethods.
 *
 * Version with std::string, better for performance if you already have an
 * std::string representation of the key.
 *
 * \param userdata A userdata.
 * \param key String key to test.
 * \return \c true if this key exists on the userdata.
 */
bool LuaContext::userdata_has_field(
    const ExportableToLua& userdata, const std::string& key) const {

  // First check the metatable of the type.
  if (userdata_has_metafield(userdata, key.c_str())) {
    return true;
  }

  // Check the userdata itself then.
  if (!userdata.is_with_lua_table()) {
    return false;
  }

  const auto& it = userdata_fields.find(&userdata);
  if (it == userdata_fields.end()) {
    return false;
  }

  return it->second.find(key) != it->second.end();
}

/**
 * \brief Returns whether the metatable of a userdata has the specified field.
 * \param userdata A userdata.
 * \param key String key to test.
 * \return \c true if this key exists on the userdata's metatable.
 */
bool LuaContext::userdata_has_metafield(
    const ExportableToLua& userdata, const char* key) const {

  // We avoid to push the userdata for performance.
  // Maybe the userdata does not even exist in the Lua side.
                                  // ...
  luaL_getmetatable(current_l, userdata.get_lua_type_name().c_str());
                                  // ... meta
  lua_pushstring(current_l, key);
                                  // ... meta key
  lua_rawget(current_l, -2);
                                  // ... meta field/nil
  const bool found = !lua_isnil(current_l, -1);
  lua_pop(current_l, 2);
                                  // ...
  return found;
}

/**
 * \brief Gets a method of the object on top of the stack.
 *
 * This is equivalent to find_method(-1, function_name).
 *
 * \param function_name Name of the function to find in the object.
 * This is not an const std::string& but a const char* on purpose to avoid
 * costly conversions as this function is called very often.
 * \return true if the function was found.
 */
bool LuaContext::find_method(const char* function_name) {

  return find_method(-1, function_name);
}

/**
 * \brief Gets a method of an object.
 *
 * If the method exists, the method and the object are both pushed
 * so that you can call the method immediately with the object as first parameter.
 * If the method is not found, the stack is left unchanged.
 *
 * \param index Index of the object in the stack.
 * \param function_name Name of the function to find in the object.
 * This is not an const std::string& but a const char* on purpose to avoid
 * costly conversions as this function is called very often.
 *
 * \return true if the function was found.
 */
bool LuaContext::find_method(int index, const char* function_name) {

  index = LuaTools::get_positive_index(current_l, index);
                                  // ... object ...
  lua_getfield(current_l, index, function_name);
                                  // ... object ... method/?

  bool exists = lua_isfunction(current_l, -1);
  if (exists) {
                                  // ... object ... method
    lua_pushvalue(current_l, index);
                                  // ... object ... method object
  }
  else {
    // Restore the stack.
    lua_pop(current_l, 1);
                                  // ... object ...
  }

  return exists;
}

/**
 * \brief Calls the Lua function with its arguments on top of the stack.
 *
 * This function is like lua_pcall, except that it additionally handles the
 * error message if an error occurs in the Lua code (the error is printed).
 * This function leaves the results on the stack if there is no error,
 * and leaves nothing on the stack in case of error.
 *
 * \param nb_arguments number of arguments placed on the Lua stack above the
 * function to call
 * \param nb_results number of results expected (you get them on the stack if
 * there is no error)
 * \param function_name A name describing the Lua function (only used to print
 * the error message if any).
 * This is not a const std::string& but a const char* on purpose to avoid
 * costly conversions as this function is called very often.
 * \return true in case of success
 */
bool LuaContext::call_function(
    int nb_arguments,
    int nb_results,
    const char* function_name
) {
  return LuaTools::call_function(current_l, nb_arguments, nb_results, function_name);
}

/**
 * \brief Opens a script if it exists and lets it on top of the stack as a
 * function.
 *
 * If the file does not exist or has a syntax error,
 * the stack is left intact and false is returned.
 *
 * \param script_name File name of the script with or without extension,
 * relative to the data directory.
 * \return true if the file exists and was loaded.
 */
bool LuaContext::load_file(const std::string& script_name) {

  // Determine the file name (possibly adding ".lua").
  std::string file_name(script_name);

  if (!QuestFiles::data_file_exists(file_name)) {
    std::ostringstream oss;
    oss << script_name << ".lua";
    file_name = oss.str();
  }

  if (!QuestFiles::data_file_exists(file_name)) {
    // No error message: this is not an error.
    return false;
  }

  // Load the file.
  // "@" tells Lua that the name is a file name, which is useful for better error messages.
  const std::string& buffer = QuestFiles::data_file_read(file_name);
  int result = luaL_loadbuffer(current_l, buffer.data(), buffer.size(), ("@" + file_name).c_str());

  if (result != 0) {
    Debug::error(std::string("Failed to load script '")
        + script_name + "': " + lua_tostring(current_l, -1));
    lua_pop(current_l, 1);
    return false;
  }
  return true;
}

/**
 * \brief Opens a Lua file and executes it.
 *
 * This function just calls load_file() and call_function().
 * The file must exist.
 *
 * \param script_name File name of the script without extension,
 * relative to the data directory.
 */
void LuaContext::do_file(const std::string& script_name) {

  if (!load_file(script_name)) {
    Debug::error("Failed to load script '" + script_name + "'");
  }
  else {
    LuaTools::call_function(current_l, 0, 0, script_name.c_str());
  }
}

/**
 * \brief Opens a Lua file if it exists and executes it without arguments.
 *
 * This function just calls load_file_if_exists() and call_function().
 * Nothing is done if the file does not exists.
 *
 * \param script_name File name of the script without extension,
 * relative to the data directory.
 * \return true if the file exists and was successfully executed.
 */
bool LuaContext::do_file_if_exists(const std::string& script_name) {

  if (load_file(script_name)) {
    LuaTools::call_function(current_l, 0, 0, script_name.c_str());
    return true;
  }
  return false;
}

/**
 * \brief Loads and executes some Lua code.
 * \param code The code to execute.
 * \param chunk_name A name describing the Lua chunk
 * (only used to print the error message if any).
 * \return \c true in case of success.
 */
bool LuaContext::do_string(const std::string& code, const std::string& chunk_name) {
  int load_result = luaL_loadstring(current_l, code.c_str());

  if (load_result != 0) {
    Debug::error(std::string("In ") + chunk_name + ": "
        + lua_tostring(current_l, -1));
    lua_pop(current_l, 1);
    return false;
  }

  return LuaTools::call_function(current_l, 0, 0, chunk_name.c_str());
}

/**
 * \brief Executes Lua code in an environment with easy access to game objects.
 *
 * The environment provides:
 * - game,
 * - map,
 * - entities from their name,
 * - tp (teletransportation function).
 *
 * \param code The code to execute.
 * \param chunk_name A name describing the Lua chunk
 * (only used to print the error message if any).
 * \return \c true in case of success.
 */
bool LuaContext::do_string_with_easy_env(const std::string& code, const std::string& chunk_name) {

  int load_result = luaL_loadstring(current_l, code.c_str());

  if (load_result != 0) {
    Debug::error(std::string("In ") + chunk_name + ": "
        + lua_tostring(current_l, -1));
    lua_pop(current_l, 1);
    return false;
  }

  // Set an environment that provides easy access to game objects.
                                  // code
  lua_newtable(current_l);
                                  // code env
  lua_newtable(current_l);
                                  // code env env_mt
  // Set our special __index function.
  lua_pushcfunction(current_l, l_easy_index);
                                  // code env env_mt __index
  lua_setfield(current_l, -2, "__index");
                                  // code env env_mt
  // We are changing the environment, so we need to also define __newindex
  // with its usual setting (the global table).
  lua_pushvalue(current_l, LUA_GLOBALSINDEX);
                                  // code env env_mt _G
  lua_setfield(current_l, -2, "__newindex");
                                  // code env env_mt
  lua_setmetatable(current_l, -2);
                                  // code env
  lua_setfenv(current_l, -2);
                                  // code

  return LuaTools::call_function(current_l, 0, 0, chunk_name.c_str());
}

/**
 * @brief sets the presumed currently running lua state
 * @param l a lua state
 */
void LuaContext::set_current_state(lua_State* l) {
  lua_context->current_l = l;
}

/**
 * \brief Prints on a line the content of the Lua stack for debugging purposes.
 * \param l A Lua state.
 */
void LuaContext::print_stack(lua_State* l) {

  int i;
  int top = lua_gettop(l);

  std::ostringstream oss;
  for (i = 1; i <= top; i++) {

    int type = lua_type(l, i);
    switch (type) {

      case LUA_TSTRING:
        oss << "\"" << lua_tostring(l, i) << "\"";
        break;

      case LUA_TBOOLEAN:
        oss << (lua_toboolean(l, i) ? "true" : "false");
        break;

      case LUA_TNUMBER:
        oss << lua_tonumber(l, i);
        break;

      case LUA_TLIGHTUSERDATA:
        oss << "lightuserdata:" << lua_touserdata(l, i);
        break;

      case LUA_TUSERDATA:
      {
        const ExportableToLuaPtr& userdata = *(static_cast<ExportableToLuaPtr*>(
            lua_touserdata(l, i)));
        const std::string& lua_type_name = userdata->get_lua_type_name();
        oss << lua_type_name.substr(lua_type_name.find_last_of('.') + 1);
        break;
      }

      default:
        oss << lua_typename(l, type);
        break;

    }
    oss << " ";
  }
  Logger::debug(oss.str());
}

/**
 * \brief Prints the version of Lua.
 *
 * This detects if LuaJIT is being used.
 */
void LuaContext::print_lua_version() {

  Debug::check_assertion(lua_gettop(current_l) == 0, "Non-empty Lua stack before print_lua_version()");

  // _VERSION is the Lua language version, giving the same
  // result for vanilla Lua and LuaJIT.
  // But we want to tell the user if LuaJIT is being used.
  // To detect this, we can check the presence of the jit table.
  std::string version;
                                  // -
  lua_getglobal(current_l, "jit");
                                  // jit/nil
  if (lua_isnil(current_l, -1)) {
    // Vanilla Lua.
                                  // nil
    lua_getglobal(current_l, "_VERSION");
                                  // nil version
    version = LuaTools::check_string(current_l, -1);
    lua_pop(current_l, 2);
                                  // -
    Logger::info("LuaJIT: no (" + version + ")");
  }
  else {
    // LuaJIT.
                                  // jit
    version = LuaTools::check_string_field(current_l, -1, "version");
    lua_pop(current_l, 1);
                                  // -
    Logger::info("LuaJIT: yes (" + version + ")");
  }

  Debug::check_assertion(lua_gettop(current_l) == 0, "Non-empty Lua stack after print_lua_version()");
}

/**
 * \brief Defines some C++ functions into a Lua table.
 * \param module_name name of the table that will contain the functions
 * (e.g. "sol.main").
 * \param functions List of functions to define in the table.
 */
void LuaContext::register_functions(
    const std::string& module_name,
    std::vector<luaL_Reg> functions
) {

  // Create a table and fill it with the functions.
  functions.push_back({ nullptr, nullptr });
  luaL_register(current_l, module_name.c_str(), functions.data());
  lua_pop(current_l, 1);
}

/**
 * \brief Defines some C++ functions into a new Lua userdata type.
 * \param module_name name of the table that will contain the functions
 * (e.g. "sol.game"). It may already exist or not.
 * This string will also identify the type.
 * \param functions List of functions to define in the module table.
 * \param methods List of methods to define in the type.
 * \param metamethods List of metamethods to define in the metatable of the
 * type.
 */
void LuaContext::register_type(
    const std::string& module_name,
    std::vector<luaL_Reg> functions,
    std::vector<luaL_Reg> methods,
    std::vector<luaL_Reg> metamethods
) {

  // Check that this type does not already exist.
  luaL_getmetatable(current_l, module_name.c_str());
  Debug::check_assertion(lua_isnil(current_l, -1),
      std::string("Type ") + module_name + " already exists");
  lua_pop(current_l, 1);

  // Make sure we create the table.
  const luaL_Reg empty[] = {
      { nullptr, nullptr }
  };
  luaL_register(current_l, module_name.c_str(), empty);
                                  // module

  // Add the functions to the module.
  if (!functions.empty()) {
    functions.push_back({ nullptr, nullptr});
    luaL_register(current_l, nullptr, functions.data());
                                  // module
  }
  lua_pop(current_l, 1);
                                  // --

  // Create the metatable for the type, add it to the Lua registry.
  luaL_newmetatable(current_l, module_name.c_str());
                                  // meta

  // Store a metafield __solarus_type with the module name.
  lua_pushstring(current_l, module_name.c_str());
                                  // meta type_name
  lua_setfield(current_l, -2, "__solarus_type");
                                  // meta

  // Add the methods to the metatable.
  if (!methods.empty()) {
    methods.push_back({ nullptr, nullptr });
    luaL_register(current_l, nullptr, methods.data());
  }
                                  // meta

  // Add the metamethods to the metatable.
  if (!metamethods.empty()) {
    metamethods.push_back({ nullptr, nullptr });
    luaL_register(current_l, nullptr, metamethods.data());
                                  // meta
  }

  // make metatable.__index = metatable,
  // unless if __index is already defined
  lua_getfield(current_l, -1, "__index");
                                  // meta __index/nil
  lua_pushvalue(current_l, -2);
                                  // meta __index/nil meta
  if (lua_isnil(current_l, -2)) {
                                  // meta nil meta
    lua_setfield(current_l, -3, "__index");
                                  // meta nil
  }
  lua_settop(current_l, 0);
                                  // --
}

/**
 * \brief Tells the Lua context what C++ functions it can call.
 */
void LuaContext::register_modules() {

  Debug::check_assertion(lua_gettop(current_l) == 0,
      "Lua stack is not empty before modules initialization");

  register_main_module();
  register_game_module();
  register_map_module();
  register_entity_module();
  register_audio_module();
  register_timer_module();
  register_surface_module();
  register_text_surface_module();
  register_sprite_module();
  register_movement_module();
  register_item_module();
  register_input_module();
  register_video_module();
  register_shader_module();
  register_file_module();
  register_menu_module();
  register_language_module();
  register_state_module();

  Debug::check_assertion(lua_gettop(current_l) == 0,
      "Lua stack is not empty after modules initialization");
}

/**
 * \brief Pushes a string.
 * \param l A Lua state.
 * \param text A string value.
 */
void LuaContext::push_string(lua_State* l, const std::string& text) {
  lua_pushlstring(l, text.c_str(), text.size());
}

/**
 * \brief Pushes a color onto the stack.
 * \param l A Lua context.
 * \param color A color.
 */
void LuaContext::push_color(lua_State* l, const Color& color) {

  uint8_t r, g, b, a;
  color.get_components(r, g, b, a);
  lua_newtable(l);
  lua_pushinteger(l, r);
  lua_rawseti(l, -2, 1);
  lua_pushinteger(l, g);
  lua_rawseti(l, -2, 2);
  lua_pushinteger(l, b);
  lua_rawseti(l, -2, 3);
  lua_pushinteger(l, a);
  lua_rawseti(l, -2, 4);
}

/**
 * \brief Pushes the Lua equivalent of a C++ object onto the stack.
 * \param l A Lua context.
 * \param userdata A userdata. It must live as a std::shared_ptr somewhere:
 * typically, it should have been stored in a std::shared_ptr at creation time.
 */
void LuaContext::push_userdata(lua_State* l, ExportableToLua& userdata) {

  // See if this userdata already exists.
  //Look in main for the userdata table entry
  lua_State* main = lua_context->main_l;
  lua_getfield(main, LUA_REGISTRYINDEX, "sol.all_userdata");
                                  // ... all_udata
  lua_pushlightuserdata(main, &userdata);
                                  // ... all_udata lightudata
  lua_gettable(main, -2);
                                  // ... all_udata udata/nil
  if (!lua_isnil(main, -1)) {
                                  // ... all_udata udata
    // The userdata already exists in the Lua world.
    lua_remove(main, -2);
                                  // ... udata
  }
  else {
    // Create a new userdata.

    if (!userdata.is_known_to_lua()) {
      // This is the first time we create a Lua userdata for this object.
      userdata.set_known_to_lua(true);
      userdata.set_lua_context(&get());
    }

                                  // ... all_udata nil
    lua_pop(main, 1);
                                  // ... all_udata
    lua_pushlightuserdata(main, &userdata);
                                  // ... all_udata lightudata

    // Find the existing shared_ptr from the raw pointer.
    ExportableToLuaPtr shared_userdata;
    try {
      shared_userdata = userdata.shared_from_this();
    }
    catch (const std::bad_weak_ptr& ex) {
      // No existing shared_ptr. This is probably because you forgot to
      // store your object in a shared_ptr at creation time.
      Debug::die(
          std::string("No living shared_ptr for ") + userdata.get_lua_type_name()
      );
    }

    ExportableToLuaPtr* block_address = static_cast<ExportableToLuaPtr*>(
          lua_newuserdata(main, sizeof(ExportableToLuaPtr))
    );
    // Manually construct a shared_ptr in the block allocated by Lua.
    new (block_address) ExportableToLuaPtr(shared_userdata);
                                  // ... all_udata lightudata udata
    luaL_getmetatable(main, userdata.get_lua_type_name().c_str());
                                  // ... all_udata lightudata udata mt

    Debug::execute_if_debug([&] {
      Debug::check_assertion(!lua_isnil(main, -1),
          std::string("Userdata of type '" + userdata.get_lua_type_name()
          + "' has no metatable, this is a memory leak"));

      lua_getfield(main, -1, "__gc");
                                    // ... all_udata lightudata udata mt gc
      Debug::check_assertion(lua_isfunction(main, -1),
          std::string("Userdata of type '") + userdata.get_lua_type_name()
          + "' must have the __gc function LuaContext::userdata_meta_gc");
                                    // ... all_udata lightudata udata mt gc
      lua_pop(main, 1);
                                    // ... all_udata lightudata udata mt
    });

    lua_setmetatable(main, -2);
                                  // ... all_udata lightudata udata
    // Keep track of our new userdata.
    lua_pushvalue(main, -1);
                                  // ... all_udata lightudata udata udata
    lua_insert(main, -4);
                                  // ... udata all_udata lightudata udata
    lua_settable(main, -3);
                                  // ... udata all_udata
    lua_pop(main, 1);
                                  // ... udata
  }

  //Check if target stack is different from main...
  if(l != main) {
    //Move ref to target stack
    lua_xmove(main,l,1);
  }
}

/**
 * \brief Get pointer to userdata if it is of the given type.
 *
 * This is luaL_testudata from the Lua auxiliary library.
 * It should be replaced when Lua 5.3/LuaJIT 2.1 or higher is required.
 *
 * \param l A Lua context.
 * \param index An index in the stack.
 * \param module_name Name of a userdata metatable in the registry.
 * \return Pointer to userdata if it is a userdata of the given type,
 *   nullptr otherwise.
 */
void* LuaContext::test_userdata(
    lua_State* l, int index, const char* module_name) {

  index = LuaTools::get_positive_index(l, index);

  void* udata = lua_touserdata(l, index);
  if (udata == nullptr || !lua_getmetatable(l, index)) {
    return nullptr;
  }
  // ... udata ... meta(found)
  lua_getfield(l, LUA_REGISTRYINDEX, module_name);
  // ... udata ... meta(found) meta(expected)
  if (lua_rawequal(l, -1, -2) == 0) {
    udata = nullptr;
  }
  lua_pop(l, 2);
  // ... udata ...
  return udata;
}

/**
 * \brief Returns whether a value is a userdata of a given type.
 * \param l a Lua context
 * \param index an index in the stack
 * \param module_name name of a userdata metatable in the registry
 * \return true if the value is a userdata with this metatable
 */
bool LuaContext::is_userdata(lua_State* l, int index,
    const std::string& module_name) {

  void* udata = test_userdata(l, index, module_name.c_str());
  return (udata != nullptr);
}

/**
 * \brief Checks that the value at the given index is userdata of the
 * specified type and returns it.
 * \param l A Lua state.
 * \param index An index in the Lua stack.
 * \param module_name Name identifying the userdata type.
 * \return The userdata at this index.
 */
const ExportableToLuaPtr& LuaContext::check_userdata(
    lua_State* l,
    int index,
    const std::string& module_name
) {

  void* udata = test_userdata(l, index, module_name.c_str());
  if (udata == nullptr) {
    LuaTools::type_error(l, index, LuaTools::get_type_name(module_name));
  }
  return *static_cast<ExportableToLuaPtr*>(udata);
}

/**
 * \brief Returns whether a value is a userdata from Solarus.
 * \param[in] l A Lua context.
 * \param[in] index An index in the stack.
 * \param[out] module_name Name of the userdata metatable in the registry,
 * if found.
 * \return \c true if the value is a userdata from Solarus.
 */
bool LuaContext::is_solarus_userdata(
    lua_State* l,
    int index,
    std::string& module_name
) {
  void* udata = lua_touserdata(l, index);
  if (udata == nullptr) {
    // This is not a userdata.
    return false;
  }

  if (!lua_getmetatable(l, index)) {
    // The userdata has no metatable.
    return false;
  }

  // Get the name of the Solarus type from this userdata.
  lua_pushstring(l, "__solarus_type");
  lua_rawget(l, -2);
  if (!lua_isstring(l, -1)) {
    // This is probably a userdata from some library other than Solarus.
    lua_pop(l, 2);
    return false;
  }

  // Check if the type name is one of the entity type names.
  module_name = lua_tostring(l, -1);
  if (module_name.substr(0, 4) != "sol.") {
    return false;
  }

  return true;
}

/**
 * \brief Finalizer of a userdata type.
 * \param l A Lua state.
 * \return Number of values to return to Lua.
 */
int LuaContext::userdata_meta_gc(lua_State* l) {

  ExportableToLuaPtr* userdata =
      static_cast<ExportableToLuaPtr*>(lua_touserdata(l, 1));

  // Note that the full userdata disappears from Lua but it may come back later!
  // So we need to keep its table if the refcount is not zero.
  // The full userdata is destroyed but the light userdata and its table persist.
  // Its table will be destroyed from ~ExportableToLua().

  // We don't need to remove the entry from sol.all_userdata
  // because it is already done: that table is weak on its values and the
  // value was the full userdata.

  // Manually destroy the shared_ptr allocated for Lua.
  userdata->~shared_ptr<ExportableToLua>();

  return 0;
}

/**
 * \brief Function called when a userdata is being destroyed from C++.
 *
 * It means that it is no longer used from Lua either
 * (__gc has been called before or is being called).
 *
 * \param userdata The userdata just destroyed.
 */
void LuaContext::notify_userdata_destroyed(ExportableToLua& userdata) {

  if (userdata.is_with_lua_table()) {
    // Remove the table associated to this userdata.
    // Otherwise, if the same pointer gets reallocated, a new userdata will get
    // its table from this deleted one!

                                  // ...
    lua_getfield(current_l, LUA_REGISTRYINDEX, "sol.userdata_tables");
                                  // ... udata_tables/nil
    if (!lua_isnil(current_l, -1)) {
                                  // ... udata_tables
      lua_pushlightuserdata(current_l, &userdata);
                                  // ... udata_tables lightudata
      lua_pushnil(current_l);
                                  // ... udata_tables lightudata nil
      lua_settable(current_l, -3);
                                  // ... udata_tables
    }
    lua_pop(current_l, 1);
                                  // ...
    get().userdata_fields.erase(&userdata);
  }
}

/**
 * \brief Tells all userdata that Lua is closing.
 *
 * This must be done when Lua is about to be closed,
 * so that they can continue to live normally in C++.
 */
void LuaContext::userdata_close_lua() {

  // Tell userdata to forget about this Lua state.
  lua_getfield(current_l, LUA_REGISTRYINDEX, "sol.all_userdata");
  lua_pushnil(current_l);
  while (lua_next(current_l, -2) != 0) {
    ExportableToLua* userdata = static_cast<ExportableToLua*>(
        lua_touserdata(current_l, -2));
    userdata->set_lua_context(nullptr);
    lua_pop(current_l, 1);
  }
  lua_pop(current_l, 1);
  userdata_fields.clear();

  // Clear userdata tables.
  lua_pushnil(current_l);
  lua_setfield(current_l, LUA_REGISTRYINDEX, "sol.userdata_tables");
}

/**
 * \brief Implementation of __newindex that allows userdata to be like tables.
 *
 * Lua code can make "object[key] = value" if object is a userdata with this
 * __newindex metamethod.
 *
 * This metamethod must be used with its corresponding __index
 * metamethod (see userdata_meta_index_as_table).
 *
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::userdata_meta_newindex_as_table(lua_State* l) {

  LuaTools::check_type(l, 1, LUA_TUSERDATA);
  LuaTools::check_any(l, 2);
  LuaTools::check_any(l, 3);

  const ExportableToLuaPtr& userdata =
      *(static_cast<ExportableToLuaPtr*>(lua_touserdata(l, 1)));

  // The user wants to make udata[key] = value but udata is a userdata.
  // So what we make instead is udata_tables[udata][key] = value.
  // This redirection is totally transparent from the Lua side.

  lua_getfield(l, LUA_REGISTRYINDEX, "sol.userdata_tables");
                                  // ... udata_tables

  if (!userdata->is_with_lua_table()) {
    // Create the userdata table if it does not exist yet.

    userdata->set_with_lua_table(true);
                                  // ... udata_tables
    lua_newtable(l);
                                  // ... udata_tables udata_table
    lua_pushlightuserdata(l, userdata.get());
                                  // ... udata_tables udata_table lightudata
    lua_pushvalue(l, -2);
                                  // ... udata_tables udata_table lightudata udata_table
    lua_settable(l, -4);
                                  // ... udata_tables udata_table
  }
  else {
    // The userdata table already exists.
    lua_pushlightuserdata(l, userdata.get());
                                  // ... udata_tables lightudata
    lua_gettable(l, -2);
                                  // ... udata_tables udata_table
  }
  Debug::check_assertion(!lua_isnil(l, -1), "Missing userdata table");
  lua_pushvalue(l, 2);
                                  // ... udata_tables udata_table key
  lua_pushvalue(l, 3);
                                  // ... udata_tables udata_table key value
  lua_settable(l, -3);
                                  // ... udata_tables udata_table

  if (lua_isstring(l, 2)) {
    if (!lua_isnil(l, 3)) {
      // Add the key to the list of existing strings keys on this userdata.
      get().userdata_fields[userdata.get()].insert(lua_tostring(l, 2));
    }
    else {
      // Assigning nil: remove the key from the list.
      get().userdata_fields[userdata.get()].erase(lua_tostring(l, 2));
    }
  }

  return 0;
}

/**
 * \brief Implementation of __index that allows userdata to be like tables.
 *
 * Lua code can get "object[key]" for an arbitrary key previously set.
 *
 * This metamethod must be used with its corresponding __newindex
 * metamethod (see userdata_meta_newindex_as_table).
 *
 * \brief Implementation of __index for the type game.
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::userdata_meta_index_as_table(lua_State* l) {

  /* The user wants to make udata[key] but udata is a userdata.
   * So what we retrieve instead is udata_tables[udata][key].
   * This redirection is totally transparent from the Lua side.
   * If udata_tables[udata][key] does not exist, we fall back
   * to the userdata __index metamethod.
   */

  LuaTools::check_type(l, 1, LUA_TUSERDATA);
  LuaTools::check_any(l, 2);

  const ExportableToLuaPtr& userdata =
      *(static_cast<ExportableToLuaPtr*>(lua_touserdata(l, 1)));
  LuaContext& lua_context = get();

  // If the userdata actually has a table, lookup this table, unless we already
  // know that we won't find it (because we know all the existing string keys).
  if (userdata->is_with_lua_table() &&
      (!lua_isstring(l, 2) || lua_context.userdata_has_field(*userdata, lua_tostring(l, 2)))) {

    lua_getfield(l, LUA_REGISTRYINDEX, "sol.userdata_tables");
                                  // ... udata_tables
    lua_pushlightuserdata(l, userdata.get());
                                  // ... udata_tables lightudata
    // Lookup the key in the table, without metamethods.
    lua_rawget(l, -2);
                                  // ... udata_tables udata_table/nil
    if (!lua_isnil(l, -1)) {
      lua_pushvalue(l, 2);
                                  // ... udata_tables udata_table key
      lua_gettable(l, -2);
                                  // ... udata_tables udata_table value/nil
      if (!lua_isnil(l, -1)) {
        // Found it!
        return 1;
      }
    }
  }

  // Not in the table. See in the metatable
  // (just like when metatable.__index = metatable).

  lua_pushvalue(l, 1);
                                  // ... udata
  lua_getmetatable(l, -1);
                                  // ... udata meta
  Debug::check_assertion(!lua_isnil(l, -1), "Missing userdata metatable");
  lua_pushvalue(l, 2);
                                  // ... udata meta key
  lua_gettable(l, -2);
                                  // ... udata meta key value/nil
  return 1;
}

/**
 * @brief checks if the LuaContext is in a event-friendly context
 */
void LuaContext::check_callback_thread() const {
  Debug::check_assertion(current_l == main_l, "Events should be called in the main Lua thread");
}

/**
 * \brief Calls the on_started() method of the object on top of the stack.
 */
void LuaContext::on_started() {
  check_callback_thread();
  if (find_method("on_started")) {
    call_function(1, 0, "on_started");
  }
}

/**
 * \brief Calls the on_started() method of the object on top of the stack.
 * \param previous_state_name Name of the previous state.
 * \param previous_state The previous state object if it was a custom one.
 */
void LuaContext::on_started(
    const std::string& previous_state_name,
    CustomState* previous_state) {
  check_callback_thread();
  if (find_method("on_started")) {
    push_string(current_l, previous_state_name);
    if (previous_state == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_state(current_l, *previous_state);
    }
    call_function(3, 0, "on_started");
  }
}

/**
 * \brief Calls the on_finished() method of the object on top of the stack.
 */
void LuaContext::on_finished() {
  check_callback_thread();
  if (find_method("on_finished")) {
    call_function(1, 0, "on_finished");
  }
}

/**
 * \brief Calls the on_finished() method of the object on top of the stack.
 * \param next_state_name Name of the previous state.
 * \param next_state The previous state object if it was a custom one.
 */
void LuaContext::on_finished(
    const std::string& next_state_name,
    CustomState* next_state) {
  check_callback_thread();
  if (find_method("on_finished")) {
    push_string(current_l, next_state_name);
    if (next_state == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_state(current_l, *next_state);
    }
    call_function(3, 0, "on_finished");
  }
}

/**
 * \brief Calls the on_update() method of the object on top of the stack.
 */
void LuaContext::on_update() {
  check_callback_thread();
  if (find_method("on_update")) {
    call_function(1, 0, "on_update");
  }
}

/**
 * \brief Calls the on_draw() method of the object on top of the stack.
 * \param dst_surface The destination surface.
 */
void LuaContext::on_draw(const SurfacePtr& dst_surface) {
  check_callback_thread();
  if (find_method("on_draw")) {
    push_surface(current_l, *dst_surface);
    call_function(2, 0, "on_draw");
  }
}

/**
 * \brief Calls the on_suspended() method of the object on top of the stack.
 * \param suspended true to suspend the object, false to unsuspend it.
 */
void LuaContext::on_suspended(bool suspended) {
  check_callback_thread();
  if (find_method("on_suspended")) {
    lua_pushboolean(current_l, suspended);
    call_function(2, 0, "on_suspended");
  }
}

/**
 * \brief Calls the on_paused() method of the object on top of the stack.
 */
void LuaContext::on_paused() {
  check_callback_thread();
  if (find_method("on_paused")) {
    call_function(1, 0, "on_paused");
  }
}

/**
 * \brief Calls the on_unpaused() method of the object on top of the stack.
 */
void LuaContext::on_unpaused() {
  check_callback_thread();
  if (find_method("on_unpaused")) {
    call_function(1, 0, "on_unpaused");
  }
}

/**
 * \brief Calls the on_dialog_started() method of the object on top of the
 * stack.
 * \param dialog The dialog that just started.
 * \param info_ref Lua ref to the info parameter to pass to the method,
 * or an empty ref.
 * \return true if the on_dialog_started() method is defined.
 */
bool LuaContext::on_dialog_started(
    const Dialog& dialog,
    const ScopedLuaRef& info_ref
) {
  check_callback_thread();
  if (find_method("on_dialog_started")) {
    push_dialog(current_l, dialog);
    push_ref(current_l, info_ref);
    call_function(3, 0, "on_dialog_started");
    return true;
  }
  return false;
}

/**
 * \brief Calls the on_dialog_finished() method of the object on top of the stack.
 * \param dialog The dialog that has just finished.
 */
void LuaContext::on_dialog_finished(const Dialog& dialog) {
  check_callback_thread();
  if (find_method("on_dialog_finished")) {
    push_dialog(current_l, dialog);
    call_function(2, 0, "on_dialog_finished");
  }
}

/**
 * \brief Calls the on_game_over_started() method of the object on top of the stack.
 */
bool LuaContext::on_game_over_started() {
  check_callback_thread();
  if (find_method("on_game_over_started")) {
    call_function(1, 0, "on_game_over_started");
    return true;
  }
  return false;
}

/**
 * \brief Calls the on_game_over_finished() method of the object on top of the stack.
 */
void LuaContext::on_game_over_finished() {
  check_callback_thread();
  if (find_method("on_game_over_finished")) {
    call_function(1, 0, "on_game_over_finished");
  }
}

/**
 * \brief Calls an input callback method of the object on top of the stack.
 * \param event The input event to forward.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_input(const InputEvent& event) {
  check_callback_thread();
  // Call the Lua function(s) corresponding to this input event.
  bool handled = false;
  if (event.is_keyboard_event()) {
    // Keyboard.
    printf("LuaContext::on_input::event.is_keyboard_event\n");
    if (event.is_keyboard_key_pressed()) {
      printf("LuaContext::on_input::event.is_keyboard_key_pressed\n");
      handled = on_key_pressed(event) || handled;
    }
    else if (event.is_keyboard_key_released()) {
      handled = on_key_released(event) || handled;
    }
  }
  else if (event.is_character_pressed()) {
    handled = on_character_pressed(event) || handled;
  }
  else if (event.is_joypad_event()) {
    // Joypad.
    if (event.is_joypad_button_pressed()) {
      handled = on_joypad_button_pressed(event) || handled;
    }
    else if (event.is_joypad_button_released()) {
      handled = on_joypad_button_released(event) || handled;
    }
    else if (event.is_joypad_axis_moved()) {
      handled = on_joypad_axis_moved(event) || handled;
    }
    else if (event.is_joypad_hat_moved()) {
      handled = on_joypad_hat_moved(event) || handled;
    }
  }
  else if (event.is_mouse_event()) {
    // Mouse.
    if (event.is_mouse_button_pressed()) {
      handled = on_mouse_button_pressed(event) || handled;
    }
    else if (event.is_mouse_button_released()) {
      handled = on_mouse_button_released(event) || handled;
    }
  }
  else if (event.is_finger_event() &&
           CurrentQuest::is_format_at_least({ 1, 6 })) {
    // Touch finger.
    if (event.is_finger_pressed()) {
      handled = on_finger_pressed(event) || handled;
    }
    else if (event.is_finger_released()) {
      handled = on_finger_released(event) || handled;
    }
    else if (event.is_finger_moved()) {
        handled = on_finger_moved(event) || handled;
    }
  }

  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a keyboard key was just pressed
 * (including if it is a directional key or a character).
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_key_pressed(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  printf("on key pressed\n");
  if (find_method("on_key_pressed")) {

    printf("on key pressed found\n");
    const std::string& key_name = enum_to_name(event.get_keyboard_key());
    printf("key name=%s\n", key_name.c_str());
    if (!key_name.empty()) { // This key exists in the Solarus API.

      push_string(current_l, key_name);
      lua_newtable(current_l);

      if (event.is_with_shift()) {
        lua_pushboolean(current_l, 1);
        lua_setfield(current_l, -2, "shift");
      }

      if (event.is_with_control()) {
        lua_pushboolean(current_l, 1);
        lua_setfield(current_l, -2, "control");
      }

      if (event.is_with_alt()) {
        lua_pushboolean(current_l, 1);
        lua_setfield(current_l, -2, "alt");
      }
      bool success = call_function(3, 1, "on_key_pressed");
      if (!success) {
        // Something was wrong in the script: don't propagate the input to other objects.
        handled = true;
      }
      else {
        handled = lua_toboolean(current_l, -1);
        lua_pop(current_l, 1);
      }
    }
    else {
      // The method exists but the key is unknown.
      lua_pop(current_l, 2);  // Pop the object and the method.
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a character was just pressed with the keyboard.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_character_pressed(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_character_pressed")) {

    const std::string& character = event.get_character();
    push_string(current_l, character);
    bool success = call_function(2, 1, "on_character_pressed");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a keyboard key was just released
 * (including if it is a directional key).
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_key_released(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_key_released")) {

    const std::string& key_name = enum_to_name(event.get_keyboard_key());
    if (!key_name.empty()) { // This key exists in the Solarus API.
      push_string(current_l, key_name);
      bool success = call_function(2, 1, "on_key_released");
      if (!success) {
        // Something was wrong in the script: don't propagate the input to other objects.
        handled = true;
      }
      else {
        handled = lua_toboolean(current_l, -1);
        lua_pop(current_l, 1);
      }
    }
    else {
      // The method exists but the key is unknown.
      lua_pop(current_l, 2);  // Pop the object and the method.
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a joypad button was just pressed.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_joypad_button_pressed(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_joypad_button_pressed")) {
    int button = event.get_joypad_button();

    lua_pushinteger(current_l, button);
    bool success = call_function(2, 1, "on_joypad_button_pressed");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a joypad button was just released.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_joypad_button_released(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_joypad_button_released")) {
    int button = event.get_joypad_button();

    lua_pushinteger(current_l, button);
    bool success = call_function(2, 1, "on_joypad_button_released");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a joypad axis was just moved.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_joypad_axis_moved(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_joypad_axis_moved")) {
    int axis = event.get_joypad_axis();
    int state = event.get_joypad_axis_state();

    lua_pushinteger(current_l, axis);
    lua_pushinteger(current_l, state);
    bool success = call_function(3, 1, "on_joypad_axis_moved");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a joypad hat was just moved.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_joypad_hat_moved(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_joypad_hat_moved")) {
    int hat = event.get_joypad_hat();
    int direction8 = event.get_joypad_hat_direction();

    lua_pushinteger(current_l, hat);
    lua_pushinteger(current_l, direction8);
    bool success = call_function(3, 1, "on_joypad_hat_moved");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a mouse button was just pressed.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_mouse_button_pressed(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_mouse_pressed")) {

    const std::string& button_name = enum_to_name(event.get_mouse_button());
    const Point mouse_xy = event.get_mouse_position();

    // Don't call the Lua event if this button doesn't exist in the Solarus API.
    if (button_name.empty()) {
      lua_pop(current_l, 2);  // Pop the object and the method.
      return handled;
    }

    push_string(current_l, button_name);
    lua_pushinteger(current_l, mouse_xy.x);
    lua_pushinteger(current_l, mouse_xy.y);

    bool success = call_function(4, 1, "on_mouse_pressed");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a mouse button was just released.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_mouse_button_released(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_mouse_released")) {

    const std::string& button_name = enum_to_name(event.get_mouse_button());
    Point mouse_xy = event.get_mouse_position();

    // Don't call the Lua event if this button doesn't exist in the Solarus API.
    if (button_name.empty()) {
      lua_pop(current_l, 2);  // Pop the object and the method.
      return handled;
    }

    push_string(current_l, button_name);
    lua_pushinteger(current_l, mouse_xy.x);
    lua_pushinteger(current_l, mouse_xy.y);

    bool success = call_function(4, 1, "on_mouse_released");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a finger was just pressed.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_finger_pressed(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_finger_pressed")) {

    const int finger_id = event.get_finger();
    const Point& finger_xy = event.get_finger_position();
    const float finger_pressure = event.get_finger_pressure();

    lua_pushinteger(current_l, finger_id);
    lua_pushinteger(current_l, finger_xy.x);
    lua_pushinteger(current_l, finger_xy.y);
    lua_pushnumber(current_l, finger_pressure);

    bool success = call_function(5, 1, "on_finger_pressed");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a finger was just released.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_finger_released(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_finger_released")) {

    const int finger_id = event.get_finger();
    const Point& finger_xy = event.get_finger_position();
    const float finger_pressure = event.get_finger_pressure();

    lua_pushinteger(current_l, finger_id);
    lua_pushinteger(current_l, finger_xy.x);
    lua_pushinteger(current_l, finger_xy.y);
    lua_pushnumber(current_l, finger_pressure);

    bool success = call_function(5, 1, "on_finger_released");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Notifies the object on top of the stack
 * that a finger was just moved.
 * \param event The corresponding input event.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::on_finger_moved(const InputEvent& event) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_finger_moved")) {

    const int finger_id = event.get_finger();
    const Point& finger_xy = event.get_finger_position();
    const Point& finger_distance = event.get_finger_distance();
    const float finger_pressure = event.get_finger_pressure();

    lua_pushinteger(current_l, finger_id);
    lua_pushinteger(current_l, finger_xy.x);
    lua_pushinteger(current_l, finger_xy.y);
    lua_pushinteger(current_l, finger_distance.x);
    lua_pushinteger(current_l, finger_distance.y);
    lua_pushnumber(current_l, finger_pressure);

    bool success = call_function(7, 1, "on_finger_moved");
    if (!success) {
      // Something was wrong in the script: don't propagate the input to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Calls the on_command_pressed() method of the object on top of the stack.
 * \param command The game command just pressed.
 */
bool LuaContext::on_command_pressed(GameCommand command) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_command_pressed")) {
    push_string(current_l, GameCommands::get_command_name(command));
    bool success = call_function(2, 1, "on_command_pressed");
    if (!success) {
      // Something was wrong in the script: don't propagate the command to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Calls the on_command_released() method of the object on top of the stack.
 * \param command The game command just pressed.
 */
bool LuaContext::on_command_released(GameCommand command) {
  check_callback_thread();
  bool handled = false;
  if (find_method("on_command_released")) {
    push_string(current_l, GameCommands::get_command_name(command));
    bool success = call_function(2, 1, "on_command_released");
    if (!success) {
      // Something was wrong in the script: don't propagate the command to other objects.
      handled = true;
    }
    else {
      handled = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return handled;
}

/**
 * \brief Calls the on_animation_finished() method of the object on top of the stack.
 * \param animation Name of the animation finished.
 */
void LuaContext::on_animation_finished(const std::string& animation) {
  check_callback_thread();
  if (find_method("on_animation_finished")) {
    push_string(current_l, animation);
    call_function(2, 0, "on_animation_finished");
  }
}

/**
 * \brief Calls the on_animation_changed() method of the object on top of the stack.
 * \param animation Name of the new animation.
 */
void LuaContext::on_animation_changed(const std::string& animation) {
  check_callback_thread();
  if (find_method("on_animation_changed")) {
    push_string(current_l, animation);
    call_function(2, 0, "on_animation_changed");
  }
}

/**
 * \brief Calls the on_direction_changed() method of the object on top of the stack.
 * \param animation Name of the sprite animation.
 * \param frame The new frame.
 */
void LuaContext::on_direction_changed(
    const std::string& animation, int direction) {
  check_callback_thread();
  if (find_method("on_direction_changed")) {
    push_string(current_l, animation);
    lua_pushinteger(current_l, direction);
    call_function(3, 0, "on_direction_changed");
  }
}

/**
 * \brief Calls the on_frame_changed() method of the object on top of the stack.
 * \param animation Name of the sprite animation.
 * \param frame The new frame.
 */
void LuaContext::on_frame_changed(const std::string& animation, int frame) {
  check_callback_thread();
  if (find_method("on_frame_changed")) {
    push_string(current_l, animation);
    lua_pushinteger(current_l, frame);
    call_function(3, 0, "on_frame_changed");
  }
}

/**
 * \brief Calls the on_position_changed() method of the object on top of the stack.
 * \param xy The new coordinates.
 */
void LuaContext::on_position_changed(const Point& xy) {
  check_callback_thread();
  if (find_method("on_position_changed")) {
    lua_pushinteger(current_l, xy.x);
    lua_pushinteger(current_l, xy.y);
    call_function(3, 0, "on_position_changed");
  }
}

/**
 * \brief Calls the on_obstacle_reached() method of the object on top of the stack.
 */
void LuaContext::on_obstacle_reached() {
  check_callback_thread();
  if (find_method("on_obstacle_reached")) {
    call_function(1, 0, "on_obstacle_reached");
  }
}

/**
 * \brief Calls the on_changed() method of the object on top of the stack.
 */
void LuaContext::on_changed() {
  check_callback_thread();
  if (find_method("on_changed")) {
    call_function(1, 0, "on_changed");
  }
}

/**
 * \brief Calls the on_started() method of the object on top of the stack.
 * \param destination The destination point used (nullptr if it is a special one).
 */
void LuaContext::on_started(const std::shared_ptr<Destination>& destination) {
  check_callback_thread();
  if (find_method("on_started")) {
    if (destination == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_entity(current_l, *destination);
    }
    call_function(2, 0, "on_started");
  }
}

/**
 * \brief Calls the on_opening_transition_finished() method of the object on top of the stack.
 * \param destination The destination point used (nullptr if it is a special one).
 */
void LuaContext::on_opening_transition_finished(const std::shared_ptr<Destination>& destination) {
  check_callback_thread();
  if (find_method("on_opening_transition_finished")) {
    if (destination == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_entity(current_l, *destination);
    }
    call_function(2, 0, "on_opening_transition_finished");
  }
}

/**
 * \brief Calls the on_obtaining_treasure() method of the object on top of the stack.
 * \param treasure The treasure being obtained.
 */
void LuaContext::on_obtaining_treasure(const Treasure& treasure) {
  check_callback_thread();
  if (find_method("on_obtaining_treasure")) {
    push_item(current_l, treasure.get_item());
    lua_pushinteger(current_l, treasure.get_variant());
    if (!treasure.is_saved()) {
      lua_pushnil(current_l);
    }
    else {
      lua_pushstring(current_l, treasure.get_savegame_variable().c_str());
    }
    call_function(4, 0, "on_obtaining_treasure");
  }
}

/**
 * \brief Calls the on_obtained_treasure() method of the object on top of the stack.
 * \param treasure The treasure just obtained.
 */
void LuaContext::on_obtained_treasure(const Treasure& treasure) {
  check_callback_thread();
  if (find_method("on_obtained_treasure")) {
    push_item(current_l, treasure.get_item());
    lua_pushinteger(current_l, treasure.get_variant());
    if (!treasure.is_saved()) {
      lua_pushnil(current_l);
    }
    else {
      lua_pushstring(current_l, treasure.get_savegame_variable().c_str());
    }
    call_function(4, 0, "on_obtained_treasure");
  }
}

/**
 * \brief Calls the on_state_changing() method of the object on top of the stack.
 * \param state_name Name of the current state.
 * \param next_state_name Name of the state about to start.
 */
void LuaContext::on_state_changing(const std::string& state_name, const std::string& next_state_name) {
  check_callback_thread();
  if (find_method("on_state_changing")) {
    push_string(current_l, state_name);
    push_string(current_l, next_state_name);
    call_function(3, 0, "on_state_changing");
  }
}

/**
 * \brief Calls the on_state_changed() method of the object on top of the stack.
 * \param new_state_name Name of the new state.
 */
void LuaContext::on_state_changed(const std::string& new_state_name) {
  check_callback_thread();
  if (find_method("on_state_changed")) {
    push_string(current_l, new_state_name);
    call_function(2, 0, "on_state_changed");
  }
}

/**
 * \brief Calls the on_taking_damage() method of the object on top of the stack.
 * \param damage The damage to take.
 */
bool LuaContext::on_taking_damage(int damage) {
  check_callback_thread();
  if (find_method("on_taking_damage")) {
    lua_pushinteger(current_l, damage);
    call_function(2, 0, "on_taking_damage");
    return true;
  }
  return false;
}

/**
 * \brief Calls the on_activating() method of the object on top of the stack.
 */
void LuaContext::on_activating() {
  check_callback_thread();
  if (find_method("on_activating")) {
    call_function(1, 0, "on_activating");
  }
}

/**
 * \brief Calls the on_activating() method of the object on top of the stack.
 * \param direction Direction to pass as parameter.
 */
void LuaContext::on_activating(int direction) {
  check_callback_thread();
  if (find_method("on_activating")) {
    lua_pushinteger(current_l, direction);
    call_function(2, 0, "on_activating");
  }
}

/**
 * \brief Calls the on_activated() method of the object on top of the stack.
 */
void LuaContext::on_activated() {
  check_callback_thread();
  if (find_method("on_activated")) {
    call_function(1, 0, "on_activated");
  }
}

/**
 * \brief Calls the on_activated() method of the object on top of the stack.
 * \param direction Direction to pass as parameter.
 */
void LuaContext::on_activated(int direction) {
  check_callback_thread();
  if (find_method("on_activated")) {
    lua_pushinteger(current_l, direction);
    call_function(2, 0, "on_activated");
  }
}

/**
 * \brief Calls the on_inactivated_repeat() method of the object on top of the stack.
 */
void LuaContext::on_activated_repeat() {
  check_callback_thread();
  if (find_method("on_activated_repeat")) {
    call_function(1, 0, "on_activated_repeat");
  }
}

/**
 * \brief Calls the on_inactivated() method of the object on top of the stack.
 */
void LuaContext::on_inactivated() {
  check_callback_thread();
  if (find_method("on_inactivated")) {
    call_function(1, 0, "on_inactivated");
  }
}

/**
 * \brief Calls the on_left() method of the object on top of the stack.
 */
void LuaContext::on_left() {
  check_callback_thread();
  if (find_method("on_left")) {
    call_function(1, 0, "on_left");
  }
}

/**
 * \brief Calls the on_npc_interaction() method of the object on top of the stack.
 * \param npc An NPC.
 */
void LuaContext::on_npc_interaction(Npc& npc) {
  check_callback_thread();
  if (find_method("on_npc_interaction")) {
    push_npc(current_l, npc);
    call_function(2, 0, "on_npc_interaction");
  }
}

/**
 * \brief Calls the on_npc_interaction_item() method of the object on top of the stack.
 * \param npc An NPC.
 * \param item_used The equipment item used.
 * \return true if an interaction occurred.
 */
bool LuaContext::on_npc_interaction_item(Npc& npc, EquipmentItem& item_used) {
  check_callback_thread();
  bool interacted = false;
  if (find_method("on_npc_interaction_item")) {
    push_npc(current_l, npc);
    push_item(current_l, item_used);
    bool success = call_function(3, 1, "on_npc_interaction_item");
    if (!success) {
      // Something was wrong in the script: don't propagate the event to other objects.
      interacted = true;
    }
    else {
      interacted = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return interacted;
}

/**
 * \brief Calls the on_interaction() method of the object on top of the stack.
 * \return true if an interaction occurred.
 */
bool LuaContext::on_interaction() {
  check_callback_thread();
  if (find_method("on_interaction")) {
    call_function(1, 0, "on_interaction");
    return true;
  }

  return false;
}

/**
 * \brief Calls the on_interaction_item() method of the object on top of the stack.
 * \param item_used The equipment item used.
 * \return true if an interaction occurred.
 */
bool LuaContext::on_interaction_item(EquipmentItem& item) {
  check_callback_thread();
  bool interacted = false;
  if (find_method("on_interaction_item")) {
    push_item(current_l, item);
    bool success = call_function(2, 1, "on_interaction_item");
    if (!success) {
      // Something was wrong in the script: don't propagate the event to other objects.
      interacted = true;
    }
    else {
      interacted = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return interacted;
}

/**
 * \brief Calls the on_npc_collision_fire() method of the object on top of the stack.
 * \param npc An NPC.
 */
void LuaContext::on_npc_collision_fire(Npc& npc) {
  check_callback_thread();
  if (find_method("on_npc_collision_fire")) {
    push_npc(current_l, npc);
    call_function(2, 0, "on_npc_collision_fire");
  }
}

/**
 * \brief Calls the on_collision_fire() method of the object on top of the stack.
 */
void LuaContext::on_collision_fire() {
  check_callback_thread();
  if (find_method("on_collision_fire")) {
    call_function(1, 0, "on_collision_fire");
  }
}

/**
 * \brief Calls the on_collision_explosion() method of the object on top of the stack.
 */
void LuaContext::on_collision_explosion() {
  check_callback_thread();
  if (find_method("on_collision_explosion")) {
    call_function(1, 0, "on_collision_explosion");
  }
}

/**
 * \brief Calls the on_buying() method of the object on top of the stack.
 * \return true if the player is allowed to buy the item.
 */
bool LuaContext::on_buying() {
  check_callback_thread();
  bool can_buy = true;
  if (find_method("on_buying")) {
    bool success = call_function(1, 1, "on_buying");
    if (!success) {
      // Something was wrong in the script: don't let the player buy the item.
      can_buy = false;
    }
    else {
      can_buy = lua_toboolean(current_l, -1);
      lua_pop(current_l, 1);
    }
  }
  return can_buy;
}

/**
 * \brief Calls the on_bought() method of the object on top of the stack.
 */
void LuaContext::on_bought() {
  check_callback_thread();
  if (find_method("on_bought")) {
    call_function(1, 0, "on_bought");
  }
}

/**
 * \brief Calls the on_opened() method of the object on top of the stack.
 */
void LuaContext::on_opened() {
  check_callback_thread();
  if (find_method("on_opened")) {
    call_function(1, 0, "on_opened");
  }
}

/**
 * \brief Calls the on_opened() method of the object on top of the stack.
 * \param treasure A treasure being obtained when opening.
 * \return \c true if the method is defined.
 */
bool LuaContext::on_opened(const Treasure& treasure) {
  check_callback_thread();
  if (find_method("on_opened")) {

    if (treasure.is_empty()) {
      lua_pushnil(current_l);
      lua_pushnil(current_l);
    }
    else {
      push_item(current_l, treasure.get_item());
      lua_pushinteger(current_l, treasure.get_variant());
    }

    if (!treasure.is_saved()) {
      lua_pushnil(current_l);
    }
    else {
      lua_pushstring(current_l, treasure.get_savegame_variable().c_str());
    }

    call_function(4, 0, "on_opened");
    return true;
  }

  return false;
}

/**
 * \brief Calls the on_closed() method of the object on top of the stack.
 */
void LuaContext::on_closed() {
  check_callback_thread();
  if (find_method("on_closed")) {
    call_function(1, 0, "on_closed");
  }
}

/**
 * \brief Calls the on_moving() method of the object on top of the stack.
 */
void LuaContext::on_moving() {
  check_callback_thread();
  if (find_method("on_moving")) {
    call_function(1, 0, "on_moving");
  }
}

/**
 * \brief Calls the on_moved() method of the object on top of the stack.
 */
void LuaContext::on_moved() {
  check_callback_thread();
  if (find_method("on_moved")) {
    call_function(1, 0, "on_moved");
  }
}

/**
 * \brief Calls the on_map_changed() method of the object on top of the stack.
 * \param map The new active map.
 */
void LuaContext::on_map_changed(Map& map) {
  check_callback_thread();
  if (find_method("on_map_changed")) {
    push_map(current_l, map);
    call_function(2, 0, "on_map_changed");
  }
}

/**
 * \brief Calls the on_game_changed() method of the object on top of the stack.
 * \param previous_world The previous world or an empty string.
 * \param new_world The new world or an empty string.
 */
void LuaContext::on_world_changed(const std::string& previous_world, const std::string& new_world) {
  check_callback_thread();
  if (find_method("on_world_changed")) {
    if (previous_world.empty()) {
      lua_pushnil(current_l);
    }
    else {
      push_string(current_l, previous_world);
    }

    if (new_world.empty()) {
      lua_pushnil(current_l);
    }
    else {
      push_string(current_l, new_world);
    }
    call_function(3, 0, "on_world_changed");
  }
}

/**
 * \brief Calls the on_pickable_created() method of the object on top of the stack.
 * \param pickable A pickable treasure.
 */
void LuaContext::on_pickable_created(Pickable& pickable) {
  check_callback_thread();
  if (find_method("on_pickable_created")) {
    push_entity(current_l, pickable);
    call_function(2, 0, "on_pickable_created");
  }
}

/**
 * \brief Calls the on_variant_changed() method of the object on top of the stack.
 * \param variant Variant of an equipment item.
 */
void LuaContext::on_variant_changed(int variant) {
  check_callback_thread();
  if (find_method("on_variant_changed")) {
    lua_pushinteger(current_l, variant);
    call_function(2, 0, "on_variant_changed");
  }
}

/**
 * \brief Calls the on_amount_changed() method of the object on top of the stack.
 * \param amount Amount of an equipment item.
 */
void LuaContext::on_amount_changed(int amount) {
  check_callback_thread();
  if (find_method("on_amount_changed")) {
    lua_pushinteger(current_l, amount);
    call_function(2, 0, "on_amount_changed");
  }
}

/**
 * \brief Calls the on_obtaining() method of the object on top of the stack.
 * \param treasure The treasure being obtained.
 */
void LuaContext::on_obtaining(const Treasure& treasure) {
  check_callback_thread();
  if (find_method("on_obtaining")) {
    lua_pushinteger(current_l, treasure.get_variant());
    if (!treasure.is_saved()) {
      lua_pushnil(current_l);
    }
    else {
      lua_pushstring(current_l, treasure.get_savegame_variable().c_str());
    }
    call_function(3, 0, "on_obtaining");
  }
}

/**
 * \brief Calls the on_obtained() method of the object on top of the stack.
 * \param treasure The treasure just obtained.
 */
void LuaContext::on_obtained(const Treasure& treasure) {
  check_callback_thread();
  if (find_method("on_obtained")) {
    lua_pushinteger(current_l, treasure.get_variant());
    if (!treasure.is_saved()) {
      lua_pushnil(current_l);
    }
    else {
      lua_pushstring(current_l, treasure.get_savegame_variable().c_str());
    }
    call_function(3, 0, "on_obtained");
  }
}

/**
 * \brief Calls the on_using() method of the object on top of the stack.
 */
void LuaContext::on_using() {
  check_callback_thread();
  if (find_method("on_using")) {
    call_function(1, 0, "on_using");
  }
}

/**
 * \brief Calls the on_ability_used() method of the object on top of the stack.
 * \param ability A built-in ability.
 */
void LuaContext::on_ability_used(Ability ability) {
  check_callback_thread();
  if (find_method("on_ability_used")) {
    push_string(current_l, enum_to_name(ability));
    call_function(2, 0, "on_ability_used");
  }
}

/**
 * \brief Calls the on_created() method of the object on top of the stack.
 */
void LuaContext::on_created() {
  check_callback_thread();
  if (find_method("on_created")) {
    call_function(1, 0, "on_created");
  }
}

/**
 * \brief Calls the on_removed() method of the object on top of the stack.
 */
void LuaContext::on_removed() {
  check_callback_thread();
  if (find_method("on_removed")) {
    call_function(1, 0, "on_removed");
  }
}

/**
 * \brief Calls the on_enabled() method of the object on top of the stack.
 */
void LuaContext::on_enabled() {
  check_callback_thread();
  if (find_method("on_enabled")) {
    call_function(1, 0, "on_enabled");
  }
}

/**
 * \brief Calls the on_disabled() method of the object on top of the stack.
 */
void LuaContext::on_disabled() {
  check_callback_thread();
  if (find_method("on_disabled")) {
    call_function(1, 0, "on_disabled");
  }
}

/**
 * \brief Calls the on_restarted() method of the object on top of the stack.
 */
void LuaContext::on_restarted() {
  check_callback_thread();
  if (find_method("on_restarted")) {
    call_function(1, 0, "on_restarted");
  }
}

/**
 * \brief Calls the on_pre_draw() method of the object on top of the stack.
 * \param camera The camera where to draw.
 */
void LuaContext::on_pre_draw(Camera& camera) {
  check_callback_thread();
  if (find_method("on_pre_draw")) {
    push_camera(current_l, camera);
    call_function(2, 0, "on_pre_draw");
  }
}

/**
 * \brief Calls the on_post_draw() method of the object on top of the stack.
 * \param camera The camera where to draw.
 */
void LuaContext::on_post_draw(Camera& camera) {
  check_callback_thread();
  if (find_method("on_post_draw")) {
    push_camera(current_l, camera);
    call_function(2, 0, "on_post_draw");
  }
}

/**
 * \brief Calls the on_position_changed() method of the object on top of the stack.
 * \param xy The new position.
 * \param layer The new layer.
 */
void LuaContext::on_position_changed(const Point& xy, int layer) {
  check_callback_thread();
  if (find_method("on_position_changed")) {
    lua_pushinteger(current_l, xy.x);
    lua_pushinteger(current_l, xy.y);
    lua_pushinteger(current_l, layer);
    call_function(4, 0, "on_position_changed");
  }
}

/**
 * \brief Calls the on_obstacle_reached() method of the object on top of the stack.
 * \param movement The movement that reached an obstacle.
 */
void LuaContext::on_obstacle_reached(Movement& movement) {
  check_callback_thread();
  if (find_method("on_obstacle_reached")) {
    push_movement(current_l, movement);
    call_function(2, 0, "on_obstacle_reached");
  }
}

/**
 * \brief Calls the on_movement_started() method of the object on top of the stack.
 * \param movement A movement.
 */
void LuaContext::on_movement_started(Movement& movement) {
  check_callback_thread();
  if (find_method("on_movement_started")) {
    push_movement(current_l, movement);
    call_function(2, 0, "on_movement_started");
  }
}

/**
 * \brief Calls the on_movement_changed() method of the object on top of the stack.
 * \param movement A movement.
 */
void LuaContext::on_movement_changed(Movement& movement) {
  check_callback_thread();
  if (find_method("on_movement_changed")) {
    push_movement(current_l, movement);
    call_function(2, 0, "on_movement_changed");
  }
}

/**
 * \brief Calls the on_movement_finished() method of the object on top of the stack.
 */
void LuaContext::on_movement_finished() {
  check_callback_thread();
  if (find_method("on_movement_finished")) {
    call_function(1, 0, "on_movement_finished");
  }
}

/**
 * \brief Calls the on_collision_enemy() method of the object on top of the stack.
 * \param other_enemy Another enemy colliding with the object on top of the stack.
 * \param other_sprite Colliding sprite of the other enemy.
 * \param this_sprite Colliding sprite of the first enemy.
 */
void LuaContext::on_collision_enemy(Enemy& other_enemy, Sprite& other_sprite, Sprite& this_sprite) {
  check_callback_thread();
  if (find_method("on_collision_enemy")) {
    push_enemy(current_l, other_enemy);
    push_sprite(current_l, other_sprite);
    push_sprite(current_l, this_sprite);
    call_function(4, 0, "on_collision_enemy");
  }
}

/**
 * \brief Calls the on_lifted() method of the object on top of the stack.
 */
void LuaContext::on_lifted() {
  check_callback_thread();
  if (find_method("on_lifted")) {
    call_function(1, 0, "on_lifted");
  }
}

/**
 * \brief Calls the on_thrown() method of the object on top of the stack.
 */
void LuaContext::on_thrown() {
  check_callback_thread();
  if (find_method("on_thrown")) {
    call_function(1, 0, "on_thrown");
  }
}

/**
 * \brief Calls the on_breaking() method of the object on top of the stack.
 */
void LuaContext::on_breaking() {
  check_callback_thread();
  if (find_method("on_breaking")) {
    call_function(1, 0, "on_breaking");
  }
}

/**
 * \brief Calls the on_looked() method of the object on top of the stack.
 */
void LuaContext::on_looked() {
  check_callback_thread();
  if (find_method("on_looked")) {
    call_function(1, 0, "on_looked");
  }
}

/**
 * \brief Calls the on_cut() method of the object on top of the stack.
 */
void LuaContext::on_cut() {
  check_callback_thread();
  if (find_method("on_cut")) {
    call_function(1, 0, "on_cut");
  }
}

/**
 * \brief Calls the on_lifting() method of the object on top of the stack.
 * \param carrier Entity that is lifting another one.
 * \param carried_object Carried object created to replace
 * the entity being lifted.
 */
void LuaContext::on_lifting(
    Entity& carrier,
    CarriedObject& carried_object
) {
  check_callback_thread();
  if (find_method("on_lifting")) {
    push_entity(current_l, carrier);
    push_carried_object(current_l, carried_object);
    call_function(3, 0, "on_lifting");
  }
}

/**
 * \brief Calls the on_exploded() method of the object on top of the stack.
 */
void LuaContext::on_exploded() {
  check_callback_thread();
  if (find_method("on_exploded")) {
    call_function(1, 0, "on_exploded");
  }
}

/**
 * \brief Calls the on_regenerating() method of the object on top of the stack.
 */
void LuaContext::on_regenerating() {
  check_callback_thread();
  if (find_method("on_regenerating")) {
    call_function(1, 0, "on_regenerating");
  }
}

/**
 * \brief Calls the on_custom_attack_received() method of the object on top of the stack.
 * \param attack The attack received.
 * \param sprite The sprite that receives the attack if any.
 */
void LuaContext::on_custom_attack_received(EnemyAttack attack, Sprite* sprite) {
  check_callback_thread();
  if (find_method("on_custom_attack_received")) {
    push_string(current_l, Enemy::attack_names.find(attack)->second);
    if (sprite != nullptr) {
      // Pixel-precise collision.
      push_sprite(current_l, *sprite);
      call_function(3, 0, "on_custom_attack_received");
    }
    else {
      call_function(2, 0, "on_custom_attack_received");
    }
  }
}

/**
 * \brief Calls the on_hurt_by_sword() method of the object on top of the stack.
 * \param hero The hero whose sword is hitting the enemy.
 * \param enemy_sprite Sprite of the enemy that gets hits.
 * \return \c true if the method is defined.
 */
bool LuaContext::on_hurt_by_sword(Hero& hero, Sprite& enemy_sprite) {
  check_callback_thread();
  if (find_method("on_hurt_by_sword")) {
    push_hero(current_l, hero);
    push_sprite(current_l, enemy_sprite);
    call_function(3, 0, "on_hurt_by_sword");
    return true;
  }
  return false;
}

/**
 * \brief Calls the on_hurt() method of the object on top of the stack.
 * \param attack The attack received.
 */
void LuaContext::on_hurt(EnemyAttack attack) {
  check_callback_thread();
  if (find_method("on_hurt")) {
    push_string(current_l, Enemy::attack_names.find(attack)->second);
    call_function(2, 0, "on_hurt");
  }
}

/**
 * \brief Calls the on_dying() method of the object on top of the stack.
 */
void LuaContext::on_dying() {
  check_callback_thread();
  if (find_method("on_dying")) {
    call_function(1, 0, "on_dying");
  }
}

/**
 * \brief Calls the on_dead() method of the object on top of the stack.
 */
void LuaContext::on_dead() {
  check_callback_thread();
  if (find_method("on_dead")) {
    call_function(1, 0, "on_dead");
  }
}

/**
 * \brief Calls the on_immobilized() method of the object on top of the stack.
 */
void LuaContext::on_immobilized() {
  check_callback_thread();
  if (find_method("on_immobilized")) {
    call_function(1, 0, "on_immobilized");
  }
}

/**
 * \brief Calls the on_attacking_hero() method of the object on top of the stack.
 * \param hero The hero attacked.
 * \param attacker_sprite Sprite that caused the collision or nullptr.
 * \return \c true if the method is defined.
 */
bool LuaContext::on_attacking_hero(Hero& hero, Sprite* attacker_sprite) {
  check_callback_thread();
  if (find_method("on_attacking_hero")) {
    push_hero(current_l, hero);
    if (attacker_sprite == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_sprite(current_l, *attacker_sprite);
    }
    call_function(3, 0, "on_attacking_hero");
    return true;
  }
  return false;
}

/**
 * \brief Calls the on_attacked_enemy() method of the object on top of the stack.
 * \param The enemy that was attacked.
 * \param enemy_sprite Sprite that was attacked if any.
 * \param attack How the enemy was attacked.
 * \param reaction How the enemy reacted to the attack.
 */
void LuaContext::on_attacked_enemy(
    Enemy& enemy,
    Sprite* enemy_sprite,
    EnemyAttack attack,
    const EnemyReaction::Reaction& reaction
) {
  check_callback_thread();
  if (find_method("on_attacked_enemy")) {
    push_enemy(current_l, enemy);
    if (enemy_sprite == nullptr) {
      lua_pushnil(current_l);
    } else {
      push_sprite(current_l, *enemy_sprite);
    }
    push_string(current_l, Enemy::attack_names.find(attack)->second);

    if (reaction.type == EnemyReaction::ReactionType::HURT) {
      lua_pushinteger(current_l, reaction.life_lost);
    } else if (reaction.type == EnemyReaction::ReactionType::LUA_CALLBACK) {
      reaction.callback.push(current_l);
    } else {
      push_string(current_l, enum_to_name(reaction.type));
    }

    call_function(5, 0, "on_attacked_enemy");
  }
}

/**
 * \brief Calls the on_ground_below_changed() method of the object on top of the stack.
 * \param ground_below The new ground below the object.
 */
void LuaContext::on_ground_below_changed(Ground ground_below) {
  check_callback_thread();
  if (find_method("on_ground_below_changed")) {
    if (ground_below == Ground::EMPTY) {
      lua_pushnil(current_l);
    }
    else {
      push_string(current_l, enum_to_name(ground_below));
    }
    call_function(2, 0, "on_ground_below_changed");
  }
}

/**
 * \brief Calls the on_map_started() method of the object on top of the stack.
 * \param map The map.
 * \param destination Destination entity where the hero is placed or nullptr.
 */
void LuaContext::on_map_started(
    Map& map, const std::shared_ptr<Destination>& destination) {

  check_callback_thread();
  if (find_method("on_map_started")) {
    push_map(current_l, map);
    if (destination == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_entity(current_l, *destination);
    }
    call_function(3, 0, "on_map_started");
  }
}

/**
 * \brief Calls the on_map_opening_transition_finished() method of the object on top of the stack.
 * \param map The map.
 * \param destination Destination entity where the hero is placed or nullptr.
 */
void LuaContext::on_map_opening_transition_finished(
    Map& map, const std::shared_ptr<Destination>& destination) {

  check_callback_thread();
  if (find_method("on_map_opening_transition_finished")) {
    push_map(current_l, map);
    if (destination == nullptr) {
      lua_pushnil(current_l);
    }
    else {
      push_entity(current_l, *destination);
    }
    call_function(3, 0, "on_map_opening_transition_finished");
  }
}

/**
 * \brief Calls the on_map_finished() method of the object on top of the stack.
 */
void LuaContext::on_map_finished() {

  check_callback_thread();
  if (find_method("on_map_finished")) {
    call_function(1, 0, "on_map_finished");
  }
}

/**
 * \brief Function called when an unprotected Lua error occurs.
 * \param l The Lua context.
 * \return Number of values to return to Lua.
 */
int LuaContext::l_panic(lua_State* l) {

  const std::string& error = luaL_checkstring(l, 1);

  Debug::die(error);
}

/**
 * \brief A loader that makes require() able to load Lua files
 * from the quest data directory or archive.
 * \param l The Lua context.
 * \return Number of values to return to Lua.
 */
int LuaContext::l_loader(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const std::string& script_name = luaL_checkstring(l, 1);
    bool load_success = get().load_file(script_name);

    if (!load_success) {
      std::ostringstream oss;
      oss << std::endl << "\tno quest file '" << script_name
          << ".lua' in 'data/', 'data.solarus' or 'data.solarus.zip'";
      push_string(l, oss.str());
    }
    return 1;
  });
}

/**
 * \brief A function that prints the stack trace of an error raised in Lua.
 * \param l The Lua context.
 * \return Number of values to return to Lua.
 */
int LuaContext::l_backtrace(lua_State* l) {

  if (!lua_isstring(l, 1)) {
    push_string(l, "Unknown error");
    return 1;
  }
  lua_getglobal(l, "debug");
  if (!lua_istable(l, -1)) {
    lua_pushvalue(l, 1);  // Return the original error message.
    return 1;
  }
  lua_getfield(l, -1, "traceback");
  if (!lua_isfunction(l, -1)) {
    lua_pushvalue(l, 1);  // Return the original error message.
    return 1;
  }
  lua_pushvalue(l, 1);    // pass error message
  lua_call(l, 1, 1);      // call debug.traceback
  return 1;
}

}

