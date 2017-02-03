################################################################################
# File:     build.mk
# Author:   GAndaLF
# Brief:    Build script for STM32F4.
################################################################################

include ../makefiles/toolchain_arm.mk
include ../makefiles/platform.mk
include ../makefiles/funs.mk

################################################################################
# Files and paths definitions

# extensions of source C and ASM files
C_EXT := c
ASM_EXT := S

# searching for source C and ASM files in directories provided
C_SRCS := $(call rwildcard,$(SRC_DIRS),*.$(C_EXT))
ASM_SRCS := $(call rwildcard,$(SRC_DIRS),*.$(ASM_EXT))

# adding single files
C_SRCS += $(C_SRC_FILES)

# variable storing all possible paths where dependencies could be found
VPATH := $(sort $(dir $(C_SRCS) $(ASM_SRCS)) $(INC_DIRS))

#
################################################################################

################################################################################
# Compiler and linker defines

# Compiler flags used for C and ASM files
CORE_FLAGS := -mcpu=cortex-m4 -mthumb

# Debug flag
CORE_FLAGS += -g

# Hardware float support
CORE_FLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffast-math

# Compiler flags specific for C files
# -std - C standard: c89, c99, gnu89,gnu99, iso9899:119409
# -O0 - optimization level: -O0, -O1, -O2, -O3, -Os
C_FLAGS := -std=gnu89 -O0 -ffunction-sections -fdata-sections

# Warning flags for C
# -Wall - standard warnings
# -Wextra - extended warnings
# -Wstrict-prototypes - additional warnings for function prototypes
C_WARNINGS := -Wall -Wextra -Wstrict-prototypes

# Linker flags
# -Wl, -Map - map file to be created
# -T - file with linker script
# -g - debug flag
# -Wl,--gc-sections - unused function removal
LD_FLAGS := -Wl,-Map=$(OUT_DIR)bin/$(TARGET_NAME).map,--cref -T$(LD_SCRIPT) -g -Wl,--gc-sections

# Add global defines
GLOBAL_DEFS_F = $(patsubst %, -D%, $(GLOBAL_DEFS))
CORE_FLAGS += $(GLOBAL_DEFS_F)

# Add header paths
INC_DIRS_F = -I. $(patsubst %, -I%, $(INC_DIRS))

# Add static lib dirs
LIB_DIRS_F = $(patsubst %, -L%, $(LIB_DIRS))

# Add static libs
LIBS_F = $(patsubst %, -l%, $(LIBS))

# final flags for C, ASM and linker
C_FLAGS += $(CORE_FLAGS) $(C_WARNINGS) $(INC_DIRS_F)
ASM_FLAGS := $(CORE_FLAGS) $(INC_DIRS_F)
LD_FLAGS += $(CORE_FLAGS) 
LD_LIBS = $(LIB_DIRS_F) $(LIBS_F)

#
################################################################################

################################################################################
# Defines for output files

ELF := $(OUT_DIR)bin/$(TARGET_NAME).elf
HEX := $(OUT_DIR)bin/$(TARGET_NAME).hex
BIN := $(OUT_DIR)bin/$(TARGET_NAME).bin
LSS := $(OUT_DIR)bin/$(TARGET_NAME).lss
DMP := $(OUT_DIR)bin/$(TARGET_NAME).dmp

C_OBJS := $(addprefix $(OUT_DIR), $(notdir $(C_SRCS:.$(C_EXT)=.o)))
ASM_OBJS := $(addprefix $(OUT_DIR), $(notdir $(ASM_SRCS:.$(ASM_EXT)=.o)))
OBJS := $(ASM_OBJS) $(C_OBJS)

GENERATED := $(OBJS) $(ELF) $(HEX) $(BIN) $(LSS) $(DMP)

#
################################################################################

################################################################################
# Target list

all : make_out_dir $(ELF) $(LSS) $(DMP) $(HEX) $(BIN) print_size

# Binaries generation
$(HEX) : $(ELF)
	$(ECHO) 'Creating HEX image: $(HEX)'
	$(OBJCOPY) -O ihex $< $@
	$(ECHO) ' '

$(BIN) : $(ELF)
	$(ECHO) 'Creating binary image: $(BIN)'
	$(OBJCOPY) -O binary $< $@
	$(ECHO) ' '

# Memory dump
$(DMP) : $(ELF)
	$(ECHO) 'Creating memory dump: $(DMP)'
	$(OBJDUMP) -x --syms $< > $@
	$(ECHO) ' '

# Extended listing
$(LSS) : $(ELF)
	$(ECHO) 'Creating extended listing: $(LSS)'
	$(OBJDUMP) -S $< > $@
	$(ECHO) ' '

# Linking
$(ELF) : $(OBJS)
	$(ECHO) 'Linking target: $(ELF)'
	$(CC) $(LD_FLAGS) $(OBJS) $(LD_LIBS) -o $@
	$(ECHO) ' '

# C files compilation
$(OUT_DIR)%.o : %.$(C_EXT)
	$(ECHO) 'Compiling file: $<'
	$(CC) -c $(C_FLAGS) $< -o $@
	$(ECHO) ' '

# ASM files compilation
$(OUT_DIR)%.o : %.$(ASM_EXT)
	$(ECHO) 'Assembling file: $<'
	$(AS) -c $(ASM_FLAGS) $< -o $@
	$(ECHO) ' '

make_out_dir :
	$(ECHO) $(OBJS)
	$(MKDIR) $(subst /,,$(OUT_DIR))
	$(MKDIR) $(OUT_DIR)bin
	
print_size :
	$(ECHO) 'Size of modules:'
	$(SIZE) -B -t --common $(OBJS) $(USER_OBJS)
	$(ECHO) ' '
	$(ECHO) 'Size of target .elf file:'
	$(SIZE) -B $(ELF)
	$(ECHO) ' '

clean:
	$(RM) $(subst /,,$(OUT_DIR))

# PHONY targets don't create output files with the same name as target
.PHONY: all clean print_size make_out_dir

#
################################################################################