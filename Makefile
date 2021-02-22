#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/libnx/switch_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# DATA is a list of directories containing data files
# INCLUDES is a list of directories containing header files
# EXEFS_SRC is the optional input directory containing data copied into exefs, if anything this normally should only contain "main.npdm".
#
# NO_ICON: if set to anything, do not use icon.
# NO_NACP: if set to anything, no .nacp file is generated.
# APP_TITLE is the name of the app stored in the .nacp file (Optional)
# APP_AUTHOR is the author of the app stored in the .nacp file (Optional)
# APP_VERSION is the version of the app stored in the .nacp file (Optional)
# APP_TITLEID is the titleID of the app stored in the .nacp file (Optional)
# ICON is the filename of the icon (.jpg), relative to the project folder.
#   If not set, it attempts to use one of the following (in this order):
#     - <Project name>.jpg
#     - icon.jpg
#     - <libnx folder>/default_icon.jpg
#---------------------------------------------------------------------------------
TARGET		:=	solarus
BUILD		:=	build
SOURCES		:=	src src/entities src/audio src/hero src/movements src/graphics src/graphics/sdlrenderer \
                        	src/graphics/glrenderer src/third_party src/third_party/hqx \
				src/third_party/mojoAL src/third_party/snes_spc src/lua src/main src/core
DATA		:=	data
INCLUDES	:=	include include/solarus include/solarus/core include/solarus/hero include/solarus/entities \
				include/solarus/lowlevel include/solarus/lua include/solarus/movements \
				include/solarus/containers include/solarus/third_party/snes_spc \
				include/solarus/third_party/mojoAL/AL  \
				include/solarus/third_party
EXEFS_SRC	:=	exefs_src

APP_TITLE	:=	Solarus Engine
APP_AUTHOR	:=	Solarus Team & capsterx
APP_VERSION	:=	1.6.4.
#ROMFS	:=	romfs
ICON		:=	solarus.jpg
#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH	:=	-march=armv8-a -mtune=cortex-a57 -mtp=soft -fPIE #-ftls-model=local-exec

CFLAGS	:=	-g -Wall -O2 -ffunction-sections \
			$(ARCH) $(DEFINES)

CFLAGS	+=	$(INCLUDE) -D__SWITCH__ -DCOCO_DISABLE

CXXFLAGS	:= $(CFLAGS) -frtti -fexceptions -std=c++11

ASFLAGS	:=	-g $(ARCH)
LDFLAGS	=	-specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map) 

LIBS	:=	-lSDL2_ttf -lglapi -lfreetype -lbz2 -lSDL2_image -lpng -lz -ljpeg -lSDL2 \
			-lphysfs -lmodplug -lvorbisfile -lvorbis -logg \
			-lwebp -lEGL -lglapi -ldrm_nouveau  -lnx 
ifneq ($(strip $(LUAJIT)),)
INCLUDES += src/third_party/luajit/src
LDFLAGS += -L$(TOPDIR)/src/third_party/luajit/src
LIBS += -lluajit -lnx
SOLARUS_LUA_JIT:=luajit_make
else
SOURCES += src/third_party/lua
INCLUDES += include/solarus/third_party/lua
endif


#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:= $(PORTLIBS) $(LIBNX)

ifneq ($(strip $(SWITCH_GUI)),)
SOURCES	+= src/switch src/third_party/switch-utils/src
INCLUDES += include/solarus/switch  src/third_party/switch-utils/include
CFLAGS += -DSOLARUS_SWITCH_GUI
ROMFS:=$(TOPDIR)/resources
BOREALIS_RESOURCES:=romfs:/
BOREALIS_PATH:=borealis
CXXFLAGS += -DSOLARUS_SWITCH_GUI -std=c++17 -DBOREALIS_RESOURCES="\"$(BOREALIS_RESOURCES)\""
include $(TOPDIR)/$(BOREALIS_PATH)/library/borealis.mk
#SOLARUS_SWITCH_GUI=switch_gui
#LIBDIRS	+= $(CURDIR)/Plutonium/Plutonium/Output
#TMP_LIB=$(LIBS)
#LIBS := -lpu -lSDL2_gfx -lSDL2_mixer -lopusfile -lopus -lmpg123 $(LIBS)
else
ifeq ($(strip $(EMBEDED_TARGET)),)
$(error no EMBEDED_TARGET set and SWITCH_GUI is not set)
endif
ifeq ($(strip $(EMBEDED_TITLE)),)
$(error no EMBEDED_TITLE set and SWITCH_GUI is not set)
endif
ifeq ($(strip $(EMBEDED_VERSION)),)
$(error no EMBEDED_VERSION set and SWITCH_GUI is not set)
endif
ifeq ($(strip $(EMBEDED_TITLE)),)
$(error no EMBEDED_TITLE set and SWITCH_GUI is not set)
endif
ifeq ($(strip $(EMBEDED_ICON)),)
$(error no EMBEDED_ICON set and SWITCH_GUI is not set)
endif
ifeq ($(strip $(EMBEDED_AUTHOR)),)
EMBEDED_AUTHOR="Solarus Team"
endif
ifeq ($(strip $(ROMFS)),)
$(error no ROMFS set and SWITCH_GUI is not set)
endif
SOLARUS_LAUNCHER=launcher
endif


#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
	export LD	:=	$(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
	export LD	:=	$(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES	:=	$(addsuffix .o,$(BINFILES)) \
			$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
			$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
			-I$(PORTLIBS)/include/SDL2 \
			-I$(PORTLIBS)/include/libmodplug \
			-I$(CURDIR)/$(BUILD)

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

export BUILD_EXEFS_SRC := $(TOPDIR)/$(EXEFS_SRC)

ifeq ($(strip $(ICON)),)
	icons := $(wildcard *.jpg)
	ifneq (,$(findstring $(TARGET).jpg,$(icons)))
		export APP_ICON := $(TOPDIR)/$(TARGET).jpg
	else
		ifneq (,$(findstring icon.jpg,$(icons)))
			export APP_ICON := $(TOPDIR)/icon.jpg
		endif
	endif
else
	export APP_ICON := $(TOPDIR)/$(ICON)
endif

ifeq ($(strip $(NO_ICON)),)
	export NROFLAGS += --icon=$(APP_ICON)
endif

ifeq ($(strip $(NO_NACP)),)
	export NROFLAGS += --nacp=$(CURDIR)/$(TARGET).nacp
endif

ifneq ($(APP_TITLEID),)
	export NACPFLAGS += --titleid=$(APP_TITLEID)
endif

ifneq ($(ROMFS),)
	export NROFLAGS += --romfsdir=$(ROMFS)
endif

.PHONY: $(BUILD) clean all

#---------------------------------------------------------------------------------
all: $(BUILD) 

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).pfs0 $(TARGET).nso $(TARGET).nro $(TARGET).nacp $(TARGET).elf \
		$(EMBEDED_TARGET).nro $(EMBEDED_TARGET).nacp

switch_gui:
	@$(MAKE) -C Plutonium




#---------------------------------------------------------------------------------
else
.PHONY:	all  switch_gui 

DEPENDS	:=	$(OFILES:.o=.d) $(SOLARUS_SWITCH_GUI) 

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
all	:	$(OUTPUT).pfs0 $(OUTPUT).nro $(SOLARUS_LAUNCHER) 

$(OUTPUT).pfs0	:	$(OUTPUT).nso

$(OUTPUT).nso	:	$(OUTPUT).elf

ifeq ($(strip $(NO_NACP)),)
$(OUTPUT).nro	:	$(OUTPUT).elf $(OUTPUT).nacp
else
$(OUTPUT).nro	:	$(OUTPUT).elf
endif

$(OUTPUT).elf	:	$(OFILES) $(SOLARUS_LUA_JIT) 

# make compiling silent
%.o: %.cpp
	@echo $(notdir $<)
	$(CXX) -MMD -MP -MF $(DEPSDIR)/$*.d $(CXXFLAGS) -c $< -o $@ $(ERROR_FILTER)

%.o: %.c
	@echo $(notdir $<)
	@$(CC) -MMD -MP -MF $(DEPSDIR)/$*.d $(CFLAGS) -c $< -o $@ $(ERROR_FILTER)

# make linking verbose
#%.elf:
#	@echo linking $(notdir $@)
#	$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@
#	$(NM) -CSn $@ > $(notdir $*.lst)

luajit_make:
	@$(MAKE) -C $(TOPDIR)/src/third_party/luajit TARGET_SYS=Switch

launcher: $(OUTPUT).elf
	nacptool --create $(EMBEDED_TITLE) $(EMBEDED_AUTHOR) $(EMBEDED_VERSION) $(TOPDIR)/$(EMBEDED_TARGET).nacp
	echo built ... $(EMBEDED_TARGET).nacp
	elf2nro  $(OUTPUT).elf $(TOPDIR)/$(EMBEDED_TARGET).nro --icon=$(EMBEDED_ICON) $(NROFLAGS) --nacp=$(TOPDIR)/$(EMBEDED_TARGET).nacp
	echo built ... $(EMBEDED_TARGET).nro

switch_gui:
	$(MAKE) -C ../Plutonium


#---------------------------------------------------------------------------------
# you need a rule like this for each extension you use as binary data
#---------------------------------------------------------------------------------
%.bin.o	:	%.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)

#---------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------
