################################################################################
#
# Script for compiling Unity test framework on PC. As a result static library
# libunity.a is created.
#
################################################################################

include ../../../makefiles/toolchain_pc.mk
include ../../../makefiles/platform.mk

################################################################################
# File paths defines

C_EXT := c
C_SRC := $(wildcard $(addsuffix /*.$(C_EXT), $(SRC_DIRS)))
OBJS := $(addprefix $(OUT_DIR), $(patsubst %.c,%.o,$(notdir $(C_SRC))))

VPATH := $(sort $(INC_DIRS) $(SRC_DIRS))

#
################################################################################

################################################################################
# Compiler and linker defines

# Currently no special flags for Unity compilation
C_FLAGS :=
INC_FLAGS := $(patsubst %, -I%, $(INC_DIRS))
C_FLAGS += $(INC_FLAGS)

#
################################################################################

################################################################################
# Targets

all: out_dir $(OUT_DIR)lib/lib$(TARGET_NAME).a

$(OUT_DIR)lib/lib$(TARGET_NAME).a : $(OBJS)
	$(ECHO) 'Making static lib: $@'
	$(AR) -rcs $@ $^
	$(ECHO) ' '

$(OUT_DIR)%.o : %.$(C_EXT)
	$(ECHO) 'Compiling file: $<'
	$(CC) -c $(C_FLAGS) $< -o $@
	$(ECHO) ' '

out_dir :
	$(MKDIR) $(subst /,,$(OUT_DIR))
	$(MKDIR) $(OUT_DIR)lib

clean :
	$(RM) $(subst /,,$(OUT_DIR))
	$(RM) $(OUT_DIR)lib