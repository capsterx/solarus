# ZeroBrane solarus plugin

## ZeroBrane

[ZeroBrane](https://studio.zerobrane.com/) is a Lua code editor and debbugger
written in lua. It includes the mobdebug library which allow any lua script to
be remotely debugged, including Solarus quests.

## Plugin

The plugin consists of three files (may change in the future) to be placed in
the `packages` directory of your ZeroBrane installation see [Documentation](https://github.com/pkulchenko/ZeroBranePackage#installation)
for the exact path depending on your installation.

* `solarus.lua` is the main plugin and it registers the Solarus "interpreter" and
api into ZeroBrane

* `solarus_lua_api.lua` is the doc file generated py `scrap_doc.py`

* `solarus_pretty_printers.lua` is the file loaded by solarus when debugging, it
allow to explore solarus values in the stack dump as if they where tables.

**Note*** : On window the user package directory is usually in `C:\Users\<username>\.zbstudio\packages`,
you have to create thoses folders to paste the files in it.

## Engine external editor :

In Solarus Quest Editor, go to Tools->Options->Text Editor and enable External
Editor. As command put `<path_to_zbstudio> "%p/data/" "%f"`. On linux, (probably OSX too)
`<path_to_zbstudio>` can be as simple as `zbstudio`. Window users can either add
Zbstudio to their `PATH` or paste the full path of the executable.

## ZeroBrane solarus executable

To be able to launch your quest or debug from ZeroBrane. ZB has to find your `solarus-run` executable.
If it is in your `PATH` you are all set. Else you can tell ZB where solarus is by adding this line in
Edit->Preference->Settings:User

```lua
--user.lua

...
ide.solarus_path = [[<path to solarus-run>]] --without the < > of course
```
