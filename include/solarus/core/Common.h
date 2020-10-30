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

/**
 * \file Common.h
 * \brief This header should be included by each class header file.
 */

#ifndef SOLARUS_COMMON_H
#define SOLARUS_COMMON_H

#ifdef ANDROID
#include "solarus/core/AndroidConfig.h"
#elif defined(__SWITCH__)
#include "solarus/core/SwitchConfig.h"
#else
#include "solarus/core/config.h"
#endif

/**
 * \cond doxygen_ignore
 */
#define SOLARUS_STRINGIFY1(x) #x
#define SOLARUS_STRINGIFY(x) SOLARUS_STRINGIFY1(x)
/**
 * \endcond
 */

/**
 * \brief The Solarus version as a string.
 *
 * This string has the form "x.y.z" where x is the major version, y is the
 * minor version and z is the patch version.
 */
#define SOLARUS_VERSION SOLARUS_STRINGIFY(SOLARUS_MAJOR_VERSION) "." SOLARUS_STRINGIFY(SOLARUS_MINOR_VERSION) "." SOLARUS_STRINGIFY(SOLARUS_PATCH_VERSION)

/**
 * \brief The Solarus version as a string, without patch number.
 *
 * This string has the form "x.y" where x is the major version and y is the
 * minor version.
 */
#define SOLARUS_VERSION_WITHOUT_PATCH SOLARUS_STRINGIFY(SOLARUS_MAJOR_VERSION) "." SOLARUS_STRINGIFY(SOLARUS_MINOR_VERSION)

// Windows specific.
/**
 * \def SOLARUS_API
 * \brief Windows DLL import/export specifications for the Solarus library symbols.
 */
#ifndef SOLARUS_LIBRARY_EXPORT
#  ifdef solarus_EXPORTS  // Define automatically added by cmake.
#    define SOLARUS_LIBRARY_EXPORT 1
#  else
#    define SOLARUS_LIBRARY_EXPORT 0
#  endif
#else
#    define SOLARUS_LIBRARY_EXPORT 0
#endif

#ifdef _WIN32
#  if SOLARUS_LIBRARY_EXPORT == 1
#    define SOLARUS_API __declspec(dllexport)
#  else
#    define SOLARUS_API __declspec(dllimport)
#  endif

#  ifdef _MSC_VER
// TODO MSVC: fix these warnings instead of disabling them
#    pragma warning( disable : 4251 4275 4458 4514 4710 4820 4244 4800)
// 4251 needs to have dll-interface to be used by clients of class
// 4275 non dll-interface class 'Foo::Bar' used as base for dll-interface class 'Foo::Baz'
// 4458 declaration of 'foo' hides class member
// 4514 unreferenced inline function has been removed
// 4710 function not inlined
// 4820 padding added after data member
// 4244 'argument': conversion from 'foo' to 'bar', possible loss of data
// 4800 'int': forcing value to bool 'true' or 'false' (performance warning)
#  endif

#else
#  define SOLARUS_API
#endif

// Define the current platform constants on Apple Systems.

/**
 * \cond doxygen_ignore
 * Define the current platform constants on Apple Systems.
 */
#if defined(__APPLE__)
#  include "TargetConditionals.h"
#  if TARGET_OS_IPHONE == 1
#    define SOLARUS_IOS
// TARGET_OS_MAC is set to 1 on both IPhone, IPhone simulator and Mac OS.
#  elif TARGET_OS_MAC == 1
#    define SOLARUS_OSX
#  endif
#endif
/**
 * \endcond
 */

/**
 * \def SOLARUS_DEFAULT_QUEST
 * \brief Path of the quest to run is none is specified at runtime.
 */
#ifndef SOLARUS_DEFAULT_QUEST
// if no default quest was specified at compilation time,
// use the current directory
#  define SOLARUS_DEFAULT_QUEST "."
#endif

/**
 * \def SOLARUS_WRITE_DIR
 * \brief Where savegames are stored, relative to the user base write directory.
 */
#ifndef SOLARUS_WRITE_DIR
#  if defined(SOLARUS_OSX) || defined(SOLARUS_IOS)
#    define SOLARUS_WRITE_DIR "Solarus"
#  else
#    define SOLARUS_WRITE_DIR ".solarus"
#  endif
#endif

// Game size.

/**
 * \def SOLARUS_DEFAULT_QUEST_WIDTH
 * \brief Width of the quest screen in pixels if not set at runtime.
 */
#ifndef SOLARUS_DEFAULT_QUEST_WIDTH
#  if defined(PANDORA)
#    define SOLARUS_DEFAULT_QUEST_WIDTH 400
#  else
#    define SOLARUS_DEFAULT_QUEST_WIDTH 320
#  endif
#endif

/**
 * \def SOLARUS_DEFAULT_QUEST_HEIGHT
 * \brief Height of the quest screen in pixels if not set at runtime.
 */
#ifndef SOLARUS_DEFAULT_QUEST_HEIGHT
#  define SOLARUS_DEFAULT_QUEST_HEIGHT 240
#endif

#endif

