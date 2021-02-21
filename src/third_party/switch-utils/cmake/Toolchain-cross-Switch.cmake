
if(DEFINED ENV{DEVKITPRO})
	set(DEVKITPRO $ENV{DEVKITPRO})
else()
	message(FATAL_ERROR "Could not find DEVKITPRO in environment")
endif()

if(DEFINED ENV{SWITCH_UTILS})
	set(SWITCH_UTILS $ENV{SWITCH_UTILS})
else()
	message(FATAL_ERROR "Could not find SWITCH_UTILS in environment")
endif()

set(CMAKE_SYSTEM_NAME Generic CACHE INTERNAL "system name")

function(create_devkit DEVKIT)
	if(DEFINED ENV{DEVKIT${DEVKIT}})
	        set(DEVKIT${DEVKIT} $ENV{DEVKIT${DEVKIT}} PARENT_SCOPE)
	else()
	        set(DEVKIT${DEVKIT} ${DEVKITPRO}/devkit${DEVKIT} PARENT_SCOPE)
	endif()

	set(CMAKE_PROGRAM_PATH ${DEVKIT${DEVKIT}}/bin CACHE INTERNAL "program path")

	set(extension)
	if (CMAKE_HOST_WIN32)
		set(extension .exe)
	endif()

	find_program(CMAKE_AR ${cross_prefix}gcc-ar${extension})
	find_program(CMAKE_RANLIB ${cross_prefix}gcc-ranlib${extension})
	find_program(CMAKE_C_COMPILER ${cross_prefix}gcc${extension})
	find_program(CMAKE_CXX_COMPILER ${cross_prefix}g++${extension})
	find_program(CMAKE_ASM_COMPILER ${cross_prefix}gcc${extension})
	find_program(CMAKE_LINKER ${cross_prefix}ld${extension})
	set(CMAKE_C_FLAGS ${inc_flags} CACHE INTERNAL "c compiler flags")
	set(CMAKE_ASM_FLAGS ${inc_flags} CACHE INTERNAL "assembler flags")
	set(CMAKE_CXX_FLAGS ${inc_flags} CACHE INTERNAL "cxx compiler flags")

	set(CMAKE_EXE_LINKER_FLAGS ${link_flags} CACHE INTERNAL "exe link flags")
	set(CMAKE_MODULE_LINKER_FLAGS ${link_flags} CACHE INTERNAL "module link flags")
	set(CMAKE_SHARED_LINKER_FLAGS ${link_flags} CACHE INTERNAL "shared link flags")

	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE INTERNAL "")
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE INTERNAL "")
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE INTERNAL "")
	set(PKG_CONFIG_EXECUTABLE "/dev/null" CACHE INTERNAL "" FORCE)
endfunction()

if(DEFINED ENV{LIBNX})
	set(LIBNX $ENV{LIBNX})
else()
	set(LIBNX ${DEVKITPRO}/libnx)
endif()

option(ENABLE_GDB "Enable GDB debugging" OFF)

if (ENABLE_GDB)
	set (gdb_link "-Wl,--whole-archive -lgdbstub -Wl,--no-whole-archive -lfmt -lstdc++")
	add_definitions(-DGDB_ENABLED)
endif()

set(cross_prefix aarch64-none-elf-)
set(arch_flags "-mtune=cortex-a57 -ffunction-sections -march=armv8-a+crc+crypto -mtp=soft -fPIE -D_GNU_SOURCE")
set(inc_flags "-I${SWITCH_UTILS}/include -I${LIBNX}/include -I${DEVKITPRO}/portlibs/switch/include ${arch_flags}")
set(link_flags "${gdb_link} -L${LIBNX}/lib -L${SWITCH_UTILS}/build -L${DEVKITPRO}/portlibs/switch/lib -specs=${LIBNX}/switch.specs ${arch_flags}")

set(CMAKE_SYSTEM_PROCESSOR aarch64 CACHE INTERNAL "processor")
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-none-elf CACHE INTERNAL "abi")

set(SWITCH ON)
add_definitions(-D__SWITCH__)

create_devkit(A64)

set(CMAKE_FIND_ROOT_PATH ${DEVKITA64}/${CMAKE_LIBRARY_ARCHITECTURE} ${DEVKITPRO}/portlibs/switch)
