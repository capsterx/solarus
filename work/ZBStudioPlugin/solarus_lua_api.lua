return {
sol = {
  type = "lib",
  childs = {
    main = {
      type = "lib",
      description = [[`sol.main` contains general features and utility functions that are global to the execution of the program, no matter if a game or some menus are running.
]],
      childs = {
        get_solarus_version = {
          type = "function",
          description = [[

Returns the current Solarus version.

The Solarus version includes three numbers: x.y.z, where x is the major version, y is the minor version and z is the patch version.

Changes of major and minor versions may introduce some incompatibilities in the Lua API. Patch versions are only for bug fixing and never introduce incompatibilities. See the [migration guide](http://wiki.solarus-games.org/doku.php?id=migration_guide) for instructions about how to upgrade your quest to the latest version.

  * Return value (string): The Solarus version.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        get_quest_version = {
          type = "function",
          description = [[

Returns the version of the currently running quest as specified in the [Quest Properties file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html).

  * Return value (string): The quest version, or `nil` if no quest version was set the quest properties.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        get_quest_format = {
          type = "function",
          description = [[

Returns the Solarus compatibility format of this quest.

This corresponds to a version of Solarus with major and minor version numbers (no patch number), for example `"1.5"`.

  * Return value (string): The format of this quest.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        load_file = {
          type = "function",
          description = [[

Loads a Lua file (but does not run it).

This function is a replacement to the usual Lua function `loadfile()`. The difference is that it looks for a file in the quest tree (which may be a directory or an archive) and also in the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir). The quest write directory is tried first.

  * `script_name` (string): Name of the Lua file to load (with or without extension), relative to the data directory or the write directory of your quest.
  * Return value (function): A function representing the chunk loaded, or `nil` if the file does not exist or could not be loaded as Lua.



Remarks
    Keep in mind that Lua files, as all data files of your quest, may be located inside an archive instead of being regular files. Therefore, to run them, you cannot use usual Lua functions like `loadfile()` or `dofile()`. Use [sol.main.load_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_load_file) and [sol.main.do_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_do_file) instead to let Solarus determine how to locate and open the file.
     Note however that `require()` can be used normally because it is a higher-level function. Indeed, a specific loader is automatically set by the engine so that `require()` looks in the archive if necessary and in the quest write directory. `require()` is the recommended way to load code from another file, because unlike [sol.main.load_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_load_file) and [sol.main.do_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_do_file), it does not parses the file again every time you call it.
]],
          args = "script_name: string",
          returns = "function",
          valuetype = "function"
          },
        do_file = {
          type = "function",
          description = [[

Loads and runs a Lua file into the current context.

This function is a replacement to the usual Lua function `dofile()`. The difference is that it looks for a file in the quest tree (which may be a directory or an archive) and also in the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir). The quest write directory is tried first. The file must exist.

Use [sol.main.load_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_load_file) explicitly if you need to check the existence of the file or to use parameters and return values.

  * `script_name` (string): Name of the Lua file to load (with or without extension), relative to the data directory or the write directory of your quest.



Remarks
    This function is equivalent to `sol.main.load_file(script_name)()`.
     `require()` is the recommended way to load code from another file, because unlike [sol.main.load_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_load_file) and [sol.main.do_file()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_do_file), it does not parses the file again every time you call it.
]],
          args = "script_name: string",
          returns = "",
          valuetype = ""
          },
        reset = {
          type = "function",
          description = [[

Resets the whole program after the current cycle. Lua will be entirely shut down and then initialized again.
]],
          args = "",
          returns = "",
          valuetype = ""
          },
        exit = {
          type = "function",
          description = [[

Exits the program after the current cycle.
]],
          args = "",
          returns = "",
          valuetype = ""
          },
        get_elapsed_time = {
          type = "function",
          description = [[

Returns the simulated time elapsed since Solarus was started.

This corresponds to real time, unless the system is too slow to play at normal speed.

  * Return value (number): The number of simulated milliseconds elapsed since the beginning of the program.



Remarks
    This time is not reset when you call [sol.main.reset()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_reset).
]],
          args = "",
          returns = "number",
          valuetype = "number"
          },
        get_quest_write_dir = {
          type = "function",
          description = [[

Returns the subdirectory where files specific to the quest are saved, like savegames and settings. The quest write directory is specified in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file and may be changed dynamically with [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).

  * Return value (string): The quest write directory, relative to the Solarus write directory, or `nil` if it was not set.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        set_quest_write_dir = {
          type = "function",
          description = [[

Changes the subdirectory where files specific to the quest are saved, like savegames and settings. Note that the quest write directory can already be specified in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file. You usually don't have to call this function, unless you need to change it dynamically for some reason.

  * `quest_write_dir` (string): The quest write directory, relative to the Solarus write directory, or `nil` to unset it.


]],
          args = "quest_write_dir: string",
          returns = "",
          valuetype = ""
          },
        load_settings = {
          type = "function",
          description = [[

Loads and applies the built-in settings from a file previously saved with [sol.main.save_settings()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_save_settings). Settings from the file include user preferences such as the language, the video mode and the audio volume.

Note that all these settings can already be modified individually with the Lua API, so you can either use this function or implement something more fitted to your needs.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.

  * `file_name` (string, optional): Settings file to read, relative to the quest write directory. The default file name is `settings.dat`.
  * Return value (boolean): `true` if settings were successfully loaded and applied.



Remarks
    When you launch a quest from the Solarus GUI, user preferences that are currently set in the menus of the GUI are automatically written to `settings.dat` before the quest starts and are automatically applied as soon as the quest starts.
]],
          args = "[file_name: string]",
          returns = "boolean",
          valuetype = "boolean"
          },
        save_settings = {
          type = "function",
          description = [[

Saves the current built-in settings into a file. This file can be reloaded later with [sol.main.load_settings()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_load_settings) to restore the saved settings. Settings saved include user preferences such as the current language, the current video mode and the current audio volume.

Note that all these settings can already be modified individually with the Lua API, so you can either use this function or implement something more fitted to your needs.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.

  * `file_name` (string, optional): Settings file to read, relative to the quest write directory. The default file name is `settings.dat`.
  * Return value (boolean): `true` if settings were successfully saved.



Remarks
    When you launch a quest from the Solarus GUI, user preferences that are currently set in the menus of the GUI are automatically written to `settings.dat` before the quest starts and are automatically applied as soon as the quest starts.
]],
          args = "[file_name: string]",
          returns = "boolean",
          valuetype = "boolean"
          },
        get_distance = {
          type = "function",
          description = [[

Utility function that computes the distance in pixels between two points.

  * `x1` (number): X coordinate of the first point.
  * `y1` (number): Y coordinate of the first point.
  * `x2` (number): X coordinate of the second point.
  * `y2` (number): Y coordinate of the second point.
  * Return value (number): The distance in pixels.


]],
          args = "x1: number, y1: number, x2: number, y2: number",
          returns = "number",
          valuetype = "number"
          },
        get_angle = {
          type = "function",
          description = [[

Utility function that computes the angle in radians between the X axis and the specified vector.

  * `x1` (number): X coordinate of the first point.
  * `y1` (number): Y coordinate of the first point.
  * `x2` (number): X coordinate of the second point.
  * `y2` (number): Y coordinate of the second point.
  * Return value (number): The angle in radians between the x axis and this vector.


]],
          args = "x1: number, y1: number, x2: number, y2: number",
          returns = "number",
          valuetype = "number"
          },
        get_resource_ids = {
          type = "function",
          description = [[

Returns an array of all resource elements ids of the given type declared in the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html).

  * `resource_type` (string): Name of a resource type. Must be one of:
    * `"enemy"`,
    * `"entity"`,
    * `"font"`,
    * `"item"`,
    * `"language"`,
    * `"map"`,
    * `"music"`,
    * `"shader"`,
    * `"sound"`,
    * `"sprite"`,
    * `"tileset"`.
  * Return value (table): An array of all elements of this resource type declared in the quest. This is a standard Lua array (the first index is 1), and values are all strings.


]],
          args = "resource_type: string",
          returns = "table",
          valuetype = "table"
          },
        resource_exists = {
          type = "function",
          description = [[

Returns whether a resource element with the specified id is declared in the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html). This does not check if the corresponding files can be found and are actually valid: it only tells whether the element is declared in the quest database.

  * `resource_type` (string): Name of a resource type. See [sol.main.get_resource_ids()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids) for the possible values.
  * Return value (boolean): `true` if such an element is declared in the quest database.


]],
          args = "resource_type: string, id",
          returns = "boolean",
          valuetype = "boolean"
          },
        get_resource_description = {
          type = "function",
          description = [[

Returns the description of a resource element as declared in the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html).

  * `resource_type` (string): Name of a resource type. See [sol.main.get_resource_ids()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids) for the possible values.
  * `id` (string): Id of the element to get.
  * Return value (string): The description of this element or `nil` if the element has no description.


]],
          args = "resource_type: string, id: string",
          returns = "string",
          valuetype = "string"
          },
        add_resource = {
          type = "function",
          description = [[

Adds the declaration of a new resource element in the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html).

This does not create any file but just registers an element in the quest database.

  * `resource_type` (string): Name of a resource type. See [sol.main.get_resource_ids()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids) for the possible values.
  * `id` (string): Id of the element to add.
  * `description` (string, optional): Description to set.



Remarks
    Usually, resource elements are already declared in the [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html) generated by the quest editor. You only need this function if you want to modify the quest database dynamically, for example if you generate content dynamically.
]],
          args = "resource_type: string, id: string, [description: string]",
          returns = "",
          valuetype = ""
          },
        remove_resource = {
          type = "function",
          description = [[

Removes the declaration of a resource element in the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html).

This does not delete any file but just unregisters an element in the quest database.

  * `resource_type` (string): Name of a resource type. See [sol.main.get_resource_ids()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids) for the possible values.
  * `id` (string): Id of the element to remove.



Remarks
    Usually, resource elements are already declared in the [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html) generated by the quest editor. This function is only useful if you need to modify the quest database dynamically, for advanced uses like dynamically generated content.
]],
          args = "resource_type: string, id: string",
          returns = "",
          valuetype = ""
          },
        get_type = {
          type = "function",
          description = [[

Returns the type name of a value.

This function is similar to the standard Lua function type(), except that for userdata known by Solarus, it returns the exact Solarus type name.

  * `value` (any type): Any value or `nil`.
  * Return value (string): The name of the type. Can of one of standard Lua type names: `"nil"` (a string, not the value nil), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`. If it is a userdata unknown to Solarus, returns `"userdata"`. If it is a Solarus userdata, returns one of: `"game"`, `"map"`, `"item"`, `"surface"`, `"text_surface"`, `"sprite"`, `"shader"`, `"timer"`, `"movement"`, `"straight_movement"`, `"target_movement"`, `"random_movement"`, `"path_movement"`, `"random_path_movement"`, `"path_finding_movement"`, `"circle_movement"`, `"jump_movement"`, `"pixel_movement"`, `"state"`, `"hero"`, `"dynamic_tile"`, `"teletransporter"`, `"destination"`, `"pickable"`, `"destructible"`, `"carried_object"`, `"chest"`, `"shop_treasure"`, `"enemy"`, `"npc"`, `"block"`, `"jumper"`, `"switch"`, `"sensor"`, `"separator"`, `"wall"`, `"crystal"`, `"crystal_block"`, `"stream"`, `"door"`, `"stairs"`, `"bomb"`, `"explosion"`, `"fire"`, `"arrow"`, `"hookshot"`, `"boomerang"`, `"camera"`, `"custom_entity"`.


]],
          args = "value: any type",
          returns = "string",
          valuetype = "string"
          },
        get_metatable = {
          type = "function",
          description = [[

Returns the metatable of a Solarus userdata type.

This function is very powerful and should be used with care.

All userdata objects of a type share the same metatable. So there is a metatable for maps, a metatable for games, a metatable for enemies, etc.

The metatable of a type stores what is common to all instances of this type. For example, the metatable of the `"enemy"` type has a field `"get_life"` that is the Solarus function [enemy:get_life()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_life) shared by all enemies.

Note that you can already get the metatable of any object with the standard Lua function `getmetatable(object)`. This function does the same thing, except that you don't have to provide an existing object: you just provide a type name. This allows you do manipulate the metatable of a type before objects of this type start to exist, typically to set up things before a game is started.

You can use the metatable to add a function to all instances of a type. Thus, you can extend the Solarus API with your own functions. This also work for events (functions that the engine automatically calls when they exist). For example, you can easily provide a function `add_overlay()` to all your maps by defining it only once in the map metatable:
    
    
    -- Somewhere in your main script, at initialization time:
    
    local map_metatable = sol.main.get_metatable("map")
    function map_metatable:add_overlay(image_file_name)
      -- Here, self is the map.
      self.overlay = sol.surface.create(image_file_name)
    end
    
    function map_metatable:on_draw(dst_surface)
      if self.overlay ~= nil then
        self.overlay:draw(dst_surface)
      end
    end
    
    -- Now, all your maps will have a function map:add_overlay() and an event
    -- map:on_draw() that allows to draw an additional image above the map!
    

When you define a field in a metatable, everything acts like if you defined it in all existing and future instances of the type. However, an individual instance is still able to define a field with the same name. In this case, the instance has the priority: the field from the metatable is overridden.

Similarly, you can even remove (by assigning `nil`) or modify (by assigning a new value) any function of the Solarus API. We don't recommend to do this because introducing differences with the official API changes the global behavior. It would be unexpected for other people who contribute to your game, and for people you share your scripts with.

  * `type_name` (string): Name of a Solarus userdata Lua type (see the list of types in [sol.main.get_type()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_type) above).
  * Return value (table): The metatable of this type, or `nil` if there is no such Solarus type.



Remarks
    If you are a Lua expert, you know that metatables are a very powerful mechanism. They are where the magic happens. Solarus uses metatables internally to do a lot of things, like allowing you to access userdata as tables. Therefore, you should never touch any metamethod (fields whose name starts with two underscores) in the metatable of a userdata type, in particular `__index`, `__newindex` and `__gc`.
]],
          args = "type_name: string",
          returns = "table",
          valuetype = "table"
          },
        get_os = {
          type = "function",
          description = [[

Returns the name of the running OS. Possible values are : `"Windows"`, `"Mac OS X"`, `"Linux"`, `"iOS"`, `"Android"`. If the correct OS name is not available, returns a string beginning with the text `"Unknown"`.

  * Return value (string): The name of the running OS.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        get_game = {
          type = "function",
          description = [[

Returns the current [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) if a game is running.

  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game currently running, or `nil` if no game is running.



#  Events of sol.main

Events are callback methods automatically called by the engine if you define them.
]],
          args = "",
          returns = "game",
          valuetype = "game"
          }
        }
      },
    audio = {
      type = "lib",
      description = [[

You can play musics and sound effects through `sol.audio`.
]],
      childs = {
        play_sound = {
          type = "function",
          description = [[

Plays a sound effect.

Generates a Lua error if the sound does not exist.

Several sounds can be played in parallel. In the current version, a sound cannot be interrupted after you start playing it.

Unlike musics, sounds files are entirely read before being played. A file access is made only the first time you play each sound. You can use [sol.audio.preload_sounds()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_preload_sounds) if you want to also avoid this initial file access.

  * `sound_id` (string): Name of the sound file to play, relative to the `sounds` directory and without extension. Currently, `.ogg` is the only extension supported.


]],
          args = "sound_id: string",
          returns = "",
          valuetype = ""
          },
        preload_sounds = {
          type = "function",
          description = [[

Loads all sounds effects into memory for faster future access.

If you don't call this function, you can still play sound effects, but the first access to each sound effect will require a file access that might be perceptible on slow machines. It is recommended to call this function at the beginning of the program (typically from [sol.main:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_on_started)).

The list of sound files to load is read from the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html) file.

This function does nothing if you already called it before.
]],
          args = "",
          returns = "",
          valuetype = ""
          },
        play_music = {
          type = "function",
          description = [[

Plays a music.

If the music does not exist, a Lua error is generated.

Only one music can be played at a time. If the same music was already playing, it continues normally and does not restart. If a different music was already playing, it is stopped and replaced by the new one.

When the music reaches the end, the `action` parameter indicates what to do next. The default behavior is to loop from the beginning.

However, some music files already have their own loop internal loop information. Such musics are able to loop to a specific point rather than to the beginning. Since they already loop forever internally, they don't have an end and the `action` parameter has no effect on them. See [Music loop settings](http://www.solarus-games.org/doc/1.6/quest_musics.html#quest_musics_loop) to know how Solarus supports internal loop information for each format.

  * `music_id` (string): Name of the music file to play, relative to the `musics` directory and without extension. The following extensions will be tried in this order: ```.ogg`, ```.it` and ```.spc`. `nil` stops playing any music (the second parameter has no effect in this case). If you set the music name to the same music that is already playing, or to the special value `"same"`, then this function does nothing: the music keeps playing (it does not restart) and the second parameter is ignored.
  * `action` (function or boolean, optional): What to do when the music finishes (reaches its end). A boolean value indicates whether or not the music should loop. The default is `true`. A function value indicates a custom action (and implies no loop). It will be called when the music finishes. This allows you to perform an action of your choice, like playing another music.


]],
          args = "music_id: string, [action: function or boolean]",
          returns = "",
          valuetype = ""
          },
        get_music = {
          type = "function",
          description = [[

Returns the name of the music currently playing.

  * Return value (string): Name of the music file currently playing, relative to the `musics` directory and without extension. Returns `nil` if no music is playing.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        stop_music = {
          type = "function",
          description = [[

Stops playing music.

This function has no effect if no music was playing.

Remarks
    This is equivalent to `sol.audio.play_music("none")`.
]],
          args = "",
          returns = "",
          valuetype = ""
          },
        get_sound_volume = {
          type = "function",
          description = [[

Returns the current volume of sound effects.

This volume applies to all sounds played by [sol.audio.play_sound()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) and by the engine.

  * Return value (number): The current volume of sound effects, as an integer between `0` (mute) and `100` (full volume).


]],
          args = "",
          returns = "number",
          valuetype = "number"
          },
        set_sound_volume = {
          type = "function",
          description = [[

Sets the volume of sound effects.

This volume applies to all sounds played by [sol.audio.play_sound()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) and by the engine.

  * `volume` (number): The new volume of sound effects, as an integer between `0` (mute) and `100` (full volume).



Remarks
    When the quest is run from the Solarus GUI, the user can also change the volume from the menus of the GUI.
]],
          args = "volume: number",
          returns = "",
          valuetype = ""
          },
        get_music_volume = {
          type = "function",
          description = [[

Returns the current volume of musics.

This volume applies to all musics played by [sol.audio.play_music(music_id, [action])](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_music). "sol.audio.play_music()"

  * Return value (number): The current volume of musics, as an integer between `0` (no sound effects) and `100` (full volume).



Remarks
    When the quest is run from the Solarus GUI, the user can also change the volume from the menus of the GUI.
]],
          args = "",
          returns = "number",
          valuetype = "number"
          },
        set_music_volume = {
          type = "function",
          description = [[

Sets the volume of musics.

This volume applies to all musics played by [sol.audio.play_music(music_id, [action])](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_music). "sol.audio.play_music()"

  * `volume` (number): The new volume of musics, as an integer between `0` (no music) and `100` (full volume).


]],
          args = "volume: number",
          returns = "",
          valuetype = ""
          },
        get_music_format = {
          type = "function",
          description = [[

Returns the format of the music currently playing.

  * Return value (string): Format of the music: `"ogg"`, `"it"` or `"spc"`. Returns `nil` if no music is playing.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        get_music_num_channels = {
          type = "function",
          description = [[

Returns the number of channels of the current .it music.

This function is only supported for .it musics.

  * Return value (number): Number of channels of the music. Returns `nil` if the current music format is not .it.


]],
          args = "",
          returns = "number",
          valuetype = "number"
          },
        get_music_channel_volume = {
          type = "function",
          description = [[

Returns the volume of notes of a channel for the current .it music.

This function is only supported for .it musics.

  * `channel` (number): Index of a channel (the first one is zero).
  * Return value (number): Volume of the channel. Returns `nil` if the current music format is not .it.



Remarks
    The channel should have the same volume for all its notes. Otherwise, calling this function does not make much sense.
]],
          args = "channel: number",
          returns = "number",
          valuetype = "number"
          },
        set_music_channel_volume = {
          type = "function",
          description = [[

Sets the volume of all notes of a channel for the current .it music.

This function has no effect for musics other than .it.

  * `channel` (number): Index of a channel (the first one is zero).
  * `volume` (number): The volume to set.


]],
          args = "channel: number, volume: number",
          returns = "",
          valuetype = ""
          },
        get_tempo = {
          type = "function",
          description = [[

Returns the tempo of the current .it music.

This function is only supported for .it musics.

  * Return value (number): Tempo of the music. Returns `nil` if the current music format is not .it.


]],
          args = "",
          returns = "number",
          valuetype = "number"
          },
        set_tempo = {
          type = "function",
          description = [[

Sets the tempo of the current .it music.

This function is only supported for .it musics.

  * `tempo` (number): Tempo to set. 


]],
          args = "tempo: number",
          returns = "",
          valuetype = ""
          }
        }
      },
    video = {
      type = "lib",
      description = [[

`sol.video` allows you to manage the window and the display.

The area where the game takes place has a fixed size called the quest size. The quest size is in a range specified in the [quest properties file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html). This quest size is the logical size: it determines how much content the player can see on the map.

The quest size is typically 320x240 pixels, but some systems may prefer other sizes, like 400x240 on Android. You can set a range of supported quest sizes in the quest properties files for portability. However, it requires more work on your part: in particular, you have to implement menus and a HUD that can adapt to any size in this range. And be aware that some players will be able to see more game content than others.

The quest can be played in windowed mode or in fullscreen. In windowed mode, the window can be resized by the user or by your scripts. The quest size is independent from the actual window size: when you resize the window, the quest image is scaled to fit the window. The pixel ratio is always preserved, possibly by adding black borders.

Solarus supports OpenGL shaders to modify the rendering, for example to apply a smoothing filter. See the [shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html) documentation for more details.
]],
      childs = {
        get_window_title = {
          type = "function",
          description = [[

Returns the text of the title bar of the window.

  * Return value (string): The window title.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        set_window_title = {
          type = "function",
          description = [[

Sets the text of the title bar of the window.

By default, the window title is set to the title of your quest followed by its version. Both these properties are indicated in the [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file.

  * `window_title` (string): The window title to set.


]],
          args = "window_title: string",
          returns = "",
          valuetype = ""
          },
        is_fullscreen = {
          type = "function",
          description = [[

Returns whether the current video mode is fullscreen.

  * Return value (boolean): `true` if the video mode is fullscreen.


]],
          args = "",
          returns = "boolean",
          valuetype = "boolean"
          },
        set_fullscreen = {
          type = "function",
          description = [[

Turns on or turns off fullscreen, keeping an equivalent video mode.

  * `fullscreen` (boolean, optional): `true` to set fullscreen (no value means `true`).



Remarks
    When the quest is run from the Solarus GUI, the user can also switch fullscreen from the menus of the GUI.
]],
          args = "[fullscreen: boolean]",
          returns = "",
          valuetype = ""
          },
        is_cursor_visible = {
          type = "function",
          description = [[

Returns whether the mouse cursor is currently visible.

  * Return value (boolean): `true` if the mouse cursor is currently visible.


]],
          args = "",
          returns = "boolean",
          valuetype = "boolean"
          },
        set_cursor_visible = {
          type = "function",
          description = [[

Shows or hides the mouse cursor, keeping an equivalent video mode.

  * `visible_cursor` (boolean, optional): `true` to show mouse cursor (no value means `true`).


]],
          args = "[cursor_visible]",
          returns = "",
          valuetype = ""
          },
        get_quest_size = {
          type = "function",
          description = [[

Returns the logical size of the quest screen.

This quest size is fixed at runtime. It is always in the range of allowed quest sizes specified in [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html).

The quest size is independent from the actual window size.

  * Return value 1 (number): Width of the quest screen in pixels.
  * Return value 2 (number): Height of the quest screen in pixels.


]],
          args = "",
          returns = "number,number",
          valuetype = "number,number"
          },
        get_window_size = {
          type = "function",
          description = [[

Returns the size of the window.

The quest image has a [fixed size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) determined when the program starts. This quest image is then scaled to the window. The size of the window can be changed at any moment by the user or by [sol.video.set_window_size()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_set_window_size). Black borders are added if necessary to keep the correct pixel ratio.

When the window is in fullscreen, this function returns the size to be used when returning to windowed mode.

When Solarus starts, the size of the window is twice the quest size.

  * Return value 1 (number): Width of the window in pixels.
  * Return value 2 (number): Height of the window in pixels.


]],
          args = "",
          returns = "number,number",
          valuetype = "number,number"
          },
        set_window_size = {
          type = "function",
          description = [[

Sets the size of the window.

See [sol.video.get_window_size()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_window_size) for a detailed description of the window size.

When the window is in fullscreen, this function still works: the changes will be visible when returning to windowed mode.

  * Return value 1 (number): Width of the window in pixels.
  * Return value 2 (number): Height of the window in pixels.


]],
          args = "width, height",
          returns = "number,number",
          valuetype = "number,number"
          },
        get_shader = {
          type = "function",
          description = [[

Returns the shader currently applied to the rendering, if any.

  * Return value ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The current shader, or `nil` if no shader is applied.


]],
          args = "",
          returns = "shader",
          valuetype = "shader"
          },
        set_shader = {
          type = "function",
          description = [[

Sets a shader to be applied to the rendering.

  * shader ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The shader to set. It replaces the previous shader if any. A `nil` value means to apply no shader.



#  Events of sol.video

Events are callback methods automatically called by the engine if you define them.
]],
          args = "shader: shader",
          returns = "",
          valuetype = ""
          }
        }
      },
    shader = {
      type = "lib",
      description = [[

This module provides a datatype `shader` that represents an OpenGL or OpenGL ES shader program.
]],
      childs = {
        create = {
          type = "function",
          description = [[

Loads and returns a shader program from the given parameters.

This function can be used for advanced purposes, but the normal way is to use [sol.shader.create(shader_id)](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_create_id), that is, to load a shader already described in a data file.

If the loading or the compilation of the shader program fails, a Lua error is raised.

  * `properties` (table): Source and parameters of the shader program. Can have the following entries:
    * `vertex_source` (string, optional): GLSL code of the vertex shader. No values means to use a default shader that does nothing special
    * `fragment_source` (string, optional): GLSL code of the fragment shader. No values means to use a default shader that does nothing special.
    * `scaling_factor` (number, optional): When the shader is applied to the whole window, indicates how much the input texture will be scaled by the shader. See [shader:set_scaling_factor()](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_set_scaling_factor) for more details.
  * Return value (shader): The shader program created.


]],
          args = "properties: table",
          returns = "shader",
          valuetype = "shader"
          },
        get_opengl_version = {
          type = "function",
          description = [[

Returns the OpenGL or OpenGL ES version Solarus is being run with.

  * Return value (string): A string describing the OpenGL or OpenGL ES version.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        get_shading_language_version = {
          type = "function",
          description = [[

Returns the GLSL or GLSL ES format supported by the OpenGL or OpenGL ES version currently used.

  * Return value (string): A string describing the shading language version.



#  Methods of the type shader
]],
          args = "",
          returns = "string",
          valuetype = "string"
          }
        }
      },
    input = {
      type = "lib",
      description = [[

You can get information about the low-level keyboard and joypad inputs through `sol.input`.

But remember that when a low-level keyboard or joypad input event occurs, all useful objects ([sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html), the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) and [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html)) are already notified. For example, when the user presses a keyboard key, the engine automatically calls [sol.main:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_on_key_pressed).

Also note that during the game, there exists the higher-level notion of [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) to ease your life.
]],
      childs = {
        is_joypad_enabled = {
          type = "function",
          description = [[

Returns whether joypad support is enabled.

This may be true even without any joypad plugged.

  * Return value (boolean): `true` if joypad support is enabled.


]],
          args = "",
          returns = "boolean",
          valuetype = "boolean"
          },
        set_joypad_enabled = {
          type = "function",
          description = [[

Enables or disables joypad support.

Joypad support may be enabled even without any joypad plugged.

  * `joypad_enabled` `true` to enable joypad support, false to disable it. No value means `true`.


]],
          args = "[joypad_enabled]",
          returns = "",
          valuetype = ""
          },
        is_key_pressed = {
          type = "function",
          description = [[

Returns whether a keyboard key is currently down.

  * `key` (string): The name of a keyboard key.
  * Return value (boolean): `true` if this keyboard key is currently down.


]],
          args = "key: string",
          returns = "boolean",
          valuetype = "boolean"
          },
        get_modifiers = {
          type = "function",
          description = [[

Returns the keyboard key modifiers currently active.

  * Return value (table): A table whose keys indicate what modifiers are currently down. Possible table keys are `"shift"`, `"control"`, `"alt"` and `"caps lock"`. Table values are `true`.


]],
          args = "",
          returns = "table",
          valuetype = "table"
          },
        is_joypad_button_pressed = {
          type = "function",
          description = [[

Returns whether a joypad button is currently down.

  * `button` (number): Index of a button of the joypad.
  * Return value (boolean): `true` if this joypad button is currently down.


]],
          args = "button: number",
          returns = "boolean",
          valuetype = "boolean"
          },
        get_joypad_axis_state = {
          type = "function",
          description = [[

Returns the current state of an axis of the joypad.

  * `axis` (number): Index of a joypad axis. The first one is `0`.
  * Return value (number): The state of that axis. `-1` means left or up, `0` means centered and `1` means right or down.


]],
          args = "axis: number",
          returns = "number",
          valuetype = "number"
          },
        get_joypad_hat_direction = {
          type = "function",
          description = [[

Returns the current direction of a hat of the joypad.

  * `hat` (number): Index of a joypad hat. The first one is `0`.
  * Return value (number): The direction of that hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.


]],
          args = "hat: number",
          returns = "number",
          valuetype = "number"
          },
        get_mouse_position = {
          type = "function",
          description = [[

Returns the current position of the mouse cursor relative to the quest size.

If the mouse is outside the window, mouse coordinates are captured only if a mouse button is pressed. In this case, the returned values can be out of bounds of the quest size and can be negative. This allows you to keep track of the mouse movement when dragging something. Otherwise, when no mouse button is pressed, the returned coordinates are the last position of the mouse in the window.

  * Return value 1 (integer): The `x` position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value 2 (integer): The `y` position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.


]],
          args = "",
          returns = "integer,integer",
          valuetype = "integer,integer"
          },
        is_mouse_button_pressed = {
          type = "function",
          description = [[

Returns whether a mouse button is currently down.

  * `button` (string): The name of a mouse button. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * Return value (boolean): `true` if mouse button is down.


]],
          args = "button: string",
          returns = "boolean",
          valuetype = "boolean"
          },
        get_finger_position = {
          type = "function",
          description = [[

Returns the current position of a finger if it exists.

  * `finger` (integer): The finger id to check.
  * Return value 1 (integer): The `x` position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates. Return `nil` if the finger does not exist or is not pressed.
  * Return value 2 (integer): The `y` position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.


]],
          args = "finger: integer",
          returns = "integer,integer",
          valuetype = "integer,integer"
          },
        get_finger_pressure = {
          type = "function",
          description = [[

Returns the current pressure of a finger if it exists.

  * `finger` (integer): The finger id to check.
  * Return value 1 (number): The `pressure` of the finger between `0.0` and `1.0`. Return `nil` if there is no such finger.


]],
          args = "finger: integer",
          returns = "number",
          valuetype = "number"
          },
        is_finger_pressed = {
          type = "function",
          description = [[

Returns whether a finger is currently pressed.

  * `finger` (integer): The finger id to check.
  * Return value (boolean): `true` if the finger is down.


]],
          args = "finger: integer",
          returns = "boolean",
          valuetype = "boolean"
          },
        simulate_key_pressed = {
          type = "function",
          description = [[

Simulates pressing a keyboard key.

  * `key` (string): The keyboard key to simulate.


]],
          args = "key: string",
          returns = "",
          valuetype = ""
          },
        simulate_key_released = {
          type = "function",
          description = [[

Simulates releasing a keyboard key.

  * `key` (string): The keyboard key to simulate. 


]],
          args = "key: string",
          returns = "",
          valuetype = ""
          }
        }
      },
    file = {
      type = "lib",
      description = [[

This module provides functions to manually read and write files from the quest data directory and from quest write directory.
]],
      childs = {
        open = {
          type = "function",
          description = [[

Same as [io.open()](http://www.lua.org/manual/5.1/manual.html#pdf-io.open), but relative to the quest write directory or to the data directory.

If a valid quest write directory is set (in your [quest.dat file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried if the mode is `"r"` (read mode).

This function just calls `io.open()` with the actual path and the mode as parameters, and returns its results.

  * `file_name` (string): Name of the file to open, relative to the quest write directory or to the data directory.
  * `mode` (string, optional): Opening mode (see the Lua documentation of [io.open()](http://www.lua.org/manual/5.1/manual.html#pdf-io.open) ).
  * Return value (file or nil+string): The file object created, or `nil` plus an error message in case of failure. The file value is the standard Lua file object as returned by `io.open()`, and you can then use all Lua file functions (file:read(), file:write(), file:lines(), file:close(), etc.).


]],
          args = "file_name: string, [mode: string]",
          returns = "file or nil+string",
          valuetype = "file or nil+string"
          },
        exists = {
          type = "function",
          description = [[

Returns whether the specified file or directory exists in the quest write directory or in the data directory.

If a valid quest write directory is set (in your [quest.dat file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried.

  * `file_name` (string): Name of the file to test, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
  * Return value (boolean): `true` if there exists a file or directory with this name.


]],
          args = "file_name: string",
          returns = "boolean",
          valuetype = "boolean"
          },
        is_dir = {
          type = "function",
          description = [[

Returns whether the specified file exists and is a directory.

If a valid quest write directory is set (in your [quest.dat file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried.

  * `file_name` (string): Name of the file to test, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
  * Return value (boolean): `true` if there exists a directory with this name.


]],
          args = "file_name: string",
          returns = "boolean",
          valuetype = "boolean"
          },
        remove = {
          type = "function",
          description = [[

Deletes a file or a directory from the quest write directory.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.

  * `file_name` (string): Name of the file to delete, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir). If it is a directory, it must be empty before you delete it.
  * Return value (boolean and string): `true` in case of success, `nil` plus an error message in case of failure.


]],
          args = "file_name: string",
          returns = "boolean and string",
          valuetype = "boolean and string"
          },
        rename = {
          type = "function",
          description = [[

Renames a file or a directory in the quest write directory.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.

  * `old_file_name` (string): Name of the file to rename, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).
  * `new_file_name` (string): New name to set, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).
  * Return value (boolean and string): `true` in case of success, `nil` plus an error message in case of failure.


]],
          args = "old_file_name: string, new_file_name: string",
          returns = "boolean and string",
          valuetype = "boolean and string"
          },
        mkdir = {
          type = "function",
          description = [[

Creates a directory in the quest write directory.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.

  * `dir_name` (string): Name of the directory to delete, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).
  * Return value (boolean or nil+string): `true` in case of success, `nil` plus an error message in case of failure.


]],
          args = "dir_name: string",
          returns = "boolean or nil+string",
          valuetype = "boolean or nil+string"
          },
        list_dir = {
          type = "function",
          description = [[

Returns the list of files in a directory.

  * `dir_name` (string): Name of the directory to explore, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
  * Return value (table): An array with the name of files and directories inside the directory. Names are ordered alphabetically. Returns `nil` if the given name is not a directory or does not exist. 


]],
          args = "dir_name: string",
          returns = "table",
          valuetype = "table"
          }
        }
      },
    menu = {
      type = "lib",
      description = [[

To display various information such as a title screen, a dialog box, a HUD (head-up display) or a pause screen, you can use one or several menus.

A menu is an arbitrary Lua table. A menu belongs to a context that may be the current [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), the current [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), the [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) table or even another menu. This context is the lifetime of your menu. As long as your menu is active, the engine will call events that are defined in your table, i.e. callback methods like [menu:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_started) [menu:on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_draw), [menu:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_key_pressed), etc., to notify your menu of something (the player pressed a key, your menu needs to be redrawn, etc.).

This menu API does not provide anything fundamental: indeed, the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) and [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) APIs already provide the necessary features, so you could do what you want from there manually. But the API described on this page makes your life easier because menus automatically receive events whenever they need to be notified, and automatically stop being active when their context no longer exists.
]],
      childs = {
        start = {
          type = "function",
          description = [[

Starts a menu in a context.

The Solarus engine will then call the appropriate events on your menu until it is stopped.

  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) or table): The context your menu will belong to. Similarly to the case of [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html), the context determines the lifetime of your menu. The context must be one of the following four objects:
    * If you make a [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) menu, your menu will be drawn above the map surface. It will be stopped when the player goes to another map. This may be useful to show head-up information local to a precise map.  
Example: a counter or a mini-game that only exists on a specific map.  

    * If you make a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) menu, your menu will be global to all maps. As long as the game is running, it will persist accross map changes.  
Example: the player's life counter.  

    * If you make a [main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) menu, your menu will be global to the whole program. It can exist outside a game (and it even persists during the game if you don't stop it).  
Example: the title screen.
    * If you set the context to another menu, then its lifetime will be limited to this other menu. This allows to make nested menus. Example: a popup that shows some information above another menu.
    * `menu` (table): The menu to activate. It can be any table. The only thing that makes it special is the presence of callback functions (events) as described in section [Events of a menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_events).
  * `on_top` (boolean, optional): Whether this menu should be drawn on top of other existing menus of the same context or behind them. If `true`, the [on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_draw) event of your menu will be the last to be called if there are several menus in the context. If `false`, it will be the first one. No value means `true`.


]],
          args = "context: map, game or table, menu: table, [on_top: boolean]",
          returns = "",
          valuetype = ""
          },
        stop = {
          type = "function",
          description = [[

Stops a menu previously activated with [sol.menu.start()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_start).

After this call, the Solarus engine will no longer call events on your menu. But you can restart it later if you want.

Nothing happens is the menu was already stopped or never started.

  * `menu` (table): The menu to stop.


]],
          args = "menu: table",
          returns = "",
          valuetype = ""
          },
        stop_all = {
          type = "function",
          description = [[

Stops all menus that are currently running in a context.

  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) or table): The context where you want to stop menus.



This function is not often needed since menus are already automatically stopped when their context is closed.
]],
          args = "context: map, game, sol.main or table",
          returns = "",
          valuetype = ""
          },
        is_started = {
          type = "function",
          description = [[

Returns whether a table is a currently active menu.

  * `menu` (table): The menu to test.
  * Return value (boolean): `true` if this is an active menu.


]],
          args = "menu: table",
          returns = "boolean",
          valuetype = "boolean"
          },
        bring_to_front = {
          type = "function",
          description = [[

Places this menu in front of other menus of the same context.

Your menu will then be the first one to receive input events (keyboard, joypad and mouse events) and the last one to be drawn.

  * `menu` (table): The menu to bring to the front.


]],
          args = "menu: table",
          returns = "",
          valuetype = ""
          },
        bring_to_back = {
          type = "function",
          description = [[

Places this menu behind other menus of the same context.

Your menu will then be the last one to receive input events (keyboard, joypad and mouse events) and the first one to be drawn.

  * `menu` (table): The menu to bring to the back.



#  Events of a menu

Events are callback methods automatically called by the engine if you define them.
]],
          args = "menu: table",
          returns = "",
          valuetype = ""
          }
        }
      },
    language = {
      type = "lib",
      description = [[

`sol.language` lets you get and set the current language and manage language-specific data.

Like all resources (maps, sounds, etc.), each language is identified by an id (like `"en"`, `"fr"`) and has a human-readable description (like `"English"`, `"Français"`). The language id corresponds to the name of a directory with files translated in this language: dialogs, strings and images. That directory is located in the `languages` directory of your quest.

The list of languages available in your quest is specified in the [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html).

If there is only one language in your quest, then it is automatically set as the current language. Otherwise, if you have several languages, no current language is automatically set for you, and you need to call [sol.language.set_language()](http://www.solarus-games.org/doc/1.6/lua_api_language.html#lua_api_language_set_language) to be able to use dialogs.
]],
      childs = {
        get_language = {
          type = "function",
          description = [[

Returns the id of the current language.

  * Return value (string): The code that identifies the current language, or `nil` if no language was set.


]],
          args = "",
          returns = "string",
          valuetype = "string"
          },
        set_language = {
          type = "function",
          description = [[

Changes the current language.

  * `language_id` (string): The code that identifies the new language to set. It must be a valid id as defined in your [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html).


]],
          args = "language_id: string",
          returns = "",
          valuetype = ""
          },
        get_language_name = {
          type = "function",
          description = [[

Returns the human-readable description of a language.

  * `language_id` (string, optional): A language id (no value means the current language).
  * Return value (string): The human-readable name of this language.



Remarks
    Equivalent to [sol.main.get_resource_description("language", language_id)](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_description)
]],
          args = "[language_id: string]",
          returns = "string",
          valuetype = "string"
          },
        get_languages = {
          type = "function",
          description = [[

Returns the list of available languages.

  * Return value (table): An array of all language ids declared in the quest.



Remarks
    Equivalent to [sol.main.get_resource_ids("language")](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids)
]],
          args = "",
          returns = "table",
          valuetype = "table"
          },
        get_string = {
          type = "function",
          description = [[

Returns a string translated in the current language.

There must be a current language when you call this function.

Translated strings are defined in the file [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html) of the language-specific directory (e.g. `languages/en/text/strings.dat`).

  * `key` (string): Key of the string to get. The corresponding key-value pair must be defined in [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html).
  * Return value (string): The value associated to this key in [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html), or `nil` if it does not exist.


]],
          args = "key: string",
          returns = "string",
          valuetype = "string"
          },
        get_dialog = {
          type = "function",
          description = [[

Returns a dialog translated in the current language.

There must be a current language when you call this function.

Translated dialogs are defined in the file [text/dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) of the language-specific directory (e.g. `languages/en/text/dialogs.dat`).

  * `dialog_id` (string): Id of the dialog to get.
  * Return value (table): The corresponding dialog in the current language, or `nil` if it does not exist. The dialog is a table with at least the following two entries:
    * `dialog_id` (string): Id of the dialog.
    * `text` (string): Text of the dialog. The table also contains all custom entries defined in [text/dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) for this dialog. These custom entries always have string keys and string values. 


]],
          args = "dialog_id: string: string",
          returns = "table",
          valuetype = "table"
          }
        }
      },
    timer = {
      type = "lib",
      description = [[

Timers allow you to call a function in the future with a specified delay.

Here is a first example of use:
    
    
    -- Play sound "secret" in one second.
    local function play_secret_sound()
      sol.audio.play_sound("secret")
    end
    
    sol.timer.start(1000, play_secret_sound)
    

Shorter version to do the same thing:
    
    
    -- Equivalent code using an anonymous function.
    sol.timer.start(1000, function()
      sol.audio.play_sound("secret")
    end)
    

You can repeat a timer by returning `true` from your function:
    
    
    -- Call a function every second.
    sol.timer.start(1000, function()
      sol.audio.play_sound("danger")
      return true  -- To call the timer again (with the same delay).
    end)
    

To make a timer that repeats itself 10 times, just return `false` after 10 calls:
    
    
    -- Call a function ten times, with one second between each call.
    local num_calls = 0
    sol.timer.start(1000, function()
      sol.audio.play_sound("danger")
      num_calls = num_calls + 1
      return num_calls < 10
    end)
    

It is possible to restrict the lifetime of a timer to a context, like the game, the map or an enemy:
    
    
    -- Enemy that shoots a fireball every 5 seconds until it is killed.
    sol.timer.start(your_enemy, 5000, function()
      sol.audio.play_sound("attack_fireball")
      map:create_enemy(...)  -- Code that creates the fireball.
      return true  -- Repeat the timer.
    end)
    

Setting the context to an enemy ensures that when the enemy is killed, the timer is canceled. Otherwise, the callback function would still be called: in this example, you would hear the `"attack_fireball"` sound and the fireball would be created even if the enemy is killed in the meantime.
]],
      childs = {
        start = {
          type = "function",
          description = [[

Sets a function to be called after a delay.

If the delay is set to zero, the function is called immediately.

  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html), [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), [state](http://www.solarus-games.org/doc/1.6/lua_api_state.html), [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) or [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html); optional): Determines the lifetime of the timer. The context is where the timer belongs.  
If the context gets closed before the timer is finished, then the timer is automatically canceled. More precisely, the following rules are applied.
    * If you set the context to a [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), the timer is canceled when the player goes to another map.  
Example: a button that opens a door for a limited time.
    * If you set the context to a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) or an [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html), the timer is canceled when the game is closed. (Items have the same lifetime as the game they belong to.) This is only possible when the game is running. Example: hot water that becomes cold after a few minutes, and that the player should bring to an NPC on another map while it's still hot.
    * If you set the context to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), the timer is canceled when the entity is removed from the map. In the case of an enemy, the timer is also canceled when the enemy is hurt, immobilized or restarts. Also note that while the entity is suspended, the timer is also suspended. An entity may be suspended when the [game is suspended](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_suspended), or when the entity is [disabled](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled).  
Example: a boss who shoots fireballs every 10 seconds. Most enemy scripts usually create timers.
    * If you set the context to a [state](http://www.solarus-games.org/doc/1.6/lua_api_state.html), the timer is canceled when the custom hero state finishes or when the hero is removed. Like entity timers, state timers get suspended when the hero is suspended. Example: charging an attack during 3 seconds in a custom state.
    * If you set the context to a [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html), the timer is canceled when the menu is closed.  
Example: in the title screen, show some animations after a few seconds without action from the user.
    * If you set the context to the [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) table, the timer is canceled when Lua is closed. Thus, it will be a global timer. This kind of timer is not often needed.  
Example: dumping some global information periodically while the program is running.
    * If you don't specify a context, then a default context is set for you: the current [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) during a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), and [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) if no game is running.
  * `delay` (number): Delay before calling the function in milliseconds.
  * `callback` (function): The function to be called when the timer finishes. If this callback function returns `true`, then the timer automatically repeats itself with the same delay. In this case, if the delay is shorter than the time of a cycle of the main loop, the callback may be executed several times in the same cycle in order to catch up.
  * Return value (timer): The timer created. Most of the time, you don't need to store the returned timer. Indeed, there is no problem if it gets garbage-collected: the timer persists in the engine side until its completion or the end of its context. Usually, you will store the return value only if you need to stop the timer explicitly later or to call another method on it.



Remarks
    When they are created, [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) timers, [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) timers and [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) timers are initially suspended if a dialog is active. After that, they get automatically suspended and unsuspended when the map is suspended or unsuspended. This default behavior is suited for most use cases, but if you want to change it, you can use [timer:set_suspended()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_set_suspended) and [timer:set_suspended_with_map()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_set_suspended_with_map).
]],
          args = "[context: map, game, item, map entity, state, menu or sol.main; optional], delay: number, callback: function",
          returns = "timer",
          valuetype = "timer"
          },
        stop_all = {
          type = "function",
          description = [[

Cancels all timers that are currently running in a context.

  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html), [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) or [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html)): The context where you want to stop timers.



This function is equivalent to calling [timer:stop()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_stop) on each timer of the context. It may allow you to avoid to store explicitly all your timers.

Remarks
    Canceling timers by hand may be tedious and error-prone. In lots of cases, you can simply pass a context parameter to [sol.timer.start()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_start) in order to restrict the lifetime of your timer to some other object.

#  Methods of the type timer
]],
          args = "context: map, game, item, map entity, menu or sol.main",
          returns = "",
          valuetype = ""
          }
        }
      },
    surface = {
      type = "lib",
      description = [[

A surface is a 2D image. It is essentially a rectangle of pixels. Its main feature is that you can draw objects on it.
]],
      childs = {
        create = {
          type = "function",
          description = [[

Creates a surface from an image file.

  * `file_name` (string): Name of the image file to load.
  * `language_specific` (boolean, optional): `true` to load the image from the `images` subdirectory of the current language directory (default is `false` and loads the image from the `sprites` directory).
  * Return value (surface): The surface created, or `nil` if the image file could not be loaded.



#  Methods inherited from drawable

Surfaces are particular [drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.

See [Methods of all drawable types](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.

#  Methods of the type surface

The following methods are specific to surfaces.
]],
          args = "file_name: string, [language_specific: boolean]",
          returns = "surface",
          valuetype = "surface"
          }
        }
      },
    text_surface = {
      type = "lib",
      description = [[

A text surface is a single line of text that you can display. A text surface can be seen as a special [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) able to contain text.
]],
      childs = {
        create = {
          type = "function",
          description = [[

Creates a text surface with the specified properties.

  * `properties` (optional table): A table that describes all properties of the text surface to create. Its key-value pairs are all optional, they can be:
    * `horizontal_alignment` (string, default `"left"`): `"left"`, `"center"` or `"right"`. When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
    * `vertical_alignment` (string, default `"middle"`): `"top"`, `"middle"` or `"bottom"`. When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
    * `font` (string, default the first one in alphabetical order): Name of the font file to use, relative to the `fonts` directory and without extension. It must be a declared in the resource list of the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html). The following extensions are auto-detected in this order: ```.png`, ```.ttf`, ```.otf`, ```.ttc` and ```.fon`.
    * `rendering_mode` (string, default `"solid"`): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).
    * `color` (table, default white): Color of the text to draw (array of 3 RGB values between 0 and 255). No effect on bitmap fonts.
    * `font_size` (number, default `11`): Font size to use. No effect on bitmap fonts.
    * `text` (string, default `""`): The text to show (must be valid UTF-8).
    * `text_key` (string, default `nil`): Key of the localized text to show. The string must exist in the file [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html) of the current [language](http://www.solarus-games.org/doc/1.6/lua_api_language.html).
    * Return value (text surface): The text surface created.



#  Methods inherited from drawable

Text surfaces are particular [drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.

See [Methods of all drawable types](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.

#  Methods of the type text surface

The following methods are specific to text surfaces.
]],
          args = "[properties: optional table]",
          returns = "text surface",
          valuetype = "text surface"
          }
        }
      },
    sprite = {
      type = "lib",
      description = [[

A sprite is an animated image. It is managed by an animation set. The animation set defines which animations are available and describes, for each animation, a sequence of images in each direction.

A sprite has the following properties:

  * a current animation from its animation set (like `"walking"` or `"hurt"`),
  * a current direction that indicates where the sprite is facing,
  * a current frame: the index of the current individual image in the sequence.



The animation set of a sprite is composed of one or several PNG images that store all the frames, and a data file that describes how frames are organized in the PNG images. The data file also indicates the delay to make between frames when animating them and other properties like whether the animation should loop. See the [sprites syntax](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) for more information about the format of sprites.

We describe here the Lua API that you can use to show sprites during your game or your menus.
]],
      childs = {
        create = {
          type = "function",
          description = [[

Creates a sprite.

  * `animation_set_id` (string): Name of the animation set to use. This name must correspond to a valid sprite sheet data file in the `sprites` directory (without its extension).
  * Return value (sprite): The sprite created, or `nil` if the sprite data file could not be loaded.



#  Methods inherited from drawable

Sprites are particular [drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.

See [Methods of all drawable types](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.

#  Methods of the type sprite

The following methods are specific to sprites.
]],
          args = "animation_set_id: string",
          returns = "sprite",
          valuetype = "sprite"
          }
        }
      },
    movement = {
      type = "lib",
      description = [[

If you need to move an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) of the map, a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) in a menu or simply an arbitrary point, you can create a movement object and set its properties. There are several types of movements. They differ by the kind of trajectory they can make. When you create a movement, you obtain a value of the movement type you chose. Then, to get and set its properties (like the speed, the angle, etc.), a movement object has several methods available. As detailed below, the methods available differ depending on the movement type because all movement types don't have the same properties.

The following movement types are available.

  * [Straight movement](http://www.solarus-games.org/doc/1.6/lua_api_straight_movement.html): Rectilinear trajectory in any direction.
  * [Random movement](http://www.solarus-games.org/doc/1.6/lua_api_random_movement.html): A straight movement whose direction changes randomly from time to time.
  * [Target movement](http://www.solarus-games.org/doc/1.6/lua_api_target_movement.html): Straight trajectory towards a possibly moving target.
  * [Path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html): Predetermined path composed of steps in the 8 main directions.
  * [Random path movement](http://www.solarus-games.org/doc/1.6/lua_api_random_path_movement.html): Like a path movement, but with random steps.
  * [Path finding movement](http://www.solarus-games.org/doc/1.6/lua_api_path_finding_movement.html): Like a path movement, but calculated to reach a possibly moving target.
  * [Circle movement](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html): Circular trajectory around a possibly moving center.
  * [Jump movement](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html): An illusion of jump above a baseline.
  * [Pixel movement](http://www.solarus-games.org/doc/1.6/lua_api_pixel_movement.html): A trajectory described pixel by pixel.



This page desribes the methods and callbacks common to all movement types.

Movements can be applied in-game to [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), but also outside a game, typically in a [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) to move a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), an [image](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) or just an `(x,y)` value. However, some properties of movements (like [movement:set_ignore_obstacles()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_set_ignore_obstacles)) only take effect in the case of a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) because they refer to [map-specific](http://www.solarus-games.org/doc/1.6/lua_api_map.html) notions like obstacles.
]],
      childs = {
        create = {
          type = "function",
          description = [[

Creates a movement.

Depending on the movement type, several methods are then available to get and set its properties.

  * `movement_type` (string): Type of movement to create. Must be one of:
    * `"straight"`: Follows a rectilinear trajectory.
    * `"random"`: Like "straight" but with random, changing angles.
    * `"target"`: Like "straight" but goes into the direction of a fixed point or a moving entity.
    * `"path"`: Follows a specified succession of basic moves on an 8x8 pixels grid.
    * `"random_path"`: Like "path" but computes the path randomly.
    * `"path_finding"`: Like "path" but computes the shortest path to an entity, avoiding obstacles of the map (only possible in game).
    * `"circle"`: Follows a circular trajectory around a center.
    * `"jump"`: Makes a jump above a rectilinear trajectory.
    * `"pixel"`: Follows a trajectory specified pixel by pixel.
  * Return value (movement): The movement created. See the sections below to know the get and set methods available for your movement type.



#  Methods of all movement types

These methods exist in all movement types.
]],
          args = "movement_type: string",
          returns = "movement",
          valuetype = "movement"
          }
        }
      },
    game = {
      type = "lib",
      description = [[

This module provides a datatype "game" that represents a savegame.
]],
      childs = {
        exists = {
          type = "function",
          description = [[

Returns whether the specified savegame file exists.

A valid quest write directory must be set (in your [quest.dat file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.

  * `file_name` (string): Name of the file to test, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).
  * Return value (boolean): `true` if there exists a file with this name in the quest write directory.


]],
          args = "file_name: string",
          returns = "boolean",
          valuetype = "boolean"
          },
        delete = {
          type = "function",
          description = [[

Deletes a savegame file.

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.

  * `file_name` (string): Name of the file to delete, relative to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).


]],
          args = "file_name: string",
          returns = "",
          valuetype = ""
          },
        load = {
          type = "function",
          description = [[

Loads an existing savegame, or initializes a new one if it does not exist (but does not save it).

A valid quest write directory must be set (in your [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.

  * `file_name` (string): Name of a savegame file, relative to the to the [quest write directory](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_quest_write_dir).
  * Return value (game): The loaded (or created) game.



Remarks
    This function does not start the game, it just loads the savegame file and initializes all [equipment item scripts](http://www.solarus-games.org/doc/1.6/lua_api_item.html). Then you can access the data saved in the savegame file and use the API of equipment items. To actually run the game, call [game:start()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start).

#  Methods of the type game
]],
          args = "file_name: string",
          returns = "game",
          valuetype = "game"
          }
        }
      },
    state = {
      type = "lib",
      description = [[

This module provides a datatype `state` that represents a custom state allowing advanced customization of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
]],
      childs = {
        create = {
          type = "function",
          description = [[

Creates a custom state but does not start it yet.

  * `description` (string, optional): An optional description of your state. The engine does nothing special with this description, but it may help you distinguish states.
  * Return value (state): The custom state created.



#  Methods of the type state
]],
          args = "[description: string]",
          returns = "state",
          valuetype = "state"
          }
        }
      }
    }
  },
shader = {
  type = "class",
  description = [[

This module provides a datatype `shader` that represents an OpenGL or OpenGL ES shader program.
]],
  childs = {
    get_id = {
      type = "method",
      description = [[

Returns the id of this shader program.

  * Return value (string): Id of this shader program (filename without extension).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_vertex_file = {
      type = "method",
      description = [[

Returns the name of the vertex shader file of this shader program.

  * Return value (string): The vertex shader file name, relative to the `"shaders"` directory, or `nil` if no vertex shader file was set.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_vertex_source = {
      type = "method",
      description = [[

Returns the vertex shader code of this shader program.

  * Return value (string): The vertex shader code. If no vertex shader was set, returns the default vertex shader code.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_fragment_file = {
      type = "method",
      description = [[

Returns the name of the fragment shader file of this shader program.

  * Return value (string): The fragment shader file name, relative to the `"shaders"` directory, or `nil` if no fragment shader file was set.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_fragment_source = {
      type = "method",
      description = [[

Returns the fragment shader code of this shader program.

  * Return value (string): The fragment shader code. If no fragment shader was set, returns the default fragment shader code.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_scaling_factor = {
      type = "method",
      description = [[

Returns the scaling factor of this shader.

The scaling factor indicates how much the input texture will be scaled by the shader. See [shader:set_scaling_factor()](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_set_scaling_factor) for more details.

  * Return value (number): The scaling factor. Returns `nil` if no scaling factor is set.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_scaling_factor = {
      type = "method",
      description = [[

Sets the scaling factor of this shader.

The scaling factor indicates how much the input texture will be scaled by the shader when the shader is applied to the window.

This value only has an effect when the shader is applied to the window (with [sol.video.set_shader()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_set_shader)), and does nothing when the shader is applied to a drawable object (with [drawable:set_shader()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_shader)).

If no value is set (the default), then the output texture of the shader will directly have the size of the window. If a value is set, then the output texture of the shader will have the size of the input texture multiplied by this scaling factor (however, that output texture will then be scaled a second time to fit to the actual window). This is only useful for scaling shaders.

  * `scaling_factor` (number): The scaling factor. A `nil` value means to set no scaling factor.


]],
      args = "scaling_factor: number",
      returns = "",
      valuetype = ""
      },
    set_uniform = {
      type = "method",
      description = [[

Sets a uniform value to this shader.

Uniforms are input values to shader programs that are constant for all vertices and pixels during one rendering frame. Solarus automatically sets some uniform variables for you if you define them in the shader (see the [built-in variables](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_overview_built_in_variables) section above).

Use this function if you want to pass additional uniform values.

The type of the uniform in your shader source code will depend on the Lua type you pass here:

  * A `boolean:` should be declared as `bool` in the shader.
  * A `number:` should be declared as `float` in the shader.
  * An array of two `number`s: should be declared as `vec2` in the shader.
  * An array of three `number`s: should be declared as `vec3` in the shader.
  * An array of four `number`s: should be declared as `vec4` in the shader.
  * A [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html): should be declared as `sampler2D` in the shader.



If the shader has no uniform with the given name, then this method does nothing.

  * `uniform_name` (string): Name of the uniform in your shader program.
  * value (boolean, number, table or surface): The value to set. If it is a table, it should be an array of 2, 3 or 4 numbers.



Remarks
    If the value is a [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html), it is passed by reference. This means that if you modify the surface later, the shader with automatically have its updated content. 
]],
      args = "uniform_name: string, value: boolean, number, table or surface",
      returns = "",
      valuetype = ""
      }
    }
  },
menu = {
  type = "class",
  description = [[

To display various information such as a title screen, a dialog box, a HUD (head-up display) or a pause screen, you can use one or several menus.

A menu is an arbitrary Lua table. A menu belongs to a context that may be the current [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), the current [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), the [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) table or even another menu. This context is the lifetime of your menu. As long as your menu is active, the engine will call events that are defined in your table, i.e. callback methods like [menu:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_started) [menu:on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_draw), [menu:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_key_pressed), etc., to notify your menu of something (the player pressed a key, your menu needs to be redrawn, etc.).

This menu API does not provide anything fundamental: indeed, the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) and [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) APIs already provide the necessary features, so you could do what you want from there manually. But the API described on this page makes your life easier because menus automatically receive events whenever they need to be notified, and automatically stop being active when their context no longer exists.
]],
  childs = {
    on_started = {
      type = "method",
      description = [[

Called when your menu is started.

This event is triggered when you call [sol.menu.start()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_start).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_finished = {
      type = "method",
      description = [[

Called when your menu is stopped.

This event is triggered when you call [sol.menu.stop()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_stop) or when the context of your menu finishes.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle of the main loop while your menu is active.

Menus of are updated in the following order:

  1. [Map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) menus (only during a game).
  2. [Game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) menus (only during a game).
  3. [Main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) menus (the more general ones).



When several menus exist in the same context, they are updated from the back one to the front one. You can control this order thanks to the `on_top` parameter of [menu:start()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_start) when you start a menu.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_draw = {
      type = "method",
      description = [[

Called when your menu has to be redrawn.

Use this event to draw your menu.

  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The surface where you should draw your menu.



Menus of are drawn in the following order:

  1. [Map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) menus (only during a game).
  2. [Game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) menus (only during a game).
  3. [Main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) menus (the more general ones).



When several menus exist in the same context, they are drawn from the back one to the front one. You can control this order thanks to the `on_top` parameter of [sol.menu.start()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_start) when you start a menu, or with [sol.menu.bring_to_front()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_bring_to_front) and [sol.menu.bring_to_back()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_bring_to_back)
]],
      args = "dst_surface: surface",
      returns = "",
      valuetype = ""
      },
    on_key_pressed = {
      type = "method",
      description = [[

Called when the user presses a keyboard key while your menu is active.

  * `key` (string): Name of the raw key that was pressed.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).



For all keyboard, joypad and mouse events, menus are notified from the front one to the back one. For example, if some dialog box is shown during the pause menu and appears above that pause menu, it will naturally receive keyboard and joypad events first.

When a menu handles the event, it should return `true` to make the event stop being propagated. Menus (and other objects) below it won't be notified then. On the contrary, if no script has handled the event, then the engine can handle it with a built-in behavior.

Remarks
    This event indicates the raw key pressed. If you want the corresponding character instead (if any), see [menu:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_character_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_key_released = {
      type = "method",
      description = [[

Called when the user releases a keyboard key while your menu is active. Menus on top are notified first.

  * `key` (string): Name of the raw key that was released.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).


]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_character_pressed = {
      type = "method",
      description = [[

Called when the user enters text while your menu is active. Menus on top are notified first.

  * `character` (string): A utf-8 string representing the character that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).



Remarks
    When a character key is pressed, two events are called: [menu:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_key_pressed) (indicating the raw key) and [menu:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_character_pressed) (indicating the utf-8 character). If your menu needs to input text from the user, [menu:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
]],
      args = "character: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_pressed = {
      type = "method",
      description = [[

Called when the user presses a joypad button while your menu is active. Menus on top are notified first.

  * `button` (number): Index of the button that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_released = {
      type = "method",
      description = [[

Called when the user releases a joypad button while your menu is active. Menus on top are notified first.

  * `button` (number): Index of the button that was released.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_axis_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad axis while your menu is active. Menus on top are notified first.

  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).


]],
      args = "axis: number, state: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_hat_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad hat while your menu is active. Menus on top are notified first.

  * `hat` (number): Index of the hat that was moved.
  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)).


]],
      args = "hat: number, direction8: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_pressed = {
      type = "method",
      description = [[

Called during a game when the player presses a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). You can use this event to override the normal built-in behavior of the game command. Menus on top are notified first.

  * `command` (string): Name of the built-in game command that was pressed (see the [game API](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) for the list of existing game commands).
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).



Remarks
    As the notion of game commands only exist during a game, this event is only called for game menus and map menus.
     This event is not triggered if you already handled the underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_released = {
      type = "method",
      description = [[

Called during a game when the player released a game command (a keyboard key or a joypad action mapped to a built-in game behavior). You can use this event to override the normal built-in behavior of the game command. Menus on top are notified first.

  * `command` (string): Name of the built-in game command that was released (see the [game API](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) for the list of existing game commands).
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).



Remarks
    As the notion of game commands only exist during a game, this event is only called for game menus and map menus.
     This event is not triggered if you already handled the underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_pressed = {
      type = "method",
      description = [[

Called when the user presses a mouse button while this menu is active. Menus on top are notified first.

  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_released = {
      type = "method",
      description = [[

Called when the user releases a mouse button while this menu is active.

  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_pressed = {
      type = "method",
      description = [[

Called when the user presses a finger while the menu is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_released = {
      type = "method",
      description = [[

Called when the user releases a finger while the menu is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_moved = {
      type = "method",
      description = [[

Called when the user moves a finger while the menu is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dx` (integer): The horizontal distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dy` (integer): The vertical distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. 


]],
      args = "finger: integer, x: integer, y: integer, dx: integer: integer, dy: integer: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      }
    }
  },
timer = {
  type = "class",
  description = [[

Timers allow you to call a function in the future with a specified delay.

Here is a first example of use:
    
    
    -- Play sound "secret" in one second.
    local function play_secret_sound()
      sol.audio.play_sound("secret")
    end
    
    sol.timer.start(1000, play_secret_sound)
    

Shorter version to do the same thing:
    
    
    -- Equivalent code using an anonymous function.
    sol.timer.start(1000, function()
      sol.audio.play_sound("secret")
    end)
    

You can repeat a timer by returning `true` from your function:
    
    
    -- Call a function every second.
    sol.timer.start(1000, function()
      sol.audio.play_sound("danger")
      return true  -- To call the timer again (with the same delay).
    end)
    

To make a timer that repeats itself 10 times, just return `false` after 10 calls:
    
    
    -- Call a function ten times, with one second between each call.
    local num_calls = 0
    sol.timer.start(1000, function()
      sol.audio.play_sound("danger")
      num_calls = num_calls + 1
      return num_calls < 10
    end)
    

It is possible to restrict the lifetime of a timer to a context, like the game, the map or an enemy:
    
    
    -- Enemy that shoots a fireball every 5 seconds until it is killed.
    sol.timer.start(your_enemy, 5000, function()
      sol.audio.play_sound("attack_fireball")
      map:create_enemy(...)  -- Code that creates the fireball.
      return true  -- Repeat the timer.
    end)
    

Setting the context to an enemy ensures that when the enemy is killed, the timer is canceled. Otherwise, the callback function would still be called: in this example, you would hear the `"attack_fireball"` sound and the fireball would be created even if the enemy is killed in the meantime.
]],
  childs = {
    stop = {
      type = "method",
      description = [[

Cancels this timer.

If the timer was already finished or canceled, nothing happens.

Remarks
    Canceling timers by hand may be tedious and error-prone. In lots of cases, you can simply pass a context parameter to [sol.timer.start()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_start) in order to restrict the lifetime of your timer to some other object.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_with_sound = {
      type = "method",
      description = [[

Returns whether a clock sound is played repeatedly during this timer.

  * Return value (boolean): `true` if a clock sound is played with this timer.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_with_sound = {
      type = "method",
      description = [[

Sets whether a clock sound is played repeatedly during this timer.

  * `with_sound` (boolean, optional): `true` to play a clock sound repeatedly (no value means `true`).


]],
      args = "with_sound: boolean",
      returns = "",
      valuetype = ""
      },
    is_suspended = {
      type = "method",
      description = [[

Returns whether this timer is currently suspended.

  * Return value (boolean): `true` if this timer is currently suspended.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_suspended = {
      type = "method",
      description = [[

Returns whether this timer is currently suspended.

  * `suspended` (boolean, optional): `true` to suspend the timer, `false` to unsuspend it (no value means `true`).


]],
      args = "[suspended: boolean]",
      returns = "",
      valuetype = ""
      },
    is_suspended_with_map = {
      type = "method",
      description = [[

Returns whether this timer gets automatically suspended when the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is suspended.

  * Return value (boolean): `true` if this timer gets suspended when the map is suspended.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_suspended_with_map = {
      type = "method",
      description = [[

Sets whether this timer should automatically be suspended when the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) gets suspended.

The map is suspended by the engine in a few cases, like when the game is paused, when there is a dialog or when the camera is being moved by a script. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation. With this setting, you can choose whether your timer gets suspended automatically as well.

By default, [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) timers, [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) timers, [state](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) timers and [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) timers are suspended with the map.

  * `suspended_with_map` (boolean, optional): `true` to suspend the timer when the map is suspended, `false` to continue (no value means `true`).



Remarks
    When this setting is `true`, entity timers also get automatically suspended when the entity is [disabled](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled).
]],
      args = "[suspended_with_map: boolean]",
      returns = "",
      valuetype = ""
      },
    get_remaining_time = {
      type = "method",
      description = [[

Returns the remaining time of this timer.

  * Return value (number): The time remaining in milliseconds. `0` means that the timer is finished (or will finish in the current cycle) or was canceled.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_remaining_time = {
      type = "method",
      description = [[

Changes the remaining time of this timer.

This function has no effect if the timer is already finished.

  * `remaining_time` (number): The time remaining in milliseconds. `0` makes the timer finish now and immediately executes its callback.



Remarks
    When a timer is repeated (that is, if its callback returns `true` or a number), the timer gets rescheduled with its full delay again, no matter if you called this function in the meantime. 
]],
      args = "remaining_time: number",
      returns = "",
      valuetype = ""
      }
    }
  },
surface = {
  type = "class",
  description = [[

A surface is a 2D image. It is essentially a rectangle of pixels. Its main feature is that you can draw objects on it.
]],
  childs = {
    get_size = {
      type = "method",
      description = [[

Returns the size of this surface.

  * Return value 1 (number): Width of the surface in pixels.
  * Return value 2 (number): Height of the surface in pixels.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    clear = {
      type = "method",
      description = [[

Erases all pixels of this surface.

All pixels become transparent. The opacity property and the size of the surface are preserved.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    fill_color = {
      type = "method",
      description = [[

Fills a region of this surface with a color.

If no region is specified, the entire surface is filled. If the color has an alpha component different from 255 (opaque), then the color is blended onto the existing pixels.

  * `color` (table): The color as an array of 3 RGB values or 4 RGBA values (`0` to `255`).
  * `x` (number, optional): X coordinate of the region to fill on this surface.
  * `y` (number, optional): Y coordinate of the region to fill on this surface.
  * `width` (number, optional): Width of the region to fill on this surface.
  * `height` (number, optional): Height of the region to fill on this surface.


]],
      args = "color: table, [x: number, y: number, width: number, height: number]",
      returns = "",
      valuetype = ""
      },
    get_pixels = {
      type = "method",
      description = [[

Returns all pixel values of this surface.

  * Return value (string): The pixels as a pack of bytes in 32-bit RGBA format. Every pixel is stored on 4 bytes (red, green, blue, alpha).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_pixels = {
      type = "method",
      description = [[

Sets all pixel values of this surface.

The number of pixels should match the size of the surface (the size does not change).

  * `pixels` (string): The pixels as a pack of bytes in 32-bit RGBA format. Every pixel is stored on 4 bytes (red, green, blue, alpha).


]],
      args = "pixels: string",
      returns = "",
      valuetype = ""
      },
    gl_bind_as_target = {
      type = "method",
      description = [[

Binds this surface as a target for next OpenGL calls.

This method is only useful for advanced users who want to directly call OpenGL primitives, which is possible with Lua bindings, for example via LuaJIT FFI.

This is equivalent to `glBindFramebuffer(GL_DRAW_FRAMEBUFFER, ...)`. It will make this surface the destination for any further OpenGL draw call.

When you call OpenGL directly, it is your responsability to restore the OpenGL state if you want the Solarus rendering to remain correct. In particular, pay attention to restore :

  * The currently bound `glProgram`
  * The current `glBlendModes`
  * The currently bound `VertexBufferObjects`
  * Face culling and alpha tests.



Remarks
    Note that Solarus surfaces have no depth buffer attached. A new framebuffer with depth attachement must be used to benefit from `GL_DEPTH_TEST`.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    gl_bind_as_texture = {
      type = "method",
      description = [[

Bind this surface as the current texture for next OpenGL calls.

This method is only useful for advanced users who want to directly call OpenGL primitives, which is possible with Lua bindings, for example via LuaJIT FFI.

This is equivalent to `glBindTexture(...)`.

See [surface:gl_bind_as_target()](http://www.solarus-games.org/doc/1.6/lua_api_surface.html#lua_api_surface_gl_bind_as_target) for details about calling OpenGL directly. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "drawable"
  },
text_surface = {
  type = "class",
  description = [[

A text surface is a single line of text that you can display. A text surface can be seen as a special [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) able to contain text.
]],
  childs = {
    get_horizontal_alignment = {
      type = "method",
      description = [[

Returns the horizontal alignment of the text.

When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.

  * Return value (string): `"left"`, `"center"` or `"right"`.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_horizontal_alignment = {
      type = "method",
      description = [[

Sets the horizontal alignment of the text.

When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.

  * `horizontal_alignment` (string): `"left"`, `"center"` or `"right"`.


]],
      args = "horizontal_alignment: string",
      returns = "",
      valuetype = ""
      },
    get_vertical_alignment = {
      type = "method",
      description = [[

Returns the vertical alignment of the text.

When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.

  * Return value (string): `"top"`, `"middle"` or `"bottom"`.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_vertical_alignment = {
      type = "method",
      description = [[

Sets the vertical alignment of the text.

When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.

  * `vertical_alignment` (string): `"top"`, `"middle"` or `"bottom"`.


]],
      args = "vertical_alignment: string",
      returns = "",
      valuetype = ""
      },
    get_font = {
      type = "method",
      description = [[

Returns the font used to draw this text surface.

  * Return value (string): Id of the font of this text surface.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_font = {
      type = "method",
      description = [[

Sets the font used to draw this text surface.

  * `font_id` (string): Name of the font file to use, relative to the `fonts` directory and without extension. It must be a declared in the resource list of the [quest database](http://www.solarus-games.org/doc/1.6/quest_database_file.html). The following extensions are auto-detected in this order: ```.png`, ```.ttf`, ```.ttc` and ```.fon`.


]],
      args = "font_id: string",
      returns = "",
      valuetype = ""
      },
    get_rendering_mode = {
      type = "method",
      description = [[

Returns the rendering mode of the text.

  * Return value (string): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_rendering_mode = {
      type = "method",
      description = [[

Sets the rendering mode of the text.

  * `rendering_mode` (string): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).


]],
      args = "rendering_mode: string",
      returns = "",
      valuetype = ""
      },
    get_color = {
      type = "method",
      description = [[

Returns the color used to draw the text.

This only has an effect for outline fonts.

  * Return value (table): The text color as an array of 3 RGB values (`0` to `255`).


]],
      args = "",
      returns = "table",
      valuetype = "table"
      },
    set_color = {
      type = "method",
      description = [[

Sets the color used to draw the text.

This only has an effect for outline fonts.

  * `color` (table): The text color as an array of 3 RGB values (`0` to `255`).


]],
      args = "color: table",
      returns = "",
      valuetype = ""
      },
    get_font_size = {
      type = "method",
      description = [[

Returns the font size used to draw the text.

This only has an effect for outline fonts.

  * Return value (number): The font size.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_font_size = {
      type = "method",
      description = [[

Sets the size used to draw the text.

This only has an effect for outline fonts.

  * `font_size` (number): The font size.


]],
      args = "font_size: number",
      returns = "",
      valuetype = ""
      },
    get_text = {
      type = "method",
      description = [[

Returns the string displayed in this object.

  * Return value (string): The current text (possibly an empty string).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_text = {
      type = "method",
      description = [[

Sets the string displayed in this object.

The string must be encoded in UTF-8.

  * `text` (string, optional): The text to set. No value or an empty string mean no text.


]],
      args = "[text: string]",
      returns = "",
      valuetype = ""
      },
    set_text_key = {
      type = "method",
      description = [[

Sets the text as a localized string in the current language.

  * `key` (string): Key of the text to set.



Remarks
    This function is equivalent to `text_surface:set_text(sol.language.get_string(key))`.
]],
      args = "key: string",
      returns = "",
      valuetype = ""
      },
    get_size = {
      type = "method",
      description = [[

Returns the size of this text surface.

  * Return value 1 (number): Width of the text surface in pixels.
  * Return value 2 (number): Height of the text surface in pixels.



Remarks
    Note that you cannot set the size of a text surface. The size is determined by the text and the font. 
]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      }
    },
  inherits = "drawable"
  },
sprite = {
  type = "class",
  description = [[

A sprite is an animated image. It is managed by an animation set. The animation set defines which animations are available and describes, for each animation, a sequence of images in each direction.

A sprite has the following properties:

  * a current animation from its animation set (like `"walking"` or `"hurt"`),
  * a current direction that indicates where the sprite is facing,
  * a current frame: the index of the current individual image in the sequence.



The animation set of a sprite is composed of one or several PNG images that store all the frames, and a data file that describes how frames are organized in the PNG images. The data file also indicates the delay to make between frames when animating them and other properties like whether the animation should loop. See the [sprites syntax](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) for more information about the format of sprites.

We describe here the Lua API that you can use to show sprites during your game or your menus.
]],
  childs = {
    get_animation_set = {
      type = "method",
      description = [[

Returns the name of the animation set used by this sprite.

  * Return value (string): Name of the animation set used by this sprite. This name corresponds to a sprite sheet data file in the `sprites` directory (without its extension).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    has_animation = {
      type = "method",
      description = [[

Returns whether the specified animation exists on a sprite.

  * `animation_name` (string): Name of the animation to check.
  * Return value (boolean): `true` if the sprite animation set contains an animation with this name.


]],
      args = "animation_name: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_animation = {
      type = "method",
      description = [[

Returns the name of the current animation of this sprite.

  * Return value (string): Name of the current animation.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_animation = {
      type = "method",
      description = [[

Sets the current animation of this sprite.

  * `animation_name` (string): Name of the animation to set. This animation must exist in the animation set.
  * `next_action` (function or string, optional): What to do when the animation finishes. This parameter only has an effect if the animation finishes, that is, if it does not loop. If you pass a function, this function will be called when the animation finishes. If you pass a string, this should be the name of an animation of the sprite, and this animation will automatically be played next. No value means no action after the animation finishes: in this case, the sprite stops being displayed.


]],
      args = "animation_name: string, [next_action: function or string]",
      returns = "",
      valuetype = ""
      },
    stop_animation = {
      type = "method",
      description = [[

Stops playing the current animation of this sprite.

The sprite stops being displayed, like when the last frame finishes.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_animation_started = {
      type = "method",
      description = [[

Returns whether the current animation is being played.

  * Return value (boolean): `true` if the current animation is playing, `false` if it is finished or was [stopped](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html#lua_api_sprite_stop_animation).


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_direction = {
      type = "method",
      description = [[

Returns the current direction of this sprite.

  * Return value (number): The current direction (the first one is `0`).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_direction = {
      type = "method",
      description = [[

Sets the current direction of this sprite.

  * `direction` (number): The direction to set (the first one is `0`). This direction must exist in the current animation.


]],
      args = "direction: number",
      returns = "",
      valuetype = ""
      },
    get_num_directions = {
      type = "method",
      description = [[

Returns the number of direction of an animation of this sprite.

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * Return value (number): The number of directions in this animation.


]],
      args = "[animation_name: string]",
      returns = "number",
      valuetype = "number"
      },
    get_frame = {
      type = "method",
      description = [[

Returns the index of the current frame of this sprite.

  * Return value (number): The current frame (the first one is `0`).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_frame = {
      type = "method",
      description = [[

Sets the current frame of this sprite.

  * `frame` (number): The frame to set (the first one is `0`). This frame must exist in the current direction.


]],
      args = "frame: number",
      returns = "",
      valuetype = ""
      },
    get_num_frames = {
      type = "method",
      description = [[

Returns the number of frames of this sprites in an animation and direction.

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`. No value means the current direction.
  * Return value (number): The number of frames.


]],
      args = "[animation_name: string, direction: number]",
      returns = "number",
      valuetype = "number"
      },
    get_frame_delay = {
      type = "method",
      description = [[

Returns the delay between two frames of this sprite in an animation.

The delay of the current animation may be overriden by [set_frame_delay()](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html#lua_api_sprite_set_frame_delay).

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * Return value (number): The delay in milliseconds between two frames in the current animation. `nil` means infinite and it is only allowed for single-frame animations.


]],
      args = "[animation_name: string]",
      returns = "number",
      valuetype = "number"
      },
    set_frame_delay = {
      type = "method",
      description = [[

Changes the delay between two frames of this sprite in the current animation.

Use this function if you want to override the normal delay (the one defined in the sprite data file).

  * `delay` (number): The new delay in milliseconds. `nil` means infinite and is only allowed for single-frame animations.


]],
      args = "delay: number",
      returns = "",
      valuetype = ""
      },
    get_size = {
      type = "method",
      description = [[

Returns the frame size of this sprite in an animation and direction.

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`.
  * Return value 1 (number): The width of a frame.
  * Return value 2 (number): The height of a frame.


]],
      args = "[animation_name: string, direction: number]",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_origin = {
      type = "method",
      description = [[

Returns the coordinates of the origin point of this sprite in an animation and direction, relative to the upper left corner of a frame.

The origin is the point of synchronization for sprites that have several animations or directions of different sizes, and for entity sprites that are larger than the entity itself.

See [entity:get_origin()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) for more details.

In a given animation and direction of a sprite, the origin point is the same for all frames.

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`.
  * Return value 1 (number): X coordinate of the origin point.
  * Return value 2 (number): Y coordinate of the origin point.


]],
      args = "[animation_name: string, direction: number]",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_frame_src_xy = {
      type = "method",
      description = [[

Returns the coordinates of a frame in its source image.

  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`. No value means the current direction.
  * `frame` (number, optional): A frame number. No value means the current frame.
  * Return value 1 (number): X coordinate of the upper left corner of the frame in its source image.
  * Return value 2 (number): Y coordinate of the upper left corner of the frame in its source image.


]],
      args = "[animation_name: string, direction: number, frame: number]",
      returns = "number,number",
      valuetype = "number,number"
      },
    is_paused = {
      type = "method",
      description = [[

Returns whether this sprite is paused.

  * Return value (boolean): `true` if this sprite is paused.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_paused = {
      type = "method",
      description = [[

Pauses or resumes the animation of this sprite.

  * `paused` (boolean, optional): `true` to pause the sprite, `false` to unpause it. No value means `true`.


]],
      args = "[paused: boolean]",
      returns = "",
      valuetype = ""
      },
    get_ignore_suspend = {
      type = "method",
      description = [[

Returns whether the animation should continue even when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is suspended.

This setting only has an effect when a game is running. The default value is `false`.

  * Return value (boolean): `true` to continue the animation even when the game is suspended.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_ignore_suspend = {
      type = "method",
      description = [[

Sets whether the animation should continue even when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is suspended.

  * `ignore` (boolean, optional): `true` to continue the animation even when the game is suspended. No value means `true`.


]],
      args = "[ignore: boolean]",
      returns = "",
      valuetype = ""
      },
    synchronize = {
      type = "method",
      description = [[

Synchronizes the frames of this sprite with the frames of a reference sprite. The synchronization will be performed whenever both animation names match. The current sprite will no longer apply its normal frame delay: instead, it will now always set its current frame to the current frame of its reference sprite.

  * `reference_sprite` (sprite, optional): The reference sprite. `nil` means stopping any previous synchronization.



#  Events of the type sprite

Events are callback methods automatically called by the engine if you define them.

The following events are specific to sprites.
]],
      args = "[reference_sprite: sprite]",
      returns = "",
      valuetype = ""
      },
    on_animation_finished = {
      type = "method",
      description = [[

Called when the current animation of this sprite is finished.

If the animation loops, this function is never called. Unless you start another animation, the sprite is no longer shown.

  * `animation` (string): Name of the animation that has just finished.


]],
      args = "animation: string",
      returns = "",
      valuetype = ""
      },
    on_animation_changed = {
      type = "method",
      description = [[

Called whenever the animation of this sprite has changed.

  * `animation` (string): Name of the new animation.


]],
      args = "animation: string",
      returns = "",
      valuetype = ""
      },
    on_direction_changed = {
      type = "method",
      description = [[

Called whenever the direction of this sprite has changed.

  * `animation` (string): Name of the current animation.
  * `direction` (number): The new current direction (the first one is `0`).


]],
      args = "animation: string, direction: number",
      returns = "",
      valuetype = ""
      },
    on_frame_changed = {
      type = "method",
      description = [[

Called whenever the frame of this sprite has changed.

  * `animation` (string): Name of the current animation.
  * `frame` (number): The new current frame (the first one is `0`). 


]],
      args = "animation: string, frame: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "drawable"
  },
drawable = {
  type = "class",
  description = [[

Drawable objects are things that can be drawn on a destination surface. They include the following types: [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html), [text surface](http://www.solarus-games.org/doc/1.6/lua_api_text_surface.html) and [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html). This page describes the methods common to those types.
]],
  childs = {
    draw = {
      type = "method",
      description = [[

Draws this object on a destination surface.

  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The destination surface.
  * `x` (number, optional): X coordinate of where to draw this object (default `0`).
  * `y` (number, optional): Y coordinate of where to draw this object. (default `0`).


]],
      args = "dst_surface: surface, [x: number, y: number]",
      returns = "",
      valuetype = ""
      },
    draw_region = {
      type = "method",
      description = [[

Draws a subrectangle of this object on a destination surface.

  * `region_x` (number): X coordinate of the subrectangle to draw.
  * `region_y` (number): Y coordinate of the subrectangle to draw.
  * `region_width` (number): Width of the subrectangle to draw.
  * `region_height` (number): Height of the subrectangle to draw.
  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The destination surface.
  * `x` (number, optional): X coordinate of where to draw this rectangle on the destination surface (default `0`).
  * `y` (number, optional): Y coordinate of where to draw this rectangle. on the destination surface (default `0`).


]],
      args = "region_x: number: number, region_y: number: number, region_width: number, region_height: number, dst_surface: surface, [x: number, y: number]",
      returns = "",
      valuetype = ""
      },
    get_rotation = {
      type = "method",
      description = [[

Returns the rotation angle of this object around its [transformation origin](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_transformation_origin). The rotation angle is in radians and goes in trigonometric direction.

  * Return value (number): The rotation angle in radians around the transformation origin. `0` means no rotation.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_rotation = {
      type = "method",
      description = [[

Sets the rotation angle of this object around its [transformation origin](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_transformation_origin). The rotation angle is in radians and goes in trigonometric direction.

  * `rotation` (number): The rotation angle in radians around the transformation origin. `0` means no rotation.


]],
      args = "rotation: number",
      returns = "",
      valuetype = ""
      },
    get_scale = {
      type = "method",
      description = [[

Returns the scaling factors of this drawable object.

  * Return value 1 (number): Scale factor in the X dimension.
  * Return value 2 (number): Scale factor in the Y dimension.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_scale = {
      type = "method",
      description = [[

Set the scale factors for this drawable object. A scale of `1` corresponds to a normal size. A negative scale will flip the drawable in the corresponding axis. Scaling is performed around the [transformation origin](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_transformation_origin).

  * `x` (number) : Scale factor in the X dimension.
  * `y` (number) : Scale factor in the Y dimension.


]],
      args = "x, y",
      returns = "",
      valuetype = ""
      },
    get_transformation_origin = {
      type = "method",
      description = [[

Returns the transformation origin of this drawable object. The tranformation origin point is the pivot point used for rotation and scaling.

The transformation point is relative to the origin point of the drawable object, which is always the upper-left corner for [surfaces](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) and [text surfaces](http://www.solarus-games.org/doc/1.6/lua_api_text_surface.html), and the sprite origin point for [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html).

  * Return value 1 (number): X coordinate of the transform point.
  * Return value 2 (number): Y coordinate of the transform point.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_transformation_origin = {
      type = "method",
      description = [[

Set the transformation origin point of this drawable object. The tranformation origin point is the pivot point used for rotation and scaling.

The transformation point is relative to the origin point of the drawable object, which is always the upper-left corner for [surfaces](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) and [text surfaces](http://www.solarus-games.org/doc/1.6/lua_api_text_surface.html), and the sprite origin point for [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html).

  * `x` (number): X coordinate of the transformation origin.
  * `y` (number): Y coordinate of the transformation origin.


]],
      args = "x: number, y: number",
      returns = "",
      valuetype = ""
      },
    get_blend_mode = {
      type = "method",
      description = [[

Returns the blend mode of this drawable object.

The blend mode defines how this drawable object will be drawn on other surfaces when you call [drawable:draw()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw) or [drawable:draw_region()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw_region).

  * Return value (string): The blend mode. See [drawable:set_blend_mode()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_blend_mode) for the possible values.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_blend_mode = {
      type = "method",
      description = [[

Sets the blend mode of this drawable object.

The blend mode defines how this drawable object will be drawn on other surfaces when you call [drawable:draw()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw) or [drawable:draw_region()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw_region).

  * `blend_mode` (string): The blend mode. Can be one of:
    * `"none"`: No blending. The destination surface is replaced by the pixels of this drawable object.  
`dstRGBA = srcRGBA`
    * `"blend"` (default): This drawable object is alpha-blended onto the destination surface.  
`dstRGB = (srcRGB * srcA) + (dstRGB * (1 - srcA))`  
`dstA = srcA + (dstA * (1 - srcA))`
    * `"add"`: This drawable object is drawn onto the destination surface with additive blending. The clarity of the destination surface is kept. Useful to color and lighten the destination surface.  
`dstRGB = (srcRGB * srcA) + dstRGB`
    * `"multiply"`: Color modulation. Can be used to darken the destination surface without degrading its content.  
`dstRGB = srcRGB * dstRGB`


]],
      args = "blend_mode: string",
      returns = "",
      valuetype = ""
      },
    get_shader = {
      type = "method",
      description = [[

Returns the shader applied to this object.

  * Return value ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The shader, or `nil` if no shader is set.


]],
      args = "",
      returns = "shader",
      valuetype = "shader"
      },
    set_shader = {
      type = "method",
      description = [[

Sets the shader used to draw this object.

Default drawing is done with no shader.

  * `shader` ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The shader to set, or `nil` to reset drawing to normal.


]],
      args = "shader: shader",
      returns = "",
      valuetype = ""
      },
    get_opacity = {
      type = "method",
      description = [[

Returns the opacity of this drawable.

  * Return value (integer): The opacity: `0` (transparent) to `255` (opaque).


]],
      args = "",
      returns = "integer",
      valuetype = "integer"
      },
    set_opacity = {
      type = "method",
      description = [[

Sets the opacity of this drawable.

All drawables are initially opaque.

  * `opacity` (integer): The opacity: `0` (transparent) to `255` (opaque).


]],
      args = "opacity: integer",
      returns = "",
      valuetype = ""
      },
    fade_in = {
      type = "method",
      description = [[

Starts a fade-in effect on this object.

You can specify a callback function to be executed when the fade-in effect finishes.

If the drawable object is a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) during a game, the fade-in effect gets the lifetime of that entity. The behavior is probably what you expect: the fade-in effect gets suspended when the entity gets suspended, and it gets canceled (that is, the callback is never executed) when the map entity is destroyed.

  * `delay` (number, optional): Delay in milliseconds between two frames of the fade-in animation (default `20`).
  * `callback` (function, optional): A function to call when the fade-in effect finishes.



Note
    When your drawable object does not belong to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (typically in a title screen before a game is started, or in your pause menu), the fade-in effect continues until the drawable object is garbage-collected. In other words, the callback can be executed even if you have stopped using the drawable object in the meantime. Therefore, you should use the `callback` parameter with care. In these situations, using a [timer](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) for your callback is easier because timers have an explicit lifetime.
]],
      args = "[delay: number], [callback: function]",
      returns = "",
      valuetype = ""
      },
    fade_out = {
      type = "method",
      description = [[

Starts a fade-out effect on this object.

You can specify a callback function to be executed when the fade-out effect finishes.

If the drawable object is a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) during a game, the fade-out effect gets the lifetime of that entity. The behavior is probably what you expect: the fade-out effect gets suspended when the entity gets suspended, and it gets canceled (that is, the callback is never executed) when the map entity is destroyed.

  * `delay` (number, optional): Delay in milliseconds between two frames of the fade-out animation (default `20`).
  * `callback` (function, optional): A function to call when the fade-out effect finishes.



Note
    When your drawable object does not belong to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (typically in a title screen before a game is started, or in your pause menu), the fade-out effect continues until the drawable object is garbage-collected. In other words, the callback can be executed even if you have stopped using the drawable object in the meantime. Therefore, you should use the `callback` parameter with care. In these situations, using a [timer](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) for your callback is easier because timers have an explicit lifetime.
]],
      args = "[delay: number], [callback: function]",
      returns = "",
      valuetype = ""
      },
    get_xy = {
      type = "method",
      description = [[

Returns the offset added where this drawable object is drawn.

This value is initially `0,0`. It is added to whatever coordinates the object is drawn at.

They can be modified by a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) or by [drawable:set_xy()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_xy).

  * Return value 1 (number): X offset of the drawable object.
  * Return value 2 (number): Y offset of the drawable object.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_xy = {
      type = "method",
      description = [[

Sets the offset added where this drawable object is drawn.

This value is initially `0,0`. It is added to whatever coordinates the object is drawn at.

  * `x` (number): X offset to set.
  * `y` (number): Y offset to set.


]],
      args = "x: number, y: number",
      returns = "",
      valuetype = ""
      },
    get_movement = {
      type = "method",
      description = [[

Returns the current movement of this drawable object.

  * Return value ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The current movement, or `nil` if the drawable object is not moving.


]],
      args = "",
      returns = "movement",
      valuetype = "movement"
      },
    stop_movement = {
      type = "method",
      description = [[

Stops the current movement of this drawable object if any. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    }
  },
straight_movement = {
  type = "class",
  description = [[

A straight movement follows a rectilinear trajectory. You can define the trajectory as an angle and a speed.
]],
  childs = {
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_angle = {
      type = "method",
      description = [[

Sets the angle of the trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible. Negative values and values greater to `2 * math.pi` are also accepted.

  * `angle` (number): The new angle in radians.


]],
      args = "angle: number",
      returns = "",
      valuetype = ""
      },
    get_max_distance = {
      type = "method",
      description = [[

Returns the maximum distance of this movement.

The movement will stop when this distance is reached.

  * Return value (number): The maximum distance in pixels (`0` means no limit).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_distance = {
      type = "method",
      description = [[

Sets the maximum distance of this movement.

The movement will stop when this distance is reached.

  * `max_distance` (number): The maximum distance in pixels (`0` means no limit).


]],
      args = "max_distance: number",
      returns = "",
      valuetype = ""
      },
    is_smooth = {
      type = "method",
      description = [[

Returns whether this movement adjusts its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * Return value (boolean): `true` if this movement is smooth.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_smooth = {
      type = "method",
      description = [[

Sets whether this movement should adjust its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.



#  Events inherited from movement

Straight movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "[smooth: boolean]",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
random_movement = {
  type = "class",
  description = [[

This type of movement is a rectilinear movement whose trajectory changes randomly over time. It can be seen as a particular case of the [straight movement](http://www.solarus-games.org/doc/1.6/lua_api_straight_movement.html) type, where the angle is automatically changed after random delays.
]],
  childs = {
    get_speed = {
      type = "method",
      description = [[

Returns the speed applied to this movement when it is started.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed applied to this movement when it is started.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the current trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    get_max_distance = {
      type = "method",
      description = [[

Returns the maximum distance of this movement.

If the movement goes further than this distance, it automatically comes back towards the initial position.

  * Return value (number): The maximum distance in pixels (`0` means no limit).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_distance = {
      type = "method",
      description = [[

Sets the maximum distance of this movement.

If the movement goes further than this distance, it automatically comes back towards the initial position.

  * `max_distance` (number): The maximum distance in pixels (`0` means no limit).


]],
      args = "max_distance: number",
      returns = "",
      valuetype = ""
      },
    is_smooth = {
      type = "method",
      description = [[

Returns whether this movement adjusts its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * Return value (boolean): `true` if this movement is smooth.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_smooth = {
      type = "method",
      description = [[

Sets whether this movement should adjust its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.



#  Events inherited from movement

Random movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "[smooth: boolean]",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
target_movement = {
  type = "class",
  description = [[

A target movement goes towards a target point. The target point can be a fixed point of an [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). If the target is a moving map entity, the movement updates its angle to continue to go towards the entity. By default, the target is the [hero](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) when a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is running.

This type of movement can be seen as a particular case of the [straight movement](http://www.solarus-games.org/doc/1.6/lua_api_straight_movement.html#lua_api_straight_movement_methods) type, where the angle is set automatically to go towards the target.

Remarks
    This type of movement goes straight towards the target. If you set the `smooth` property to `true`, it will try to avoid simple obstacles by moving to a side. This is usually enough for simple enemies that target the hero. If you want a more complex technique that calculates an intelligent path to the target, see the [path finding movement](http://www.solarus-games.org/doc/1.6/lua_api_path_finding_movement.html) type.
]],
  childs = {
    set_target = {
      type = "method",
      description = [[

Sets the target of this movement as a fixed point or a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html).

To target a fixed point:

  * `x` (number): X coordinate of the target.
  * `y` (number): Y coordinate of the target.



To target a map entity (only during a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)):

  * `entity` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity to target.
  * `x` (number, optional): X offset to add to the target entity's coordinates. Default is `0`.
  * `y` (number, optional): Y offset to add to the target entity's coordinates. Default is `0`.


]],
      args = "x: number: number, y: number: number",
      returns = "",
      valuetype = ""
      },
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    is_smooth = {
      type = "method",
      description = [[

Returns whether this movement adjusts its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * Return value (boolean): `true` if this movement is smooth.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_smooth = {
      type = "method",
      description = [[

Sets whether this movement should adjust its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.

  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.



#  Events inherited from movement

Target movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "[smooth: boolean]",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
path_movement = {
  type = "class",
  description = [[

A path movement follows a specified path on an 8*8 pixels grid, in an 8-direction system. A path is a succession of steps of 8 pixels in one of the 8 main directions. You can define each step of the path and make it repeated if you want.
]],
  childs = {
    get_path = {
      type = "method",
      description = [[

Returns the path of this movement.

  * Return value (table): The path as an array of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.


]],
      args = "",
      returns = "table",
      valuetype = "table"
      },
    set_path = {
      type = "method",
      description = [[

Sets the path of this movement.

  * `path` (table): The path as an array of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.



Example of use: 
    
    
    -- Example of code from a map script.
    -- Assume that there is an NPC called "scared_cat" on this map.
    function scared_cat:on_interaction()
      -- The hero is talking to me: run away!
      sol.audio.play_sound("meow")
      local movement = sol.movement.create("path")
      -- This path is arbitrary, it's just an example (North and then West).
      movement:set_path{2,2,2,2,2,2,4,4,4,4}
      movement:set_speed(80)
      self:start_movement(movement)
    end
    
]],
      args = "path: table",
      returns = "",
      valuetype = ""
      },
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_loop = {
      type = "method",
      description = [[

Returns whether this movement repeats itself once the end of the path is reached.

  * Return value (boolean): `true` if the path repeats itself.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_loop = {
      type = "method",
      description = [[

Sets whether this movement repeats itself once the end of the path is reached.

  * `loop` (boolean, optional): `true` to make the path repeat itself. No value means `true`.


]],
      args = "[loop: boolean]",
      returns = "",
      valuetype = ""
      },
    get_snap_to_grid = {
      type = "method",
      description = [[

Returns whether this movement automatically snaps to the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) grid the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that it controls.

The map grid is composed of squares of 8*8 pixels. All tiles are aligned to the grid. This property has no effect if there is no current map of if this movement is not attached to a map entity.

  * Return value (boolean): `true` if this movement automatically snaps its map entity to the map grid.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_snap_to_grid = {
      type = "method",
      description = [[

Sets whether this movement should automatically snap to the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) grid the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that it controls.

The map grid is composed of squares of 8*8 pixels. All tiles are aligned to the grid. This property has no effect if there is no current map of if this movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html).

  * `snap` (boolean, optional): `true` to make this movement automatically snap its map entity to the map grid. No value means `true`.


]],
      args = "[snap: boolean]",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the current trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2`.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).

#  Events inherited from movement

Path movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "",
      returns = "number",
      valuetype = "number"
      }
    },
  inherits = "movement"
  },
random_path_movement = {
  type = "class",
  description = [[

The random path movement is a particular case of [path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html), where the path is chosen automatically. The resulting movement is composed of repeated random steps in the four main directions only and with a length that is a multiple of 8 pixels.

Remarks
    This movement is a typical random walk movement. You will probably use it for [NPCs](http://www.solarus-games.org/doc/1.6/lua_api_npc.html).

Example of use: 
    
    
    -- Example of code from a map script.
    -- Assume that there is an NPC called "bob" on this map.
    function sol.map:on_started()
      -- The map has just started: make bob walk.
      bob:start_movement(sol.movement.create("random_path"))
    end
    
]],
  childs = {
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the current trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2`.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).

#  Events inherited from movement

Random path movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "",
      returns = "number",
      valuetype = "number"
      }
    },
  inherits = "movement"
  },
path_finding_movement = {
  type = "class",
  description = [[

A path finding movement is a particular [path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html) where the path is calculated to reach a target. The target is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (by default the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)). The movement calculates repeatedly the shortest path towards the target entity, taking into account obstacles of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). With this type of movement, an entity is capable of finding its way in a maze.

Remarks
    This type of movement computes a precise path on the map grid and avoids complex obstacles by using a sophisticated A.I. algorithm ([A*](http://en.wikipedia.org/wiki/A*)). If you just need to go straight towards a target, which may be more natural for basic enemies, see the [target movement](http://www.solarus-games.org/doc/1.6/lua_api_target_movement.html) type.
]],
  childs = {
    set_target = {
      type = "method",
      description = [[

Sets the target entity of this movement.

  * `entity` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity to target.


]],
      args = "entity: entity",
      returns = "",
      valuetype = ""
      },
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle of the current trajectory in radians.

East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2`.

  * Return value (number): The angle in radians.



Remarks
    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).

#  Events inherited from movement

Path finding movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "",
      returns = "number",
      valuetype = "number"
      }
    },
  inherits = "movement"
  },
circle_movement = {
  type = "class",
  description = [[

A circle movement makes a circular trajectory around a center point.

The center can either be some fixed coordinates or a possibly moving [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html).
]],
  childs = {
    get_center = {
      type = "method",
      description = [[

Returns the center point of this movement.

  * Return value 1 (number): X coordinate of the center.
  * Return value 2 (number): Y coordinate of the center.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_center = {
      type = "method",
      description = [[

Sets the center of this movement as a fixed point or a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html).

To make circles around a fixed point:

  * `x` (number): X coordinate of the center.
  * `y` (number): Y coordinate of the center.



To make circles around a map entity (only during a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)):

  * `entity` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The center entity.
  * `dx` (number, optional): X offset to add to the center entity's coordinates (default 0).
  * `dy` (number, optional): Y offset to add to the center entity's coordinates (default 0).


]],
      args = "x: number, y: number",
      returns = "",
      valuetype = ""
      },
    get_radius = {
      type = "method",
      description = [[

Returns the radius of circles to make.

If [circle_movement:get_radius_speed()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed) is not 0, radius changes are made gradually.

  * Return value (number): The wanted radius in pixels.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_radius = {
      type = "method",
      description = [[

Sets the radius of circles to make.

If [circle_movement:get_radius_speed()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed) is not 0, the radius will be updated gradually.

  * `radius` (number): The new wanted radius in pixels.


]],
      args = "radius: number",
      returns = "",
      valuetype = ""
      },
    get_radius_speed = {
      type = "method",
      description = [[

Returns the speed of radius changes.

  * Return value (number): The speed in pixels per second, or 0 if radius changes are immediate.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_radius_speed = {
      type = "method",
      description = [[

Sets the radius to be updated immediately of gradually (at the specified speed) towards its wanted value.

  * `radius_speed` (number): The speed of radius changes in pixels per second, or 0 to make radius changes immediate.


]],
      args = "radius_speed: number",
      returns = "",
      valuetype = ""
      },
    is_clockwise = {
      type = "method",
      description = [[

Returns whether circles are made clockwise or counter-clockwise.

  * Return value (boolean): `true` if circles are clockwise.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_clockwise = {
      type = "method",
      description = [[

Sets whether circles are made clockwise or counter-clockwise.

  * `clockwise` (boolean, optional): `true` to make circles clockwise. No value means `true`.


]],
      args = "[clockwise: boolean]",
      returns = "",
      valuetype = ""
      },
    get_angle_from_center = {
      type = "method",
      description = [[

Returns the angle indicating the current position on the circle.

This is the angle of the vector between the center and the current position.

  * Return value (number): The angle in radians.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_angle_from_center = {
      type = "method",
      description = [[

Sets the position on the circle as an angle from its center.

This is the angle of the vector between the center and the new position to set.

  * `initial_angle` (number): The angle in radians.


]],
      args = "angle_from_center",
      returns = "",
      valuetype = ""
      },
    get_angular_speed = {
      type = "method",
      description = [[

Returns the speed of the angle variation.

  * Return value (number): The angle speed in radians per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_angular_speed = {
      type = "method",
      description = [[

Sets the speed of the angle variation.

  * `angular_speed` (number): The new angle speed in radians per second.


]],
      args = "angular_speed: number",
      returns = "",
      valuetype = ""
      },
    get_max_rotations = {
      type = "method",
      description = [[

Returns the maximum number of rotations of this movement.

When this number of rotations is reached, the movement stops.

  * Return value (number): The maximum number of rotations to make (`0` means infinite).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_rotations = {
      type = "method",
      description = [[

Sets the maximum number of rotations of this movement.

When this number of rotations is reached, the movement stops.

  * `max_rotations` (number): The maximum number of rotations to make (`0` means infinite).



Remarks
    The movement stops itself by setting its radius to 0. Therefore, if the radius is set to change gradually (see [circle_movement:get_radius_speed()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed)), the movement will continue for a while until the radius reaches 0.
     When the movement has stopped, it restarts later if it was set to loop (see [circle_movement:get_loop_delay()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_loop_delay)), and again, possibly gradually.
]],
      args = "max_rotations: number",
      returns = "",
      valuetype = ""
      },
    get_duration = {
      type = "method",
      description = [[

Returns the maximum duration of this movement.

When this delay is reached, the movement stops.

  * Return value (number): The duration of the movement in milliseconds (`0` means infinite).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_duration = {
      type = "method",
      description = [[

Sets the maximum duration of this movement.

When this delay is reached, the movement stops.

  * `duration` (number): The duration of the movement in milliseconds (`0` means infinite).



Remarks
    The movement is stopped by automatically setting its radius to 0. Therefore, if the radius is set to change gradually (see [circle_movement:get_radius_speed()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed)), the movement will continue for a while until the radius reaches 0.
     When the movement has stopped, it will then restart if it was set to loop (see [circle_movement:set_loop_delay()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_set_loop_delay)), and again, possibly gradually.
]],
      args = "duration: number",
      returns = "",
      valuetype = ""
      },
    get_loop_delay = {
      type = "method",
      description = [[

Returns the delay after which this movement restarts.

  * Return value (number): The restart delay in milliseconds (`0` means no restart).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_loop_delay = {
      type = "method",
      description = [[

Sets the delay after which this movement restarts.

  * `loop_delay` (number): The restart delay in milliseconds (`0` means no restart).



Remarks
    This delay is applied if the movement get stopped by reaching the [maximum number of rotations](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_max_rotations) or the [maximum duration](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_get_duration).
     When the movement restarts, the radius starts from 0 and gets back to its previous value, possibly gradually (see [circle_movement:set_radius_speed()](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html#lua_api_circle_movement_set_radius_speed)).

#  Events inherited from movement

Circle movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events.

#  Deprecated methods of the type circle movement

The following methods are deprecated and may be removed it future releases.
]],
      args = "loop_delay: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
jump_movement = {
  type = "class",
  description = [[

This type of movement makes a jump above a specified rectilinear trajectory. We call this rectilinear trajectory the baseline. To use a jump movement, you typically specify the baseline (direction and distance), and the movement will jump above this baseline. The speed is adjusted automatically depending on the distance, but you can change it if you want.

For now, the baseline can only have one of the 8 main directions. This restriction may be removed in the future.
]],
  childs = {
    get_direction8 = {
      type = "method",
      description = [[

Returns the direction of the baseline of this jump. The baseline always has one of the 8 main directions. 0 is East, 1 is North-East, etc.

  * Return value (number): The direction (`0` to `7`).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_direction8 = {
      type = "method",
      description = [[

Sets the direction of the baseline of this jump. The baseline always has one of the 8 main directions. 0 is East, 1 is North-East, etc.

  * `direction8` (number): The direction (`0` to `7`).


]],
      args = "direction8: number",
      returns = "",
      valuetype = ""
      },
    get_distance = {
      type = "method",
      description = [[

Returns the distance of the baseline of this jump.

  * Return value (number): The distance of the jump in pixels.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_distance = {
      type = "method",
      description = [[

Sets the distance of the baseline of this jump.

  * `distance` (number): The new distance of the jump in pixels.


]],
      args = "distance: number",
      returns = "",
      valuetype = ""
      },
    get_speed = {
      type = "method",
      description = [[

Returns the speed of this movement.

  * Return value (number): The speed in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed of this movement.

  * `speed` (number): The new speed in pixels per second. `0` means to set automatically a speed based on the distance of the jump.



#  Events inherited from movement

Jump movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
pixel_movement = {
  type = "class",
  description = [[

A pixel movement makes a succession of basic translations, where each translation is a pixel-precise specified move (for example `(+2,-1)`). Each translation is immediate.

Unlike most other types of movements, there is no notion of speed in pixels per seconds. That's because a translation can transport the object instantly to another place - the movement is not necessarily continuous. Instead, you can set the delay between each translation.

Remarks
    Pixel movements are not often needed. Most of the time, you don't want to specify pixel-by-pixel trajectories. Higher-level types of movements like [path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html#lua_api_path_movement_methods) or [target movement](http://www.solarus-games.org/doc/1.6/lua_api_target_movement.html#lua_api_target_movement_methods) usually fit your needs when you move [NPCs](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) or [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html).
]],
  childs = {
    get_trajectory = {
      type = "method",
      description = [[

Returns the trajectory of this movement.

  * Return value (table): An array of all successive translations. Each translation is itself an array of two integers (x and y).


]],
      args = "",
      returns = "table",
      valuetype = "table"
      },
    set_trajectory = {
      type = "method",
      description = [[

Sets the trajectory of this movement.

Any previous trajectory is removed and the movement starts at the beginning of the new trajectory.

  * trajectory (table): An array of all successive translations to make. Each translation should be an array of two integers (x and y).


]],
      args = "trajectory: table",
      returns = "",
      valuetype = ""
      },
    get_loop = {
      type = "method",
      description = [[

Returns whether this movement restarts automatically when the trajectory is finished.

  * Return value (boolean): `true` if the movement loops.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_loop = {
      type = "method",
      description = [[

Sets whether this movement should restart automatically when the trajectory is finished.

  * `loop` (boolean, optional): `true` to make the movement loop. No value means `true`.


]],
      args = "[loop: boolean]",
      returns = "",
      valuetype = ""
      },
    get_delay = {
      type = "method",
      description = [[

Returns the delay between two steps of the trajectory.

  * Return value (number): The delay between two steps in milliseconds.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_delay = {
      type = "method",
      description = [[

Sets the delay between two steps of the trajectory.

  * `delay` (number): The delay between two steps in milliseconds.



#  Events inherited from movement

Pixel movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.

See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
]],
      args = "delay: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "movement"
  },
movement = {
  type = "class",
  description = [[

If you need to move an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) of the map, a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) in a menu or simply an arbitrary point, you can create a movement object and set its properties. There are several types of movements. They differ by the kind of trajectory they can make. When you create a movement, you obtain a value of the movement type you chose. Then, to get and set its properties (like the speed, the angle, etc.), a movement object has several methods available. As detailed below, the methods available differ depending on the movement type because all movement types don't have the same properties.

The following movement types are available.

  * [Straight movement](http://www.solarus-games.org/doc/1.6/lua_api_straight_movement.html): Rectilinear trajectory in any direction.
  * [Random movement](http://www.solarus-games.org/doc/1.6/lua_api_random_movement.html): A straight movement whose direction changes randomly from time to time.
  * [Target movement](http://www.solarus-games.org/doc/1.6/lua_api_target_movement.html): Straight trajectory towards a possibly moving target.
  * [Path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html): Predetermined path composed of steps in the 8 main directions.
  * [Random path movement](http://www.solarus-games.org/doc/1.6/lua_api_random_path_movement.html): Like a path movement, but with random steps.
  * [Path finding movement](http://www.solarus-games.org/doc/1.6/lua_api_path_finding_movement.html): Like a path movement, but calculated to reach a possibly moving target.
  * [Circle movement](http://www.solarus-games.org/doc/1.6/lua_api_circle_movement.html): Circular trajectory around a possibly moving center.
  * [Jump movement](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html): An illusion of jump above a baseline.
  * [Pixel movement](http://www.solarus-games.org/doc/1.6/lua_api_pixel_movement.html): A trajectory described pixel by pixel.



This page desribes the methods and callbacks common to all movement types.

Movements can be applied in-game to [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), but also outside a game, typically in a [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) to move a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), an [image](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) or just an `(x,y)` value. However, some properties of movements (like [movement:set_ignore_obstacles()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_set_ignore_obstacles)) only take effect in the case of a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) because they refer to [map-specific](http://www.solarus-games.org/doc/1.6/lua_api_map.html) notions like obstacles.
]],
  childs = {
    start = {
      type = "method",
      description = [[

Starts this movement on an object.

The movement will be applied until it finishes (if it has an end) or until it is replaced by another one. It does not matter if the movement gets out of scope in your Lua script.

  * `object_to_move` ([map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), [drawable object](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) or table): The object to move. It may be a map entity, a drawable object or a table with two fields `x` and `y`. In the case of the table, if the fields `x` and `y` don't exist, they are created and initialized to `0`.

An empty table will be initialized with `{x = 0, y = 0}`.

  * `callback` (function, optional): A function to call when the movement finishes.



Remarks
    The [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) just like any other. So you can apply a custom movement to him using this function. The usual way to do this is to call [hero:freeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_freeze) first to properly remove control from the player, and then to start the movement. When you have finished, you can restore the control with [hero:unfreeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_unfreeze). Indeed, changing the movement while the hero is in a state other than `"frozen"` might give surprising results. Your movement will be applied, replacing any built-in movement of the state, but whatever was happening in the state will still continue. Furthermore, your movement will disappear as soon as the state changes. So don't start a movement on the hero during an arbitrary state unless you know what you are doing.
]],
      args = "object_to_move: map entity, drawable object or table, [callback: function]",
      returns = "",
      valuetype = ""
      },
    stop = {
      type = "method",
      description = [[

Stops this movement and detaches it from the object that was moved.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_xy = {
      type = "method",
      description = [[

Returns the coordinates of the object controlled by this movement.

The object controlled by this movement may be a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), a [drawable object](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) or a point.

  * Return value 1 (number): X coordinate.
  * Return value 2 (number): Y coordinate.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_xy = {
      type = "method",
      description = [[

Sets the coordinates of the object controlled by this movement.

The object controlled by this movement may be a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), a [drawable object](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) or a point.

  * `x` (number): X coordinate to set.
  * `y` (number): Y coordinate to set.


]],
      args = "x: number, y: number",
      returns = "",
      valuetype = ""
      },
    is_suspended = {
      type = "method",
      description = [[

Returns whether this movement is currently suspended.

  * Return value (boolean): `true` if the movement is suspended.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_ignore_suspend = {
      type = "method",
      description = [[

Returns whether the movement should continue even when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is suspended.

This setting only has an effect for movements attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) during a game. The default value is `false`.

  * Return value (boolean): `true` to continue the movement even when the game is suspended.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_ignore_suspend = {
      type = "method",
      description = [[

Sets whether the movement should continue even when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is suspended.

  * `ignore` (boolean, optional): `true` to continue the movement even when the game is suspended. No value means `true`.


]],
      args = "[ignore: boolean]",
      returns = "",
      valuetype = ""
      },
    get_ignore_obstacles = {
      type = "method",
      description = [[

Returns whether this movement ignores obstacles of the map.

If the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) yet, it is not an error to call this function: the result will have an effect when the movement gets attached to a map entity.

  * Return value (boolean): `true` if this movement ignores obstacles.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_ignore_obstacles = {
      type = "method",
      description = [[

Sets whether a map entity controlled by this movement should ignore obstacles of the map.

If the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) yet, it is not an error to call this function: your choice will have an effect when the movement gets attached to a map entity.

  * `ignore_obstacles` (boolean, optional): `true` to make this movement ignore obstacles of the map (no value means `true`).


]],
      args = "[ignore_obstacles: boolean]",
      returns = "",
      valuetype = ""
      },
    get_direction4 = {
      type = "method",
      description = [[

From the four main directions, returns the closest one to the current trajectory.

East is 0, North is 1, West is 2, South is 3. As the real trajectory does not necessarily follows one of the four main directions, it will be converted to the closest one.

If you use this movement to control a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) (or a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that has a sprite), you can use this function to make the sprite face the direction of the movement.

  * Return value (number): The closest direction corresponding to the angle of this movement.



Example of use: 
    
    
    -- Example of code from an enemy script.
    
    -- This function is called when the enemy should start or restart its movement.
    function enemy:on_restarted()
    
      -- Create a movement that makes random straight trajectories.
      local movement = sol.movement.create("random")
    
      -- This function is called when the trajectory has changed.
      function movement:on_movement_changed()
        -- The angle of the movement has changed: update the sprite accordingly.
        local direction = movement:get_direction4()
        enemy:get_sprite():set_direction(direction)
      end
    
      movement:start(enemy)
    end
    

#  Events of all movement types

Events are callback methods automatically called by the engine if you define them.

The following events are common to all movement types.

Remarks
    All movement events are here (it turns out that no specific movement type define additional events).
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    on_position_changed = {
      type = "method",
      description = [[

Called when the coordinates controlled by this movement have just changed.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_obstacle_reached = {
      type = "method",
      description = [[

During a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), called when the coordinates controlled by this movement have just failed to change because they would lead the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) controlled into an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

When an obstacle is reached, this event is called instead of [movement:on_position_changed()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_on_position_changed).

This event can only be called when all of these conditions are met:

  * A [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is currently running.
  * The movement is attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (like an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), an [NPC](http://www.solarus-games.org/doc/1.6/lua_api_npc.html), etc.).
  * The movement does not ignore obstacles (i.e. [movement:get_ignore_obstacles()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_ignore_obstacles) returns `false`).



Remarks
    When the movement attempts to change the coordinates, one of [movement:on_position_changed()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_on_position_changed) or [movement:on_obstacle_reached()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_on_obstacle_reached) is guaranteed to be called.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_changed = {
      type = "method",
      description = [[

Called when the characteristics of this movement (like speed or angle) have just changed.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_finished = {
      type = "method",
      description = [[

Called when this movement has just finished (if there is an end). 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    }
  },
game = {
  type = "class",
  description = [[

This module provides a datatype "game" that represents a savegame.
]],
  childs = {
    save = {
      type = "method",
      description = [[

Saves this game into its savegame file.

A valid quest write directory must be set (in your [quest.dat file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    start = {
      type = "method",
      description = [[

Runs this game.

This function is typically called from your savegame menu, when the player chooses its savegame file.

If another game was running, it is stopped automatically because only one game can be running at a time.

You can also call this function to restart the current game itself, even if it was not saved recently (saved data will not be reset). This may be useful to restart the game after the [game-over sequence](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_game_over_started).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_started = {
      type = "method",
      description = [[

Returns whether this game is currently running.

Only one game can be running at a time.

  * Return value (boolean): `true` if this game is running.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_suspended = {
      type = "method",
      description = [[

Returns whether this game is currently suspended.

The game is suspended when at least one of the following conditions is true:

  * the game is [paused](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_paused),
  * or a [dialog](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_dialog_enabled) is active,
  * or the [game-over sequence](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_game_over_enabled) is active,
  * or a transition between two maps is playing,
  * or you explicitly called [game:set_suspended(true)](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_suspended).



  * Return value (boolean): `true` if this game is currently suspended. Only possible when the game is running.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_suspended = {
      type = "method",
      description = [[

Suspends or unsuspends the game.

Note that the game is also automatically suspended by the engine in the following situations:

  * when the game is [paused](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_paused),
  * or when a [dialog](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_dialog_enabled) is active,
  * or when the [game-over sequence](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_game_over_enabled) is active,
  * or when a transition between two maps is playing.



Therefore, if you call `game:set_suspended(false)` during one of these sequences, it will only take effect at the end of it.

  * `suspended` (boolean, optional): `true` to suspend the game, `false` to resume it. No value means `true`.



Note
    When the hero goes to another map, the game is automatically unsuspended after the map opening transition.
]],
      args = "[suspended: boolean]",
      returns = "",
      valuetype = ""
      },
    is_paused = {
      type = "method",
      description = [[

Returns whether this game is currently paused.

  * Return value (boolean): `true` if this game is paused. Only possible when the game is running.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_paused = {
      type = "method",
      description = [[

Pauses or resumes the game explictly.

Note that by default, a built-in game command already exists to pause and unpause the game.

  * `paused` (boolean, optional): `true` to pause the game, `false` to unpause it. Only possible when the game is running. No value means `true`.


]],
      args = "[paused: boolean]",
      returns = "",
      valuetype = ""
      },
    is_pause_allowed = {
      type = "method",
      description = [[

Returns whether the player can pause or unpause the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html).

  * Return value (boolean): `true` if the player is allowed to pause the game.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_pause_allowed = {
      type = "method",
      description = [[

Sets whether the player can pause or unpause the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html).

  * `pause_allowed` (boolean, optional): `true` to allow the player to pause the game. No value means `true`.



Remarks
    This function applies to the built-in [pause command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands). Your script can still pause the game explicitly by calling [game:set_paused()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_paused).
]],
      args = "[pause_allowed: boolean]",
      returns = "",
      valuetype = ""
      },
    is_dialog_enabled = {
      type = "method",
      description = [[

Returns whether this game is currently showing a dialog.

It does not matter whether the dialog is shown with the built-in, minimal dialog box or with your custom dialog box (see [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started)).

Only possible when the game is running.

  * Return value (boolean): `true` if a dialog is being shown.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    start_dialog = {
      type = "method",
      description = [[

Starts showing a dialog.

A dialog must not be already active. This function returns immediately, but you can provide a callback that will be executed when the dialog finishes. The game is suspended during the dialog, like when it is paused.

If the event [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started) is not defined, then the engine will show a default, minimal dialog system without decoration. The user will be able to close the dialog by pressing the action command (you don't need to call [game:stop_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_dialog)).

On the contrary, if the event [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started) is defined, the engine calls it and does nothing else. This is the recommended way, because you can make your custom dialog box implementation with any feature you need. The game will be suspended until you call [game:stop_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_dialog) explicitly.

  * `dialog_id` (string): Id of the dialog to show. The corresponding dialog must exist in the [dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) file of the current [language](http://www.solarus-games.org/doc/1.6/lua_api_language.html).
  * `info` (any type, optional): Any information you want to pass to the [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started) event. You can use this parameter to include in the dialog any information that is only known at runtime, for example the name of the player, the best score of a mini-game or the time spent so far in the game. See the examples below.
  * `callback` (function, optional): A function to be called when the dialog finishes. A status parameter (possibly `nil`) is passed to your function: its value is the argument of [game:stop_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_dialog) and it represents the result of the dialog. This feature may be used by your dialog box system to return any useful information to the map script, like the answer chosen by the player if the dialog was a question, or whether the dialog was skipped.



Example of a small map script with an NPC that shows a simple dialog: 
    
    
    local map = ...
    
    function some_npc:on_interaction()
      -- Remember that you specify a dialog id, not directly the text to show.
      -- The text is defined in the dialogs.dat file of the current language.
      map:get_game():start_dialog("welcome_to_my_house")
    end
    

Here is a more complex example, with an NPC that asks a question. This example assumes that your dialog box system can ask questions to the player, and returns the answer as a boolean value passed to [game:stop_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_dialog). 
    
    
    local map = ...
    local game = map:get_game()
    function another_npc:on_interaction()
      game:start_dialog("give_me_100_rupees_please", function(answer)
        if answer then
          if game:get_money() >= 100 then
            game:remove_money(100)
            game:start_dialog("thanks")
          else
            sol.audio.play_sound("wrong")
            game:start_dialog("not_enough_money")
          end
        else
          game:start_dialog("not_happy")
        end
      end)
    end
    

Finally, to illustrate the use of the `info` parameter, let's modify the previous example to make the amount of money only determined at runtime. In other words, we want an NPC that can say "Please give me 100 rupees", but also "Please give me 25 rupees" or any number. Since the number is only known at runtime, it can no longer be hardcoded in the text of the [dialog](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html). So let's assume that the text of the dialog contains instead a special sequence (like `"$v"`) to be substituted by the final value. (Note that [shop treasures](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html#lua_api_shop_treasure_dialogs) use a very similar convention for their dialogs.) 
    
    
    local map = ...
    local game = map:get_game()
    
    function another_npc:on_interaction()
      local how_much = math.random(100)
      game:start_dialog("give_me_x_rupees_please", how_much, function(answer)
        if answer then
          if game:get_money() >= how_much then
            game:remove_money(how_much)
            -- ... The rest is unchanged.
    

To make this example work, you need a dialog box system that performs the substitution when `info` is set. See [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started).

Note
    The `info` parameter of [game:start_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog) and the status parameter of the callback are a flexible way to make the map script communicate with the dialog box system in both directions. They can been seen as the parameter and the result (respectively) of the dialog being displayed. They can both be any value, like a table with many information.
]],
      args = "dialog_id: string, [info: any type], [callback: function]",
      returns = "",
      valuetype = ""
      },
    stop_dialog = {
      type = "method",
      description = [[

Stops the current dialog.

A dialog must be active when you call this function. The dialog stops being displayed and the game can resume. This function is typically called by your dialog box system when it wants to close the dialog.

The [game:on_dialog_finished()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_finished) event is first called (if it is defined). Then, the callback that was passed to [game:start_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog) is called (if it was defined) with the `status` argument.

  * `status` (any type, optional): Some information to return to the script that started the dialog. For example, you can pass the result of the dialog if it was a question, or whether it was skipped by the user before the end. See the [examples above](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog).


]],
      args = "[status: any type]",
      returns = "",
      valuetype = ""
      },
    is_game_over_enabled = {
      type = "method",
      description = [[

Returns whether this game is currently showing a game-over sequence.

Only possible when the game is running.

The game-over sequence automatically starts when the player's life gets to zero, or when you call [game:start_game_over()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_game_over) explicitly. Define the event [game:on_game_over_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_game_over_started) to show your game-over menu. If you don't define this event, by default, there is no game-over sequence and the engine immediately restarts the game (but does not save it).

  * Return value (boolean): `true` if a game-over sequence is running.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    start_game_over = {
      type = "method",
      description = [[

Starts the game-over sequence manually.

Only possible when the game is running.

This function is seldom needed since the game-over sequence automatically starts when the player's life reaches zero. But you can use it if you want to start a game-over sequence even when the player's life is greater than zero.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    stop_game_over = {
      type = "method",
      description = [[

Finishes the current game-over sequence.

Only possible during a game-over sequence.

The game is suspended during the whole game-over sequence. Call this function to resume it. If the [life](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_life) is still zero at this point, then the engine automatically restores full life.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_map = {
      type = "method",
      description = [[

Returns the current map.

  * Return value ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The current map of this game (`nil` if this game is not running).


]],
      args = "",
      returns = "map",
      valuetype = "map"
      },
    get_hero = {
      type = "method",
      description = [[

Returns the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).

The hero is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that always exists while the game is running, and that persists when the map changes. For this reason, he can be seen as belonging to the game more than to the current map. That's why this function exists.

  * Return value ([hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)): The hero, or `nil` if the game is not running.



Remarks
    Equivalent to `game:get_map():get_entity("hero")`.
]],
      args = "",
      returns = "hero",
      valuetype = "hero"
      },
    get_value = {
      type = "method",
      description = [[

Returns a value saved.

  * `savegame_variable` (string): Name of the value to get from the savegame.
  * Return value (string, number or boolean): The corresponding value (`nil` if no value is defined with this key).


]],
      args = "savegame_variable: string",
      returns = "string, number or boolean",
      valuetype = "string, number or boolean"
      },
    set_value = {
      type = "method",
      description = [[

Sets a value in the savegame.

This function allows to store key-value pairs in the savegame. Values can be strings, integers or booleans.

  * `savegame_variable` (string): Name of the value to save (must contain alphanumeric characters or `'_'` only, and must start with a letter).
  * `value` (string, number or boolean): The value to set, or `nil` to unset this value.



Remarks
    This method changes a value, but remember that the change will be saved in the savegame file only when you call [game:save()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_save).
]],
      args = "savegame_variable: string, value: string, number or boolean",
      returns = "",
      valuetype = ""
      },
    get_starting_location = {
      type = "method",
      description = [[

Returns the location where the hero is placed when this game is started or restarted.

  * Return value 1 (string): Id of the starting map. `nil` means that it was not set: in this case, the first map declared in [project_db.dat](http://www.solarus-games.org/doc/1.6/quest_database_file.html) will be used.
  * Return value 2 (string): Name of the destination where the hero will be placed on that map. `nil` means that it was not set: in this case, the default destination entity of that map will be used.


]],
      args = "",
      returns = "string,string",
      valuetype = "string,string"
      },
    set_starting_location = {
      type = "method",
      description = [[

Sets the location where the hero should be placed when this game is started or restarted.

  * `map_id` (string, optional): Id of the starting map. By default, the first map declared in [project_db.dat](http://www.solarus-games.org/doc/1.6/quest_database_file.html) is used.
  * `destination_name` (string, optional): Name of the destination where the hero should be placed on that map. By default, the default destination of the map is used.



Remarks
    When the hero moves from a map to another map that belongs to a different world (for example, from a dungeon to the outside world) using a destination entity, by default, the starting location is automatically set to this point. If this behavior is okay for your quest, you never need to call this function except the first time: when initializing a new savegame file. This behavior can be changed by setting the "Save starting location" property of destinations, from the quest editor or from a script (with [destination:set_starting_location_mode()](http://www.solarus-games.org/doc/1.6/lua_api_destination.html#lua_api_destination_set_starting_location_mode)).
]],
      args = "[map_id: string, [destination_name: string]]",
      returns = "",
      valuetype = ""
      },
    get_life = {
      type = "method",
      description = [[

Returns the current level of life of the player.

  * Return value (number): The current life.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_life = {
      type = "method",
      description = [[

Sets the level of life of the player.

A negative value will be replaced by zero. A value greater than than the maximum level of life will be replaced by the maximum value.

  * `life` (number): Number of life points to set.


]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    add_life = {
      type = "method",
      description = [[

Adds some life to the player.

  * `life` (number): Number of life points to add. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_life(game:get_life() + life)`.
]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    remove_life = {
      type = "method",
      description = [[

Removes some life from the player.

  * `life` (number): Number of life points to remove. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_life(game:get_life() - life)`.
]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    get_max_life = {
      type = "method",
      description = [[

Returns the maximum level of life of the player.

  * Return value (number): The maximum number of life points.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_life = {
      type = "method",
      description = [[

Sets the maximum level of life of the player.

  * `life` (number): Maximum number of life points to set. Must be a positive number.


]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    add_max_life = {
      type = "method",
      description = [[

Increases the maximum level of life of the player.

  * `life` (number): Maximum number of life points to add to the maximum. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_max_life(game:get_max_life() + life)`.
]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    get_money = {
      type = "method",
      description = [[

Returns the amount of money of the player.

  * Return value (number): The current amount of money.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_money = {
      type = "method",
      description = [[

Sets the amount of money of the player.

A negative value will be replaced by zero. A value greater than than the maximum amount of money will be replaced by the maximum amount.

  * `money` (number): The amount of money to set.


]],
      args = "money: number",
      returns = "",
      valuetype = ""
      },
    add_money = {
      type = "method",
      description = [[

Adds some money to the player.

  * `money` (number): Amount of money to add. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_money(game:get_money() + money)`.
]],
      args = "money: number",
      returns = "",
      valuetype = ""
      },
    remove_money = {
      type = "method",
      description = [[

Removes some money from the player.

  * `money` (number): Amount of money to remove. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_money(game:get_money() - money)`.
]],
      args = "money: number",
      returns = "",
      valuetype = ""
      },
    get_max_money = {
      type = "method",
      description = [[

Returns the maximum amount of money of the player.

  * Return value (number): The maximum money.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_money = {
      type = "method",
      description = [[

Sets the maximum amount of money of the player.

  * `money` (number): Maximum money to set. Must be a positive number or `0`.


]],
      args = "money: number",
      returns = "",
      valuetype = ""
      },
    get_magic = {
      type = "method",
      description = [[

Returns the current number of magic points.

  * Return value (number): The current number of magic points.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_magic = {
      type = "method",
      description = [[

Sets the amount of magic points of the player.

A negative value will be replaced by zero. A value greater than than the maximum number of magic points will be replaced by that maximum.

  * `magic` (number): The number of magic points to set.


]],
      args = "magic: number",
      returns = "",
      valuetype = ""
      },
    add_magic = {
      type = "method",
      description = [[

Adds some magic points to the player.

  * `magic` (number): Number of magic points to add. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_magic(game:get_magic() + magic)`.
]],
      args = "magic: number",
      returns = "",
      valuetype = ""
      },
    remove_magic = {
      type = "method",
      description = [[

Removes some magic points from the player.

  * `magic` (number): Number of magic points to remove. Must be a positive number or `0`.



Remarks
    Equivalent to `game:set_magic(game:get_magic() - magic)`.
]],
      args = "magic: number",
      returns = "",
      valuetype = ""
      },
    get_max_magic = {
      type = "method",
      description = [[

Returns the maximum number of magic points.

  * Return value (number): The maximum number of magic points.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_magic = {
      type = "method",
      description = [[

Sets the maximum number of magic points.

  * `magic` (number): The maximum number of magic points to set. Must be a positive number or `0`.


]],
      args = "magic: number",
      returns = "",
      valuetype = ""
      },
    has_ability = {
      type = "method",
      description = [[

Returns whether the player has a built-in ability.

  * `ability_name:` Name of the ability to get (see [game:get_ability()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) for the list of valid ability names).
  * Return value (boolean): `true` if the player has this ability.



Remarks
    Equivalent to `game:get_ability(ability_name) > 0`.
]],
      args = "ability_name",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_ability = {
      type = "method",
      description = [[

Returns the level of a built-in ability.

Built-in ability levels indicate whether the hero can perform some built-in actions like attacking, swimming or running. The initial value is `0` unless specified otherwise.

  * `ability_name` (string): Name of the ability to get. Valid ability names are:
    * `"sword"`: Using the sword when pressing the attack command. Determines the default sword sprite.
    * `"sword_knowledge"`: Ability to make the super spin-attack.
    * `"tunic"`: Resistance level that reduces the damage received by the hero. Determines the default sprite used for the hero's body. The initial value is `1`.
    * `"shield"`: Protection against enemies. Allows to avoid some attacks. Determines the default shield sprite.
    * `"lift"`: Ability to lift heavy [destructible objects](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html).
    * `"swim"`: Ability to swim in deep water.
    * `"jump_over_water"`: Automatically jumping when arriving into water without the `"swim"` ability.
    * `"run"`: Running when pressing the action command.
    * `"push"`: Trying to push when walking towards an obstacle. The initial value is `1`.
    * `"grab"`: Grabbing the faced obstacle when pressing the action command. The initial value is `1`.
    * `"pull"`: Pulling the faced obstacle the hero is grabbing. The initial value is `1`.
    * `"detect_weak_walls"`: Notifying the player with a sound when a weak wall is nearby.
  * Return value (number): Level of this ability (`0` means not having this ability yet).


]],
      args = "ability_name: string",
      returns = "number",
      valuetype = "number"
      },
    set_ability = {
      type = "method",
      description = [[

Sets the level of an ability.

  * `ability_name` (string): Name of the ability to set (see [game:get_ability()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) for the list of valid ability names).
  * `level` (number): Level of this ability to set (`0` removes the ability).


]],
      args = "ability_name: string, level: number",
      returns = "",
      valuetype = ""
      },
    get_item = {
      type = "method",
      description = [[

Returns an equipment item.

  * `item_name` (string): Name of the item to get.
  * Return value ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The corresponding equipment item.


]],
      args = "item_name: string",
      returns = "item",
      valuetype = "item"
      },
    has_item = {
      type = "method",
      description = [[

Returns whether the player has the specified [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (only for a saved item).

  * `item_name` (string): Name of the item to check.
  * Return value (boolean): `true` if the player has at least the first variant of this item.



Remarks
    Equivalent to `game:get_item(item_name):get_variant() > 0`.
]],
      args = "item_name: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_item_assigned = {
      type = "method",
      description = [[

Returns the equipment item assigned to a slot.

  * `slot` (number): The slot to get (`1` or `2`).
  * Return value ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The equipment item associated to this slot (`nil` means none).


]],
      args = "slot: number",
      returns = "item",
      valuetype = "item"
      },
    set_item_assigned = {
      type = "method",
      description = [[

Assigns an equipment item to a slot.

  * `slot` (number): The slot to set (`1` or `2`).
  * `item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The equipment item to associate to this slot, or `nil` to make the slot empty.


]],
      args = "slot: number, item: item",
      returns = "",
      valuetype = ""
      },
    get_command_effect = {
      type = "method",
      description = [[

Returns the current built-in effect of a game command.

This function is useful if you want to show a HUD that indicates to the player the current effect of pressing a game command, especially for command `"action"` whose effect changes a lot depending on the context.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (string): A string describing the current built-in effect of this game command. `nil` means that this command has currently no built-in effect (for example because the game is paused). Possible values are:
    * For command `"action"`: `"next"`, `"look"`, `"open"`, `"lift"`, `"throw"`, `"grab"`, `"speak"`, `"swim"`, `"run"` or `nil`.
    * For command `"attack"`: `"sword"` or `nil`.
    * For command `"pause"`: `"pause"`, `"return"` or `nil`.
    * For command `"item_1"`: `"use_item_1"` or `nil`.
    * For command `"item_2"`: `"use_item_2"` or `nil`.
    * For command `"right"`: `"move_right"` or `nil`.
    * For command `"left"`: `"move_left"` or `nil`.
    * For command `"up"`: `"move_up"` or `nil`.
    * For command `"down"`: `"move_down"` or `nil`.



Remarks
    All these built-in game commands are initially mapped to some default keyboard and joypad inputs. You can use [game:set_command_keyboard_binding()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_command_keyboard_binding), [game:set_command_joypad_binding()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_command_joypad_binding) and [game:capture_command_binding()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_capture_command_binding) to change or even disable these mappings.
     It is also possible to override the behavior of game commands by intercepting the events [game:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_command_pressed) [game:on_command_released()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_command_released).
]],
      args = "command: string",
      returns = "string",
      valuetype = "string"
      },
    get_command_keyboard_binding = {
      type = "method",
      description = [[

Returns the keyboard key that triggers the specified game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (string): Name of the keyboard key that triggers this game command, or `nil` if no keyboard key is mapped to this game command.


]],
      args = "command: string",
      returns = "string",
      valuetype = "string"
      },
    set_command_keyboard_binding = {
      type = "method",
      description = [[

Sets the keyboard key that triggers a game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * key (string): Name of the keyboard key that should trigger this game command (`nil` means none).



Note
    If this keyboard key was already mapped to a command, keyboard keys of both commands are switched.
]],
      args = "command: string, key: string",
      returns = "",
      valuetype = ""
      },
    get_command_joypad_binding = {
      type = "method",
      description = [[

Returns the joypad input that triggers the specified game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (string): A string describing what joypad input triggers this game command, or `nil` if no joypad input is mapped to this game command. This string can have one of the following forms:
    * `"button X"` where X is the index of a joypad button (first is `0`),
    * `"axis X +"` where X is the index of a joypad axis (first is `0`),
    * `"axis X -"` where X is the index of a joypad axis (first is `0`),
    * `"hat X Y"` where X is the index of a joypad hat (first is `0`) and Y is a direction (`0` to `7`).


]],
      args = "command: string",
      returns = "string",
      valuetype = "string"
      },
    set_command_joypad_binding = {
      type = "method",
      description = [[

Sets the joypad input that should trigger the specified game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * joypad_string (string): A string describing what joypad input should trigger this game command (`nil` means none). This string must have one of the following forms:
    * `"button X"` where X is the index of a joypad button (first is `0`),
    * `"axis X +"` where X is the index of a joypad axis (first is `0`),
    * `"axis X -"` where X is the index of a joypad axis (first is `0`),
    * `"hat X Y"` where X is the index of a joypad hat (first is `0`) and Y is a direction (`0` to `7`).



Note
    If this joypad input was already mapped to a command, joypad inputs of both commands are switched.
]],
      args = "command: string, joypad_string: string",
      returns = "",
      valuetype = ""
      },
    capture_command_binding = {
      type = "method",
      description = [[

Makes the next keyboard or joypad input become the new binding for the specified game command.

This function returns immediately. After you call it, the next time the player presses a keyboard key or performs a joypad input, this input is treated differently: instead of being forwarded to your script or handled by the engine as usual, it automatically becomes the new keyboard or joypad binding for a game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * `callback` (function, optional): A function to call when the new input occurs.



Note
    If the keyboard (or joypad) input was already mapped to a command, keyboard (or joypad) inputs of both commands are switched.
]],
      args = "command: string, [callback: function]",
      returns = "",
      valuetype = ""
      },
    is_command_pressed = {
      type = "method",
      description = [[

Returns whether a built-in game command is currently pressed.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): `true` if this game command is currently pressed by the player.


]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_commands_direction = {
      type = "method",
      description = [[

Returns the direction (in an 8-direction system) formed by the combination of directional game commands currently pressed by the player.

  * Return value (number): The direction wanted by the player (`0` to 7), or `nil` for no direction. No direction means that no directional command is pressed, or that contradictory directional commands are pressed, like left and right at the same time (impossible with most joypads, but easy with a keyboard).



Remarks
    This function is provided for convenience. Its result can also be computed by calling [game:is_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_is_command_pressed) four times (with the four directional game commands).
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    simulate_command_pressed = {
      type = "method",
      description = [[

Creates a command pressed input event.

Everything acts like if the player had just pressed an input mapped to this game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.


]],
      args = "command: string",
      returns = "",
      valuetype = ""
      },
    simulate_command_released = {
      type = "method",
      description = [[

Creates a command released input event.

Everything acts like if the player had just released an input mapped to this game command.

  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.



#  Events of a game

Events are callback methods automatically called by the engine if you define them. In the case of a game, they are only called on the game currently running, if any.
]],
      args = "command: string",
      returns = "",
      valuetype = ""
      },
    on_started = {
      type = "method",
      description = [[

Called when this game starts running (including when you restart the same game).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_finished = {
      type = "method",
      description = [[

Called when this game stops running (including when you restart the same game).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle of the main loop while this game is running.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_draw = {
      type = "method",
      description = [[

Called when the game has just been redrawn by the engine.

The engine has already drawn the current map, since the map is always drawn before the game. If the game has [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html), these menu are not drawn yet at this point. Use this event if you want to draw some additional content before the menus.

  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The surface where the game is drawn.


]],
      args = "dst_surface: surface",
      returns = "",
      valuetype = ""
      },
    on_map_changed = {
      type = "method",
      description = [[

Called when the player has just entered a map.

The new map is already started at this point. For example, you may use this event if some parts of your HUD needs to be changed on particular maps.

  * `map` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The new active map.



Remarks
    When you [start or restart](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start) the game, this event is always called, even if the new run happens to start on the same map as where the previous run finished.
]],
      args = "map: map",
      returns = "",
      valuetype = ""
      },
    on_world_changed = {
      type = "method",
      description = [[

Called when the player has just entered a map whose [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world) is different from the previous one.

Recall that maps without a world property are considered to be in their own world, different to all other maps. Therefore, if at least one of the previous and the new map has no world property, this event is necessarily called.

This event is called right after [game:on_map_changed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_map_changed).

  * `previous_world` (string): The world of the previous map if any, or `nil` if the previous map had no world set or if there was no previous map.
  * `new_world` (string): The world of the new map if any, or `nil` if the mew map had no world set.



Remarks
    When you [start or restart](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start) the game, this event is always called, even if the new happens to start on a map with the same world (or even on the same map) as where the previous run finished.
     Since the world is considered to be different from any other
]],
      args = "previous_world: string, new_world: string",
      returns = "",
      valuetype = ""
      },
    on_paused = {
      type = "method",
      description = [[

Called when the game has just been paused.

The game may have been paused by the player (by pressing the `"pause"` game command) or by you (by calling [game:set_paused(true)](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_paused)).

This function is typically the place where you should start your pause menu.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_unpaused = {
      type = "method",
      description = [[

Called when the game is being resumed.

The game may have been unpaused by the player (by pressing the `"pause"` game command) or by you (by calling [game:set_paused(false)](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_paused)).

This is probably a good place to stop your pause menu.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_dialog_started = {
      type = "method",
      description = [[

Called when a dialog starts.

The dialog may be triggered by a Lua script (by calling [game:start_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog)) or by the engine in various situations (for example when finding a treasure).

If this event is not defined, the engine shows a minimal dialog box without decoration and you have nothing else to do.

If this event is defined, the engine does nothing and your script is responsible to show the dialog in any way you want, and to close it later by calling [game:stop_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_dialog). It is recommended to implement your dialog system as a [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html): if you do so, you will automatically get called by the engine when a command is pressed, when you need to draw the dialog box on the screen, etc.

  * `dialog` (table): All properties of the dialog to show. This table is identical to the one returned by [sol.language.get_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_language.html#lua_api_language_get_dialog). It is a table with at least the following two entries:

    * `dialog_id` (string): Id of the dialog.
    * `text` (string): Text of the dialog in the current language. It may have several lines. When it is not empty, it always ends with a newline character.

The table also contains all custom entries defined in [text/dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) for this dialog. These custom entries always have string keys and string values. Values that were defined as numbers in `"text/dialogs.dat"` are replaced in this table by their string representation, and values that were defined as booleans are replaced by the string `"1"` for `true` and `"0"` for `false`.

  * `info` (any value, optional): Some additional information for this particular dialog. You can get here some data that is only known at runtime. See the examples of [game:start_dialog()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog).


]],
      args = "dialog: table, [info: any value]",
      returns = "",
      valuetype = ""
      },
    on_dialog_finished = {
      type = "method",
      description = [[

Called when the current dialog stops.

  * `dialog` (table): All properties of the dialog that was shown. See [game:on_dialog_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_dialog_started) for a description of this table.


]],
      args = "dialog: table",
      returns = "",
      valuetype = ""
      },
    on_game_over_started = {
      type = "method",
      description = [[

Called when a game-over sequence starts.

This event is called when the player's life reaches zero, as soon as the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is in a state that allows game-over. It is also called if you started a game-over sequence manually with [game:start_game_over()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_game_over).

If this event is not defined, there is no game-over sequence: the game restarts immediately, like if you called [game:start()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start), and the full life of the player is restored.

If this event is defined, the engine does nothing except suspending the game. Your script is then responsible to show a game-over sequence in any way you want, and to call [game:stop_game_over()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_stop_game_over) once you have finished.

For instance, you may create a [dialog](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start_dialog) that lets the player [restart the game](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_start) or [save](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_save) and [quit](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_reset), or a [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) with more options.

Actually, it is not even required to restart or quit the game after your game-over sequence (even if this is the most common case). Indeed, you can also just resume the game. In this case, the game continues normally like if nothing happened.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_game_over_finished = {
      type = "method",
      description = [[

Called when the current game-over sequence stops.

This event is also called if you did not define a game-over sequence.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_key_pressed = {
      type = "method",
      description = [[

Called when the user presses a keyboard key while your game is running.

  * `key` (string): Name of the raw key that was pressed.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) if any, to the current map (including its own menus if any), and then to the game commands.



If you handle the event, you should return `true` to make the event stop being propagated. The [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of your game (if any) and the current map won't be not notified in this case. On the contrary, if neither your game, its menus nor the current map handle the event, then the engine handles it with a built-in behavior. This built-in behavior is to check whether a game command is mapped to the keyboard key that was pressed. If yes, the keyboard pressed event will be transformed into a game command pressed event (see [game:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_command_pressed)).

Remarks
    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [game:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_character_pressed). If you want the corresponding higher-level game command (if any), see [game:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_command_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_key_released = {
      type = "method",
      description = [[

Called when the user releases a keyboard key while your game is running.

  * `key` (string): Name of the raw key that was released.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) if any, to the current map (including its own menus if any), and then to the game commands.



If you handle the event, you should return `true` to make the event stop being propagated. The [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of your game (if any) and the current map won't be not notified in this case. On the contrary, if neither your game, its menus nor the current map handle the event, then the engine handles it with a built-in behavior. This built-in behavior is to check whether a game command is mapped to the keyboard key that was released. If yes, the "keyboard released" event will be transformed into a "game command released" event (see [game:on_command_released()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_command_released)).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_character_pressed = {
      type = "method",
      description = [[

Called when the user enters text while your game is running.

  * `character` (string): A utf-8 string representing the character that was entered.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) if any and then to the current map (including its own menus if any).



Remarks
    When a character key is pressed, two events are called: [game:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_key_pressed) (indicating the raw key) and [game:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_character_pressed) (indicating the utf-8 character). If your game needs to input text from the user, [game:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
]],
      args = "character: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_pressed = {
      type = "method",
      description = [[

Called when the user presses a joypad button while your game is running.

  * `button` (number): Index of the button that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_released = {
      type = "method",
      description = [[

Called when the user releases a joypad button while your game is running.

  * `button` (number): Index of the button that was released.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_axis_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad axis while your game is running.

  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "axis: number, state: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_hat_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad hat while your game is running.

  * `hat` (number): Index of the hat that was moved.
  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "hat: number, direction8: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_pressed = {
      type = "method",
      description = [[

Called when the player presses a game command (a keyboard key or a joypad action mapped to a built-in game behavior) while this game is running. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was pressed. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_released = {
      type = "method",
      description = [[

Called when the player released a game command (a keyboard key or a joypad action mapped to a built-in game behavior). while this game is running. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was released. Possible commands are
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_pressed = {
      type = "method",
      description = [[

Called when the user presses a mouse button while the game is running.

  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_released = {
      type = "method",
      description = [[

Called when the user releases a mouse button while the game is running.

  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_pressed = {
      type = "method",
      description = [[

Called when the user presses a finger while the game is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_released = {
      type = "method",
      description = [[

Called when the user releases a finger while the game is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_moved = {
      type = "method",
      description = [[

Called when the user moves a finger while the game is running.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dx` (integer): The horizontal distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dy` (integer): The vertical distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. 


]],
      args = "finger: integer, x: integer, y: integer, dx: integer: integer, dy: integer: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      }
    }
  },
item = {
  type = "class",
  description = [[

An equipment item represents something that the player can obtain (one or more times, in various forms and with several variants) and possibly keep. The Lua item type described in this page provides various functions to

  * get and the possession state of a equipment item,
  * set its properties, like whether the item is saved and has an amount,
  * control its dynamic behavior, like what happens when the player uses this item (for items that can be used).



A Lua item object represents a kind of treasure, and not a particular instance of treasures. Individual treasures may then be represented as [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html), [chests](http://www.solarus-games.org/doc/1.6/lua_api_chest.html), [shop treasures](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html), and may be brandished by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html). For example, multiple treasures of the kind `"rupee"` may exist at the same time during the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), but only one Lua item object manages them.

The script file `items/XXXX.lua` defines the item named `XXXX`. The corresponding Lua item object is passed as parameter of that script. Use the Lua notation `"..."` to get this parameter and store it into a regular variable.

Here is a basic example of script for the `rupee` item, an item whose only role is to increase the money of the player when he obtains a rupee. 
    
    
    -- First, we put the parameter into a variable called "rupee".
    -- (In Lua, the notation "..." refers to the parameter(s) of the script.)
    local rupee = ...
    
    -- Event called when the hero obtains a rupee treasure.
    function rupee:on_obtaining()
      self:get_game():add_money(1)  -- Increase the money of 1 unit.
    end
    

Remarks
    All item scripts are loaded when you create a [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) object. Indeed, equipment items only exist in the context of a particular savegame. As shown in the example above, you can retrieve that savegame with [item:get_game()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_get_game).
     A [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) animation named `XXXX` must also exist in the sprite `entities/items`: it is used by the engine whenever it needs to draw your item on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) (for example, when a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this kind is created on the map).
]],
  childs = {
    get_name = {
      type = "method",
      description = [[

Returns the name of this item.

  * Return value (string): The name that identifies this item. It is also the file name of the item script (without the extension).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_game = {
      type = "method",
      description = [[

Returns the game where this item belongs.

  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game that contains this item.



Remarks
    Items only exist in the context of a game, but the game is not necessarily running.
]],
      args = "",
      returns = "game",
      valuetype = "game"
      },
    get_map = {
      type = "method",
      description = [[

Returns the current map.

  * Return value ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The current map, or `nil` if the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is not running.


]],
      args = "",
      returns = "map",
      valuetype = "map"
      },
    get_savegame_variable = {
      type = "method",
      description = [[

Returns the name of the integer savegame value that stores the possession state of this item.

  * Return value (string): The savegame variable that stores the possessed variant of this item, or `nil` if this item is not saved.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_savegame_variable = {
      type = "method",
      description = [[

Sets the name of the integer savegame value that stores the possession state of this item.

You should call this function at initialization time if you want your item to be saved.

  * `savegame_variable` (string): The savegame variable that should stored the possessed variant of this item, or `nil` to make this item unsaved.


]],
      args = "savegame_variable: string",
      returns = "",
      valuetype = ""
      },
    get_amount_savegame_variable = {
      type = "method",
      description = [[

Returns the name of the integer savegame value that stores the amount associated to this item.

  * Return value (string): The savegame variable that stores the possessed amount of this item, or `nil` if this item has no associated amount.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_amount_savegame_variable = {
      type = "method",
      description = [[

Sets the name of the integer savegame value that stores the amount of this item.

You should call this function at initialization time if you want your item to store an amount (in addition to its possessed variant). This is typically used for items like the bow and the counter of bombs.

  * Return value (string): The savegame variable that should store the possessed amount of this item, or `nil` to make this item have no associated amount.


]],
      args = "amount_savegame_variable",
      returns = "string",
      valuetype = "string"
      },
    is_obtainable = {
      type = "method",
      description = [[

Returns whether the player is allowed to obtain this item.

If not, any treasure representing this item is automatically replaced by an empty treasure.

  * Return value (boolean): `true` if this item is obtainable.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_obtainable = {
      type = "method",
      description = [[

Sets whether the player is allowed to obtain this item.

If not, any treasure representing this item is automatically replaced by an empty treasure. There is no risk that the player can obtain it or even see it during the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html). You can use this feature to hide some items while the player has not the necessary equipment. For example, you can make arrows unobtainable until the player has the bow. You can also make magic jars unobtainable until the player has a magic bar.

  * Return value (boolean, optional): `true` if this item is obtainable (no value means `true`).


]],
      args = "[obtainable]",
      returns = "boolean, optional",
      valuetype = "boolean, optional"
      },
    is_assignable = {
      type = "method",
      description = [[

Returns whether this item can be assigned to an item slot.

When the item is assigned to a slot, the player can use it by pressing the [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) of that slot. Some items are meant to be used by pressing a command (like the bow), other are not supposed to (like a key or a rupee). When the player uses your item, the event [item:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) is triggered.

  * Return value (boolean): `true` if this item is assignable.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_assignable = {
      type = "method",
      description = [[

Sets whether this item should be assignable to an item slot.

When the item is assigned to a slot, the player can use it by pressing the [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) of this slot. Some items are meant to be used by pressing a command (like the bow), other are not supposed to (like a key or a rupee). When the player uses your item, the event [item:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) is triggered.

By default, an item is not assignable. Call this function at initialization time if you want your item to be assignable.

  * `assignable` (boolean, optional): `true` if this item is assignable (no value means `true`).


]],
      args = "[assignable: boolean]",
      returns = "",
      valuetype = ""
      },
    get_can_disappear = {
      type = "method",
      description = [[

Returns whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this kind disappears after a few seconds when they are dropped by an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) or a [destructible entity](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html).

  * Return value (boolean): `true` if pickable treasures of this kind can disappear.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_disappear = {
      type = "method",
      description = [[

Sets whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this kind should disappear after a few seconds when they are dropped by an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) or a [destructible entity](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html).

By default, an item cannot disappear. Call this function at initialization time if you want your item to be ephemeral.

  * `can_disappear` (boolean, optional): `true` to make such pickable treasures disappear after a few seconds (no value means `true`).



Remarks
    This property only applies to [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) dropped dynamically (by [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and [destructible entities](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html)). Pickable treasures already present on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) when the map starts don't disappear with time.
]],
      args = "[can_disappear: boolean]",
      returns = "",
      valuetype = ""
      },
    get_brandish_when_picked = {
      type = "method",
      description = [[

Returns whether the hero brandishes treasures of this kind when he [picks](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) them on the ground.

  * Return value (boolean): `true` if the hero brandish such treasures.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_brandish_when_picked = {
      type = "method",
      description = [[

Sets whether the hero should brandish treasures of this kind when he [picks](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) them on the ground.

Treasures coming from a [chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html) are always brandished, even the most basic ones like simple rupees. However, when treasures are [picked](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) on the ground (like rupees dropped by an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html)), you may want the hero not to brandish them.

By default, this property is `true`. Call this function if you don't want your item to be brandished when it is picked on the ground.

  * `brandish_when_picked` (boolean, optional): `true` if the hero should brandish such treasures (no value means `true`).


]],
      args = "[brandish_when_picked: boolean]",
      returns = "",
      valuetype = ""
      },
    get_shadow = {
      type = "method",
      description = [[

Returns the name of the animation representing the shadow of this item in the sprite `"entities/shadow"`.

  * Return value (string): Name of the shadow animation adapted to this item in the sprite `"entities/shadow"`. `nil` means no shadow displayed.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_shadow = {
      type = "method",
      description = [[

Sets the name of the animation that should represent the shadow of this item in the sprite `"entities/shadow"`.

When the engine needs to show a treasure representing your item, it sometimes also wants to display a shadow (in addition of the treasure's main sprite). For example, [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) dropped by enemies normally have a shadow.

The default shadow animation is `"big"`. You should call this function at initialization time if your item sprite is larger or smaller than usual.

  * `shadow_animation` (string): Name of the shadow animation in the sprite `"entities/shadow"` to set for this item. `nil` means that no shadow will be displayed.



Remarks
    To draw a treasure, the engine relies on two sprites: the treasure's main sprite (`entities/item`) and the shadow's sprite (`entities/shadow`). Both sprites and their appropriate animations must exist so that treasures can be displayed correctly.
]],
      args = "shadow_animation: string",
      returns = "",
      valuetype = ""
      },
    get_sound_when_picked = {
      type = "method",
      description = [[

Returns the sound played when the hero [picks a treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this kind.

  * Return value (string): Name of the sound played when the hero picks a treasure of this kind (`nil` means no sound).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_sound_when_picked = {
      type = "method",
      description = [[

Sets the sound to play when the hero [picks a treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this kind.

The default sound is `"picked_item"`.

  * `sound_when_picked` (string): Name of the sound to play (as in [sol.audio.play_sound()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound)) when the hero picks a treasure of this kind (`nil` means no sound).



Remarks
    This sound is always played, even if the treasure is also brandished then (i.e. if [item:get_brandish_when_picked()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_get_brandish_when_picked) returns `true`).
]],
      args = "sound_when_picked: string",
      returns = "",
      valuetype = ""
      },
    get_sound_when_brandished = {
      type = "method",
      description = [[

Returns the sound played when the hero brandishes a treasure of this kind.

  * Return value (string): Name of the sound played when the hero brandishes a treasure of this kind (`nil` means no sound).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_sound_when_brandished = {
      type = "method",
      description = [[

Sets the sound to play when the hero brandishes a treasure of this kind.

The hero can brandish treasures in various situations: when opening a [chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html), when buying a [shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html), when picking up a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) (unless you called [item:set_brandish_when_picked(false)](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_brandish_when_picked)), and also when you call [hero:start_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_treasure) directly.

The default sound is `"treasure"`.

  * `sound_when_brandished` (string): Name of the sound to play (as in [sol.audio.play_sound()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound)) when the hero brandishes a treasure of this kind (`nil` means no sound).


]],
      args = "sound_when_brandished: string",
      returns = "",
      valuetype = ""
      },
    has_variant = {
      type = "method",
      description = [[

Returns whether the player owns at least the specified variant of this item (only for a saved item).

  * `variant` (number, optional): The variant to check (default `1`).
  * Return value (boolean): `true` if the player has at least this variant.



Remarks
    Equivalent to `item:get_variant() >= variant`.
]],
      args = "[variant: number]",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_variant = {
      type = "method",
      description = [[

Returns the possession state of this item (only for a saved item).

  * Return value (number): The possession state (`0`: not possessed, `1`: first variant, `2`: second variant, etc.).



Remarks
    Equivalent to `item:get_game():get_value(item:get_savegame_variable())`.
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_variant = {
      type = "method",
      description = [[

Sets the possession state of this item (only for a saved item).

  * `variant` (number): The new possession state to set (`0`: not possessed, `1`: first variant, `2`: second variant, etc.)



Remarks
    Equivalent to `item:get_game():set_value(item:get_savegame_variable(), variant)`.
]],
      args = "variant: number",
      returns = "",
      valuetype = ""
      },
    has_amount = {
      type = "method",
      description = [[

Returns whether this item has an associated amount, or whether the player has at least the specified value.

  * `amount` (number, optional): The amount to check. If this parameter is not set, this function only tests whether an amount value exists for the item.
  * Return value (boolean): If an amount is specified, return `true` if the player has at least that amount. Otherwise, returns `true` if the item has an amount value.



Remarks
    If an amount is specified, this method is equivalent to `item:get_amount() >= amount`. Otherwise, this method is equivalent to `item:get_amount_savegame_variable() ~= nil`.
]],
      args = "[amount: number]",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_amount = {
      type = "method",
      description = [[

Returns the amount associated to this item (only for an item with an amount value).

  * Return value (number): The associated amount.



Remarks
    Equivalent to `item:get_game():get_value(item:get_amount_savegame_variable())`.
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_amount = {
      type = "method",
      description = [[

Sets the amount associated to this item (only for an item with an amount value). A negative amount will be replaced by `0`. An amount greater than [item:get_max_amount()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_get_max_amount) will be replaced by that maximum value.

  * `amount` (number): The amount to set.


]],
      args = "amount: number",
      returns = "",
      valuetype = ""
      },
    add_amount = {
      type = "method",
      description = [[

Increases the amount associated to this item (only for an item with an amount value), without exceeding the maximum amount.

  * `amount` (number): The amount to add.


]],
      args = "amount: number",
      returns = "",
      valuetype = ""
      },
    remove_amount = {
      type = "method",
      description = [[

Decreases the amount associated to this item (only for an item with an amount value), without going below `0`.

  * `amount` (number): The amount to remove.


]],
      args = "amount: number",
      returns = "",
      valuetype = ""
      },
    get_max_amount = {
      type = "method",
      description = [[

Returns the maximum amount associated to this item (only for an item with an amount value).

  * Return value (number): The maximum amount.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_max_amount = {
      type = "method",
      description = [[

Sets the maximum amount associated to this item (only for an item with an amount value). This maximum value is used in [item:set_amount()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_amount) and [item:add_amount()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_add_amount) to make a limit. The default value is `1000`.

  * `max_amount` (number): The maximum amount to set.



Remarks
    The maximum amount of an item is not saved automatically. Only the current variant (see [item:set_savegame_variable()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_savegame_variable)) and the current amount (see [item:set_amount_savegame_variable()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_amount_savegame_variable)) are saved by the engine. Therefore, you have to set the maximum amount of appropriate items when they are loaded (typically from event [item:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_started)).
]],
      args = "max_amount: number",
      returns = "",
      valuetype = ""
      },
    is_being_used = {
      type = "method",
      description = [[

Returns whether the item is currently being used by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    set_finished = {
      type = "method",
      description = [[

Notifies the engine that using this item is finished and that the hero can get back to a normal state.

When the player uses this item (by pressing an item [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)), your item script takes full control of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) (event [item:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) is called) and you have to program the item's behavior. When it is finished, call this function to restore normal control to the player.

This method should only be called when the hero is using this item.

#  Events of an item

Events are callback methods automatically called by the engine if you define them. In the case of a game, they are only called on the game currently running, if any.
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
map = {
  type = "class",
  description = [[

Maps are areas where the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) takes place. They may be rooms, houses, entire dungeon floors, parts of the outside world or any place. The active map contains many objects called [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (or just "entities" to be short). Map entities are everything that has a position on the map, including the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), the [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html), the [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), the [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) and even the [camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html). See the [entity API](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) for more details.
]],
  childs = {
    get_id = {
      type = "method",
      description = [[

Returns the id of this map.

  * Return value (string): Id of the map.



Remarks
    This id appears in the name of [map files](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).
]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_game = {
      type = "method",
      description = [[

Returns the current game.

  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game that is currently running the map.


]],
      args = "",
      returns = "game",
      valuetype = "game"
      },
    get_world = {
      type = "method",
      description = [[

Returns the world name that was set on this map.

The world name is an optional property defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). Worlds allow to group maps together. The world can be any arbitrary name. Maps that have the same world name are considered to be part of the same environment. For example, your map can be in a world named `"outside_world"`, `"dungeon_1"` or `"some_scary_cave"`. A map that has no world is always considered to be alone in its own environment.

The world property is used to decide when to set the starting location of the player (the place where he starts when loading his [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html)). By default, the starting location is automatically set by the engine when the world changes (not when the map changes). This can be changed by defining the "Save starting location" property of destinations, from the quest editor or from a script (with [destination:set_starting_location_mode()](http://www.solarus-games.org/doc/1.6/lua_api_destination.html#lua_api_destination_set_starting_location_mode)).

Some other features may also rely on the world property, like the state of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html). Their state persists between all maps of the current world and is reset when entering a map whose world is different.

  * Return value (string): Name of the world of the current map. `nil` means no world.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_world = {
      type = "method",
      description = [[

Changes the world of this map.

The world property remains until the map is destroyed: If you reload the same map again later, the world is reset to the one defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).

  * `world` (string): The new world name to set, or `nil` to set no world.


]],
      args = "world: string",
      returns = "",
      valuetype = ""
      },
    get_floor = {
      type = "method",
      description = [[

Returns the floor of the current map if any.

The floor is an optional property defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).

The engine does not do anything particular with this floor property. But you can use it in scripts, for example to show the current floor on the HUD when it changes or to make a minimap [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html).

  * Return value (number): The current floor. `0` is the first floor, `1` is the second floor, `-1` is the first basement floor, etc. `nil` means that this map is not part of a floor system.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_floor = {
      type = "method",
      description = [[

Changes the floor of this map.

The floor property remains until the map is destroyed: If you reload the same map again later, the floor is reset to the one defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).

  * `floor` (number): The new floor number to set, or `nil` to set no floor.


]],
      args = "floor: number",
      returns = "",
      valuetype = ""
      },
    get_min_layer = {
      type = "method",
      description = [[

Returns the index of the lowest layer of this map.

  * Return value (number): The lowest layer (0 or less).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    get_max_layer = {
      type = "method",
      description = [[

Returns the index of the highest layer of this map.

  * Return value (number): The highest layer (0 or more).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    get_size = {
      type = "method",
      description = [[

Returns the size of this map in pixels.

  * Return value 1 (number): The width in pixels (always a multiple of 8).
  * Return value 2 (number): The height in pixels (always a multiple of 8).


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_location = {
      type = "method",
      description = [[

Returns the x,y location of this map in its [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world).

The engine uses this information to implement scrolling between two adjacent maps.

For example, you can also use this property in scripts if you want to show the position of the hero on the minimap [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of your outside [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world). Indeed, your outside world is probably not a single map, but it is usually composed of several adjacent maps.

  * Return value 1 (number): X position of the top-left corner of this map relative to its world.
  * Return value 2 (number): Y position of the top-left corner of this map relative to its world.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_tileset = {
      type = "method",
      description = [[

Returns the name of the [tileset](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_tileset) of the current map.

  * Return value (string): Id of the current tileset.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_tileset = {
      type = "method",
      description = [[

Changes the [tileset](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_tileset) of the current map.

It is your responsability to make sure that the new tileset is be compatible with the previous one: every tile of the previous tileset must exist in the new one and have the exact same properties, and only the images can differ.

  * `tileset_id` (string): Id of the new tileset to set.



Remarks
    If the new tileset is not compatible with the previous one, tiles will be displayed with wrong graphics.
]],
      args = "tileset_id: string",
      returns = "",
      valuetype = ""
      },
    get_music = {
      type = "method",
      description = [[

Returns the name of the music associated to this map.

This is the music to play when the map starts, as specified in the map file. It may be different from the music currently being played. To get the music currently being played, see [sol.audio.get_music()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_get_music).

  * Return value (string): Name of the music of this map, relative to the `musics` directory and without extension. It can also be the special value `"same"` if the map specifies to keep the music unchanged, or `nil` if the map specifies to play no music.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_camera = {
      type = "method",
      description = [[

Returns the camera entity of the map.

  * Return value ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera.


]],
      args = "",
      returns = "camera",
      valuetype = "camera"
      },
    get_ground = {
      type = "method",
      description = [[

Returns the kind of ground (terrain) of a point.

The ground is defined by [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) (and other entities that may change it like [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html)) that overlap this point.

  * `x` (number): X coordinate of a point of the map.
  * `y` (number): Y coordinate of a point of the map.
  * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
  * Return value (string): The kind of ground. The possible values are the same as the `ground` property of the [tileset file](http://www.solarus-games.org/doc/1.6/quest_tileset_data_file.html): `"empty"`, `"traversable"`, `"wall"`, `"low_wall"`, `"wall_top_right"`, `"wall_top_left"`, `"wall_bottom_left"`, `"wall_bottom_right"`, `"wall_top_right_water"`, `"wall_top_left_water"`, `"wall_bottom_left_water"`, `"wall_bottom_right_water"`, `"deep_water"`, `"shallow_water"`, `"grass"`, `"hole"`, `"ice"`, `"ladder"`, `"prickles"` or `"lava"`.


]],
      args = "x: number, y: number, lay: numberer",
      returns = "string",
      valuetype = "string"
      },
    draw_visual = {
      type = "method",
      description = [[

Draws a [drawable object](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html), [text surface](http://www.solarus-games.org/doc/1.6/lua_api_text_surface.html) or [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)) on the [camera](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_camera) at the given map coordinates.

This function can be used as an alternative to [drawable:draw()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw) in order to draw the object relative to the map (instead of relative to the screen).

If the object to draw is a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), its origin point will be displayed at the given location, relative to the the upper left corner of the map.

This function should only be called during the drawing phase of the map, for example from [map:on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_draw) or from [custom_entity:on_post_draw()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_post_draw).

  * `drawable` ([drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html)): The visual object to draw on the map.
  * `x` (number): X coordinate of where to draw the object, in map coordinates.
  * `y` (number): Y coordinate of where to draw the object, in map coordinates.


]],
      args = "drawable: drawable, x: number, y: number",
      returns = "",
      valuetype = ""
      },
    draw_sprite = {
      type = "method",
      description = [[

Draws a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) on the screen at the given map coordinates.

Warning
    This method is deprecated since Solarus 1.5.

Use [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) instead.
]],
      args = "sprite, x, y",
      returns = "",
      valuetype = ""
      },
    get_crystal_state = {
      type = "method",
      description = [[

Returns the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).

  * Return value (boolean): `false` initially (orange blocks lowered), `true` otherwise (blue blocks lowered).


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_crystal_state = {
      type = "method",
      description = [[

Sets the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).

This state persists accross maps of the same [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world). It is reset when the world changes and when the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is reloaded.

  * `state` (boolean): `false` to set the initial configuration (orange blocks lowered), `true` to the modified one (blue blocks lowered).


]],
      args = "state: boolean",
      returns = "",
      valuetype = ""
      },
    change_crystal_state = {
      type = "method",
      description = [[

Inverts the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).

Remarks
    Equivalent to `map:set_crystal_state(not map:get_crystal_state())`.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    open_doors = {
      type = "method",
      description = [[

Opens the [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) whose name starts with the specified prefix, enables or disables relative [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) accordingly and plays the `"door_open"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).

Opening a door may be more complex than just modifying a single [door entity](http://www.solarus-games.org/doc/1.6/lua_api_door.html). Indeed, there is often a corresponding door is the adjacent room that you also want to open (that corresponding door is another [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)). Name both doors with the same prefix, and you can use this function to open both of them.

Furthermore, you sometimes want [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) to be shown or hidden depending on the state of a door. When a door is open, all dynamic tiles whose prefix is the door's name followed by `_open` or `_closed` are automatically enabled or disabled, respectively.

  * `prefix` (string): Prefix of the name of doors to open.



Remarks
    The doors will be really closed once the opening animation of their sprite is finished. However, they immediately become obstacles.
]],
      args = "prefix: string",
      returns = "",
      valuetype = ""
      },
    close_doors = {
      type = "method",
      description = [[

Closes the [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) whose name starts with the specified prefix, enables or disables relative [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) accordingly and plays the `"door_closed"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).

Closing a door may be more complex than just modifying a single [door entity](http://www.solarus-games.org/doc/1.6/lua_api_door.html). Indeed, there is often a corresponding door is the adjacent room that you also want to open (that corresponding door is another [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)). Name both doors with the same prefix, and you can use this function to close both of them.

Furthermore, you sometimes want [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) to be shown or hidden depending on the state of a door. When a door is closed, all dynamic tiles whose prefix is the door's name followed by `_open` or `_closed` are automatically disabled or enabled, respectively.

  * `prefix` (string): Prefix of the name of doors to close.


]],
      args = "prefix: string",
      returns = "",
      valuetype = ""
      },
    set_doors_open = {
      type = "method",
      description = [[

Like [map:open_doors()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_open_doors) or [map:close_doors()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_close_doors), but does not play any sound or any sprite animation.

This function is intended to be called when you don't want the player to notice the change, typically when your map starts (i.e. from the [map:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_started) event).

  * `prefix` (string): Prefix of the name of doors to set.
  * `open` (boolean, optional): `true` to open the doors, `false` to close them (no value means `true`).


]],
      args = "prefix: string, [open: boolean]",
      returns = "",
      valuetype = ""
      },
    get_entity = {
      type = "method",
      description = [[

Returns the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) with the specified name if it exists on this map. Entity names are unique (two entities cannot exist on the map with the same name at the same time). The name is optional: some entities may have no name. In this case, you cannot access them from this function.

As a convenient feature, map entities can also be accessed directly through the environment of the [map script](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). In other words, you can just write `bob:get_position()` as an equivalent to `map:get_entity("bob"):get_position()`.

  * `name` (string): Name of the map entity to get.
  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The corresponding entity, or `nil` if there exists no entity with this name on the map.



Remarks
    Technical note for curious Lua experts: the mechanism that makes map entities directly accessible in the map script environment is lazy (it is implemented as an `__index` metamethod). Entities are imported to the Lua side only when your script requests them. If you have thousands of named entities in your map, you won't have thousands of useless objects living in Lua. Only the ones your script tries to access are imported.
]],
      args = "name: string",
      returns = "entity",
      valuetype = "entity"
      },
    has_entity = {
      type = "method",
      description = [[

Returns whether there currently exists a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) with the specified name on the map.

  * `name` (string): Name of the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) to check.
  * Return value (boolean): `true` if such an entity exists.



Remarks
    Equivalent to `map:get_entity(name) ~= nil` (but a bit lighter because it avoids to export the entity to Lua).
]],
      args = "name: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_entities = {
      type = "method",
      description = [[

Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) whose name has the specified prefix.

The typical usage of this function is: 
    
    
    for entity in map:get_entities("your_prefix") do
      -- some code related to the entity
    end
    

  * `prefix` (string, optional): Prefix of the entities to get. No value means all entities (equivalent to an empty prefix).
  * Return value (function): An iterator to all entities with this prefix. Entities are returned in Z order (insertion order).


]],
      args = "[prefix: string]",
      returns = "function",
      valuetype = "function"
      },
    get_entities_count = {
      type = "method",
      description = [[

Returns the number of [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.

  * `prefix` (string): Prefix of the entities to count.
  * Return value (number): The number of entities having this prefix on the map.


]],
      args = "prefix: string",
      returns = "number",
      valuetype = "number"
      },
    has_entities = {
      type = "method",
      description = [[

Returns whether there exists at least one [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.

This function can be used for example to checker whether a group of [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) is dead.

  * `prefix` (string): Prefix of the entities to check.
  * Return value (boolean): `true` if at least one entity with this prefix exists on the map.



Remarks
    Equivalent to `map:get_entities_count(prefix) > 0` but faster when there are a lot of entities (because it stops searching as soon as there is a match).
]],
      args = "prefix: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_entities_by_type = {
      type = "method",
      description = [[

Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) of the given type on the map.

The typical usage of this function is: 
    
    
    for entity in map:get_entities_by_type(type) do
      -- some code related to the entity
    end
    

  * `type` (string): Name of an entity type. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values.


]],
      args = "type: string",
      returns = "",
      valuetype = ""
      },
    get_entities_in_rectangle = {
      type = "method",
      description = [[

Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) whose maximum bounding box intersects the given rectangle. The maximum bounding box is the union of the entity's own [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) and of the bounding boxes from its sprites.

The typical usage of this function is: 
    
    
    for entity in map:get_entities_in_rectangle(x, y, width, height) do
      -- some code related to the entity
    end
    

  * `x` (number): X coordinate of the rectangle's upper-left corner.
  * `y` (number): Y coordinate of the rectangle's upper-left corner.
  * `width` (number): Width of the rectangle.
  * `height` (number): Height of the rectangle.
  * Return value (function): An iterator to all entities intersecting the rectangle. Entities are returned in Z order (insertion order).


]],
      args = "x: number, y: number, width: number, height: number",
      returns = "function",
      valuetype = "function"
      },
    get_entities_in_region = {
      type = "method",
      description = [[

Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that are in a region. Regions of the map are defined by the position of [separators](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) and map limits. The region of an entity is the one of its center point.

Regions should be rectangular. Non-convex regions, for example with an "L" shape, are not supported by this function.

The typical usage of this function is: 
    
    
    for entity in map:get_entities_in_region(my_entity) do
      -- some code related to the entity
    end
    

To get entities in the same region as a point:

  * `x` (number): X coordinate of the region to get.
  * `y` (number): Y coordinate of the region to get.
  * Return value (function): An iterator to all entities in the same region as the point.



To get entities in the same region as another entity:

  * `entity` (entity): An entity.
  * Return value (function): An iterator to all other entities in the same region.


]],
      args = "x: number, y: number",
      returns = "function,function",
      valuetype = "function,function"
      },
    get_hero = {
      type = "method",
      description = [[

Returns the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).

  * Return value ([hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)): The hero.



Remarks
    Equivalent to `map:get_entity("hero")` but shorter to write. This function is provided for convenience as getting the hero is often needed.
]],
      args = "",
      returns = "hero",
      valuetype = "hero"
      },
    set_entities_enabled = {
      type = "method",
      description = [[

Enables or disables all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.

Disabled entities are not displayed and are not updated. Therefore, they don't move and their collisions are no longer detected. But they still exist and can be enabled back later.

  * `prefix` (string): Prefix of the entities to change.
  * `enable` (boolean, optional): `true` to enable them, `false` to disable them. No value means `true`.



Remarks
    Equivalent to calling [entity:set_enabled()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled) on a group of entities.
]],
      args = "prefix: string, [enable: booleand]",
      returns = "",
      valuetype = ""
      },
    remove_entities = {
      type = "method",
      description = [[

Removes and destroys all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.

Once an entity is removed, it is destroyed and it no longer exists on the map. A good practice is to avoid keeping references to destroyed entities in your scripts so that they can be garbage-collected by Lua.

  * `prefix` (string): Prefix of the entities to remove from the map.



Remarks
    Equivalent to calling [entity:remove()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_remove) on a group of entities.
]],
      args = "prefix: string",
      returns = "",
      valuetype = ""
      },
    create_destination = {
      type = "method",
      description = [[

Creates an entity of type [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) on the map.

  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Direction that the hero should take when arriving on the destination, between `0` (East) and `3` (South), or `-1` to keep his direction unchanged.
    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the destination. No value means no sprite (the destination will then be invisible).
    * `save_location` (string, optional): Whether to update the [starting location](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving to this destination. If yes, when the player restarts his game, he will restart at this destination. Must be one of:
      * `"when_world_changes"` (default): Updates the starting location if the current [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
      * `"yes"`: Updates the starting location.
      * `"no"`: Does not update the starting location.
    * `default` (boolean, optional): Sets this destination as the default one when teletransporting the hero to this map without destination specified. No value means `false`. Only one destination can be the default one on a map. If no default destination is set, then the first one declared becomes the default one.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination created.


]],
      args = "properties: table: table",
      returns = "destination",
      valuetype = "destination"
      },
    create_teletransporter = {
      type = "method",
      description = [[

Creates an entity of type [teletransporter](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html) on the map.

  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels.
    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the teletransporter. No value means no sprite (the teletransporter will then be invisible).
    * `sound` (string, optional): Sound to [play](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) uses the teletransporter. No value means no sound.
    * `transition` (string, optional): Style of transition to play when the hero uses the teletransporter. Must be one of:
      * `"immediate"`: No transition.
      * `"fade"`: Fade-out and fade-in effect.
      * `"scrolling"`: Scrolling between maps. The default value is `"fade"`.
    * `destination_map` (string): Id of the map to transport to (can be the id of the current map).
    * `destination` (string, optional): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). No value means the default destination entity of the map.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([teletransporter](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html)): The teletransporter created.


]],
      args = "properties: table: table",
      returns = "teletransporter",
      valuetype = "teletransporter"
      },
    create_pickable = {
      type = "method",
      description = [[

Creates an entity of type [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) on the map.

  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `treasure_name` (string, optional): Kind of treasure to create (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, or corresponds to a [non-obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item, then no entity is created and `nil` is returned.
    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this pickable treasure was found. No value means that the treasure is not saved. If the treasure is saved and the player already has it, then no entity is be created and `nil` is returned.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html)): The pickable treasure created, or `nil` if the item is not set, not [obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), or if the pickable treasure is already found (for a saved one).


]],
      args = "properties: table: table",
      returns = "pickable treasure",
      valuetype = "pickable treasure"
      },
    create_destructible = {
      type = "method",
      description = [[

Creates an entity of type [destructible object](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `treasure_name` (string, optional): Kind of [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) to hide in the destructible object (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then no treasure is placed in the destructible object. If the treasure is not obtainable when the object is destroyed, no pickable treasure is created.
    * `treasure_variant` (number, optional): Variant of the treasure if any (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) hidden in the destructible object was found. No value means that the treasure (if any) is not saved. If the treasure is saved and the player already has it, then no treasure is put in the destructible object.
    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the destructible object.
    * `destruction_sound` (string, optional): Sound to [play](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) when the destructible object is cut or broken after being thrown. No value means no sound.
    * `weight` (number, optional): Level of `"lift"` [ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) required to lift the object. `0` allows the player to lift the object unconditionally. The special value `-1` means that the object can never be lifted. The default value is `0`.
    * `can_be_cut` (boolean, optional): Whether the hero can cut the object with the sword. No value means `false`.
    * `can_explode` (boolean, optional): Whether the object should explode when it is cut, hit by a weapon and after a delay when the hero lifts it. The default value is `false`.
    * `can_regenerate` (boolean, optional): Whether the object should automatically regenerate after a delay when it is destroyed. The default value is `false`.
    * `damage_on_enemies` (number, optional): Number of life points to remove from an enemy that gets hit by this object after the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws it. If the value is `0`, enemies will ignore the object. The default value is `1`.
    * `ground` (string, optional): Ground defined by this entity. The ground is usually `"wall"`, but you may set `"traversable"` to make the object traversable, or for example `"grass"` to make it traversable too but with an additional grass sprite below the hero. The default value is `"wall"`.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([destructible object](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html)): The destructible object created.



Remarks
    The state of the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) placed in the destructible object (obtained or not) and the possessed variant of the [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (a number) are two independent values that have different meanings and are saved separately.
]],
      args = "properties: table: table",
      returns = "destructible object",
      valuetype = "destructible object"
      },
    create_chest = {
      type = "method",
      description = [[

Creates an entity of type [treasure chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `treasure_name` (string, optional): Kind of treasure to place in the chest (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then the chest will be empty. If the treasure is not obtainable when the hero opens the chest, it becomes empty.
    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this chest is open. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then no treasure is placed in the chest (the chest will appear open).
    * `sprite` (string): Name of the animation set of the [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the chest. The sprite must have animations `"open"` and `"closed"`.
    * `opening_method` (string, optional): Specifies the permissions for the hero to open the chest. Must be one of:
      * `"interaction"` (default): Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it.
      * `"interaction_if_savegame_variable"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that a specific savegame variable is set.
      * `"interaction_if_item"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that the player has a specific [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html).
    * `opening_condition` (string, optional): The condition required to open the chest. Only for opening methods `"interaction_if_savegame_variable"` and `"interaction_if_item"`.
      * For opening method `"interaction_if_savegame_variable"`, it must be the name of a savegame variable. The [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) will be allowed to open the chest if this saved value is either `true`, an integer greater than zero or a non-empty string.
      * For opening method `"interaction_if_item"`, it must be the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). The hero will be allowed to open the chest if he has that item and, for items with an amount, if the amount is greater than zero.
      * For the default opening method (`"interaction"`), this setting has no effect.
    * `opening_condition_consumed` (boolean, optional): Whether opening the chest should consume the savegame variable or the [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) that was required. The default setting is `false`. If you set it to `true`, the following rules are applied when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) successfully opens the chest:
      * For opening method `"interaction_if_savegame_variable"`, the savegame variable that was required is reset to `false`, `0` or `""` (depending on its type).
      * For opening method is `"interaction_if_item"`, the equipment item that was required is removed. This means setting its [possessed variant](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_variant) to `0`, unless it has an associated amount: in this case, the amount is decremented.
    * `cannot_open_dialog` (string, optional): Id of the dialog to show if the hero fails to open the chest. If you don't set this value, no dialog is shown.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html)): The treasure chest created.



Remarks
    The state of the [treasure chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html) (obtained or not) and the possessed variant of its [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) are two independent values that have different meanings and are saved separately.
]],
      args = "properties: table: table",
      returns = "chest",
      valuetype = "chest"
      },
    create_jumper = {
      type = "method",
      description = [[

Creates an entity of type [jumper](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels.
    * `direction` (number): Direction of the jump, between `0` (East) and `7` (South-East). If the direction is horizontal, the width must be `8` pixels. If the direction is vertical, the height must be `8` pixels. If the direction is diagonal, the size must be square.
    * `jump_length` (number): Length of the baseline of the jump in pixels (see the [jump movement](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html) page for details).
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([jumper](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html)): The jumper created.


]],
      args = "properties: table: table",
      returns = "jumper",
      valuetype = "jumper"
      },
    create_enemy = {
      type = "method",
      description = [[

Creates an entity of type [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Initial direction of the enemy, between `0` (East) and `3` (South).
    * `breed` (string): Model of enemy to create.
    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this enemy is dead. No value means that the enemy is not saved. If the enemy is saved and was already killed, then no enemy is created. Instead, its [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created if it is a saved one.
    * `treasure_name` (string, optional): Kind of [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) to drop when the enemy is killed (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then the enemy won't drop anything. If the treasure is not obtainable when the enemy is killed, then nothing is dropped either.
    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this enemy was obtained. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the enemy won't drop anything.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) or [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html)): The enemy created, except when it is a saved enemy that is already dead. In this case, if the enemy dropped a saved treasure that is not obtained yet, this [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created and returned. Otherwise, `nil` is returned.



Remarks
    The state of the [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) (alive or dead), the state of its [treasure dropped](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) (obtained or not) and the possessed variant of the [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) dropped (a number) are three independent values that have different meanings and are saved separately.
]],
      args = "properties: table: table",
      returns = "enemy or pickable treasure",
      valuetype = "enemy or pickable treasure"
      },
    create_npc = {
      type = "method",
      description = [[

Creates an entity of type [non-playing character](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) (NPC) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Initial direction of the NPC's sprite, between `0` (East) and `3` (South).
    * `subtype` (number): Kind of NPC to create: `1` for a usual NPC who the player can talk to, `0` for a generalized NPC (not necessarily a person). See the [NPC documentation](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) for more details.
    * `sprite` (string, optional): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the NPC. No value means no sprite (the NPC will then be invisible).
    * `behavior` (string, optional): What to do when there is an interaction with the NPC.
      * `"dialog#XXXX"`: Starts the dialog with id `XXXX` when the player talks to this NPC.
      * `"map"` (default): Forwards events to the map script (for example, calls the [on_interaction()](http://www.solarus-games.org/doc/1.6/lua_api_npc.html#lua_api_npc_on_interaction) event of the NPC).
      * `"item#XXXX"`: Forwards events to an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) script (for example, calls the [on_interaction()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_npc_interaction) event of the equipment item with id `XXXX`).
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([NPC](http://www.solarus-games.org/doc/1.6/lua_api_npc.html)): the NPC created.


]],
      args = "properties: table: table",
      returns = "NPC",
      valuetype = "NPC"
      },
    create_block = {
      type = "method",
      description = [[

Creates an entity of type [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number, optional): The only direction where the block can be moved, between `0` (East) and `3` (South). `nil` means no restriction and allows the block to be moved in any of the four main directions. The default value is `nil`.
    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the block.
    * `pushable` (boolean): `true` to allow the block to be pushed.
    * `pullable` (boolean): `true` to allow the block to be pulled.
    * `max_moves` (number, optional): `How` many times the block can be moved (`nil` means unlimited). The default value is `nil`.
    * `maximum_moves` (number, optional, deprecated): Like `max_moves`, but for historical reasons, only supports `0`, `1` or the special value `2` to mean infinite. New scripts should only use `max_moves`. It is an error to set both values.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([block](http://www.solarus-games.org/doc/1.6/lua_api_block.html)): the block created.


]],
      args = "properties: table: table",
      returns = "block",
      valuetype = "block"
      },
    create_dynamic_tile = {
      type = "method",
      description = [[

Creates an entity of type [dynamic tile](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate of the top-left corner of the dynamic tile on the map.
    * `y` (number): Y coordinate of the top-left corner of the dynamic tile on the map.
    * `width` (number): Width of the dynamic tile in pixels. The tile pattern will be repeated horizontally to fit to this width.
    * `height` (number): Height of the entity in pixels. The tile pattern will be repeated vertically to fit to this height.
    * `pattern` (string): Id of the tile pattern to use from the tileset.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([dynamic tile](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html)): the dynamic tile created.


]],
      args = "properties: table: table",
      returns = "dynamic tile",
      valuetype = "dynamic tile"
      },
    create_switch = {
      type = "method",
      description = [[

Creates an entity of type [switch](http://www.solarus-games.org/doc/1.6/lua_api_switch.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `subtype` (string): Kind of switch to create:
      * `"walkable"`: A traversable pressure plate that gets activated when the hero walks on it.
      * `"solid"`: A non-traversable, solid switch that can be activated in various conditions: by the sword, by an explosion or by a projectile (a thrown object, an arrow, the boomerang or the hookshot).
      * `"arrow_target"` A switch that can be only activated by shooting an arrow on it.
    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the switch. The animation set must at least contain animations `"activated"` and `"inactivated"`. No value means no sprite.
    * `sound` (string, optional): Sound to play when the switch is activated. No value means no sound.
    * `inactivate_when_leaving` (boolean): If `true`, the switch becomes inactivated when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) or the [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html) leaves it (only for a walkable switch).
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([switch](http://www.solarus-games.org/doc/1.6/lua_api_switch.html)): the switch created.


]],
      args = "properties: table: table",
      returns = "switch",
      valuetype = "switch"
      },
    create_wall = {
      type = "method",
      description = [[

Creates an entity of type [wall](http://www.solarus-games.org/doc/1.6/lua_api_wall.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels.
    * `stops_hero` (boolean, optional): `true` to make the wall stop the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html). No value means `false`.
    * `stops_npcs` (boolean, optional): `true` to make the wall stop [non-playing characters](http://www.solarus-games.org/doc/1.6/lua_api_npc.html). No value means `false`.
    * `stops_enemies` (boolean, optional): `true` to make the wall stop [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html). No value means `false`.
    * `stops_blocks` (boolean, optional): `true` to make the wall stop [blocks](http://www.solarus-games.org/doc/1.6/lua_api_block.html). No value means `false`.
    * `stops_projectiles` (boolean, optional): `true` to make the wall stop projectiles: [thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), the [hookshot](http://www.solarus-games.org/doc/1.6/lua_api_hookshot.html) and [the boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html). No value means `false`.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([wall](http://www.solarus-games.org/doc/1.6/lua_api_wall.html)): the wall created.


]],
      args = "properties: table: table",
      returns = "wall",
      valuetype = "wall"
      },
    create_sensor = {
      type = "method",
      description = [[

Creates an entity of type [sensor](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([sensor](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html)): the sensor created.


]],
      args = "properties: table: table",
      returns = "sensor",
      valuetype = "sensor"
      },
    create_crystal = {
      type = "method",
      description = [[

Creates an entity of type [crystal](http://www.solarus-games.org/doc/1.6/lua_api_crystal.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([crystal](http://www.solarus-games.org/doc/1.6/lua_api_crystal.html)): the crystal created.


]],
      args = "properties: table: table",
      returns = "crystal",
      valuetype = "crystal"
      },
    create_crystal_block = {
      type = "method",
      description = [[

Creates an entity of type [crystal block](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels.
    * `subtype` (number): Kind of crystal block to create: `0` for a block initially lowered (orange), `1` for a block initially raised (blue).
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([crystal block](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html)): the crystal block created.


]],
      args = "properties: table: table",
      returns = "crystal block",
      valuetype = "crystal block"
      },
    create_shop_treasure = {
      type = "method",
      description = [[

Creates an entity of type [shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `price` (number): Money amount required to buy the treasure.
    * `font` (string, optional): Id of the font to use to display to price. The default value is the first one in alphabetical order.
    * `dialog` (string): Id of the dialog to show when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) asks for information about the treasure.
    * `treasure_name` (string): Kind of treasure to sell (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value or corresponds to a [non-obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item, then the shop treasure is not created and `nil` is returned.
    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the player has purchased this treasure. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the shop treasure is not created and `nil` is returned.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html)): The shop treasure created, or `nil` if the item is not [obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), or if the shop treasure was already purchased (for a saved one).



Remarks
    The state of the [shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html) (purchased or not) and the possessed variant of its [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (a number) are two independent values that have different meanings and are saved separately.
]],
      args = "properties: table: table",
      returns = "shop treasure",
      valuetype = "shop treasure"
      },
    create_stream = {
      type = "method",
      description = [[

Creates an entity of type [stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Direction where the stream moves the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), between `0` (East) and `7` (South-East).
    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the stream. No value means no sprite (the stream will then be invisible).
    * `speed` (number, optional): Speed of the movement applied to the hero by the stream, in pixels per second. The default value is `64`.
    * `allow_movement` (boolean, optional): Whether the player can still move the hero when he is on the stream. The default value is `true`.
    * `allow_attack` (boolean, optional): Whether the player can use the sword when he is on the stream. The default value is `true`.
    * `allow_item` (boolean, optional): Whether the player can use equipment items when he is on the stream. The default value is `true`.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html)): the stream created.


]],
      args = "properties: table: table",
      returns = "stream",
      valuetype = "stream"
      },
    create_door = {
      type = "method",
      description = [[

Creates an entity of type [door](http://www.solarus-games.org/doc/1.6/lua_api_door.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Direction of the door, between `0` (East of the room) and `3` (South of the room).
    * `sprite` (string): Name of the animation set of the [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the door. The sprite must have an animation `"closed"`, that will be shown while the door is closed. When the door is open, no sprite is displayed. Optionally, the sprite can also have animations `"opening"` and `"closing"`, that will be shown (if they exist) while the door is being opened or closed, respectively. If they don't exist, the door will open close instantly.
    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this door is open. No value means that the door is not saved. If the door is saved as open, then it appears open.
    * `opening_method` (string, optional): How the door is supposed to be opened by the player. Must be one of:
      * `"none"` (default): Cannot be opened by the player. You can only open it from Lua.
      * `"interaction"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it.
      * `"interaction_if_savegame_variable"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that a specific savegame variable is set.
      * `"interaction_if_item"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that the player has a specific [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html).
      * `"explosion"`: Can be opened by an explosion.
    * `opening_condition` (string, optional): The condition required to open the door. Only for opening methods `"interaction_if_savegame_variable"` and `"interaction_if_item"`.
      * For opening method `"interaction_if_savegame_variable"`, it must be the name of a savegame variable. The [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) will be allowed to open the door if this saved value is either `true`, an integer greater than zero or a non-empty string.
      * For opening method `"interaction_if_item"`, it must be the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). The hero will be allowed to open the door if he has that item and, for items with an amount, if the amount is greater than zero.
      * For other opening methods, this setting has no effect.
    * `opening_condition_consumed` (boolean, optional): Whether opening the door should consume the savegame variable or the [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) that was required. The default setting is `false`. If you set it to `true`, the following rules are applied when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) successfully opens the door:
      * For opening method `"interaction_if_savegame_variable"`, the savegame variable that was required is reset to `false`, `0` or `""` (depending on its type).
      * For opening method is `"interaction_if_item"`, the equipment item that was required is removed. This means setting its [possessed variant](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_variant) to `0`, unless it has an associated amount: in this case, the amount is decremented.
      * With other opening methods, this setting has no effect.
    * `cannot_open_dialog` (string, optional): Id of the dialog to show if the hero fails to open the door. If you don't set this value, no dialog is shown.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([door](http://www.solarus-games.org/doc/1.6/lua_api_door.html)): The [door](http://www.solarus-games.org/doc/1.6/lua_api_door.html) created.


]],
      args = "properties: table: table",
      returns = "door",
      valuetype = "door"
      },
    create_stairs = {
      type = "method",
      description = [[

Creates an entity of type [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `direction` (number): Direction where the stairs should be turned between `0` (East of the room) and `3` (South of the room). For stairs inside a single floor, this is the direction of going upstairs.
    * `subtype` (number): Kind of stairs to create:
      * `0`: Spiral staircase going upstairs.
      * `1`: Spiral staircase going downstairs.
      * `2`: Straight staircase going upstairs.
      * `3`: Straight staircase going downstairs.
      * `4`: Small stairs inside a single floor (change the layer of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)).
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html)): the stairs created.


]],
      args = "properties: table: table",
      returns = "stairs",
      valuetype = "stairs"
      },
    create_bomb = {
      type = "method",
      description = [[

Creates an entity of type [bomb](http://www.solarus-games.org/doc/1.6/lua_api_bomb.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([bomb](http://www.solarus-games.org/doc/1.6/lua_api_bomb.html)): the bomb created.


]],
      args = "properties: table: table",
      returns = "bomb",
      valuetype = "bomb"
      },
    create_explosion = {
      type = "method",
      description = [[

Creates an entity of type [explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html)): the explosion created.


]],
      args = "properties: table: table",
      returns = "explosion",
      valuetype = "explosion"
      },
    create_fire = {
      type = "method",
      description = [[

Creates an entity of type [fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html) on the map.

  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html)): the fire created.


]],
      args = "properties: table: table",
      returns = "fire",
      valuetype = "fire"
      },
    create_separator = {
      type = "method",
      description = [[

Creates an entity of type [separator](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) on the map.

  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels.
    * `height` (number): Height of the entity in pixels. One of `width` or `height` must be 16 pixels.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([separator](http://www.solarus-games.org/doc/1.6/lua_api_separator.html)): The separator created.


]],
      args = "properties: table: table",
      returns = "separator",
      valuetype = "separator"
      },
    create_custom_entity = {
      type = "method",
      description = [[

Creates an entity of type [custom entity](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) on the map.

  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
    * `direction` (number): Direction of the custom entity, between `0` (East) and `3` (South). This direction will be applied to the entity's sprites if possible.
    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
    * `x` (number): X coordinate on the map.
    * `y` (number): Y coordinate on the map.
    * `width` (number): Width of the entity in pixels (default `16`).
    * `height` (number): Height of the entity in pixels (default `16`).
    * `sprite` (string, optional): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the custom entity.
    * `model` (string, optional): Model of custom entity or `nil`. The model is the name of a Lua script in the `"entities"` directory of your quest. It will define the behavior of your entity. This script will be called with the entity as parameter. Models are useful when you need to create lots of similar entities, especially in different maps. `nil` means no model: in this case, no particular script will be called but you can still define the behavior of your entity in the map script.
    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
  * Return value ([custom entity](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html)): The custom entity created.



#  Events of a map

Events are callback methods automatically called by the engine if you define them. In the case of maps, they are only called on the current map.
]],
      args = "properties: table: table",
      returns = "custom entity",
      valuetype = "custom entity"
      },
    on_started = {
      type = "method",
      description = [[

Called when this map starts (when the player enters it).

  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrives on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).


]],
      args = "destination: destination",
      returns = "",
      valuetype = ""
      },
    on_finished = {
      type = "method",
      description = [[

Called when this map stops (when the player leaves it).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle of the main loop while this map is the current one.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_draw = {
      type = "method",
      description = [[

Called when the map has just been redrawn by the engine.

The engine has already drawn the map, but not the [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of this map if any. Use this event if you want to draw some additional content on the map before the menus, for example an overlay.

  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The surface where the map is drawn. This surface represents the visible part of the screen, not the whole map.


]],
      args = "dst_surface: surface",
      returns = "",
      valuetype = ""
      },
    on_suspended = {
      type = "method",
      description = [[

Called when the map has just been suspended or resumed.

The map is suspended by the engine in a few cases, like when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation.

  * `suspended` (boolean): `true` if the map was just suspended, `false` if it was resumed.


]],
      args = "suspended: boolean",
      returns = "",
      valuetype = ""
      },
    on_opening_transition_finished = {
      type = "method",
      description = [[

When the map begins, called when the opening transition effect finishes.

  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrived on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).


]],
      args = "destination: destination",
      returns = "",
      valuetype = ""
      },
    on_obtaining_treasure = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is obtaining a treasure on this map, before the treasure's dialog (if any).

  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item being obtained.
  * `treasure_variant` (number): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants).
  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this treasure is found, or `nil` if this treasure is not saved.


]],
      args = "treasure_item: item, treasure_variant: number, treasure_savegame_variable: string",
      returns = "",
      valuetype = ""
      },
    on_obtained_treasure = {
      type = "method",
      description = [[

Called after the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) has obtained a treasure on this map.

In the case of a brandished treasure, this event is called once the treasure's dialog is finished. Otherwise, it is called immediately after [map:on_obtaining_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_obtaining_treasure).

  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item being obtained.
  * `treasure_variant` (number): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants).
  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this treasure is found, or `nil` if this treasure is not saved.


]],
      args = "treasure_item: item, treasure_variant: number, treasure_savegame_variable: string",
      returns = "",
      valuetype = ""
      },
    on_key_pressed = {
      type = "method",
      description = [[

Called when the user presses a keyboard key while your map is active.

  * `key` (string): Name of the raw key that was pressed.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed). If you want the corresponding higher-level game command (if any), see [map:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_command_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_key_released = {
      type = "method",
      description = [[

Called when the user releases a keyboard key while your map is active.

  * `key` (string): Name of the raw key that was released.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed). If you want the corresponding higher-level game command (if any), see [map:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_command_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_character_pressed = {
      type = "method",
      description = [[

Called when the user enters text while your map is active.

  * `character` (string): A utf-8 string representing the character that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    When a character key is pressed, two events are called: [map:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_key_pressed) (indicating the raw key) and [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed) (indicating the utf-8 character). If your script needs to input text from the user, [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
]],
      args = "character: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_pressed = {
      type = "method",
      description = [[

Called when the user presses a joypad button while your map is active.

  * `button` (number): Index of the button that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_released = {
      type = "method",
      description = [[

Called when the user releases a joypad button while your map is active.

  * `button` (number): Index of the button that was released.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_axis_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad axis while your map is active.

  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "axis: number, state: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_hat_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad hat while your map is active.

  * `hat` (number): Index of the hat that was moved.
  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "hat: number, direction8: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_pressed = {
      type = "method",
      description = [[

Called when the player presses a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior) while this map is active. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was pressed. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_released = {
      type = "method",
      description = [[

Called when the player released a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). while this map is active. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was released. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_pressed = {
      type = "method",
      description = [[

Called when the user presses a mouse button while this map is active.

  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_released = {
      type = "method",
      description = [[

Called when the user releases a mouse button while this map is active.

  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_pressed = {
      type = "method",
      description = [[

Called when the user presses a finger while this map is active.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_released = {
      type = "method",
      description = [[

Called when the user releases a finger while this map is active.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_moved = {
      type = "method",
      description = [[

Called when the user moves a finger while this map is active.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dx` (integer): The horizontal distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dy` (integer): The vertical distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.



#  Deprecated methods of the type map

The following methods are deprecated and may be removed it future releases.
]],
      args = "finger: integer, x: integer, y: integer, dx: integer: integer, dy: integer: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      }
    },
  inherits = "entity"
  },
hero = {
  type = "class",
  description = [[

The hero is the character controlled by the player. There is always exactly one hero on the current map. The hero is automatically created by the engine: you cannot create or remove him.
]],
  childs = {
    teleport = {
      type = "method",
      description = [[

Teletransports the hero to a different place.

  * `map_id` (string): Id of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) to go to (may be the same map or another one). If the map does not exist, the teletransportation fails and this function generates a Lua error. If the map exists, then the teletransportation is always successful even if there is no viable destination (see below).
  * `destination_name` (string, optional): Name of the [destination entity](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) where to go on that map, or the special keyword `"_same"` to keep the same coordinates. Can also be the special keyword `"_side0"`, `"_side1"`, `"_side2"` or `"_side3"` to arrive near the East, North, West or South frontier of the map respectively. But the hero should be near the corresponding side of the original map for this to look okay. This is usually used in combination with scrolling transitions. No value means the default destination entity of the map. If the destination does not exist, a debugging message is logged and the default destination is used as a fallback. Finally, if there is no destination at all, then no default destination can be used. In this case, another debugging message is logged and the hero is placed at coordinates ``(0,0).
  * `transition_style` (string, optional): `"immediate"` (no transition effect) `"fade"` (fade-out and fade-in effect) or `"scrolling"`. The default value is `"fade"`.



Remarks
    The transportation will occur at the next cycle of the engine's main loop. Therefore, your map is not unloaded immediately and your map script continues to work.
]],
      args = "map_id: string, [destination_name: string, [transition_style: string]]",
      returns = "",
      valuetype = ""
      },
    get_direction = {
      type = "method",
      description = [[

Returns the direction of the hero's [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html).

  * Return value (number): The direction of the hero's sprites, between `0` (East) and 3 (South).



Remarks
    The direction of the hero's sprites may be different from both the direction pressed by the [player's](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_commands_direction) commands" and from the actual direction of the hero's \ref lua_api_movement "movement".
]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_direction = {
      type = "method",
      description = [[

Sets the direction of the hero's [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html).

  * `direction4` (number): The direction of the hero's sprites, between `0` (East) and 3 (South).



Remarks
    The direction of the hero's sprites may be different from both the direction pressed by the [player's](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_commands_direction) commands" and from the actual direction of the hero's \ref lua_api_movement "movement".
]],
      args = "direction4: number",
      returns = "",
      valuetype = ""
      },
    get_walking_speed = {
      type = "method",
      description = [[

Returns the speed of the normal walking movement of hero.

This speed is automatically reduced when the hero walks on special ground like grass, ladders or holes.

  * Return value (number): The speed of normal walk in pixels par second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_walking_speed = {
      type = "method",
      description = [[

Sets the speed of the normal walking movement of hero.

The default walking speed is 88 pixels per second. This speed is automatically reduced when the hero walks on special ground like grass, ladders or holes.

  * `walking` speed (number): The speed of normal walk in pixels par second.


]],
      args = "walking_speed",
      returns = "",
      valuetype = ""
      },
    save_solid_ground = {
      type = "method",
      description = [[

Sets a position to go back to if the hero falls into a hole or other bad ground.

This replaces the usual behavior which is going back to the last solid position before the fall.

The position can be specified either as coordinates and a layer, or as a function that returns coordinates and a layer. Using a function allows to decide the position at the last moment.

To memorize a position directly:

  * `x` (number, optional): X coordinate to memorize (no value means the current position).
  * `y` (number, optional): Y coordinate to memorize (no value means the current position).
  * `layer` (number, optional): Layer to memorize (no value means the current position).



To set a function that indicates the position to go back to:

  * `callback` (function): A function to be called whenever the hero falls into bad ground. The function should return 2 or 3 values: x, y and optionally the layer (no layer value means keeping the layer unchanged). A `nil` value unsets any position or function that was previously set.


]],
      args = "[x: number, y: number, lay: numberer]",
      returns = "",
      valuetype = ""
      },
    reset_solid_ground = {
      type = "method",
      description = [[

Forgets a position that was previously memorized by [hero:save_solid_ground()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_save_solid_ground) (if any).

The initial behavior is restored: the hero will now get back to where he was just before falling, instead going to of a memorized position.

This is equivalent to `hero:save_solid_ground(nil)`.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_solid_ground_position = {
      type = "method",
      description = [[

Returns the position where the hero gets back if he falls into a hole or other bad ground now.

This is the position that was previously memorized by the last call to [hero:save_solid_ground()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_save_solid_ground), if any. If the position was passed to [hero:save_solid_ground()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_save_solid_ground) as a function, then this function is called to get a position.

Otherwise, this is the position of the hero the last time he was on solid ground.

  * Return value 1 (number): X coordinate where to get back to solid ground, or `nil` if the hero never went on solid ground on this map yet.
  * Return value 2 (number): Y coordinate where to get back to solid ground, or no value if the hero never went on solid ground on this map yet.
  * Return value 3 (number): Layer where to get back to solid ground, or no value if the hero never went on solid ground on this map yet.


]],
      args = "",
      returns = "number,number,number",
      valuetype = "number,number,number"
      },
    get_animation = {
      type = "method",
      description = [[

Returns the current animation of the hero's sprites.

The hero may have several sprites (see [hero:set_animation()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_animation). This function always returns the animation of the tunic sprite.

  * Return value (string): The animation name of the tunic sprite.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_animation = {
      type = "method",
      description = [[

Changes the animation of the hero's sprites.

The hero has several [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), that are normally displayed or not depending on his [state](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) and his [abilities](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability):

  * the body (the tunic),
  * the shield,
  * the sword,
  * the sword stars,
  * the trail of dust (by default, only shown when running).



The animation of all these sprites is usually managed by the engine to represent the current state of the hero. You can use this function to customize the animation. This allows you to implement custom actions that are not provided by the built-in states. Make sure that you don't call this function when the hero is not already doing a particular action (like pushing something or attacking), unless you know what you are doing.

All sprites of the hero that have an animation with the specified name take the animation. The ones that don't have such an animation are not displayed.

  * `animation` (string): Name of the animation to set to hero sprites.
  * `callback` (function, optional): A function to call when the animation ends (on the tunic sprite). If the animation loops, or is replaced by another animation before it ends, then the function will never be called.


]],
      args = "animation: string, [callback: function]",
      returns = "",
      valuetype = ""
      },
    get_tunic_sprite_id = {
      type = "method",
      description = [[

Returns the name of the sprite representing the hero's body.

  * Return value (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's tunic.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_tunic_sprite_id = {
      type = "method",
      description = [[

Changes the sprite representing the hero's body.

By default, the sprite used for the body is `"hero/tunicX"`, where X is the [tunic level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability).

You can use this function if you want to use another sprite.

  * `sprite_id` (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's tunic.


]],
      args = "sprite_id: string",
      returns = "",
      valuetype = ""
      },
    get_sword_sprite_id = {
      type = "method",
      description = [[

Returns the name of the sprite representing the hero's sword.

  * Return value (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's sword.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_sword_sprite_id = {
      type = "method",
      description = [[

Changes the sprite representing the hero's sword.

By default, the sprite used for the sword is `"hero/swordX"`, where X is the [sword level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability), or no sprite if the sword level is `0`.

You can use this function if you want to use another sprite.

  * `sprite_id` (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's sword. An empty string means no sword sprite.


]],
      args = "sprite_id: string",
      returns = "",
      valuetype = ""
      },
    get_sword_sound_id = {
      type = "method",
      description = [[

Returns the name of the sound played when the hero uses the sword.

  * Return value (string): The sound id of the hero's sword.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_sword_sound_id = {
      type = "method",
      description = [[

Changes the sound to play when the hero uses the sword.

By default, the sound used for the sword is `"swordX"`, where X is the [sword level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability), or no sound if the sword level is `0`.

You can use this function if you want another sound to be played.

  * `sound_id` (string): The sound id of the hero's sword. An empty string means no sword sound.


]],
      args = "sound_id: string",
      returns = "",
      valuetype = ""
      },
    get_shield_sprite_id = {
      type = "method",
      description = [[

Returns the name of the sprite representing the hero's shield.

  * Return value (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's shield.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_shield_sprite_id = {
      type = "method",
      description = [[

Changes the sprite representing the hero's shield.

By default, the sprite used for the shield is `"hero/shieldX"`, where X is the [shield level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability), or no sprite if the shield level is `0`.

You can use this function if you want to use another sprite.

  * `sprite_id` (string): The [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) animation set id of the hero's shield. An empty string means no shield sprite.


]],
      args = "sprite_id: string",
      returns = "",
      valuetype = ""
      },
    is_invincible = {
      type = "method",
      description = [[

Returns whether the hero is currently invincible.

The hero is temporarily invincible after being hurt or after you called [hero:set_invincible()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_invincible). In this situation, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) cannot attack the hero, but you can still hurt him manually with [hero:start_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt).

  * Return value (boolean): `true` if the hero is currently invincible.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_invincible = {
      type = "method",
      description = [[

Sets or unsets the hero temporarily invincible.

When the hero is invincible, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) cannot attack him, but you can still hurt him manually with [hero:start_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt).

  * `invincible` (boolean, optional): `true` to make the hero invincible, or `false` to stop the invincibility. No value means `true`.
  * `duration` (number, optional): Duration of the invincibility in milliseconds. Only possible when you set `invincible` to `true`. No value means unlimited.


]],
      args = "[invincible: boolean, [duration: number]]",
      returns = "",
      valuetype = ""
      },
    is_blinking = {
      type = "method",
      description = [[

Returns whether the hero's sprites are currently blinking.

The sprites are temporarily blinking after the hero was hurt or after you called [hero:set_blinking()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_blinking).

  * Return value (boolean): `true` if the hero's sprite are currently blinking.



Remarks
    The visibility property of the hero is independent from this. Even when the sprites are blinking, the result of [hero:is_visible()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_visible) is unchanged.
]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_blinking = {
      type = "method",
      description = [[

Makes the hero's sprites temporarily blink or stop blinking.

This only affects displaying: see [hero:set_invincible()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_invincible) if you also want to make the hero invincible.

  * `blinking` (boolean, optional): `true` to to make the sprites blink, or `false` to stop the blinking. No value means `true`.
  * `duration` (number, optional): Duration in milliseconds before stopping the blinking. Only possible when you set `blinking` to `true`. No value means unlimited.


]],
      args = "[blinking: boolean, [duration: number]]",
      returns = "",
      valuetype = ""
      },
    get_carried_object = {
      type = "method",
      description = [[

Returns the [carried object](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) the hero is currently lifting, carrying or throwing, if any.

  * Return value ([carried object](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html)): The current carried object or `nil`.


]],
      args = "",
      returns = "carried object",
      valuetype = "carried object"
      },
    freeze = {
      type = "method",
      description = [[

Prevents the player from moving the hero until you call [hero:unfreeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_unfreeze).

After you call this method, the [state](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) of the hero is `"frozen"`.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    unfreeze = {
      type = "method",
      description = [[

Restores the control to the player. The control may have been lost for example by a call to [hero:freeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_freeze) or to [some_movement:start(hero)](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_start).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    walk = {
      type = "method",
      description = [[

Makes the hero move with the specified path and a walking animation. The player cannot control him during the movement.

  * `path` (string): The path as a string sequence of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.
  * `loop` (boolean, optional): `true` to repeat the path once it is done (default `false`).
  * `ignore_obstacles` (boolean, optional): `true` to allow the hero to traverse obstacles during this movement (default `false`). Make sure the movement does not end inside an obstacle.


]],
      args = "path: string, [loop: boolean, [ignore_obstacles: boolean]]",
      returns = "",
      valuetype = ""
      },
    start_jumping = {
      type = "method",
      description = [[

Makes the hero jump towards the specified direction.

  * `direction8` (number): Direction of the jump, between `0` and `7` (see [jump_movement:set_direction8()](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html#lua_api_jump_movement_set_direction8)).
  * `distance` (number): Distance of the jump in pixels (see [jump_movement:set_distance()](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html#lua_api_jump_movement_set_distance)).
  * `ignore_obstacles` (boolean, optional): `true` to allow the hero to traverse obstacles during this movement (default `false`). Make sure the movement does not end inside an obstacle.


]],
      args = "direction8: number, distance: number, [ignore_obstacles: boolean]",
      returns = "",
      valuetype = ""
      },
    start_attack = {
      type = "method",
      description = [[

Makes the hero perform his main attack (swinging his sword).

This function does the same as what happens when the player presses the `"attack"` game [command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands). You can use it to trigger the attack from your script instead of from a game command.

If the player is not allowed to perform the attack now (because he does not have the sword [ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) or because the hero is currently busy in another state), then nothing happens.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    start_item = {
      type = "method",
      description = [[

Makes the hero use an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html).

The [item:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) event will be called and the player won't be able to control the hero until you call [item:set_finished()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_finished). See the documentation of [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) for more information.

This function does the same as what happens when the player presses a game [command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) corresponding to this equipment item. You can use it to trigger the item from your script instead of from a game command.

If the player is not allowed to use the item now (because he does not have it, because the item cannot be used explicitly, or because the hero is currently busy in another state), then nothing happens.

  * `item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The equipment item to start using.


]],
      args = "item: item",
      returns = "",
      valuetype = ""
      },
    start_treasure = {
      type = "method",
      description = [[

Gives a treasure to the player. The hero will brandish the treasure as follows.

The hero sprites take the animation `"treasure"`. The treasure is displayed above the hero, as the sprite `"entities/items"` with animation `treasure_name` and direction `treasure_variant - 1`. If this sprite, this animation or this direction do not exist, then no treasure sprite is displayed above the hero.

If a dialog called `"_treasure.treasure_name.treasure_variant"` exists, then this dialog is displayed during the brandishing animation. For example, calling `hero:start_treasure("heart", 1)` will automatically show the dialog `_treasure.heart.1`.

  * `treasure_name` (string, optional): Kind of treasure to give (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). The treasure must be an [obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item.
  * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
  * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this treasure is found. No value means that the state of the treasure is not saved. It is allowed (though strange) to give the same saved treasure twice.
  * `callback` (function, optional): A function that will be called when the treasure's dialog finishes, or after a delay of 3 seconds if there is no dialog.



Remarks
    If there is no callback, or if the callback does not change the state of the hero, then he automatically stops the brandishing animation.
]],
      args = "treasure_name: string, [treasure_variant: number, [treasure_savegame_variable: string, [callback: function]]]",
      returns = "",
      valuetype = ""
      },
    start_victory = {
      type = "method",
      description = [[

Makes the hero brandish his sword for a victory.

  * `callback` (function, optional): A function to call when the victory sequence finishes. If you don't define it, the default behavior is to restore control to the player. If you define it, you can do other things, like teletransporting the hero somewhere else. To restore the control to the player, call [hero:unfreeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_unfreeze).


]],
      args = "[callback: function]",
      returns = "",
      valuetype = ""
      },
    start_boomerang = {
      type = "method",
      description = [[

Makes the hero shoot a [boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html).

  * `max_distance` (number): Maximum distance of the boomerang's movement in pixels.
  * `speed` (number): Speed of the boomerang's movement in pixels per second.
  * `tunic_preparing_animation` (string): Name of the animation that the hero's tunic sprite should take while preparing the boomerang.
  * `sprite_name` (string): Sprite animation set to use to draw the boomerang then.


]],
      args = "max_distance: number, speed: number, tunic_preparing_animation: string, sprite_name: string",
      returns = "",
      valuetype = ""
      },
    start_bow = {
      type = "method",
      description = [[

Makes the hero shoot an [arrow](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html) with a bow.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    start_hookshot = {
      type = "method",
      description = [[

Makes the hero throw a [hookshot](http://www.solarus-games.org/doc/1.6/lua_api_hookshot.html).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    start_running = {
      type = "method",
      description = [[

Makes the hero run.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    start_hurt = {
      type = "method",
      description = [[

Same as [hero:start_hurt(source_x, source_y, damage)](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt), but specifying the source coordinates as an optional entity and possibly its sprite.

  * `source_entity` ([map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html), optional): Whatever hurts the hero. The coordinates of this source entity are used to push the hero away from that source. No value means that the hero will not be pushed away.
  * `source_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), optional): Which sprite of the source entity is hurting the hero. If you set this value, the hero will be pushed away from the origin of this sprite instead of from the origin of the source entity. Most of the time, you don't need to set this parameter.
  * `damage:` Base number of life points to remove (possibly `0`). This number will be divided by the [tunic](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) level of the player, unless you override this default calculation in [hero:on_taking_damage()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_on_taking_damage).


]],
      args = "[source_entity: map entity, [source_sprite: sprite]], damage",
      returns = "",
      valuetype = ""
      },
    get_state = {
      type = "method",
      description = [[

Returns the name of the current state of the hero, and possibly the corresponding [custom state](http://www.solarus-games.org/doc/1.6/lua_api_state.html) object if any.

  * Return value 1 (`string`): The current state. Can be one of: `"back to solid ground"`, `"boomerang"`, `"bow"`, `"carrying"`, `"falling"`, `"forced walking"`, `"free"`, `"frozen"`, `"grabbing"`, `"hookshot"`, `"hurt"`, `"jumping"`, `"lifting"`, `"plunging"`, `"pulling"`, `"pushing"`, `"running"`, `"stairs"`, `"swimming"`, `"sword loading"`, `"sword spin attack"`, `"sword swinging"`, `"sword tapping"`, `"treasure"`, `"using item"`, `"victory"` or `"custom"`.
  * Return value 2 ([state](http://www.solarus-games.org/doc/1.6/lua_api_state.html) or no value): The custom state object, in case the state name is `"custom"`.


]],
      args = "",
      returns = "string,state or no value",
      valuetype = "string,state or no value"
      },
    start_state = {
      type = "method",
      description = [[

Starts a [custom state](http://www.solarus-games.org/doc/1.6/lua_api_state.html) on the hero.

Custom states allow advanced customization of the hero's behavior. After you call this method, the hero state string as returned by [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) is `"custom"`. Use [hero:get_state_object()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state_object) to get the actual custom state object.
]],
      args = "state",
      returns = "",
      valuetype = ""
      },
    get_state_object = {
      type = "method",
      description = [[

Returns the current custom state object of the hero, if any.

  * Return value ([state](http://www.solarus-games.org/doc/1.6/lua_api_state.html)) : The custom state, or `nil` if the current state is not a custom one.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

The hero is a particular [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, he inherits all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type hero

The following events are specific to the hero.

Recall that the hero persists when the player goes to another map, and so do the events defined on the hero.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_state_changing = {
      type = "method",
      description = [[

Called when the state of the hero is about to change.

  * `state_name` (string): Name of the current built-in state. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the list of possible built-in states.
  * `next_state_name` (string): Name of the built-in state about to start. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the list of possible built-in states.


]],
      args = "state_name: string, next_state_name: string: string",
      returns = "",
      valuetype = ""
      },
    on_state_changed = {
      type = "method",
      description = [[

Called when the state of the hero has just changed.

  * `new_state_name` (string): Name of the new state. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the list of possible state names.



Remarks
    This event is called even for the initial state of the hero, right after [game:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_on_started). This initial state is always `"free"`.
]],
      args = "new_state_name: string",
      returns = "",
      valuetype = ""
      },
    on_taking_damage = {
      type = "method",
      description = [[

Called when the hero is hurt and should take damages.

This happens usually after a collision with an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) or when you call [hero:start_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt).

This event allows you to override what happens when the hero takes damage. By default, if you don't define this event, the hero loses some life as follows. The life lost is the damage inflicted by the attacker divided by the [tunic level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) of the player, with a minimum of `1` (unless the initial damage was already `0`).

You can define this event if you need to change how the hero takes damage, for example if you want the [shield level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) to give better resistance to injuries.

  * `damage` (number): Damage inflicted by the attacker, no matter if this was an enemy or a call to [hero:start_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt). 


]],
      args = "damage: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
dynamic_tile = {
  type = "class",
  description = [[

Dynamic tiles are [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) that can be hidden, shown, created and deleted at runtime.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_dynamic_tile()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_dynamic_tile).
]],
  childs = {
    get_pattern_id = {
      type = "method",
      description = [[

Returns the id of the tile pattern of this dynamic tile.

  * Return value (string): The tile pattern id in the tileset.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_tileset = {
      type = "method",
      description = [[

Returns the id of the tileset of this dynamic tile.

  * Return value (string or nil): The tileset id, or `nil` if no tileset is set for the dynamic tile (in this case, the tileset of the map is used).


]],
      args = "",
      returns = "string or nil",
      valuetype = "string or nil"
      },
    set_tileset = {
      type = "method",
      description = [[

Sets the tileset of this dynamic tile.

  * `tileset_id` (string or nil): The tileset id, or `nil` to clear the tileset for the dynamic tile (in this case, the tileset of the map is used).


]],
      args = "tileset_id: string or nil",
      returns = "",
      valuetype = ""
      },
    get_modified_ground = {
      type = "method",
      description = [[

Returns the ground defined by this dynamic tile on the map.

The presence of a dynamic tile can modify the ground of the map. This is determined by the ground property of the tile pattern.

  * Return value (string): The ground defined by this dynamic tile. `"empty"` means that this dynamic tile does not modify the ground of the map. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Dynamic tiles are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type dynamic tile

None. 
]],
      args = "",
      returns = "string",
      valuetype = "string"
      }
    },
  inherits = "entity"
  },
teletransporter = {
  type = "class",
  description = [[

A teletransporter is a detector that sends the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) to another place when he walks on it.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_teletransporter()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_teletransporter).
]],
  childs = {
    get_sound = {
      type = "method",
      description = [[

Returns the sound to be played when the hero uses this teletransporter.

  * Return value (string): Id of the teletransporter's sound. `nil` means that no sound will be played.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_sound = {
      type = "method",
      description = [[

Sets the sound to be played when the hero uses this teletransporter.

  * `sound_id` (string): Id of the teletransporter's sound. `nil` means that no sound will be played.


]],
      args = "sound_id: string",
      returns = "",
      valuetype = ""
      },
    get_transition = {
      type = "method",
      description = [[

Returns the style of transition to play when the hero uses this teletransporter.

  * Return value (string): The transition style. Can be one of:
    * `"immediate"`: No transition.
    * `"fade"`: Fade-out and fade-in effect.
    * `"scrolling"`: Scrolling between maps.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_transition = {
      type = "method",
      description = [[

Sets the style of transition to play when the hero uses this teletransporter.

  * `transition_style` (string): The transition style. Can be one of:
    * `"immediate"`: No transition.
    * `"fade"`: Fade-out and fade-in effect.
    * `"scrolling"`: Scrolling between maps.


]],
      args = "transition_style: string",
      returns = "",
      valuetype = ""
      },
    get_destination_map = {
      type = "method",
      description = [[

Returns the id of the destination [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of this teletransporter.

  * Return value (string): Id of the destination map.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_destination_map = {
      type = "method",
      description = [[

Sets the destination [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of this teletransporter.

  * `map_id` (string): Id of the destination map to set.


]],
      args = "map_id: string",
      returns = "",
      valuetype = ""
      },
    get_destination_name = {
      type = "method",
      description = [[

Returns the name of the destination place on the destination map.

  * Return value (string): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). `nil` means the default destination entity of the map.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_destination_name = {
      type = "method",
      description = [[

Sets the destination place on the destination map.

  * `destination_name` (string): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). `nil` means the default destination entity of the map.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Teletransporters are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type teletransporter

The following events are specific to teletransporters.
]],
      args = "destination_name: string",
      returns = "",
      valuetype = ""
      },
    on_activated = {
      type = "method",
      description = [[

Called when the user takes this teletransporter, just before the map closing transition starts.

Remarks
    If you [disable](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled) or [remove](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_remove) the teletransporter during this event, then the teletransportation does not occur. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
destination = {
  type = "class",
  description = [[

A destination is a possible arrival place for [teletransporters](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html).

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_destination()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_destination).
]],
  childs = {
    get_starting_location_mode = {
      type = "method",
      description = [[

Returns whether this destination updates the [starting location](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving on it. If yes, when the player restarts his game, he will restart at this destination. The default value is `"when_world_changes"`.

  * Return value (string): The starting location mode. Can be one of:
    * `"when_world_changes"`: Updates the starting location if the current [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
    * `"yes"`: Updates the starting location.
    * `"no"`: Does not update the starting location.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_starting_location_mode = {
      type = "method",
      description = [[

Sets whether this destination updates the [starting location](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving on it. If yes, when the player restarts his game, he will restart at this destination. The default value is `"when world changes"`.

  * `mode` (string): The starting location mode. Can be one of:
    * `"when_world_changes"`: Updates the starting location if the current [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
    * `"yes"`: Updates the starting location.
    * `"no"`: Does not update the starting location.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Destinations are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type destination

The following events are specific to destinations.
]],
      args = "mode: string",
      returns = "",
      valuetype = ""
      },
    on_activated = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrives on this destination.

The map opening transition is about to start at this point.

He may come from a [teletransporter](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html), from [hero:teleport()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_teleport) or from the [saved starting location](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_starting_location). 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
pickable = {
  type = "class",
  description = [[

A pickable treasure is a treasure on the ground and that the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) can pick up.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_pickable()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_pickable).

Pickable treasures may also be dropped by [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and by [destructible entities](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html).
]],
  childs = {
    has_layer_independent_collisions = {
      type = "method",
      description = [[

Returns whether this pickable treasure can detect collisions with entities even if they are not on the same layer.

By default, pickable treasures can only have collisions with entities on the same layer.

  * Return value (boolean): `true` if this pickable treasure can detect collisions even with entities on other layers.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_layer_independent_collisions = {
      type = "method",
      description = [[

Sets whether this pickable treasure can detect collisions with entities even if they are not on the same layer.

By default, pickable treasures can only have collisions with entities on the same layer. For example, you can call this method if your pickable treasure is a flying object that should be able to be picked by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) no matter his current layer.

  * `independent` (boolean, optional): `true` to make this pickable treasure detect collisions even with entities on other layers. No value means `true`.


]],
      args = "[independent: boolean]",
      returns = "",
      valuetype = ""
      },
    get_followed_entity = {
      type = "method",
      description = [[

Returns the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (if any) followed by this pickable treasure.

Pickable treasures get automatically attached to entities like the boomerang or the hookshot when such entities collide with them. You can use this function to know if it happens.

  * Return value ([map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity this pickable treasure is attached to, or `nil` if the pickable treasure is free.


]],
      args = "",
      returns = "map entity",
      valuetype = "map entity"
      },
    get_falling_height = {
      type = "method",
      description = [[

Indicates how high this pickable treasure falls from.

This depends on how the pickable treasure was created. If is was placed on the map initially, it does not fall at all (`0` is returned). If it appears when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) lifts a [destructible object](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html), it falls from a low height. If it is dropped by an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), it falls from higher.

By default, the engine sets a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) that makes the pickable treasure bounce of a few pixels over the ground during a fraction of second. The number of pixels, the duration and the number of bounces of the movement depends on this height. If you want to override that movement, (by calling [movement:start(pickable)](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_start)), you may also want to make it dependent of the falling height.

  * Return value (number): An integer indicating how high the pickable treasure falls from at creation time, between `0` (not falling at all) and `3` (falling from some high place).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    get_treasure = {
      type = "method",
      description = [[

Returns the kind of treasure represented by this pickable treasure.

  * Return value 1 ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The equipment item of this treasure.
  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this pickable treasure is found. `nil` means that the treasure is not saved.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Pickable treasures are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type pickable

None. 
]],
      args = "",
      returns = "item,number,string",
      valuetype = "item,number,string"
      }
    },
  inherits = "entity"
  },
destructible = {
  type = "class",
  description = [[

A destructible object is an entity that can be cut or [lifted](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_weight) by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) and that may hide a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html).

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_destructible()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_destructible).
]],
  childs = {
    get_treasure = {
      type = "method",
      description = [[

Returns what [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) this object will drop when being lifted, when being cut or when exploding.

  * Return value 1 (string): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` means no item (in this case, other return values are `nil` too).
  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` means that the treasure is not saved.


]],
      args = "",
      returns = "string,number,string",
      valuetype = "string,number,string"
      },
    set_treasure = {
      type = "method",
      description = [[

Sets the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) that this object will drop when being lifted, when being cut or when exploding.

  * `item_name` (string, optional): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` or no value means no item.
  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`.
  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` or no value means that the treasure is not saved.


]],
      args = "[item_name: string, [variant: number, [savegame_variable: string]]]",
      returns = "",
      valuetype = ""
      },
    get_destruction_sound = {
      type = "method",
      description = [[

Returns the sound to be played when this object is cut or broken.

  * Return value (string): Id of the destruction sound. `nil` means that no sound will be played.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_destruction_sound = {
      type = "method",
      description = [[

Sets the sound to be played when this object is cut or broken.

  * `destruction_sound_id` (string): Id of the destruction sound. `nil` means that no sound will be played.


]],
      args = "destruction_sound_id: string",
      returns = "",
      valuetype = ""
      },
    get_can_be_cut = {
      type = "method",
      description = [[

Returns whether this object can be cut by the sword.

  * Return value (boolean): `true` if this object can be cut by the sword.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_be_cut = {
      type = "method",
      description = [[

Sets whether this object can be cut by the sword.

  * `can_be_cut` (boolean, optional): `true` to allow the player to cut this object with the sword. No value means `true`.


]],
      args = "can_be_cut: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_explode = {
      type = "method",
      description = [[

Returns whether this object explodes when it is hit or after a delay when it is lifted.

  * Return value (boolean): `true` if this object can explode.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_explode = {
      type = "method",
      description = [[

Sets whether this object explodes when it is hit or after a delay when it is lifted.

  * `can_explode` (boolean, optional): `true` to make the object able to explode. No value means `true`.


]],
      args = "can_explode: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_regenerate = {
      type = "method",
      description = [[

Returns whether this object regenerates after a delay when it is destroyed.

  * Return value (boolean): `true` if this object can regenerate.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_regenerate = {
      type = "method",
      description = [[

Sets whether this object regenerates after a delay when it is destroyed.

  * `can_regenerate` (boolean, optional): `true` to make the object able to regenerate. No value means `true`.


]],
      args = "can_regenerate: boolean",
      returns = "",
      valuetype = ""
      },
    get_damage_on_enemies = {
      type = "method",
      description = [[

Returns the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.

  * Return value (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_damage_on_enemies = {
      type = "method",
      description = [[

Sets the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.

  * `damage_on_enemies` (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.


]],
      args = "damage_on_enemies: number",
      returns = "",
      valuetype = ""
      },
    get_modified_ground = {
      type = "method",
      description = [[

Returns the ground defined by this destructible object on the map.

The presence of a destructible object can modify the ground of the map. The ground is usually `"wall"`, but it may sometimes be `"traversable"`, or for example `"grass"` to make the destructible object traversable too but with an additional grass sprite below the hero.

  * Return value (string): The ground defined by this destructible object. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Destructible objects are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type destructible

The following events are specific to destructible objects.
]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    on_looked = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) looks this destructible object, that is, when the player presses the action key but is not allowed to lift the object.

By default, nothing happens in this case. You can for example show a dialog to give the player a hint like "This is too heavy".

Remarks
    If you want to do the same action for all destructible objects of your game, use the [metatable trick](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_metatable). Just define this event on the metatable of the destructible object type instead of each individual object, and it will be applied to all of them.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_cut = {
      type = "method",
      description = [[

Called when the hero has just cut this destructible object.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_exploded = {
      type = "method",
      description = [[

Called when this destructible object is exploding.

If [destructible:get_can_explode()](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html#lua_api_destructible_get_can_explode) is `true`, the destructible object explodes when there is an [explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html) nearby or when the hero lifts it, after a delay.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_regenerating = {
      type = "method",
      description = [[

Called when this destructible object regenerates.

If [destructible:get_can_regenerate()](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html#lua_api_destructible_get_can_regenerate) is `true`, the destructible object regenerates after a delay when it was lifted or exploded. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
carried_object = {
  type = "class",
  description = [[

A carried object is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is lifting, carrying or throwing.
]],
  childs = {
    get_carrier = {
      type = "method",
      description = [[

Returns the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that carried this object.

  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The carrier entity.


]],
      args = "",
      returns = "entity",
      valuetype = "entity"
      },
    get_damage_on_enemies = {
      type = "method",
      description = [[

Returns the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.

  * Return value (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_damage_on_enemies = {
      type = "method",
      description = [[

Sets the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.

  * `damage_on_enemies` (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.


]],
      args = "damage_on_enemies: number",
      returns = "",
      valuetype = ""
      },
    get_destruction_sound = {
      type = "method",
      description = [[

Returns the sound to be played when this object is cut or broken.

  * Return value (string): Id of the destruction sound. `nil` means that no sound will be played.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_destruction_sound = {
      type = "method",
      description = [[

Sets the sound to be played when this object is cut or broken.

  * `destruction_sound_id` (string): Id of the destruction sound. `nil` means that no sound will be played.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Carried objects are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type carried object

The following events are specific to carried objects.
]],
      args = "destruction_sound_id: string",
      returns = "",
      valuetype = ""
      },
    on_lifted = {
      type = "method",
      description = [[

Called when this object has finished being lifted and is now actually carried.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_thrown = {
      type = "method",
      description = [[

Called when this object starts being thrown.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_breaking = {
      type = "method",
      description = [[

Called when this object falls on the ground and starts breaking. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
chest = {
  type = "class",
  description = [[

A chest is a box that contains a treasure.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_chest()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_chest).
]],
  childs = {
    is_open = {
      type = "method",
      description = [[

Returns the state of this chest (open or closed).

  * Return value (boolean): `true` if this chest is open, `false` if it is closed.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_open = {
      type = "method",
      description = [[

Sets the state of this chest (open or closed). If you close the chest, its treasure (as returned by [chest:get_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_chest.html#lua_api_chest_get_treasure)) is restored and can be obtained again later.

  * `open` (boolean, optional): `true` to make the chest open, `false` to make it closed. No value means `true`.


]],
      args = "[open: boolean]",
      returns = "",
      valuetype = ""
      },
    get_treasure = {
      type = "method",
      description = [[

Returns the treasure the player will obtain when opening this chest.

If the chest is already open, this function still works: it returns the treasure that was inside the chest before it was open.

  * Return value 1 (string): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` means that the chest is empty.
  * Return value 2 (number): Variant of this equipment item (`1` means the first variant). `nil` means that the chest is empty.
  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the chest is open. `nil` means that the chest is not saved.



Remarks
    If the treasure is a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), the hero will actually get no treasure when opening the chest.
]],
      args = "",
      returns = "string,number,string",
      valuetype = "string,number,string"
      },
    set_treasure = {
      type = "method",
      description = [[

Sets the treasure the player will obtain when opening this chest.

If the chest is already open, this function still works, it sets the treasure that will be put back in case you [close](http://www.solarus-games.org/doc/1.6/lua_api_chest.html#lua_api_chest_set_open) the chest later.

  * `item_name` (string, optional): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` makes the chest empty.
  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`. Must be `nil` when `item_name` is `nil`.
  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the chest is open. `nil` means that the chest is not saved.



Remarks
    If the treasure is a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), the hero will actually get no treasure when opening the chest.

#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Chests are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type chest

The following events are specific to chests.
]],
      args = "[item_name: string, [variant: number, [savegame_variable: string]]]",
      returns = "",
      valuetype = ""
      },
    on_opened = {
      type = "method",
      description = [[

Called when the hero opens this chest.

At this point, if the chest is saved, then the engine has already set the corresponding savegame value to `true` (`treasure_savegame_variable`), no matter if this event is defined.

Then, if you don't define this event, by default, the engine gives the treasure to the player (if there is no treasure, then nothing else happens and the hero is automatically unfrozen).

Your script can define this event to customize what happens. By calling [hero:start_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_treasure), you can either give the chest's treasure or a treasure decided dynamically. Or you can do something else: show a dialog, play a sound, close the chest again, etc.

The hero is automatically frozen during the whole process of opening a chest. If you don't give him a treasure, then you have to unblock him explicitly by calling [hero:unfreeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_unfreeze) when you want to restore control to the player.

  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item in the chest, or `nil` if the chest is empty or contains a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable).
  * `treasure_variant` (number): Variant of the treasure or `nil` if the chest is empty or contains a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable).
  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this chest is open, or `nil` if this chest is not saved. 


]],
      args = "treasure_item: item, treasure_variant: number, treasure_savegame_variable: string",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
shop_treasure = {
  type = "class",
  description = [[

A shop treasure is a treasure that can be purchased by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) for money.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_shop_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_shop_treasure).
]],
  childs = {
    on_buying = {
      type = "method",
      description = [[

Called when the player is about to buy this treasure.

He already accepted to buy it and validated the dialog. At this point, you may cancel the deal for some reason by returning `false` (for example if you realize that the player has no bottle and therefore cannot buy the potion he wanted).

  * Return value (boolean): `true` if the player is allowed to buy the treasure.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_bought = {
      type = "method",
      description = [[

Called when the player has just bought this treasure.

  * Return value (boolean): `true` if the player is allowed to buy the treasure.



Remarks
    This event is called right after the more general events [item:on_obtaining()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_obtaining) and [map:on_obtaining_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_obtaining_treasure). Those two events are called no matter how the treasure is being obtained: from a [chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html), from a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html), from a shop treasure or explicitly with [hero:start_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_treasure). 
]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      }
    },
  inherits = "entity"
  },
enemy = {
  type = "class",
  description = [[

An enemy is a bad guy that hurts the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) when touching him.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_enemy()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_enemy).
]],
  childs = {
    get_breed = {
      type = "method",
      description = [[

Returns the breed (the model) of this enemy.

  * Return value (string): The enemy's breed.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_life = {
      type = "method",
      description = [[

Returns the current life of this enemy.

  * Return value (number): Number of health points of the enemy.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_life = {
      type = "method",
      description = [[

Sets the current life of this enemy.

The initial value is `1`.

  * `life` (number): Number of health points to set. A value of `0` or lower kills the enemy.


]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    add_life = {
      type = "method",
      description = [[

Adds some life to the enemy.

  * `life` (number): Number of health points to add.



Remarks
    Equivalent to `enemy:set_life(enemy:get_life() + life)`
]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    remove_life = {
      type = "method",
      description = [[

Removes some life from the enemy.

  * `life` (number): Number of health points to remove.



Remarks
    Equivalent to `enemy:set_life(enemy:get_life() - life)`
]],
      args = "life: number",
      returns = "",
      valuetype = ""
      },
    get_damage = {
      type = "method",
      description = [[

Returns the number of life points that the enemy removes from the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) when touching him. This number will be divided by the level of resistance ability of the player (his tunic).

  * Return value (number): Damage inflicted to the hero.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_damage = {
      type = "method",
      description = [[

Sets the number of life points that the enemy removes from the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) when touching him. This number will be divided by the [tunic](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) level of the player, unless you override this default calculation in [hero:on_taking_damage()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_on_taking_damage).

The default value is `1`.

  * `damage` (number): Damage inflicted to the hero.


]],
      args = "damage: number",
      returns = "",
      valuetype = ""
      },
    is_pushed_back_when_hurt = {
      type = "method",
      description = [[

Returns whether the enemy is pushed away when it is hurt.

  * Return value (boolean): `true` if the enemy is pushed away when hurt.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_pushed_back_when_hurt = {
      type = "method",
      description = [[

Sets whether the enemy should be pushed away when it is hurt.

The default value is `true`.

  * `pushed_back_when_hurt` (boolean, optional): `true` to make the enemy pushed away when hurt. No value means `true`.


]],
      args = "[pushed_back_when_hurt: boolean]",
      returns = "",
      valuetype = ""
      },
    get_push_hero_on_sword = {
      type = "method",
      description = [[

Returns whether the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is pushed away when he hits this enemy with his sword.

  * Return value (boolean): `true` if the hero is pushed away when hitting this enemy with his sword.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_push_hero_on_sword = {
      type = "method",
      description = [[

Sets whether the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) should be pushed away when he hits this enemy with his sword.

The default value is `false`.

  * `push_hero_on_sword` (boolean, optional): `true` to push the hero away when hitting this enemy with his sword. No value means `true`.


]],
      args = "[push_hero_on_sword: boolean]",
      returns = "",
      valuetype = ""
      },
    get_can_hurt_hero_running = {
      type = "method",
      description = [[

Returns whether this enemy can hurt the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) even when the hero is running.

  * Return value (boolean): `true` if the hero can be hurt by this enemy even when running.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_hurt_hero_running = {
      type = "method",
      description = [[

Sets whether this enemy can hurt the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) even when the hero is running.

The default value is `false`.

  * `can_hurt_hero_running` (boolean, optional): `true` so that the hero can be hurt by this enemy even when running. No value means `true`.


]],
      args = "[can_hurt_hero_running: boolean]",
      returns = "",
      valuetype = ""
      },
    get_hurt_style = {
      type = "method",
      description = [[

Returns the style of sounds and animations to play when this enemy is hurt.

  * Return value (string): `"normal"`, `"monster"` or `"boss"`.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_hurt_style = {
      type = "method",
      description = [[

Sets the style of sounds and animations to play when this enemy is hurt. The default values is `"normal"`.

  * `hurt_style` (string): `"normal"`, `"monster"` or `"boss"`.


]],
      args = "hurt_style: string",
      returns = "",
      valuetype = ""
      },
    get_dying_sprite_id = {
      type = "method",
      description = [[

Returns the id of the sprite to show when this enemy is dying.

This sprite is displayed during the usual dying animation. It is not used when the dying animation is a special one, for example if the [hurt style](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_hurt_style) is `"boss"` (in which case explosions are displayed instead) or if the enemy was killed by bad ground like water or holes.

The default dying sprite id is `"enemies/enemy_killed"`.

  * Return value (string or nil): Id of the sprite to use for the dying animation, or `nil` to show no dying animation.


]],
      args = "",
      returns = "string or nil",
      valuetype = "string or nil"
      },
    set_dying_sprite_id = {
      type = "method",
      description = [[

Sets the id of the sprite to show when this enemy is dying.

See [enemy:get_dying_sprite_id()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_dying_sprite_id) for more details.

  * `dying_sprite_id` (string or nil): Id of the sprite to use for the dying animation, or `nil` to show no dying animation.


]],
      args = "dying_sprite_id: string or nil",
      returns = "",
      valuetype = ""
      },
    get_can_attack = {
      type = "method",
      description = [[

Returns whether this enemy can currently attack the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).

  * Return value (boolean): `true` if the enemy can currently attack the hero.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_attack = {
      type = "method",
      description = [[

Sets whether this enemy can currently attack the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).

When the enemy restarts after being hurt, `can_attack` is always set to `true`.

  * `can_attack` (boolean, optional): `true` to allow the enemy to attack the hero. No value means `true`.


]],
      args = "[can_attack: boolean]",
      returns = "",
      valuetype = ""
      },
    get_minimum_shield_needed = {
      type = "method",
      description = [[

Returns the level of protection (if any) that stops attacks from this enemy.

If the player has a protection [ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) greater than or equal to this value, he will stop attacks from this enemy if he is facing the direction of the enemy. The special value of `0` means that attacks cannot be stopped with the protection ability. Returns the required level of protection to stop attacks from this enemy.

  * Return value (number): The level of protection that stops attacks from this enemy. A value of `0` means that the hero cannot stop the attacks.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_minimum_shield_needed = {
      type = "method",
      description = [[

Sets a level of protection that stops attacks from this enemy.

If the player has a protection [ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) greater than or equal to this value, he will stop attacks from this enemy if he is facing the direction of the enemy. The special value of `0` means that attacks cannot be stopped with the protection ability. The default value is `0`.

  * `minimum_shield_needed` (number): The level of protection that stops attacks from this enemy. A value of `0` means that the hero cannot stop the attacks.


]],
      args = "minimum_shield_needed: number",
      returns = "",
      valuetype = ""
      },
    is_traversable = {
      type = "method",
      description = [[

Returns whether this enemy can be traversed by other entities.

  * Return value (boolean): `true` if this enemy is traversable.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_traversable = {
      type = "method",
      description = [[

Sets whether this enemy can be traversed by other entities.

By default, the enemy is traversable. For example, if you want to prevent the [hero](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) to pass without killing the enemy, you can use this function to make the enemy become an obstacle.

  * `traversable` (boolean, optional): `true` to make this enemy traversable. No value means `true`.



Remarks
    When the enemy is not traversable, the enemy can no longer hurt the hero since their sprites cannot overlap anymore (unless if the enemy's sprite is bigger than its bounding box). You can use [enemy:set_attacking_collision_mode("touching")](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode) to make the enemy still hurt the hero when touching him without overlapping.
]],
      args = "[traversable: boolean]",
      returns = "",
      valuetype = ""
      },
    get_attacking_collision_mode = {
      type = "method",
      description = [[

Returns the kind of collision test performed to detect when the hero should be hurt by this enemy.

  * Return value (string): A collision mode name. See [enemy:set_attacking_collision_mode()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode) for the possible values.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_attacking_collision_mode = {
      type = "method",
      description = [[

Sets the kind of collision test performed to detect when the hero should be hurt by this enemy.

  * collision_mode (string): A collision mode name. This may be one of:
    * `"overlapping"`: Collision if the [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) of the enemy and the hero overlap.
    * `"containing"`: Collision if the bounding box of the hero is fully inside the bounding box of this enemy.
    * `"origin"`: Collision if the [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) or the hero is inside the bounding box of this enemy.
    * `"center"`: Collision if the [center point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_center_position) of the hero is inside the bounding box of this enemy.
    * `"facing"`: Collision if the [facing position](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_facing_position) of the hero's bounding box is touching this enemy's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of the hero, which is a rectangle with four sides, the facing point is the middle point of the side the hero is oriented to.
    * `"touching"`: Like `"facing"`, but accepts all four sides of the hero's bounding box, no matter its direction. This `"touching"` collision test is useful when the hero cannot traverse your enemy (see [enemy:set_traversable()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_traversable)).
    * `"sprite"`: Collision if the tunic sprite of the hero overlaps a sprite of this enemy. The collision test is pixel precise. This is the default value.


]],
      args = "collision_mode: string",
      returns = "",
      valuetype = ""
      },
    get_attack_consequence = {
      type = "method",
      description = [[

Returns how this enemy reacts when he receives an attack.

Recall that enemies may have several [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html). This attack consequence applies to all sprites of the enemy, unless you override some of them with [enemy:set_attack_consequence_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).

  * `attack` (string): Name of an attack against the enemy: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`.
  * `consequence` (number, string or function): Indicates what happens when this enemy receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).


]],
      args = "attack: string",
      returns = "",
      valuetype = ""
      },
    set_attack_consequence = {
      type = "method",
      description = [[

Sets how this enemy reacts when he receives an attack.

Recall that enemies may have several [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html). This attack consequence applies to all sprites of the enemy, unless you override some of them with [enemy:set_attack_consequence_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).

  * `attack` (string): Name of an attack against the enemy: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`.
  * `consequence` (number, string or function): Indicates what happens when this enemy receives the attack. It may be:
    * A positive integer: The enemy is hurt and loses this number of life points. In the particular case of a sword attack, this number will by default be increased by the level of the sword (see [enemy:on_hurt_by_sword()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_on_hurt_by_sword)).
    * `"ignored"`: Nothing happens. The weapon (if any) traverses the enemy.
    * `"protected"`: The enemy stops the attack. An attack failure sound is played.
    * `"immobilized"`: The enemy is immobilized for a few seconds.
    * `"custom"`: Event [enemy:on_custom_attack_received()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_on_custom_attack_received) is called. Note: Since Solarus 1.6, we recommend to use a function parameter instead for more simplicity (see below).
    * `A` function: A function to be called when this enemy receives the attack.


]],
      args = "attack: string, consequence: number, string or function",
      returns = "",
      valuetype = ""
      },
    get_attack_consequence_sprite = {
      type = "method",
      description = [[

Returns how this enemy reacts when one of his [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) receives an attack.

This method returns the same result as [enemy:get_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_attack_consequence), unless you override the reaction of the enemy for a particular sprite with [enemy:set_attack_consequence_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of this enemy.
  * `attack` (string): Name of an attack against the enemy: "sword", "thrown_item", "explosion", "arrow", "hookshot", "boomerang" or "fire".
  * `consequence` (number, string or function): Indicates what happens when this sprite receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).


]],
      args = "sprite: sprite, attack: string",
      returns = "",
      valuetype = ""
      },
    set_attack_consequence_sprite = {
      type = "method",
      description = [[

Sets how this enemy reacts when one of his [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) receives an attack.

This method overrides for a particular sprite the attack consequences defined by [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of this enemy.
  * `attack` (string): Name of an attack against the enemy: "sword", "thrown_item", "explosion", "arrow", "hookshot", "boomerang" or "fire".
  * `consequence` (number, string or function): Indicates what happens when this sprite receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).


]],
      args = "sprite: sprite, attack: string, consequence: number, string or function",
      returns = "",
      valuetype = ""
      },
    set_default_attack_consequences = {
      type = "method",
      description = [[

Restores the default attack consequences for this enemy and its sprites.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    set_default_attack_consequences_sprite = {
      type = "method",
      description = [[

Restores the default attack consequences for a particular sprite of this enemy.

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of this enemy.


]],
      args = "sprite: sprite",
      returns = "",
      valuetype = ""
      },
    set_invincible = {
      type = "method",
      description = [[

Makes this enemy ignore all attacks.

Equivalent to calling [enemy:set_attack_consequence(attack, "ignored")](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for each attack.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    set_invincible_sprite = {
      type = "method",
      description = [[

Makes a sprite of this enemy ignore all attacks.

Equivalent to calling [enemy:set_attack_consequence(sprite, attack, "ignored")](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite) for each attack.

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of this enemy.


]],
      args = "sprite: sprite",
      returns = "",
      valuetype = ""
      },
    has_layer_independent_collisions = {
      type = "method",
      description = [[

Returns whether this enemy can detect collisions with entities even if they are not on the same layer.

By default, enemies can only have collisions with entities on the same layer.

  * Return value (boolean): `true` if this enemy can detect collisions even with entities on other layers.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_layer_independent_collisions = {
      type = "method",
      description = [[

Sets whether this enemy can detect collisions with entities even if they are not on the same layer.

By default, enemies can only have collisions with entities on the same layer. If you set this property to `true`, this enemy will be able to hurt the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) even from a different layer.

  * `independent` (boolean, optional): `true` to make this enemy detect collisions even with entities on other layers. No value means `true`.


]],
      args = "[independent: boolean]",
      returns = "",
      valuetype = ""
      },
    get_treasure = {
      type = "method",
      description = [[

Returns the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) that will drop this enemy when killed.

  * Return value 1 (string): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` means no item dropped (in this case, other return values are `nil` too).
  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` means that the treasure is not saved.


]],
      args = "",
      returns = "string,number,string",
      valuetype = "string,number,string"
      },
    set_treasure = {
      type = "method",
      description = [[

Sets the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) that will drop this enemy when killed.

  * `item_name` (string, optional): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` or no value means no item.
  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`.
  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` or no value means that the treasure is not saved.


]],
      args = "[item_name: string, [variant: number, [savegame_variable: string]]]",
      returns = "",
      valuetype = ""
      },
    get_obstacle_behavior = {
      type = "method",
      description = [[

Returns how the enemy behaves with obstacles.

  * Return value (string): `"normal"`, `"flying"` or `"swimming"`.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_obstacle_behavior = {
      type = "method",
      description = [[

Sets how this enemy should behave with obstacles. The default value is `"normal"`. `"swimming"` allow the enemy to traverse water. `"flying"` allows the enemy to traverse holes, water and lava.

  * `obstacle_behavior` (string): `"normal"`, `"flying"` or `"swimming"`.


]],
      args = "obstacle_behavior: string",
      returns = "",
      valuetype = ""
      },
    restart = {
      type = "method",
      description = [[

Restarts this enemy.

This plays animation `"walking"` on its [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), destroys any timer of the enemy and calls the event [enemy:on_restarted()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_on_restarted).

This function has no effect if the enemy is dying.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    hurt = {
      type = "method",
      description = [[

Hurts this enemy if he is currently vulnerable.

If the enemy is vulnerable, the hurting animation and sound start and the given number of life points are removed.

Nothing happens if the enemy is currently invulnerable (for example because he is already being hurt).

  * `life_points` (number): Number of life points to remove from the enemy.



Remarks
    If you just want to silently remove some life, call [enemy:remove_life()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_remove_life) instead.
]],
      args = "life_points: number",
      returns = "",
      valuetype = ""
      },
    is_immobilized = {
      type = "method",
      description = [[

Returns whether the enemy is currently immobilized.

  * Return value (boolean): `true` if the enemy is immobilized.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    immobilize = {
      type = "method",
      description = [[

Immobilizes this enemy for a while if possible.

After a few seconds, the enemy shakes and then restarts.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    create_enemy = {
      type = "method",
      description = [[

Creates another enemy on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), specifying its coordinates as relative to the current enemy.

This function is similar to [map:create_enemy()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_enemy) but the coordinates are relative to the current enemy, and the layer is the one of the current enemy by default.

  * `properties` (table): A table that describes all properties of the enemy to create. Its key-value pairs must be:
    * `name` (string, optional): Name identifying the entity. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique. No value means no name.
    * `layer` (number, optional): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer). No value means the same layer as the current enemy.
    * `x` (number, optional): X coordinate on the map, relative to the current enemy. The default value is `0`.
    * `y` (number, optional): Y coordinate on the map, relative to the current enemy. The default value is `0`.
    * `direction` (number, optional): Initial direction of the enemy, between `0` (East) and `3` (South). The default value is `3`.
    * `breed` (string): Model of enemy to create.
    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this enemy is dead. No value means that the enemy is not saved. If the enemy is saved and was already killed, then no enemy is created. Instead, its [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created if it is a saved one.
    * `treasure_name` (string, optional): Kind of [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) to drop when the enemy is killed (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, or corresponds to a [non obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item, then the enemy won't drop anything.
    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this enemy was obtained. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the enemy won't drop anything.
  * Return value (enemy or [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html)): The enemy created, except when it is a saved enemy that is already dead. In this case, if the enemy dropped a saved treasure that is not obtained yet, this [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created and returned. Otherwise, `nil` is returned.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Enemies are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type enemy

The following events are specific to enemies.
]],
      args = "properties: table",
      returns = "enemy or pickable treasure",
      valuetype = "enemy or pickable treasure"
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle while this enemy is alive.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_restarted = {
      type = "method",
      description = [[

Called when this enemy should start or restart its [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) and [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) because something happened. For example, the enemy has just been created, or it was just hurt or immobilized, or you called [enemy:restart()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_restart). If your enemy should move, this is the right place to create its movement.

[Timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) associated to the enemy were automatically destroyed. Thus, you should also recreate them from this event.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_collision_enemy = {
      type = "method",
      description = [[

Called when a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of this enemy overlaps another enemy's sprite.

  * `other_enemy` (enemy): Another enemy.
  * `other_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of that other enemy.
  * `my_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): A sprite of the current enemy.


]],
      args = "other_enemy: enemy, other_sprite: sprite, my_sprite: sprite",
      returns = "",
      valuetype = ""
      },
    on_custom_attack_received = {
      type = "method",
      description = [[

Called when this enemy receives an attack with a custom effect.

This function is called if you have set [consequence of the attack](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to `"custom"`. You have to define what happens, for example hurting the enemy, making a special reaction, etc.

  * `attack` (string): The attack that was received: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`. In the particular case of a `"sword"` attack, the sword state is stopped and the hero goes back to state `"free"`.
  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite of this enemy that receives the attack, or `nil` if the attack does not come from a pixel-precise collision.



Remarks
    Instead of using this event and the attack consequence `"custom"`, you can now simply pass a callback parameter to [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) or to [enemy:set_attack_consequence_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).
]],
      args = "attack: string, sprite: sprite",
      returns = "",
      valuetype = ""
      },
    on_hurt_by_sword = {
      type = "method",
      description = [[

Called when this enemy is successfully hurt by the sword of the hero.

You should define this event to customize the damage inflicted by the sword.

This event can only be called if the [reaction](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to the `"sword"` attack is hurting the enemy.

At this point, the enemy is in the state of being hurt. His hurting animation and sound have just started. This is a good time to remove some life points with [enemy:remove_life()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_remove_life).

By default, if you don't define this event, the enemy loses a number of life points computed as [his reaction to sword attacks](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) multiplied by the sword [ability level](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) of the hero, and doubled during a spin attack.

  * `hero` ([hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)): The hero who used the sword.
  * `enemy_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite of this enemy that was hit. You may use this information if your enemy has several sprites with different behaviors.


]],
      args = "hero: hero, enemy_sprite: sprite",
      returns = "",
      valuetype = ""
      },
    on_hurt = {
      type = "method",
      description = [[

Called when this enemy is successfully hurt by any attack.

This event can only be called if the [reaction](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to the attack is hurting the enemy.

At this point, the enemy is in the state of being hurt. His hurting animation and sound have just started and he has just lost some life.

  * `attack` (string): The attack that was received: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"`, `"fire"`, or `"script"`.



Remarks
    In the case of a `"sword"` attack, this event is called right after [enemy:on_hurt_by_sword()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_on_hurt_by_sword).
]],
      args = "attack: string",
      returns = "",
      valuetype = ""
      },
    on_dying = {
      type = "method",
      description = [[

Called when the enemy's life comes to `0`.

When the life comes to `0`, the movement of the enemy is stopped, its timers are stopped too, the dying animation starts and a sound is played. The details of the dying animation and the sound played depend on the [hurt style](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_hurt_style) property.

  * If the hurt style is `"enemy"` or `"monster"`, any sprite of the enemy is automatically removed and replaced by the sprite indicated by [enemy:get_dying_sprite_id()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_dying_sprite_id) if any (which is by default `"enemies/enemy_killed"`).
  * If the hurt style is `"boss"`, your sprites continue to exist and to play animation "hurt", while explosions appear on the enemy.



In all cases, the enemy will be removed from the map when the dying animation ends.

Remarks
    This event is called right after [enemy:on_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_on_hurt).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_dead = {
      type = "method",
      description = [[

Called when the enemy's dying animation is finished.

At this point, the enemy no longer exists on the map. In other words, [enemy:exists()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_exists) returns `false`, trying to get the enemy from its name returns `nil`, and functions like [map:get_entities(prefix)](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_entities_count) won't find this enemy.

This means that you can safely use [map:has_entities(prefix)](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_has_entities) from `enemy:on_dead()` to detect when all enemies with a common prefix are dead.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_immobilized = {
      type = "method",
      description = [[

Called when the enemy is immobilized.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_attacking_hero = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is successfully touched by this enemy.

This event is not called if the hero was protected by his shield, or if he currently cannot be hurt for some reason, like when he is already being hurt, when he is [temporarily invincible](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_invincible), or when he is in a special [state](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) like brandishing a treasure.

Your script can define this event to customize what bad things happen to the hero. If you define this event, the engine does absolutely nothing and lets you handle this.

If you don't define this event, the hero is hurt with the predefined behavior as follows. The hero goes to the state `"hurt"` where is pushed away from the enemy. He loses some life depending on the enemy's [damage](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_get_damage) property, and on the hero's [tunic](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) and on [hero:on_taking_damage()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_on_taking_damage) if defined. Then, he recovers and his sprites blink for a while. During this short period, he is temporarily invincible.

  * `hero` ([hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)): The hero being attacked.
  * `enemy_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite of the enemy that caused the collision with the hero. You may use this information if your enemy has several sprites with different behaviors. This value is `nil` if the attack does not come from a sprite collision test (see [enemy:set_attacking_collision_mode()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode)).



Remarks
    If you call [hero:start_hurt()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_hurt_entity), you will obtain something equivalent to the default behavior. But if you don't, keep in mind that if the hero can still be hurt after your call, this event will continue to be called while there is a collision with the enemy. To avoid this, see for example [hero:set_invincible()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_set_invincible) to make the hero temporarily invincible. 
]],
      args = "hero: hero, enemy_sprite: sprite",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
npc = {
  type = "class",
  description = [[

A non-playing character (NPC) is somebody or something that the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) can interact with by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) or by using an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) just in front of it.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_npc()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_npc).
]],
  childs = {
    is_traversable = {
      type = "method",
      description = [[

Returns whether this NPC can be traversed by other entities.

By default, NPCs are not traversable. However, be aware that some entities can override this setting. Indeed, other NPCs, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and projectiles ([thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), [boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html)) can traverse usual NPCs but cannot traverse generalized NPCs. And [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) can have finer customization.

  * Return value (boolean): `true` if this NPC is traversable.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_traversable = {
      type = "method",
      description = [[

Sets whether this NPC can be traversed by other entities.

By default, NPCs are not traversable. However, be aware that some entities can override this setting. Indeed, other NPCs, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and projectiles ([thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), [boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html)) can traverse usual NPCs but cannot traverse generalized NPCs. And [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) can have finer customization.

If you want to allow the [hero](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) to be able to traverse this NPC, you can use this function.

  * `traversable` (boolean, optional): `true` to make this NPC traversable. No value means `true`.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Non-playing characters are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type non-playing character

The following events are specific to non-playing characters.
]],
      args = "[traversable: boolean]",
      returns = "",
      valuetype = ""
      },
    on_interaction = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) interacts (the player pressed the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)) in front of this NPC, if the NPC has the property to notify its own Lua script.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_interaction_item = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) uses any [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (the player pressed an [item command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)) with this NPC, if the NPC has the property to notify its own Lua script.

  * `item_used` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The item currently used by the player.
  * Return value (boolean): `true` if an interaction happened. If you return `false` or nothing, then [item_used:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) will be called (just like if there was no NPC in front of the hero).


]],
      args = "item_used: item",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_collision_fire = {
      type = "method",
      description = [[

Called when [fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html) touches this NPC, if the NPC has the property to notify its own Lua script. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
block = {
  type = "class",
  description = [[

Blocks are solid [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that may be pushed or pulled by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_block()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_block).
]],
  childs = {
    reset = {
      type = "method",
      description = [[

Restores the block at its initial position and resets its counter of moves.

It means that the hero will be able to move again a block that could only be moved a limited number of times even if the limit was reached.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_pushable = {
      type = "method",
      description = [[

Returns whether this block can be pushed.

This property is independent of whether or not the block was already moved its maximum number of times.

  * Return value (boolean): `true` if this block can be pushed.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_pushable = {
      type = "method",
      description = [[

Sets whether this block can be pushed.

This property is independent of whether or not the block was already moved its maximum number of times.

  * `pushable` (boolean): `true` to make this block pushable. No value means `true`.


]],
      args = "[pushable: boolean]",
      returns = "",
      valuetype = ""
      },
    is_pullable = {
      type = "method",
      description = [[

Returns whether this block can be pulled.

This property is independent of whether or not the block was already moved its maximum number of times.

  * Return value (boolean): `true` if this block can be pulled.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_pullable = {
      type = "method",
      description = [[

Sets whether this block can be pulled.

This property is independent of whether or not the block was already moved its maximum number of times.

  * `pullable` (boolean): `true` to make this block pullable. No value means `true`.


]],
      args = "[pullable: boolean]",
      returns = "",
      valuetype = ""
      },
    get_max_moves = {
      type = "method",
      description = [[

Returns the maximum number of times the block can be moved.

This function returns the maximum moves value that was set at creation time or by [block:set_max_moves()](http://www.solarus-games.org/doc/1.6/lua_api_block.html#lua_api_block_set_max_moves), no matter if the block was moved then.

  * Return value (number or nil): How many times the block can be moved. `nil` means unlimited.


]],
      args = "",
      returns = "number or nil",
      valuetype = "number or nil"
      },
    set_max_moves = {
      type = "method",
      description = [[

Sets the maximum number of times the block can be moved.

This resets the remaining allowed moves.

  * `maximum_moves` (number or nil): How many times the block can be moved. `nil` means unlimited.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Blocks are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type block

The following events are specific to blocks.
]],
      args = "max_moves",
      returns = "",
      valuetype = ""
      },
    on_moving = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) starts moving the block of a step.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_moved = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) has just moved this block of a step.

#  Deprecated methods of the type block

The following methods are deprecated and may be removed it future releases.
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
switch = {
  type = "class",
  description = [[

A switch is a button that can be activated to trigger a mechanism.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_switch()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_switch).
]],
  childs = {
    is_walkable = {
      type = "method",
      description = [[

Returns whether this is a walkable switch.

  * Return value (boolean): `true` if this switch is a walkable one.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_activated = {
      type = "method",
      description = [[

Returns whether this switch is activated.

  * Return value (boolean): `true` if this switch is currently activated.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_activated = {
      type = "method",
      description = [[

Sets whether this switch is activated or not.

The change is quiet and immediate: no sound is played and no event is triggered.

  * `activated` (boolean, optional): `true` to make the switch activated, `false` to make is inactivated. No value means `true`.


]],
      args = "[activated: boolean]",
      returns = "",
      valuetype = ""
      },
    is_locked = {
      type = "method",
      description = [[

Returns whether this switch is current locked.

When a switch is locked, its state cannot change anymore: it can no longer be activated or inactivated by other entities. However, it can still changed programmatically by calling [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated).

  * Return value (boolean): `true` if this switch is currently activated.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_locked = {
      type = "method",
      description = [[

Locks this switch in its current state or unlocks it.

When a switch is locked, its state cannot change anymore: it can no longer be activated or inactivated by other entities. However, it can still changed programmatically by calling [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated).

  * `locked` (boolean, optional): `true` to lock the switch, `false` to unlock it. No value means `true`.



Remarks
    The method [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated) works even on a locked switch.

#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Switches are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type switch

The following events are specific to switches.
]],
      args = "[locked: boolean]",
      returns = "",
      valuetype = ""
      },
    on_activated = {
      type = "method",
      description = [[

Called when this switch has just been turned on.

This is the right place to define the action that you want your switch to perform.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_inactivated = {
      type = "method",
      description = [[

Called when a switch has just been turned off.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_left = {
      type = "method",
      description = [[

Called when an entity placed on a switch (like the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) or a [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html)) has just left the switch, regardless of whether the switch was activated or not. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
sensor = {
  type = "class",
  description = [[

A sensor is an invisible detector that triggers something when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) overlaps it.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_sensor()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_sensor).
]],
  childs = {
    on_activated = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) overlaps this sensor.

The bounding box of the hero (of size 16x16 pixels) must fit entirely the sensor. This means that if the sensor has a size of 16x16, the hero and the sensor must overlap perfectly.

This event is the right place to define the action that you want your sensor to perform.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_activated_repeat = {
      type = "method",
      description = [[

Called continuously while the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) overlaps this sensor.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_left = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) stops overlapping this sensor.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_collision_explosion = {
      type = "method",
      description = [[

Called when an [explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html) touches this sensor. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
separator = {
  type = "class",
  description = [[

Separators allow to visually separate different regions of a map like if there was several maps.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_separator()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_separator).
]],
  childs = {
    on_activating = {
      type = "method",
      description = [[

Called when the camera starts traversing on this separator.

  * `direction4` (number): Direction of the hero when traversing the separator, `beween` 0 (East) to `3` (South).


]],
      args = "direction4: number",
      returns = "",
      valuetype = ""
      },
    on_activated = {
      type = "method",
      description = [[

Called when the camera has finished traversing this separator.

The hero is now on the other side.

  * `direction4` (number): Direction of the hero when traversing the separator, `beween` 0 (East) to `3` (South). 


]],
      args = "direction4: number",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
stream = {
  type = "class",
  description = [[

When walking on a stream, the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) automatically moves into one of the eight main directions.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_stream()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_stream).
]],
  childs = {
    get_direction = {
      type = "method",
      description = [[

Returns the direction of this stream.

This direction will be applied to entities that follow the stream.

  * Return value (number): The direction between `0` (East) and `7` (South-East).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_direction = {
      type = "method",
      description = [[

Sets the direction of this stream.

This direction will be applied to entities that follow the stream.

  * `direction` (number): The direction to set, between `0` (East) and `7` (South-East).


]],
      args = "direction: number",
      returns = "",
      valuetype = ""
      },
    get_speed = {
      type = "method",
      description = [[

Returns the speed applied by this stream.

  * Return value (number): The speed of the stream in pixels per second.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_speed = {
      type = "method",
      description = [[

Sets the speed applied by this stream.

  * `speed` (number): The speed to set in pixels per second. The default value is `40`.


]],
      args = "speed: number",
      returns = "",
      valuetype = ""
      },
    get_allow_movement = {
      type = "method",
      description = [[

Returns whether the player can still move the hero while being on this stream.

  * Return value (boolean): `true` if the player can still move, `false` if this is a blocking stream.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_allow_movement = {
      type = "method",
      description = [[

Sets whether the player can still move the hero while being on this stream.

  * `allow_movement` (boolean): `true` to allow the player to move, `false` to make a blocking stream. No value means `true`.


]],
      args = "allow_movement: boolean",
      returns = "",
      valuetype = ""
      },
    get_allow_attack = {
      type = "method",
      description = [[

Returns whether the player can still use the sword while being on this stream.

  * Return value (boolean): `true` if the player use his sword.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_allow_attack = {
      type = "method",
      description = [[

Sets whether the player can still use the sword while being on this stream.

  * `allow_attack` (boolean): `true` to allow the player to use the sword. No value means `true`.


]],
      args = "allow_attack: boolean",
      returns = "",
      valuetype = ""
      },
    get_allow_item = {
      type = "method",
      description = [[

Returns whether the player can still use equipment items while being on this stream.

  * Return value (boolean): `true` if the player can still use equipment itens.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_allow_item = {
      type = "method",
      description = [[

Sets whether the player can still use equipment items while being on this stream.

  * `allow_item` (boolean): `true` to allow the player to use equipment items. No value means `true`.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Streams are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type stream

None. 
]],
      args = "allow_item: boolean",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
door = {
  type = "class",
  description = [[

A door is an obstacle that can be opened by Lua, and optionally by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) under some conditions.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_door()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_door).
]],
  childs = {
    is_open = {
      type = "method",
      description = [[

Returns whether this door is open.

  * Return value (boolean): `true` if this door is open, `false` if it is opening, closed or closing.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_opening = {
      type = "method",
      description = [[

Returns whether this door is being opened.

  * Return value (boolean): `true` if this door is being opened, `false` if it is open, closed or closing.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_closed = {
      type = "method",
      description = [[

Returns whether this door is closed.

  * Return value (boolean): `true` if this door is closed, `false` if it is closing, open or opening.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_closing = {
      type = "method",
      description = [[

Returns whether this door is being closed.

  * Return value (boolean): `true` if this door is being closed, `false` if it is closed, open or opening.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    open = {
      type = "method",
      description = [[

Opens this door, enables [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) whose name starts with the door's name followed by `_open` and plays the `"door_open"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).

Remarks
    The door will be really closed once the opening animation of its sprite is finished. However, it immediately becomes an obstacle.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    close = {
      type = "method",
      description = [[

Closes this door, disables [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) whose name starts with the door's name followed by `_closed` and plays the `"door_closed"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    set_open = {
      type = "method",
      description = [[

Makes the door open or closed like [door:open()](http://www.solarus-games.org/doc/1.6/lua_api_door.html#lua_api_door_open) or [door:close()](http://www.solarus-games.org/doc/1.6/lua_api_door.html#lua_api_door_close), but does not play any sound or any sprite animation.

This function is intended to be called when you don't want the player to notice the change, typically when your map starts (i.e. from the [map:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_started) event).

  * `open` (boolean, optional): `true` to open the door, `false` to close it. No value means `true`.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Doors are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type door

The following events are specific to doors.
]],
      args = "[open: boolean]",
      returns = "",
      valuetype = ""
      },
    on_opened = {
      type = "method",
      description = [[

Called when this door starts being opened.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_closed = {
      type = "method",
      description = [[

Called when this door starts being closed. 
]],
      args = "",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
stairs = {
  type = "class",
  description = [[

Stairs make fancy animations, movements and sounds when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) takes them.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_stairs()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_stairs).

Remarks
    Stairs entities provide very specific behavior for historical reasons and are not very customizable. If you need more flexibility, we recommend to use [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) instead and to script the behavior you want.
]],
  childs = {
    get_direction = {
      type = "method",
      description = [[

Returns the direction of these stairs.

Stairs can be taken in two opposite directions. The one returned here is the main one, which is: for stairs that teleport the hero, the direction when leaving the place using the stairs (and not the one when arriving from the stairs), and for inner stairs, the direction when going upwards.

  * Return value (number): The stairs direction between `0` (East) and `3` (South).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    is_inner = {
      type = "method",
      description = [[

Returns whether these stairs go from a layer to another layer on the same map or go to another place.

  * Return value (number): The direction between `0` (East) and `3` (South).



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Stairs are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type stairs

None. 
]],
      args = "",
      returns = "number",
      valuetype = "number"
      }
    },
  inherits = "entity"
  },
camera = {
  type = "class",
  description = [[

The camera is a rectangular shape that determines the visible part of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). There is always exactly one camera on the current map. The camera is automatically created by the engine when loading a map. You cannot create or remove it. To access the camera of the map from one of your scripts, you can use [map:get_camera()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_camera).
]],
  childs = {
    get_position_on_screen = {
      type = "method",
      description = [[

Returns where the camera is displayed on the quest screen.

The default position is `0, 0`, meaning that the upper left corner of the camera is displayed on the upper left corner of the screen.

  * Return value 1 (number): X coordinate of the camera on the screen, in quest screen coordinates.
  * Return value 2 (number): Y coordinate of the camera on the screen, in quest screen coordinates.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_position_on_screen = {
      type = "method",
      description = [[

Sets where the camera is displayed on the quest screen.

You can use this function in conjunction with [camera:set_size()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_size) to display the camera only on a subpart of the screen and for example keep the rest of the space for the HUD.

The default position is `0,0`, meaning that the upper left corner of the camera is displayed on the upper left corner of the screen.

  * `x` (number): X coordinate of the camera on the screen, in quest screen coordinates.
  * `y` (number): Y coordinate of the camera on the screen, in quest screen coordinates.


]],
      args = "x: number, y: number",
      returns = "",
      valuetype = ""
      },
    get_position_to_track = {
      type = "method",
      description = [[

Returns the coordinates this camera should have in order to track the given entity or point, respecting constraints of map limits and separators.

The returned coordinates make their best to have the entity or point centered in the camera, but make sure that the camera does not cross [separators](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) or map limits. This function can be used to compute legal coordinates for the camera, and for example pass them to [camera:set_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_position) or start a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_start).

To get coordinates that center the camera on a map entity:

  * `entity` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)) The entity to center the camera on.



To get coordinates that center the camera on a point:

  * `x` (number): X coordinate of the point to center the camera on.
  * `y` (number): Y coordinate of the point to center the camera on.


]],
      args = "entity: number",
      returns = "",
      valuetype = ""
      },
    get_state = {
      type = "method",
      description = [[

Returns the name of the current state of the camera.

  * Return value (string): The current camera state: `"tracking"` or `"manual"`.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    start_tracking = {
      type = "method",
      description = [[

Switches the camera to tracking state.

The camera will be focused on an entity to track, and follow it when it moves.

When the tracked entity crosses a separator, the engine automatically starts a scrolling movement on the camera. The game is automatically suspended during the scrolling. After the scrolling, the camera continues to normally track the entity on the other side of the separator.

  * `entity` (entity): The entity to track.


]],
      args = "entity: entity",
      returns = "",
      valuetype = ""
      },
    get_tracked_entity = {
      type = "method",
      description = [[

Returns the entity currently tracked by this camera, if any.

  * Return value (entity): The tracked entity if the camera is in tracking state, or `nil` if the camera is not in tracking state.


]],
      args = "",
      returns = "entity",
      valuetype = "entity"
      },
    start_manual = {
      type = "method",
      description = [[

Switches the camera to manual state.

Remarks
    The camera automatically switches to manual state if you start a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_start) on it.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_surface = {
      type = "method",
      description = [[

Returns the [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html) this camera draws its content to.

The size of this surface is the size of the camera.

  * Return value ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The camera's surface.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

A camera is a particular [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, it inherits all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type camera

The following events are specific to cameras.
]],
      args = "",
      returns = "surface",
      valuetype = "surface"
      },
    on_state_changing = {
      type = "method",
      description = [[

Called when the state of the camera is about to change.

  * `state_name` (string): Name of the current state. See [camera:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.
  * `next_state_name` (string): Name of the state about to start. See [camera:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.


]],
      args = "state_name: string, next_state_name: string: string",
      returns = "",
      valuetype = ""
      },
    on_state_changed = {
      type = "method",
      description = [[

Called when the state of the camera has just changed.

  * `new_state_name` (string): Name of the new state. See [camera:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.



Remarks
    When the map starts, the initial state of the camera always `"tracking"`, because the camera initially tracks the hero. 
]],
      args = "new_state_name: string",
      returns = "",
      valuetype = ""
      }
    },
  inherits = "entity"
  },
custom_entity = {
  type = "class",
  description = [[

A custom entity is a map entity entirely defined by your Lua scripts.

This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_custom_entity()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_custom_entity).
]],
  childs = {
    get_model = {
      type = "method",
      description = [[

Returns the model of this custom entity.

The model is the name of a Lua script in the `"entities"` directory that manages this custom entity. This works exactly like the breed of [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), except that it is optional.

  * Return value (string): The model of custom entity, or `nil` if the custom entity has no model script.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_direction = {
      type = "method",
      description = [[

Returns the direction of this custom entity.

This direction is set at creation time or when you can call [custom_entity:set_direction()](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_set_direction).

  * Return value 1 (number): The direction.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_direction = {
      type = "method",
      description = [[

Sets the direction of this custom entity.

Sprites of your custom entity that have such a direction automatically take it.

  * Return value 1 (number): The direction.


]],
      args = "direction",
      returns = "number",
      valuetype = "number"
      },
    is_tiled = {
      type = "method",
      description = [[

Returns whether the sprite is repeated with tiling to fit the size of the custom entity when the size is bigger than the sprite.

  * Return value (boolean): `true` if the sprite is tiled.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_tiled = {
      type = "method",
      description = [[

Sets whether the sprite should be repeated with tiling to fit the size of the custom entity when the size is bigger than the sprite.

  * `tiled` (boolean, optional): `true` to make the sprite tiled. No value means `true`.


]],
      args = "[tiled: boolean]",
      returns = "",
      valuetype = ""
      },
    set_traversable_by = {
      type = "method",
      description = [[

Sets whether this custom entity can be traversed by other entities.

By default, a custom entity can be traversed.

  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types that do not override it.
  * `traversable` (boolean, function or `nil`): Whether this entity type can traverse your custom entity. This can be:
    * A boolean: `true` to make your custom entity traversable by this entity type, `false` to make it obstacle.
    * A function: Custom test. This allows you to decide dynamically. The function takes your custom entity and then the other entity as parameters, and should return `true` if you allow the other entity to traverse your custom entity. This function will be called every time a [moving](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) entity of the specified type is about to overlap your custom entity.
    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.


]],
      args = "[entity_type: string], traversable: boolean, function or nil",
      returns = "",
      valuetype = ""
      },
    set_can_traverse = {
      type = "method",
      description = [[

Sets whether this custom entity can traverse other entities.

This is important only if your custom entity can [move](http://www.solarus-games.org/doc/1.6/lua_api_movement.html).

By default, this depends on the other entities: for example, [sensors](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html) can be traversed by default while [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) cannot unless they are open.

  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types for which you don't override this setting.
  * `traversable` (boolean, function or `nil`): Whether your custom entity can traverse the other entity type. This can be:
    * A boolean: `true` to allow your custom entity to traverse entities of the specified type, `false` otherwise.
    * A function: Custom test. This allows you to decide dynamically. The function takes your custom entity and then the other entity as parameters, and should return `true` if you allow your custom entity to traverse the other entity. When your custom entity has a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html), this function will be called every time it is about to overlap an entity of the specified type.
    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.


]],
      args = "[entity_type: string], traversable: boolean, function or nil",
      returns = "",
      valuetype = ""
      },
    can_traverse_ground = {
      type = "method",
      description = [[

Returns whether this custom entity can traverse a kind of ground.

This is important only if your custom entity can [move](http://www.solarus-games.org/doc/1.6/lua_api_movement.html).

The [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) is the terrain property of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). It is defined by [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) and by other entities that may change it dynamically.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * Return value (boolean): `true` if your custom entity can traverse this kind of ground.


]],
      args = "ground: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_traverse_ground = {
      type = "method",
      description = [[

Sets whether this custom entity can traverse a kind of ground.

This is important only if your custom entity can [move](http://www.solarus-games.org/doc/1.6/lua_api_movement.html).

The [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) is the terrain property of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). It is defined by [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) and by other entities that may change it dynamically.

By default, this depends on the the ground: for example, the `"grass"` ground can be traversed by default while the `"low wall"` ground cannot.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * `traversable` (boolean): Whether your custom entity can traverse this kind of ground.


]],
      args = "ground: string, traversable: boolean",
      returns = "",
      valuetype = ""
      },
    add_collision_test = {
      type = "method",
      description = [[

Registers a function to be called when your custom entity detects a collision when another entity.

  * `collision_mode` (string or function): Specifies what kind of collision you want to test. This may be one of:
    * `"overlapping"`: Collision if the [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) of both entities overlap. This is often used when the other entity can traverse your custom entity.
    * `"containing"`: Collision if the bounding box of the other entity is fully inside the bounding box of your custom entity.
    * `"origin"`: Collision if the [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) or the other entity is inside the bounding box of your custom entity.
    * `"center"`: Collision if the [center point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_center_position) of the other entity is inside the bounding box of your custom entity.
    * `"facing"`: Collision if the [facing position](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_facing_position) of the other entity's bounding box is touching your custom entity's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of an entity, which is a rectangle with four sides, the facing point is the middle point of the side the entity is oriented to. This `"facing"` collision test is useful when the other entity cannot traverse your custom entity. For instance, if the other entity has direction "east", there is a collision if the middle of the east side of its bounding box touches (but does not necessarily overlap) your custom entity's bounding box. This is very often what you need, typically to let the hero interact with your entity when he is looking at it.
    * `"touching"`: Like `"facing"`, but accepts all four sides of the other entity's bounding box, no matter its direction.
    * `"sprite"`: Collision if a sprite of the other entity overlaps a sprite of your custom entity. The collision test is pixel precise.
    * A function: Custom collision test. The function takes your custom entity and then the other entity as parameters and should return `true` if there is a collision between them. This function will be called every time the engine needs to check collisions between your custom entity and any other entity.
  * `callback` (function): A function that will be called when the collision test detects a collision with another entity. This allows you to decide dynamically. This function takes your custom entity and then the other entity as parameters. If the collision test was `"sprite"`, both involved sprites are also passed as third and fourth parameters: the third parameter is the sprite of your custom entity, and the fourth parameter is the sprite of the other entity. This may be useful when your entities have several sprites, otherwise you can just ignore these additional sprite parameters.



Remarks
    See also [entity:overlaps()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_overlaps_entity) to directly test a collision rather than registering a callback.
]],
      args = "collision_mode: string or function, callback: function",
      returns = "",
      valuetype = ""
      },
    clear_collision_tests = {
      type = "method",
      description = [[

Disables any collision test previously registered with [custom_entity:add_collision_test()](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    has_layer_independent_collisions = {
      type = "method",
      description = [[

Returns whether this custom entity can detect collisions with entities even if they are not on the same layer.

By default, custom entities can only have collisions with entities on the same layer.

  * Return value (boolean): `true` if this entity can detect collisions even with entities on other layers.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_layer_independent_collisions = {
      type = "method",
      description = [[

Sets whether this custom entity can detect collisions with entities even if they are not on the same layer.

By default, custom entities can only have collisions with entities on the same layer. If you set this property to `true`, the [collision tests](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test) will be performed even with entities that are on a different layer.

  * `independent` (boolean, optional): `true` to make this entity detect collisions even with entities on other layers. No value means `true`.


]],
      args = "[independent: boolean]",
      returns = "",
      valuetype = ""
      },
    get_modified_ground = {
      type = "method",
      description = [[

Returns the kind of [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) (terrain) defined by this custom entity on the map.

  * Return value (string): The ground defined by this custom entity, or `nil` if this custom entity does not modify the ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_modified_ground = {
      type = "method",
      description = [[

Sets the kind of [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) (terrain) defined by this custom entity on the map.

The ground of the map is normally defined by tiles, but other entities may modify it dynamically.

This property allows you to make a custom entity that modifies the ground of the map, for example a hole with a special sprite or ice with particular [collision callbacks](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test). The modified ground will be applied on the map in the rectangle of this custom entity's [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box). Your custom entity can move: the ground will still be correctly applied.

  * `modified_ground` (string): The ground defined by this custom entity, or `nil` (or `"empty"`) to make this custom entity stop modifying the ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.



Remarks
    If you only need to modify the ground of the map dynamically, for example to make a moving platform over holes, a [dynamic tile](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) with a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) may be enough.
]],
      args = "modified_ground: string",
      returns = "",
      valuetype = ""
      },
    get_follow_streams = {
      type = "method",
      description = [[

Returns whether this custom entity follows [streams](http://www.solarus-games.org/doc/1.6/lua_api_stream.html).

By default, custom entities are not affected by streams and ignore them.

  * Return value (boolean): `true` if this custom entity follows streams, `false` if it ignores them.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_follow_streams = {
      type = "method",
      description = [[

Sets whether this custom entity should follow [streams](http://www.solarus-games.org/doc/1.6/lua_api_stream.html).

By default, custom entities are not affected by streams and ignore them.

  * `follow_streams` (boolean, optional): `true` to make this custom entity follow streams, `false` to ignore them. No value means `true`.



#  Events inherited from map entity

Events are callback methods automatically called by the engine if you define them.

Custom entities are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.

See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.

#  Events of the type custom entity

The following events are specific to custom entities.
]],
      args = "[follow_streams: boolean]",
      returns = "",
      valuetype = ""
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle while this custom entity lives on the map.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_ground_below_changed = {
      type = "method",
      description = [[

Called when the kind of [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) on the map below this custom entity has changed. It may change because this custom entity is moving, or when because another entity changes it.

  * `ground_below` (string): The kind of ground at the [ground point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_ground_position) of this custom entity. `nil` means empty, that is, there is no ground at this point on the current layer.


]],
      args = "ground_below: string",
      returns = "",
      valuetype = ""
      },
    on_interaction = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) interacts with this custom entity, that is, when the player presses the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) while facing this custom entity.

Remarks
    This event is also available with [NPCs](http://www.solarus-games.org/doc/1.6/lua_api_npc.html#lua_api_npc_on_interaction).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_interaction_item = {
      type = "method",
      description = [[

Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) uses any [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (the player pressed an [item command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)) while facing this custom entity.

  * `item_used` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The item currently used by the player.
  * Return value (boolean): `true` if an interaction happened. If you return `false` or nothing, then [item_used:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) will be called (just like if there was no custom entity in front of the hero).



Remarks
    This event is also available with [NPCs](http://www.solarus-games.org/doc/1.6/lua_api_npc.html#lua_api_npc_on_interaction_item). 
]],
      args = "item_used: item",
      returns = "boolean",
      valuetype = "boolean"
      }
    },
  inherits = "entity"
  },
entity = {
  type = "class",
  description = [[

Objects placed on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) are called map entities (or just entities).

There exists many types of entities. They can be either declared in the [map data file](http://www.solarus-games.org/doc/1.6/quest_map_data_file.html), or created dynamically by using the `map:create_*` methods of the [map API](http://www.solarus-games.org/doc/1.6/lua_api_map.html).
]],
  childs = {
    get_type = {
      type = "method",
      description = [[

Returns the type of entity.

  * Return value (string): The type of this entity. Can be one of: `"hero"`, `"dynamic_tile"`, `"teletransporter"`, `"destination"`, `"pickable"`, `"destructible"`, `"carried_object"`, `"chest"`, `"shop_treasure"`, `"enemy"`, `"npc"`, `"block"`, `"jumper"`, `"switch"`, `"sensor"`, `"separator"`, `"wall"`, `"crystal"`, `"crystal_block"`, `"stream"`, `"door"`, `"stairs"`, `"bomb"`, `"explosion"`, `"fire"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"custom_entity"`.



Remarks
    The type `"tile"` is not is this list because [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) don't exist at runtime for optimization reasons.
]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_map = {
      type = "method",
      description = [[

Returns the map this entity belongs to.

  * Return value ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The map that contains this entity.


]],
      args = "",
      returns = "map",
      valuetype = "map"
      },
    get_game = {
      type = "method",
      description = [[

Returns the game that is running the map this entity belongs to.

  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The current game.


]],
      args = "",
      returns = "game",
      valuetype = "game"
      },
    get_name = {
      type = "method",
      description = [[

Returns the name of this map entity.

The name uniquely identifies the entity on the map.

  * Return value (string): The name of this entity, or `nil` if the entity has no name (because the name is optional).


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    exists = {
      type = "method",
      description = [[

Returns whether this entity still exists on the map.

An entity gets destroyed when you call [entity:remove()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_remove) or when the engine removes it (for example an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) that gets killed or a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) that gets picked up). If you refer from Lua to an entity that no longer exists in the C++ side, this method returns `false`.

  * Return value (boolean): `true` if the entity exists, `false` if it was destroyed.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    remove = {
      type = "method",
      description = [[

Removes this entity from the map and destroys it.

After the entity is destroyed, [entity:exists()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_exists) returns `false` and there is no reason to keep a reference to it in the Lua side (though it is harmless).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_enabled = {
      type = "method",
      description = [[

Returns whether this entity is enabled.

When an entity is disabled, it is not displayed on the map, it does not move and does not detect collisions. But it still exists, it still has a position and it can be enabled again later.

  * Return value (boolean): `true` if this entity is enabled.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_enabled = {
      type = "method",
      description = [[

Enables or disables this entity.

When an entity is disabled, it is not displayed on the map, it does not move and does not detect collisions. Its [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html), its [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) and its [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) if any are suspended and will be resumed when the entity gets enabled again. While the entity is disabled, it still exists, it still has a position and it can be enabled again later.

  * `enabled` (boolean, optional): `true` to enable the entity, `false` to disable it. No value means `true`.


]],
      args = "[enabled: boolean]",
      returns = "",
      valuetype = ""
      },
    get_size = {
      type = "method",
      description = [[

Returns the size of the bounding box of this entity.

The [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) determines the position of the entity on the map. It is a rectangle whose width and height are multiples of 8 pixels. The bounding box is used to detect whether the entity overlaps obstacles or other entities.

  * Return value 1 (number): Width of the entity in pixels.
  * Return value 2 (number): Height of the entity in pixels.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_size = {
      type = "method",
      description = [[

Sets the size of the [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) of this entity.

This is the effective size used to detect obstacles when moving, but the [sprite(s)](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of the entity may be larger.

The default value depends on the type of entity and is often `16x16` pixels.

  * `width` (number): Width of the entity in pixels.
  * `height` (number): Height of the entity in pixels.



Remarks
    Note that the [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of an entity may have a different size than the entity itself. See [sprite:get_size()](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html#lua_api_sprite_get_size) to know it.
]],
      args = "width: number, height: number",
      returns = "",
      valuetype = ""
      },
    get_origin = {
      type = "method",
      description = [[

Returns the origin point of this entity, relative to the upper left corner of its [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box).

When an entity is located at some coordinates on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), the origin points determines what exact point of the entity's bounding box is at those coordinates. It is not necessarily the upper left corner of the entity's bounding box.

The default origin point depends on the type of entity. By convention, it is usually be the central point of contact between the entity and the soil. For most entities, including the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), [non-playing characters](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) and [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html), the default origin point is `8, 13` as their default size is `16x16`. More generally, the convention is to have an origin point of `width / 2, height - 3`.

This origin point property allows entities of different sizes to have comparable reference points. Indeed, when two entities to be drawn in Y order overlap, the engine needs to determine which one has to be displayed first (it is always the one with the lowest Y coordinate). Using the upper left corner Y coordinate for this would not work well with entities of different sizes.

Similarly, if you need to compute an [angle](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_angle) between two entities to move an entity away from another one, the calculation uses the origin point of both entities. Using the upper left corner of their bounding box would not give the accurate angle with entities of different sizes.

The origin point is also the point of synchronization of an entity with its [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) (because again, an entity that has a given size may have sprites with different sizes).

  * Return value 1 (number): X coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
  * Return value 2 (number): Y coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.


]],
      args = "",
      returns = "number,number",
      valuetype = "number,number"
      },
    set_origin = {
      type = "method",
      description = [[

Sets the origin point of this entity, relative to the upper left corner of its [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box).

See [entity:get_origin()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) for details about the origin point.

  * `origin_x` (number): X coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
  * `origin_y` (number): Y coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.



Remarks
    When you call this method, the bounding box of the entity is moved so that coordinates (as returned by [entity:get_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_position)) do not change. If this is not what you need, you can call [entity:set_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_position) then to adjust the entity's position to the coordinates you want.
]],
      args = "origin_x: number, origin_y: number",
      returns = "",
      valuetype = ""
      },
    get_position = {
      type = "method",
      description = [[

Returns the position of this entity on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) (coordinates and layer).

  * Return value 1 (number): X coordinate of the [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) of the entity, relative to the upper left corner of the map.
  * Return value 2 (number): Y coordinate of the [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) of the entity, relative to the upper left corner of the map.
  * Return value 3 (number): Layer where the entity is on the map, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).


]],
      args = "",
      returns = "number,number,number",
      valuetype = "number,number,number"
      },
    set_position = {
      type = "method",
      description = [[

Changes instantly the position of this entity on the map (coordinates and layer). The [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) of the entity gets placed at these coordinates, relative to the map's upper left corner. Any previous movement or other action performed by the entity continues normally.

  * `x` (number): X coordinate to set.
  * `y` (number): Y coordinate to set.
  * `layer` (number, optional): Layer to set, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer). By default, the layer is unchanged.



Remarks
    Be careful: this function does not check collisions with obstacles.
]],
      args = "x: number, y: number, [lay: numberer]",
      returns = "",
      valuetype = ""
      },
    get_center_position = {
      type = "method",
      description = [[

Returns the coordinates of the center point of this entity on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

  * Return value 1 (number): X coordinate of the center of this entity's bounding box, relative to the upper left corner of the map.
  * Return value 2 (number): Y coordinate of the center of this entity's bounding box, relative to the upper left corner of the map.
  * Return value 3 (number): Layer of the entity.


]],
      args = "",
      returns = "number,number,number",
      valuetype = "number,number,number"
      },
    get_facing_position = {
      type = "method",
      description = [[

Returns the coordinates of the point this entity is looking at. This point depends on the direction of the main sprite if any. If the entity has no sprite, or if the main sprite has not 4 directions, then the movement is considered. If there is no movement either, the entity is assumed to look to the North.

  * Return value 1 (number): X coordinate of the facing point of this entity, relative to the upper left corner of the map.
  * Return value 2 (number): Y coordinate of the facing point of this entity, relative to the upper left corner of the map.
  * Return value 3 (number): Layer of the entity.


]],
      args = "",
      returns = "number,number,number",
      valuetype = "number,number,number"
      },
    get_facing_entity = {
      type = "method",
      description = [[

Returns the entity this entity is looking at, if any.

This is an entity overlapping the [facing position](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_facing_position) of this entity. If several entities are overlapping the facing position, the first one in Z order is returned.

  * Return value (entity): The facing entity, or `nil` if there is no entity in front of this entity.


]],
      args = "",
      returns = "entity",
      valuetype = "entity"
      },
    get_ground_position = {
      type = "method",
      description = [[

Returns the coordinates of the point used for ground detection for this entity on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

The ground position is the point tested by all features related to the ground, like all effects of various grounds on the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), the result of [entity:get_ground_below()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_ground_below) and the event [custom_entity:on_ground_below_changed()](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_on_ground_below_changed).

  * Return value 1 (number): X coordinate of the ground point of this entity, relative to the upper left corner of the map.
  * Return value 2 (number): Y coordinate of the ground point of this entity, relative to the upper left corner of the map.
  * Return value 3 (number): Layer of the entity.



Remarks
    The ground point of an entity is slightly (2 pixels) above its origin point as returned by [entity:get_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_position).
]],
      args = "",
      returns = "number,number,number",
      valuetype = "number,number,number"
      },
    get_ground_below = {
      type = "method",
      description = [[

Returns the map's ground below this entity.

The ground is defined by the topmost [tile](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) below this entity, plus potential dynamic entities that may affect the ground, like [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html), [destructibles](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html) and [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html).

The exact point tested is the one returned by [entity:get_ground_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_ground_position), and it is slightly different from [entity:get_position()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_position).

  * Return value (string): The ground below this entity. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    get_bounding_box = {
      type = "method",
      description = [[

Returns the rectangle representing the [coordinates](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_position) and [size](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_size) of this entity on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

The [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) determines the position of the entity on the map. It is a rectangle whose width and height are multiples of 8 pixels. The bounding box is used to detect whether the entity overlaps obstacles or other entities.

  * Return value 1 (number): X coordinate of the upper left corner of the bounding box.
  * Return value 2 (number): Y coordinate of the upper left corner of the bounding box.
  * Return value 3 (number): Width of the bounding box.
  * Return value 4 (number): Height of the bounding box.



Remarks
    The sprites of this entity (if any) may exceed the bounding box. See [entity:get_max_bounding_box()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_max_bounding_box).
]],
      args = "",
      returns = "number,number,number,number",
      valuetype = "number,number,number,number"
      },
    get_max_bounding_box = {
      type = "method",
      description = [[

Returns the rectangle surrounding the bounding box of this entity plus the bounding boxes of its sprites in all their possible animations and directions.

This is usually larger than [entity:get_bounding_box()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box), because the sprite of an entity often exceeds its bounding box.

  * Return value 1 (number): X coordinate of the upper left corner of the sprites bounding box.
  * Return value 2 (number): Y coordinate of the upper left corner of the sprites bounding box.
  * Return value 3 (number): Width of the sprites bounding box.
  * Return value 4 (number): Height of the sprites bounding box.


]],
      args = "",
      returns = "number,number,number,number",
      valuetype = "number,number,number,number"
      },
    get_layer = {
      type = "method",
      description = [[

Returns the layer of this entity on the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

  * Return value (number): Layer where the entity is on the map, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_layer = {
      type = "method",
      description = [[

Changes the layer of this entity on the map. The X and Y coordinates of the entity are unchanged. Any previous movement or action performed by the entity continues normally.

  * `layer` (number, optional): Layer to set, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).



Remarks
    Be careful: this function does not check collisions with obstacles.
]],
      args = "layer: number",
      returns = "",
      valuetype = ""
      },
    overlaps = {
      type = "method",
      description = [[

Returns whether another entity collides with this entity according to the specified collision test.

  * `entity` (entity): Another entity.
  * `collision_mode` (string, optional): Specifies what kind of collision you want to test. This may be one of:
    * `"overlapping"`: Collision if the [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) of both entities overlap. This is the default value.
    * `"containing"`: Collision if the bounding box of the other entity is fully inside the bounding box of this entity.
    * `"origin"`: Collision if the [origin point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_origin) or the other entity is inside the bounding box of this entity.
    * `"center"`: Collision if the [center point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_center_position) of the other entity is inside the bounding box of this entity.
    * `"facing"`: Collision if the [facing position](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_facing_position) of the other entity's bounding box is touching this entity's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of an entity, which is a rectangle with four sides, the facing point is the middle point of the side the entity is oriented to. This `"facing"` collision test is useful when the other entity cannot traverse your custom entity. For instance, if the other entity has direction "east", there is a collision if the middle of the east side of its bounding box touches (but does not necessarily overlap) this entity's bounding box. This is typically what you need to let the hero interact with this entity when he is looking at it.
    * `"touching"`: Like `"facing"`, but accepts all four sides of the other entity's bounding box, no matter its direction.
    * `"sprite"`: Collision if a sprite of the other entity overlaps a sprite of this entity. The collision test is pixel precise. The last two optional sprite parameters can then indicate which sprite of both entities you want to test. If you don't set them, all sprites of both entities will be tested.
  * `entity_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) or nil, optional): Sprite of this entity you want to test (only with collision mode `"sprite"`). `nil` or no value means to test all sprites of this entity.
  * `other_entity_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) or nil, optional): Sprite of the other entity you want to test (only with collision mode `"sprite"`). `nil` or no value means to test all sprites of the other entity.
  * Return value (boolean): `true` if a collision is detected with this collision test.



Remarks
    For custom entities, see also [custom_entity:add_collision_test()](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test) to be automatically notified when a collision is detected.
]],
      args = "other_entity: entity, [collision_mode: string, [entity: entity_sprite: sprite or nil, [other_entity: entity_sprite: sprite or nil]]]",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_distance = {
      type = "method",
      description = [[

Returns the distance in pixels between this map entity and a point or another map entity.

To compute the distance to a specified point:

  * `x` (number): X coordinate of the point.
  * `y` (number): Y coordinate of the point.
  * Return value (number): The distance in pixels between the origin point of this entity and the point.



To compute the distance to another map entity:

  * `other_entity` (entity): The entity to compute the distance to.
  * Return value (number): The distance in pixels between the origin point of this entity and the origin point of the other entity.


]],
      args = "x: number, y: number",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_angle = {
      type = "method",
      description = [[

Returns the angle between the X axis and the vector that joins this entity to a point.

To compute the angle to a specified point:

  * `x` (number): X coordinate of the point.
  * `y` (number): Y coordinate of the point.
  * Return value (number): The angle in radians between the origin point of this entity and the specified point. The angle is between `0` and `2 * math.pi`.



To compute the angle to another map entity:

  * `other_entity` (entity): The entity to compute the angle to.
  * Return value (number): The angle in radians between the origin point of this entity and the origin point of the other entity. The angle is between `0` and `2 * math.pi`.


]],
      args = "x: number, y: number",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_direction4_to = {
      type = "method",
      description = [[

Like [entity:get_angle()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_angle), but instead of an angle in radians, returns the closest direction among the 4 main directions.

This is a utility function that essentially rounds the result of [entity:get_angle()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_angle).

To compute the direction to a specified point:

  * `x` (number): X coordinate of the point.
  * `y` (number): Y coordinate of the point.
  * Return value (number): The direction this entity should take to look at this point, between 0 (East) and 3 (South).



To compute the direction to another map entity:

  * `other_entity` (entity): An entity to target.
  * Return value (number): The direction this entity should take to look at the other entity, between 0 (East) and 3 (South).


]],
      args = "x: number, y: number",
      returns = "number,number",
      valuetype = "number,number"
      },
    get_direction8_to = {
      type = "method",
      description = [[

Like [entity:get_angle()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_angle), but instead of an angle in radians, returns the closest direction among the 8 main directions.

This is a utility function that essentially rounds the result of [entity:get_angle()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_angle).

To compute the direction to a specified point:

  * `x` (number): X coordinate of the point.
  * `y` (number): Y coordinate of the point.
  * Return value (number): The direction this entity should take to look at this point, between 0 (East) and 7 (South-East).



To compute the direction to another map entity:

  * `other_entity` (entity): An entity to target.
  * Return value (number): The direction this entity should take to look at the other entity, between 0 (East) and 7 (South-East).


]],
      args = "x: number, y: number",
      returns = "number,number",
      valuetype = "number,number"
      },
    snap_to_grid = {
      type = "method",
      description = [[

Makes sure this entity's upper left corner is aligned with the 8*8 grid of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html).

Remarks
    Be careful: this function does not check collisions with obstacles.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    bring_to_front = {
      type = "method",
      description = [[

Places this entity in front of all other entities on the same layer.

Since entities that are on the same layer can overlap, you can use this function to change their Z order.

Remarks
    Some entities can have have the property to be [drawn in Y order](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) rather than in Z order. This function only has an effect on entities drawn in Z order.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    bring_to_back = {
      type = "method",
      description = [[

Places this entity behind all other entities on the same layer.

Since entities that are on the same layer can overlap, you can use this function to change their Z order.

Remarks
    Some entities can have have the property to be [drawn in Y order](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) rather than in Z order. This function only has an effect on entities drawn in Z order.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    is_drawn_in_y_order = {
      type = "method",
      description = [[

Returns whether this entity should be drawn in Y order or in Z order.

The map is drawn layer by layer, and each layer is drawn in two passes: first, entities displayed in Z order, and then, entities displayed in Y order.

The Z order is the creation order of entities unless you call [entity:bring_to_front()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_to_front) or [entity:bring_to_back()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_to_back).

The Y order compares the Y coordinate of entities on the map. Entities drawn in Y order are displayed from the one the most to the north to the one the most to the south.

Usually, entities representing a character or something that is standing should be drawn in Y order, so that it looks correct when some of them overlap with each other, and flat entities should be drawn in Z order.

The default setting depends on the type of entities.

  * Return value (boolean): `true` if this entity is displayed in Y order, `false` if it is displayed in Z order.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_drawn_in_y_order = {
      type = "method",
      description = [[

Sets whether this entity should be drawn in Y order or in Z order.

See [entity:is_drawn_in_y_order()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) for details about the Y order and the Z order.

  * `y_order` (boolean, optional): `true` to display this entity in Y order, `false` to display it in Z order. No value means `true`.


]],
      args = "[y_order: boolean]",
      returns = "",
      valuetype = ""
      },
    get_optimization_distance = {
      type = "method",
      description = [[

Returns the optimization threshold hint of this map entity.

Above this distance from the camera, the engine may decide to skip updates or drawings. This is only a hint: the engine is responsible of the final decision. A value of `0` means an infinite distance (the entity is never optimized away).

  * Return value (number): The optimization distance hint in pixels.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_optimization_distance = {
      type = "method",
      description = [[

Sets the optimization threshold hint of this map entity.

Above this distance from the camera, the engine may decide to skip updates or drawings. This is only a hint: the engine is responsible of the final decision.

A value of `0` means an infinite distance (the entity is never optimized away). The default value is `0`.

  * `optimization_distance` (number): The optimization distance hint to set in pixels.


]],
      args = "optimization_distance: number",
      returns = "",
      valuetype = ""
      },
    is_in_same_region = {
      type = "method",
      description = [[

Returns whether this entity is in the same region as another one.

Regions of the map are defined by the position of [separators](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) and map limits. The region of an entity is the one of its center point.

Regions should be rectangular. Non-convex regions, for example with an "L" shape, are not supported by this function.

You can use this function to make sure that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) close to the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) but in the other side of a separator won't attack him.

  * `other_entity` (entity): Another entity.
  * Return value (boolean): `true` if both entities are in the same region.


]],
      args = "other_entity: entity",
      returns = "boolean",
      valuetype = "boolean"
      },
    test_obstacles = {
      type = "method",
      description = [[

Returns whether there would be a collision with obstacles if this map entity was placed at a given offset from its current position.

  * `dx` (number, optional): X offset in pixels (`0` means the current X position). No value means `0`.
  * `dy` (number, optional): Y offset in pixels (`0` means the current Y position). No value means `0`.
  * `layer` (number, optional): Layer to test. No value means the current layer.
  * Return value (boolean): `true` if there would be a collision in this position.


]],
      args = "[dx: number, dy: number, [layer: number]]",
      returns = "boolean",
      valuetype = "boolean"
      },
    get_sprite = {
      type = "method",
      description = [[

Returns a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) representing this entity.

To manage entities with multiple sprites, you can set names when you create sprites with [entity:create_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_create_sprite). However, it is easier to just leave the names blank and simply store the result of these sprite creation methods. The name is more useful for built-in entities that have multiple sprites automatically created by the engine. Such entities are the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html), [carried objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) and [crystals](http://www.solarus-games.org/doc/1.6/lua_api_crystal.html). See the documentation pages of these entities to know their exact sprites, the name of these sprites and which one is their main sprite. For [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html), the main sprite is the first one in Z order, which is the sprite creation order unless you call [entity:bring_sprite_to_front()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_sprite_to_front) or [entity:bring_sprite_to_back()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_sprite_to_back).

  * `name` (string, optional): Name of the sprite to get. Only useful for entities that have multiple sprites. No value means the main sprite.
  * Return value ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The entity sprite with this name, or its main sprite if no name is specified. Returns `nil` if the entity has no such sprite.


]],
      args = "[name: string]",
      returns = "sprite",
      valuetype = "sprite"
      },
    get_sprites = {
      type = "method",
      description = [[

Returns an iterator to all [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of this entity.

At each step, the iterator provides two values: the name of a sprite (which is an empty string if the sprite has no name) and the sprite itself. See [entity:get_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_sprite) for more details about named sprites.

Sprites are returned in their displaying order. Note that this order can be changed with [entity:bring_sprite_to_front()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_sprite_to_front) and [entity:bring_sprite_to_back()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_bring_sprite_to_back).

The typical usage of this function is: 
    
    
    for sprite_name, sprite in entity:get_sprites() do
      -- some code related to the sprite
    end
    

  * Return value (function): An iterator to all sprites of this entity.


]],
      args = "",
      returns = "function",
      valuetype = "function"
      },
    create_sprite = {
      type = "method",
      description = [[

Creates a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) for this entity.

  * `animation_set_id` (string): Animation set to use for the sprite.
  * `sprite_name` (string, optional): An optional name to identify the created sprite. Only useful for entities with multiple sprites (see [entity:get_sprite()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_sprite)).
  * Return value ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite created.


]],
      args = "animation_set_id: string, [sprite_name: string]",
      returns = "sprite",
      valuetype = "sprite"
      },
    remove_sprite = {
      type = "method",
      description = [[

Removes and destroys a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of this entity.

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), optional): The sprite to remove. The default value is the first sprite that was created.


]],
      args = "[sprite: sprite]",
      returns = "",
      valuetype = ""
      },
    bring_sprite_to_front = {
      type = "method",
      description = [[

Reorders a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of this entity to be displayed after other sprites (displayed to the front).

This function is only useful for entities that have multiple sprites.

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite to reorder. It must belong to this entity.


]],
      args = "sprite: sprite",
      returns = "",
      valuetype = ""
      },
    bring_sprite_to_back = {
      type = "method",
      description = [[

Reorders a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) of this entity to be displayed before other sprites (displayed to the back).

This function is only useful for entities that have multiple sprites.

  * `sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): The sprite to reorder. It must belong to this entity.


]],
      args = "sprite: sprite",
      returns = "",
      valuetype = ""
      },
    is_visible = {
      type = "method",
      description = [[

Returns whether this entity is visible.

When the entity is hidden, its sprites (if any) are not displayed, but everything else continues normally, including collisions.

  * Return value (boolean): `true` if the entity is visible.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_visible = {
      type = "method",
      description = [[

Hides or shows the entity.

When the entity is hidden, its sprites (if any) are not displayed, but everything else continues normally, including collisions.

  * `visible` (boolean, optional): `true` to show the entity, `false` to hide it. No value means `true`.


]],
      args = "[visible: boolean]",
      returns = "",
      valuetype = ""
      },
    get_draw_override = {
      type = "method",
      description = [[

Returns the draw function of this entity.

See [entity:set_draw_override()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_draw_override) for more details.

  * Return value (function or nil): The draw function, or `nil` if the draw function was not overridden.


]],
      args = "",
      returns = "function or nil",
      valuetype = "function or nil"
      },
    set_draw_override = {
      type = "method",
      description = [[

Changes how this entity is drawn.

You can use this to replace the built-in draw implementation of the engine by your own function, if the default behavior does not fit your needs. To do so, your function can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `draw_override` (function or nil): The draw function, or `nil` to restore the built-in drawing. Your function will receive the following parameters:
    * `entity` (entity): The entity to draw.
    * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): Camera where this entity is drawn.



Remarks
    Even when you set a draw override, events [entity:on_pre_draw()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_pre_draw) and [entity:on_post_draw()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_post_draw) are still called.
]],
      args = "draw_override: function or nil",
      returns = "",
      valuetype = ""
      },
    get_weight = {
      type = "method",
      description = [[

Returns the weight of this entity, if any.

If the entity has a weight, then the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is allowed to lift it if his [lift ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) is greater than or equal to that weight. You can use [entity:on_lifting()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_lifting) to know when an entity starts being lifted.

The default weight depends on the type of entity. Most entities cannot be lifted by default.

  * Return value (number): The level of `"lift"` ability required to lift this entity. `0` allows the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) to lift the entity unconditionally. The special value `-1` means that the entity can never be lifted.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_weight = {
      type = "method",
      description = [[

Sets the weight of this entity.

See [entity:get_weight()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_weight) for more details.

  * `weight` (number): The level of `"lift"` ability required to lift this entity. `0` allows the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) to lift the entity unconditionally. The special value `-1` means that the entity can never be lifted.


]],
      args = "weight: number",
      returns = "",
      valuetype = ""
      },
    get_controlling_stream = {
      type = "method",
      description = [[

Returns the [stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html) that is currently controlling this entity, if any.

  * Return value ([stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html)): The current stream, or `nil` if this entity is not being controlled by a stream.


]],
      args = "",
      returns = "stream",
      valuetype = "stream"
      },
    get_movement = {
      type = "method",
      description = [[

Returns the current movement of this map entity.

  * Return value ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The current movement, or `nil` if the entity is not moving.


]],
      args = "",
      returns = "movement",
      valuetype = "movement"
      },
    stop_movement = {
      type = "method",
      description = [[

Stops the current movement of this map entity if any.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_property = {
      type = "method",
      description = [[

Returns the value of a user-defined property of this entity.

User-defined properties are arbitrary key-value pairs that you can set to any entity. The engine does nothing special with them, but you can use them in your scripts to store extra information.

  * `key` (string): Name of the property to get.
  * Return value (string): The corresponding value, or `nil` if there is no such property.


]],
      args = "key: string",
      returns = "string",
      valuetype = "string"
      },
    set_property = {
      type = "method",
      description = [[

Sets a user-defined property for this entity.

If the property does not exist yet, it will be created.

User-defined properties are arbitrary key-value pairs that you can set to any entity. The engine does nothing special with them, but you can use them in your scripts to store extra information.

  * `key` (string): Name of the property to set. It must be a valid identifier (only alphanumeric ASCII characters or `'_'`).
  * `value` (string or nil): The value to set, or `nil` to remove the property.


]],
      args = "key: string, value: string or nil",
      returns = "",
      valuetype = ""
      },
    get_properties = {
      type = "method",
      description = [[

Returns the user-defined properties of this entity.

  * Return value (table): An array of properties. Each property is a table with two fields:
    * `key` (string): Name of the property.
    * `value` (string): Value of the property.


]],
      args = "",
      returns = "table",
      valuetype = "table"
      },
    set_properties = {
      type = "method",
      description = [[

Sets the user-defined properties of this entity.

Existing properties if any are removed.

  * `properties` (table): An array of properties. Each property is a table with two fields:
    * `key` (string): Name of the property. It must be a valid identifier (only alphanumeric ASCII characters or `'_'`).
    * `value` (string): Value of the property.



#  Events of all entity types

Events are callback methods automatically called by the engine if you define them.
]],
      args = "properties: table",
      returns = "",
      valuetype = ""
      },
    on_created = {
      type = "method",
      description = [[

Called when this entity has just been created on the map.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_removed = {
      type = "method",
      description = [[

Called when this entity is about to be removed from the map (and therefore destroyed).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_enabled = {
      type = "method",
      description = [[

called when this entity has just been [enabled](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_enabled).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_disabled = {
      type = "method",
      description = [[

called when this entity has just been [disabled](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_is_enabled).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_suspended = {
      type = "method",
      description = [[

Called when the entity has just been suspended or resumed.

The entity is suspended by the engine in a few cases, like when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation.

  * `suspended` (boolean): `true` if the entity was just suspended, `false` if it was resumed.


]],
      args = "suspended: boolean",
      returns = "",
      valuetype = ""
      },
    on_position_changed = {
      type = "method",
      description = [[

Called when the coordinates of this entity have just changed.

  * `x` (number): The new X coordinate of the entity.
  * `y` (number): The new Y coordinate of the entity.
  * `layer` (number): The new layer of the entity.


]],
      args = "x: number, y: number, lay: numberer",
      returns = "",
      valuetype = ""
      },
    on_obstacle_reached = {
      type = "method",
      description = [[

Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of this entity was stopped because of an obstacle.

When an obstacle is reached, this event is called instead of [entity:on_position_changed()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_position_changed).

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.


]],
      args = "movement: movement",
      returns = "",
      valuetype = ""
      },
    on_movement_started = {
      type = "method",
      description = [[

Called when a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) is started on this entity.

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement that was just started on this entity.


]],
      args = "movement: movement",
      returns = "",
      valuetype = ""
      },
    on_movement_changed = {
      type = "method",
      description = [[

Called when some characteristics of this entity's [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) (like the speed or the angle) have just changed.

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.


]],
      args = "movement: movement",
      returns = "",
      valuetype = ""
      },
    on_movement_finished = {
      type = "method",
      description = [[

Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of the entity is finished (if there is an end).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_lifting = {
      type = "method",
      description = [[

Called when this entity starts being lifted.

At this point, the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is in [state](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) `"lifting"`. The animation `"lifting"` of his sprites is playing and the player cannot control the hero.

This entity no longer exists (unless it is a destructible object that can [regenerate](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html#lua_api_destructible_get_can_regenerate)). It is replaced by a [carried object](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) with the same sprite.

  * `carrier` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): Entity that is lifting this destructible object (can only be the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) for now).
  * `carried_object` ([carried object](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html)): The carried object that was created.


]],
      args = "carrier: entity, carried_object: carried object",
      returns = "",
      valuetype = ""
      },
    on_pre_draw = {
      type = "method",
      description = [[

Called just before the entity is drawn on the map.

You may display additional things below the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn.


]],
      args = "camera: camera",
      returns = "",
      valuetype = ""
      },
    on_post_draw = {
      type = "method",
      description = [[

Called just after the entity is drawn on the map.

You may display additional things above the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn. 


]],
      args = "camera: camera",
      returns = "",
      valuetype = ""
      }
    }
  },
state = {
  type = "class",
  description = [[

This module provides a datatype `state` that represents a custom state allowing advanced customization of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
]],
  childs = {
    get_description = {
      type = "method",
      description = [[

Returns the description of this state.

  * Return value (string): The description, or `nil` if no description was set.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_description = {
      type = "method",
      description = [[

Sets the description of this state.

The engine does nothing special with this description, but it may help you distinguish states.

  * `description` (string or nil): The description to set, or `nil` to set no description.


]],
      args = "description: string or nil",
      returns = "",
      valuetype = ""
      },
    get_entity = {
      type = "method",
      description = [[

Returns the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) controlled by this state.

  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity controlled by this state (which can only by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)), or `nil` if the state is not associated to an entity yet.



Remarks
    Even if the state is finished, this method still returns the entity that was controlled.
]],
      args = "",
      returns = "entity",
      valuetype = "entity"
      },
    get_map = {
      type = "method",
      description = [[

Returns the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of the entity controlled by this state.

  * Return value ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The map, or `nil` if the state is not associated to an entity yet.


]],
      args = "",
      returns = "map",
      valuetype = "map"
      },
    get_game = {
      type = "method",
      description = [[

Returns the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) of the entity controlled by this state.

  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game, or `nil` if the state is not associated to an entity yet.


]],
      args = "",
      returns = "game",
      valuetype = "game"
      },
    is_started = {
      type = "method",
      description = [[

Returns whether this state is started, that is, if it was activated on an entity (see [hero:start_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_state)) and is not finished yet.

  * Return value (boolean): `true` if the state is started.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    is_visible = {
      type = "method",
      description = [[

Returns whether the entity is visible during this state.

  * Return value (boolean): `true` if the entity is visible during this state, `false` if it is hidden.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_visible = {
      type = "method",
      description = [[

Returns whether the entity should be visible during this state.

  * `visible` (boolean, optional): `true` to make the entity visible during this state, `false` to hide it. No value means `true`.


]],
      args = "[visible: boolean]",
      returns = "",
      valuetype = ""
      },
    get_draw_override = {
      type = "method",
      description = [[

Returns the draw function of this state.

See [state:set_draw_override()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_set_draw_override) for more details.

  * Return value (function or nil): The draw function, or `nil` if the draw function was not overridden.


]],
      args = "",
      returns = "function or nil",
      valuetype = "function or nil"
      },
    set_draw_override = {
      type = "method",
      description = [[

Changes how this entity is drawn during this state.

You can use this to replace the built-in draw implementation of the engine by your own function, if the default behavior does not fit your needs. To do so, your function can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `draw_override` (function or nil): The draw function, or `nil` to restore the built-in drawing. Your function will receive the following parameters:
    * `state` (state): The custom state of the entity to draw.
    * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): Camera where the entity is drawn.



Remarks
    Even when you set a draw override, events [state:on_pre_draw()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_pre_draw) and [state:on_post_draw()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_post_draw) are still called.
]],
      args = "draw_override: function or nil",
      returns = "",
      valuetype = ""
      },
    get_can_control_direction = {
      type = "method",
      description = [[

Returns whether the player controls the direction of entity's sprites during this state.

  * Return value (boolean): `true` if the player controls the sprites direction.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_control_direction = {
      type = "method",
      description = [[

Sets whether the player controls the direction of entity's sprites during this state.

The default value is `true`. If you set this to `false`, then the entity's sprites no longer automatically take the direction pressed by the player.

  * `can_control_direction` (boolean): `true` to let the player control the sprites direction. No value means `true`.


]],
      args = "can_control_direction: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_control_movement = {
      type = "method",
      description = [[

Returns whether the player controls the movement of the entity during this state.

  * Return value (boolean): `true` if the player controls the movement.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_control_movement = {
      type = "method",
      description = [[

Sets whether the player controls the movement of the entity during this state.

The default value is `true`. If this setting is `true`, a movement is automatically created on the entity and this movement reacts to the player's input. If you set this to `false`, then the entity has no automatic movement during this state.

  * `can_control_movement` (boolean): `true` to let the player control the movement.


]],
      args = "can_control_movement: boolean",
      returns = "",
      valuetype = ""
      },
    set_can_traverse = {
      type = "method",
      description = [[

Sets whether the entity can traverse other entities in this state.

By default, this depends on the other entities: for example, [sensors](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html) can be traversed by default while [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) cannot unless they are open.

  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types for which you don't override this setting.
  * `traversable` (boolean, function or `nil`): Whether the entity controlled by this state can traverse the other entity type. This can be:
    * A boolean: `true` to allow your entity to traverse entities of the specified type, `false` otherwise.
    * A function: Custom test. This allows you to decide dynamically. The function takes your entity (the one controlled by this state) and then the other entity as parameters, and should return `true` if you allow your entity to traverse the other entity. When your entity has a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html), this function will be called every time it is about to overlap an entity of the specified type.
    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.


]],
      args = "[entity_type: string], traversable: boolean, function or nil",
      returns = "",
      valuetype = ""
      },
    get_can_traverse_ground = {
      type = "method",
      description = [[

Returns whether the entity can traverse the given kind of ground during this state.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * Return value (boolean): `true` if the ground can be traversed during this state.


]],
      args = "ground: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_traverse_ground = {
      type = "method",
      description = [[

Sets whether the entity can traverse the given kind of ground during this state.

By default, this depends on the the ground: for example, the `"grass"` ground can be traversed by default while the `"low wall"` ground cannot.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * `traversable` (boolean): Whether the entity can traverse this kind of ground during this state.


]],
      args = "ground: string, traversable: boolean",
      returns = "",
      valuetype = ""
      },
    is_gravity_enabled = {
      type = "method",
      description = [[

Returns whether the entity is affected by gravity during this state.

If yes, the entity will fall to the lower layer when the ground below it is `"empty"`.

  * Return value (boolean): `true` if the entity is affected by gravity during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_gravity_enabled = {
      type = "method",
      description = [[

Sets whether the entity is affected by gravity during this state.

If yes, the entity will fall to the lower layer when the ground below it is `"empty"`.

The default value is `true`. You should typically set this to `false` when the entity is jumping of flying.

  * `gravity_enabled` (boolean): `true` to make the entity affected by gravity during this state.


]],
      args = "gravity_enabled: boolean",
      returns = "",
      valuetype = ""
      },
    is_affected_by_ground = {
      type = "method",
      description = [[

Returns whether the given kind of ground affects the entity during this state.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * Return value (boolean): `true` if this ground affects the entity during this state.


]],
      args = "ground: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_affected_by_ground = {
      type = "method",
      description = [[

Sets whether a kind of ground affects the entity during this state.

  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
  * `affected` (boolean): `true` to make this ground affect the entity during this state.


]],
      args = "ground: string, affected: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_come_from_bad_ground = {
      type = "method",
      description = [[

Returns whether this state remembers the last solid position of the entity as a place to come back to later if it falls into bad ground like holes or lava.

  * Return value (boolean): `true` if solid positions in this state are considered as places to come back to when falling into bad grounds.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_come_from_bad_ground = {
      type = "method",
      description = [[

Sets whether this state remembers the last solid position of the entity as a place to come back to later if it falls into bad ground like holes or lava.

The default value is `true`.

  * `can_come_from_bad_ground` (boolean): `true` if solid positions in this state should be considered as places to come back to when falling into bad grounds.


]],
      args = "",
      returns = "",
      valuetype = ""
      },
    get_can_be_hurt = {
      type = "method",
      description = [[

Returns whether the entity can be hurt during this state.

  * Return value (boolean): `true` if the entity can be hurt during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_be_hurt = {
      type = "method",
      description = [[

Sets whether the entity can be hurt during this state.

The default value is `true`.

  * `can_be_hurt` (boolean): Whether the entity controlled by this state can be hurt.


]],
      args = "can_be_hurt: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_use_sword = {
      type = "method",
      description = [[

Returns whether the entity can swing the sword during this state.

  * Return value (boolean): `true` if the entity can use the sword.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_use_sword = {
      type = "method",
      description = [[

Sets whether the entity can swing the sword during this state.

The default value is `true`.

  * `can_use_sword` (boolean): `true` to allow to use the sword.


]],
      args = "can_use_sword: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_use_shield = {
      type = "method",
      description = [[

Returns whether the entity can stop attacks with the shield during this state.

  * Return value (boolean): `true` if the entity can stop attacks with the shield.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_use_shield = {
      type = "method",
      description = [[

Sets whether the entity can stop attacks with the shield during this state.

The default value is `true`.

  * `can_use_shield` (boolean): `true` if the entity can stop attacks with the shield.


]],
      args = "can_use_shield: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_use_item = {
      type = "method",
      description = [[

Returns whether an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) can be used during this state.

  * Return value (boolean): `true` if the player can use equipment items during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_use_item = {
      type = "method",
      description = [[

Sets whether an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) can be used during this state.

The default value is `true`.

  * `can_use_item` (boolean): `true` to allow the player to use equipment items during this state.


]],
      args = "can_use_item: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_push = {
      type = "method",
      description = [[

Returns whether the entity can try to push the obstacles it is facing.

  * Return value (boolean): `true` if pushing is allowed in this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_push = {
      type = "method",
      description = [[

Sets whether the entity can start pushing the obstacles it is facing.

If `true`, the entity will go to state `"pushing"` when it reaches an obstacle and continues to move toward this obstacle for a configurable [delay](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_pushing_delay). This does not mean that the obstacle being pushed will actually move ([blocks](http://www.solarus-games.org/doc/1.6/lua_api_block.html) can move when being pushed, but other entities usually cannot).

The default value is `true`.

  * `can_push` (boolean): `true` to allow to push in this state.



Remarks
    Ability [pushing](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) is necessary so that the hero can push.
]],
      args = "can_push: boolean",
      returns = "",
      valuetype = ""
      },
    get_pushing_delay = {
      type = "method",
      description = [[

Returns the delay before pushing when moving towards an obstacle during this state.

  * Return value (number): The pushing delay in milliseconds.


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_pushing_delay = {
      type = "method",
      description = [[

Sets the delay before pushing when moving towards an obstacle during this state.

This only has an effect if [state:get_can_push()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_can_push) is `true`.

The default value is `1000` ms.

  * `pushing_delay` (number): The pushing delay in milliseconds (`0` for no delay).


]],
      args = "pushing_delay: number",
      returns = "",
      valuetype = ""
      },
    get_can_pick_treasure = {
      type = "method",
      description = [[

Returns whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) can be picked during this state.

  * Return value (boolean): `true` if pickable treasures can be picked during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_pick_treasure = {
      type = "method",
      description = [[

Sets whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) can be picked during this state.

The default value is `true`.

  * `can_pick_treasure` (boolean): `true` to allow the entity to pick treasures during this state.


]],
      args = "can_pick_treasure: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_use_stairs = {
      type = "method",
      description = [[

Returns whether the entity can take [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) during this state.

  * Return value (boolean): `true` if the entity can take stairs during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_use_stairs = {
      type = "method",
      description = [[

Sets whether the entity can take [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) during this state.

The default value is `true`.

  * `can_use_stairs` (boolean): `true` to allow the entity to take stairs during this state.


]],
      args = "can_use_stairs: boolean",
      returns = "",
      valuetype = ""
      },
    get_can_use_jumper = {
      type = "method",
      description = [[

Returns whether the entity can activate [jumpers](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) during this state.

  * Return value (boolean): `true` if the entity can take jumpers during this state.


]],
      args = "",
      returns = "boolean",
      valuetype = "boolean"
      },
    set_can_use_jumper = {
      type = "method",
      description = [[

Sets whether the entity can take [jumpers](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) during this state.

The default value is `true`.

  * `can_use_jumper` (boolean): `true` to allow the entity to take jumpers during this state.


]],
      args = "can_use_jumper: boolean",
      returns = "",
      valuetype = ""
      },
    get_jumper_delay = {
      type = "method",
      description = [[

Returns the delay before jumping when taking a jumper during this state.

  * Return value (number): The jump delay in milliseconds (`0` means no delay).


]],
      args = "",
      returns = "number",
      valuetype = "number"
      },
    set_jumper_delay = {
      type = "method",
      description = [[

Sets the delay before jumping when taking a jumper during this state.

This only has an effect if [state:get_can_use_jumper()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_can_use_jumper) is `true`.

The default value is `200` ms.

  * `jumper_delay` (number): The jump delay in milliseconds (`0` for no delay).


]],
      args = "jumper_delay: number",
      returns = "",
      valuetype = ""
      },
    get_carried_object_action = {
      type = "method",
      description = [[

Returns what happens during this state to an object that was [carried](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) the previous state.

  * Return value (string): One of:
    * `"throw"` (default): The carried object is automatically thrown.
    * `"remove"`: The carried object is silently destroyed.
    * `"keep"`: The carried object continues to be carried.


]],
      args = "",
      returns = "string",
      valuetype = "string"
      },
    set_carried_object_action = {
      type = "method",
      description = [[

Sets what happens during this state to an object that was [carried](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) the previous state.

  * `action` (string): One of:
    * `"throw"` (default): The carried object is automatically thrown.
    * `"remove"`: The carried object is silently destroyed.
    * `"keep"`: The carried object continues to be carried.



#  Events of a state

Events are callback methods automatically called by the engine if you define them. In the case of states, they are only called on an active state.
]],
      args = "action: string",
      returns = "",
      valuetype = ""
      },
    on_started = {
      type = "method",
      description = [[

Called when this state starts.

  * `previous_state_name` (string or nil): Name of the state that was active before. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the possible values. This value is `nil` if there was no state before (only possible for the first state of an entity).
  * `previous_state` (state or nil): Custom state object that was active before, if it was a custom one, `nil` otherwise.


]],
      args = "previous_state: state or nil_name: string or nil, previous_state: state or nil",
      returns = "",
      valuetype = ""
      },
    on_finished = {
      type = "method",
      description = [[

Called when this state finishes.

  * `next_state_name` (string or nil): Name of the state that is about to be active after yours. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the possible values. This value is `nil` if there is no state after yours (only possible if the entity is being removed).
  * `next_state` (state or nil): Custom state object about to start, if it is a custom one, `nil` otherwise.


]],
      args = "next_state: state or nil_name: string or nil, next_state: state or nil",
      returns = "",
      valuetype = ""
      },
    on_update = {
      type = "method",
      description = [[

Called at each cycle of the main loop while this state is active.

Remarks
    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_pre_draw = {
      type = "method",
      description = [[

Called just before the entity is drawn on the map during this state.

You may display additional things below the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn.


]],
      args = "camera: camera",
      returns = "",
      valuetype = ""
      },
    on_post_draw = {
      type = "method",
      description = [[

Called just after the entity is drawn on the map during this state.

You may display additional things above the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).

  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn.


]],
      args = "camera: camera",
      returns = "",
      valuetype = ""
      },
    on_suspended = {
      type = "method",
      description = [[

Called when the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) has just been suspended or resumed.

The entity is suspended by the engine in a few cases, like when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation.

  * `suspended` (boolean): `true` if the entity was just suspended, `false` if it was resumed.


]],
      args = "suspended: boolean",
      returns = "",
      valuetype = ""
      },
    on_map_started = {
      type = "method",
      description = [[

Called when a map starts (when the player enters it) during this state.

  * `map` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The new map.
  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrives on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).


]],
      args = "map: map, destination: destination",
      returns = "",
      valuetype = ""
      },
    on_map_finished = {
      type = "method",
      description = [[

Called when the map stops (when the player leaves it) during this state.
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_map_opening_transition_finished = {
      type = "method",
      description = [[

When a map begins during this state, called when the opening transition effect finishes.

  * `map` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The map.
  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrived on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).


]],
      args = "map: map, destination: destination",
      returns = "",
      valuetype = ""
      },
    on_position_changed = {
      type = "method",
      description = [[

Called when the coordinates of the entity controlled by this state have just changed.

  * `x` (number): The new X coordinate of the entity.
  * `y` (number): The new Y coordinate of the entity.
  * `layer` (number): The new layer of the entity.


]],
      args = "x: number, y: number, lay: numberer",
      returns = "",
      valuetype = ""
      },
    on_ground_below_changed = {
      type = "method",
      description = [[

Called when the kind of [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) on the map below the entity controlled by this state has changed. It may change because the entity is moving, or when because another entity changes it.

  * `ground_below` (string): The kind of ground at the [ground point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_ground_position) of the entity controlled by this state. `nil` means empty, that is, there is no ground at this point on the current layer.


]],
      args = "ground_below: string",
      returns = "",
      valuetype = ""
      },
    on_obstacle_reached = {
      type = "method",
      description = [[

Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of the entity was stopped because of an obstacle during this state.

When an obstacle is reached, this event is called instead of [state:on_position_changed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_position_changed).

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.


]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_movement_started = {
      type = "method",
      description = [[

Called when a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) is started on the entity controlled by this state.

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement that was just started on the entity.


]],
      args = "movement: movement",
      returns = "",
      valuetype = ""
      },
    on_movement_changed = {
      type = "method",
      description = [[

Called when some characteristics of the entity's [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) (like the speed or the angle) have just changed during this state.

  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.


]],
      args = "movement: movement",
      returns = "",
      valuetype = ""
      },
    on_movement_finished = {
      type = "method",
      description = [[

Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of the entity controlled by this state is finished (if there is an end).
]],
      args = "",
      returns = "",
      valuetype = ""
      },
    on_attacked_enemy = {
      type = "method",
      description = [[

Called when the entity has just attacked an enemy during this state, even if the attack was not successful.

  * `enemy` ([enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html)): The attacked enemy.
  * `enemy_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): Sprite of the enemy that received the attack, or `nil` if the attack does not come from a pixel-precise collision test.
  * `attack` (string): How the enemy was attacked. See [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for the possible values.
  * `consequence` (number, string or function): How the enemy reacted to the attack. See [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for the possible values.


]],
      args = "enemy: enemy, enemy: enemy_sprite: sprite, attack: string, consequence: number, string or function",
      returns = "",
      valuetype = ""
      },
    on_key_pressed = {
      type = "method",
      description = [[

Called when the user presses a keyboard key during this state.

  * `key` (string): Name of the raw key that was pressed.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed). If you want the corresponding higher-level game command (if any), see [state:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_command_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_key_released = {
      type = "method",
      description = [[

Called when the user releases a keyboard key during this state.

  * `key` (string): Name of the raw key that was released.
  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed). If you want the corresponding higher-level game command (if any), see [state:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_command_pressed).
]],
      args = "key: string, modifiers: table",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_character_pressed = {
      type = "method",
      description = [[

Called when the user enters text during this state.

  * `character` (string): A utf-8 string representing the character that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).



Remarks
    When a character key is pressed, two events are called: [state:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_key_pressed) (indicating the raw key) and [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed) (indicating the utf-8 character). If your script needs to input text from the user, [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
]],
      args = "character: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_pressed = {
      type = "method",
      description = [[

Called when the user presses a joypad button during this state.

  * `button` (number): Index of the button that was pressed.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_button_released = {
      type = "method",
      description = [[

Called when the user releases a joypad button during this state.

  * `button` (number): Index of the button that was released.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_axis_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad axis during this state.

  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "axis: number, state: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_joypad_hat_moved = {
      type = "method",
      description = [[

Called when the user moves a joypad hat during this state.

  * `hat` (number): Index of the hat that was moved.
  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "hat: number, direction8: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_pressed = {
      type = "method",
      description = [[

Called when the player presses a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior) during this state. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was pressed. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_command_released = {
      type = "method",
      description = [[

Called when the player released a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). during this state. You can use this event to override the normal built-in behavior of the game command.

  * `command` (string): Name of the built-in game command that was released. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).



Remarks
    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
]],
      args = "command: string",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_pressed = {
      type = "method",
      description = [[

Called when the user presses a mouse button during this state.

  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_mouse_released = {
      type = "method",
      description = [[

Called when the user releases a mouse button during this state.

  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "button: string, x: integer, y: integer",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_pressed = {
      type = "method",
      description = [[

Called when the user presses a finger during this state.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_released = {
      type = "method",
      description = [[

Called when the user releases a finger during this state.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.


]],
      args = "finger: integer, x: integer, y: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      },
    on_finger_moved = {
      type = "method",
      description = [[

Called when the user moves a finger during this state.

  * `finger` (integer): ID of the finger that was pressed.
  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dx` (integer): The horizontal distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `dy` (integer): The vertical distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. 


]],
      args = "finger: integer, x: integer, y: integer, dx: integer: integer, dy: integer: integer, pressure: number",
      returns = "boolean",
      valuetype = "boolean"
      }
    }
  }
}