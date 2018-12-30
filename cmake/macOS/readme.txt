This is Solarus, the open-source A-RPG game engine.

Solarus is licensed under GNU General Public License v3.

This macOS package contains:
- Solarus (Solarus.app): A GUI that allows you to run a Solarus quest and
  choose your audio and video settings.
- Solarus-run (Solarus-run.app): An application that directly runs
  a Solarus quest without the GUI, in a standalone way.
  Normally opened, it runs the quest (the data/ folder, data.solarus or
  data.solarus.zip) placed _inside_ the bundle, in
  Solarus-run.app/Contents/Resources/ .
  Through the command-line, run Solarus-run.app/Contents/Resources/solarus-run 
  with the path of your quest as argument (the directory containing data/
  or data.solarus or data.solarus.zip).
  Without this argument, the current directory is used as quest path.
  Try also 'solarus-run -help' to show information about the command-line
  options.
- A sample quest. This is a very minimalist example of game with only one map
  and almost nothing to do, but you can run it or edit it.
- Solarus Quest Editor (Solarus Quest Editor.app): An editor that helps you
  create maps and tilesets for your quest.
  See http://www.solarus-games.org/doc/latest/ to know how to create a quest.

See our website www.solarus-games.org for more information, to get help or to
download our games or the source code of the engine.

Enjoy!
