![Solarus logo](/images/solarus_logo.png)

**COMPILATION GUIDE**

[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/copyleft/gpl.html)

---

# About Solarus

Solarus is an open-source adventure 2D game engine written in C++.
It can run games scripted in Lua.
This engine is used by our Zelda fangames.
Solarus is licensed under GPL v3.

This document explains how to compile Solarus.

# Contents

* [Overview](#overview)
* [External dependencies](#external-dependencies)
  - [Linux users](#linux-users)
  - [Windows users](#windows-users)
  - [macOS users](#macos-users)
* [Compilation instructions](#compilation-instructions)
  - [Configuring](#configuring)
  - [Building](#building)
  - [Running the Solarus GUI](#running-the-solarus-gui)
  - [Running a quest directly](#running-a-quest-directly)
  - [Installation](#installation)
* [Platform-specific information](#platform-specific-information)
  - [Mac OS X](#mac-os-x)
  - [OpenPandora](#openpandora)
  - [GCW-Zero](#gcw-zero)

# Overview

Solarus can run quests scripted in Lua.

A quest is a game, represented as a directory called `data` or a zip archive
called `data.solarus` or `data.solarus.zip` and containing all the data
files of the quest (graphics, musics, sounds, scripts, dialogs, etc.).
A short sample quest is provided in the directory `sample_quest`.

Our quests can be found on the website: http://www.solarus-games.org

The project is separated in two parts: **Solarus** and the **Solarus GUI**.

Compiling the core part (Solarus) generates:

1. A dynamic library called `solarus`.
2. An executable file called `solarus-run` that directly runs a quest.

Compiling the GUI part (Solarus GUI) is *optional* and generates:

1. A dynamic library called `solarus-gui`.
2. An executable file called `solarus`, providing a GUI window to run quests.

It is possible to play Solarus games without the GUI part: the `solarus-run`
executable will directly run the quest in the current directory if any.
The GUI part adds a user-friendly interface with menus that allow users to
select quests and change some settings.

The GUI mode is probably the preferred way for desktop systems, while the
`solarus-run` mode may be better on mobile systems.
If you don't want the GUI part, it is possible to disable it at configuration
time, and then you don't require the Qt dependencies.

# External dependencies

The build process of Solarus uses [CMake](https://cmake.org/).
You also will need the [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/) helper tool installed.

To compile Solarus, you need a C++ compiler with support of C++11.
Solarus compiles fine with GCC 4.8.1 or greater and Clang 3.4 or greater, and
probably with other recent compilers (please let us know).

The following libraries are required to compile and execute Solarus:

- SDL2 (2.0.6 or greater)
- SDL2main
- SDL2_image
- SDL2_ttf
- OpenGL or OpenGL ES
- OpenAL
- Vorbisfile
- Ogg
- Modplug (0.8.8.4 or greater)
- Lua 5.1 or LuaJIT 2.0 (LuaJIT is recommended)
- Physfs
- Qt5 (only if you build the Solarus GUI too)

Note that another library is directly embedded in the source code: `snes_spc`,
an SPC (Nintendo SNES) music decoding library.

**About SDL2**

SDL 2.0.2 is buggy (you will get broken graphics or even a black screen).
You need at least SDL 2.0.6.

**About Qt5**

You only need Qt if you want to build the Solarus GUI.
If you want to disable the build of the Solarus GUI, set the CMake variable
`SOLARUS_GUI` to `OFF` at the configuration step and then you don't need Qt.

**About Lua**

Solarus uses the Lua scripting language.
LuaJIT, a *just-in-time* implementation of Lua, is used by default for optimal
performance.
However, if you want to use vanilla Lua rather than LuaJIT, set the CMake
variable `SOLARUS_USE_LUAJIT` to `OFF` at the configuration step.

**About ModPlug**

We maintain a fork of libmodplug 0.8.8.4 here:
https://gitlab.com/solarus-games/libmodplug
Previous versions of libmodplug cause compilation problems as well as issues
like `.it` files that do not correctly loop.

**About OpenGL ES**

If you wish to enable the OpenGL ES implementation, set the CMake
variable `SOLARUS_GL_ES` to `ON` at the configuration step.

## Linux users

Just install the corresponding packages.
For example, in Ubuntu or Debian:

    build-essential cmake pkg-config
    libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libluajit-5.1-dev
    libphysfs-dev libopenal-dev libvorbis-dev libmodplug-dev
    qtbase5-dev qttools5-dev qttools5-dev-tools libglm-dev

## Windows users

Install a C++ compiler, Git and CMake.
Solarus compiles fine with the [MinGW compiler](http://www.mingw.org/) and
probably with other compilers too.

We recommend [QtCreator](https://www.qt.io/developers/), which includes the Qt
libraries, MinGW, as well as Git and CMake integration.

The directory `libraries/win32/mingw32` in the Solarus repository contains
headers and compiled binaries of all required libraries that Solarus needs
besides Qt, all of which working at least with the MinGW32 compiler.

If you want other versions of these dependencies of if you don't use the
MinGW32 toolchain, you can download the header files and the binaries of all
libraries listed above, on their official websites.
For some of them you have to compile the binary libraries yourself.

In any case, you will then need to tell CMake the location of these
dependencies.

## macOS users

The directory `libraries/macOS` in the Solarus repository contains some
required static and dynamic libraries that are not provided as binaries by
their authors, but we don't guarantee that they are up-to-date.
The Lua documentation recommends to link statically against Lua, so you
shouldn't embed it.
Also, the OpenAL framework is already part of the macOS system since 10.4,
so you don't have to embed this library either.
You can use both `.dylib` or `.framework` for the other libraries, but just
remember that you have to check the version number, runpath search,
architecture and backward compatibility if you want to deploy your application.

# Compilation instructions

The following are the instructions for configuring and building Solarus.

## Configuring

Use CMake to generate the Makefiles or a project for your favorite IDE from
the CMake GUI or from the command-line.

**Using the CMake GUI**

Run the CMake GUI.
Select the source directory of Solarus (for example `C:\solarus`) and choose a
build directory of your choice (for example `C:\solarus\build`).

Click *Configure* and choose what kind of project you want CMake to generate
Makefiles, a Code::Blocks project, a Visual Studio project, etc.

If CMake does not automatically find a compiler, indicate its installation path
by creating a variable `CMAKE_PREFIX_PATH` with the appropriate value
(for example `C:\MinGW`).
This prefix path should be a directory that contains include, lib and bin
directories with all the required dependencies in them.
After that, click *Configure* again. CMake should be now able to find all
includes and libraries.
If it does not, check that you have correctly installed them.

Then click *Generate* to generate the project files.

**Using the CMake command-line**

Go to the solarus directory and type the following:

    $ mkdir build
    $ cd build
    $ cmake ..

This generates appropriate Makefiles for your system in the `build` directory.
If you prefer, you can also generate other kinds of projects with the
appropriate `-G` option (see the documentation of CMake for more information).

## Building

After configuring the build, you can now compile the Solarus project using the
files generated by CMake.

**Using a GUI**

If you chose to generate a project for an IDE (like Code::Blocks or
Qt Creator), open the generated project an compile it from your IDE.

**Using the command-line**

If you chose to generate Makefiles, you can compile from the command-line:

    $ make

Any build error messages will tell you which headers and libraries are missing
(it is hard to get them right in one try!).

Once the compilation is finished, you will obtain a dynamic library named
`solarus` and an executable named `solarus-run`.
If you built the Solarus GUI too, you will also have a `gui` directory that
contains a dynamic library named `solarus-gui` and an executable
named `solarus`.

## Running the Solarus GUI

To open the Solarus user-friendly GUI, run the `solarus` executable located
in the `gui` directory.
You can then choose the quest to run and change its settings.

## Running a quest directly

To directly execute a quest without a GUI, run the `solarus-run` executable.
The quest path must be specified on the command line.
If you don't specify it, it will be the current directory by default.

The quest path is a directory containing the `data` subdirectory of your quest,
or containing the `data.solarus` or `data.solarus.zip` archive of your quest,
or an archive containing your quest files (content of the `data` directory).

This means that if you run `solarus-run` without parameters, then a quest must
exist in the current directory.

**Using a GUI**

Make a shortcut that runs the `solarus-run` executable with your quest path as
parameter, or place the quest in the same directory as the `solarus-run`
executable and run it wihout any parameters.

**Using the command-line**

Type from your build directory:

    $ ./solarus-run path/to/your/quest

## Installation

Installing Solarus is *optional*.

However, installing Solarus can be useful in some cases.
If you want it in your `PATH` (on Unix), or if you want to remove the build
directory, or if you want to use the Solarus libraries in another project.

**Using a GUI**

Copy the `solarus` library, the `solarus-run` executable, the `solarus-gui`
library and the `solarus` executable where you want them to be installed.

If you intend to use the Solarus libraries from another project, you need to
copy the whole include/solarus directory somewhere as well, and
`gui/include/solarus` for the Solarus GUI library.

*Important:* also copy the `build/include/solarus/config.h` file and place it
with the other installed headers, next to `config.h.in`.
The `config.h` file is a header generated at the configuration step, this is
why it is in the build directory and not with the rest of source files.

**Using the command-line**

If you generated Makefiles with CMake, an appropriate install rule is
available:

    $ make install

This will install all compiled Solarus libraries, executables and headers
(including the generated header `config.h`).
The default installation directory probably requires administrative privileges.

To change the installation directory, change the CMake variable
`CMAKE_INSTALL_PREFIX` at the configuration step.
The executables, the libraries and the headers will be installed in
standard subdirectories of this install prefix, i.e. `bin`, `lib` and `include`.

If you need finer-grained customization, the name of these three subdirectories
can also be changed in CMake.
For this, set the variables `SOLARUS_EXECUTABLE_INSTALL_DESTINATION`,
`SOLARUS_LIBRARY_INSTALL_DESTINATION` and `SOLARUS_HEADERS_INSTALL_DESTINATION`.

# Platform-specific information

## Mac OS X

**Pre-requisites**

To install the needed packages via the brew package manager, type:

    brew install cmake ninja \
        sdl2 sdl2_image sdl2_ttf luajit libvorbis libmodplug physfs

You will also need a copy of the OS X SDK, which is included with XCode.
XCode is freely available on the App Store.

**Compile on macOS**

You can follow the standard compilation instructions to build Solarus on macOS.
However here are some tips that may be useful depending on your developer
environment.

You can build the XCode project using CMake:

    $ cmake -G Xcode ..

If you wish to build the solarus GUI, the CMake invocation will probably become
something like this:

    $ cmake \
        -DCMAKE_PREFIX_PATH="<path_to_Qt>/Qt/<version>/clang_64/lib/cmake" \
        -Wno-dev  ..

**Deploy on macOS**

If you wish to deploy a quest on non-developer environment with a standalone
bundle, the better way is to use the Solarus package provided on
http://www.solarus-games.org/ and use a post-build script to replace the
`Solarus-run.app/Contents/Resources/solarus-run` and
`Solarus-run.app/Contents/Frameworks/libsolarus.dylib` files by the ones
just compiled.
The bundle is made to run the `data/` or `data.solarus` quest located in the
`Solarus-run.app/Contents/Resources` directory.

Once done, you eventually have to make sure that all new embedded binaries
are undependant from your developer environment.
Open a new command-line window and run the following on all of them:

    $ otool -L <binary_to_check>

Verify that all dependencies path related to an embedded binary are correct
and begin with the `@rpath/` string.
If not, run:

    $ install_name_tool -id <binary_path>

to update the first line returned by `otool -L` or:

    $ install_name_tool -change <old_path> <new_path>

to update one of the other.

*Note:* If you wish to deploy the Solarus GUI instead of a standalone quest,
steps are the same except that you will use the `Solarus.app` package instead
of the `Solarus-run.app` one, and will copy `libsolarus-gui.dylib` and
`solarus-launcher` binaries instead of the `solarus-run` one and the quest.

## OpenPandora

First, you need a working OpenPandora cross-compiling environment.
See the OpenPandora website: http://www.openpandora.org

To compile Solarus, we provide a CMake toolchain file:
`cmake/pandora/PandoraToolchain.cmake`.
The role of this toolchain file is essentially to indicate the compiler to
use to CMake.
You may want to modify some paths in this toolchain file to better fit your
configuration.
Then, compile Solarus normally with CMake, indicating the toolchain file like
this:

    $ mkdir pandora-build
    $ cd pandora-build
    $ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/pandora/PandoraToolchain.cmake ..
    $ make

## GCW-Zero

First, you need a working GCW-Zero toolchain.
See the website in http://www.gcw-zero.com/develop to see how to set it up.

To compile Solarus, we provide a CMake toolchain file:
`cmake/gcw-zero/gcw-zero.cmake`.
The role of this toolchain file is essentially to indicate the compiler to
use to CMake.
You may want to modify some paths in this toolchain file to better fit your
configuration.
Then, compile Solarus normally with CMake, indicating the toolchain file like
this:

    $ mkdir gcw-zero-build
    $ cd gcw-zero-build
    $ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/gcw-zero/.cmake ..
    $ make
