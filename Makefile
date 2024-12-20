#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITPPC)),)
$(error "Please set DEVKITPPC in your environment. export DEVKITPPC=<path to>devkitPPC")
endif

include $(DEVKITPPC)/wii_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
#---------------------------------------------------------------------------------
TARGET		:=	$(notdir $(CURDIR))
BUILD		:=	build
SOURCES		:=	source
DATA		:=	data  
INCLUDES	:=

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------

CFLAGS	= -g -O2 -Wall $(MACHDEP) $(INCLUDE)
CXXFLAGS	=	$(CFLAGS)

LDFLAGS	=	-g $(MACHDEP) -Wl,-Map,$(notdir $@).map

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS	:=	-lwiiuse -lbte -lvorbisidec -logg -lasnd -logc -lm

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:= $(PORTLIBS)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT	:=	$(CURDIR)/$(TARGET)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
					$(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))
SAMPLEFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.sample)))
EXCLUDEFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*exclude)))
HEADFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*HEAD*)))
PACKFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.pack*)))
IDXFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.idx*)))
MAINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*main*)))
OGGFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.ogg*)))
DATSFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.dats*)))
PLAYFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.play*)))
YYFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.yy*)))
HFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.h*)))
PNGFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.png*)))
LISTFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.list*)))
GMLFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.gml*)))
MP3FILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.mp3*)))
WAVFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.wav*)))
TXTFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.txt*)))
MDFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.md*)))
SOUNDFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.sound*)))
JSONFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.json*)))
SF2FILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.sf2*)))
BATFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.bat*)))
EXEFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.exe*)))
RESSOURCES_ORDERFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.ressources_order*)))
REFFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*ref*)))
YYPFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.yyp*)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
	export LD	:=	$(CC)
else
	export LD	:=	$(CXX)
endif

export OFILES_BIN	:=	$(addsuffix .o,$(BINFILES))
export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(sFILES:.s=.o) $(SFILES:.S=.o)
export OFILES := $(OFILES_BIN) $(OFILES_SOURCES)

export HFILES := $(addsuffix .h,$(subst .,_,$(BINFILES)))

#---------------------------------------------------------------------------------
# build a list of include paths
#---------------------------------------------------------------------------------
export INCLUDE	:=	$(foreach dir,$(INCLUDES), -iquote $(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
					-I$(CURDIR)/$(BUILD) \
					-I$(LIBOGC_INC)

#---------------------------------------------------------------------------------
# build a list of library paths
#---------------------------------------------------------------------------------
export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib) \
					-L$(LIBOGC_LIB)

export OUTPUT	:=	$(CURDIR)/$(TARGET)
.PHONY: $(BUILD) clean

ifeq (,$(wildcard $(DEVKITPRO)/portlibs/ppc/include/tremor/ivorbiscodec.h))

$(BUILD):
	@echo
	@echo "*------------------------------------------------------------------------------------------*"
	@echo
	@echo "Please install libvorbisidec using (dkp-)pacman -S ppc-libvorbisidec"
	@echo
	@echo "See https://devkitpro.org/viewtopic.php?f=13&t=8702 for details"
	@echo
	@echo "*------------------------------------------------------------------------------------------*"
	@echo
else

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

endif


#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(OUTPUT).elf $(OUTPUT).dol

#---------------------------------------------------------------------------------
run:
	wiiload $(TARGET).dol


#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).dol: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

$(OFILES_SOURCES) : $(HFILES)

#---------------------------------------------------------------------------------
# This rule links in binary data with the .ogg extension
#---------------------------------------------------------------------------------
%.ogg.o	%_ogg.h :	%.ogg
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	$(bin2o)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
