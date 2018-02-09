###############################################################################
#
# Script file for building unit tests on PC. This script is universal for every
# PC test. Each tests contains conf.mk file containing test specific defines.
#
###############################################################################

include ../../../makefiles/toolchain_pc.mk
include ../../../makefiles/platform.mk
include ../../../makefiles/funs.mk

###############################################################################
# Files and paths defines

C_EXT := c
CODE_SRC := $(call rwildcard,$(SRC_DIRS),*.$(C_EXT)) $(C_SRC_FILES)
TEST_SRC := $(call rwildcard,$(TEST_SRC_DIRS),*.$(C_EXT)) $(TEST_SRC_FILES)

CODE_SRC := $(filter-out $(C_SRC_EXCLUDE), $(CODE_SRC))
TEST_SRC := $(filter-out $(C_SRC_EXCLUDE), $(TEST_SRC))

CODE_OBJ := $(addprefix $(OUT_DIR)code/, $(sort $(notdir $(CODE_SRC:.$(C_EXT)=.o))))
TEST_OBJ := $(addprefix $(OUT_DIR)test/, $(sort $(notdir $(TEST_SRC:.$(C_EXT)=.o))))

OBJS := $(CODE_OBJ) $(TEST_OBJ)

DEPS := $(OBJS:.o=.d)

VPATH := $(sort $(dir $(TEST_SRC) $(CODE_SRC)) $(TEST_INC_DIRS))
#
###############################################################################

###############################################################################
# Compiler and linker defines

# Code under tests is compiled with extended warning flags
C_FLAGS_CODE := -Wall -Wextra -Wstrict-prototypes -MMD
# Test files are compiled with only standard flags set
C_FLAGS_TEST := -Wall -MMD

# Include paths
INC_FLAGS_CODE := $(patsubst %, -I%, $(INC_DIRS))
INC_FLAGS_TEST := -I. $(patsubst %, -I%, $(TEST_INC_DIRS))

# Global defines
GLOBAL_DEFS_F = $(patsubst %, -D%, $(GLOBAL_DEFS))

# Compiler flags
C_FLAGS_CODE += $(GLOBAL_DEFS_F) $(INC_FLAGS_CODE) -g
C_FLAGS_TEST += $(GLOBAL_DEFS_F) $(INC_FLAGS_CODE) $(INC_FLAGS_TEST) -g

# Linker flags
LD_FLAGS := -Wl,-Map=$(OUT_DIR)bin/$(TARGET_NAME).map -Wl,--gc-sections
LD_LIBS := -L$(LIB_DIRS) -l$(LIBS)

#
###############################################################################

###############################################################################
# Targets

all: init out_dir $(OUT_DIR)bin/$(TARGET_NAME) run

run:
	@rm -rf test_results.txt
	@echo 'Running tests for $(TARGET_NAME)' >> ../test_results.txt
	@echo '' >> ../test_results.txt
	@echo 'Date and time:' >> ../test_results.txt
	@date +'%y.%m.%d %H:%M:%S' >> ../test_results.txt
	@echo '' >> ../test_results.txt
	@$(OUT_DIR)bin/$(TARGET_NAME) >> ../test_results.txt
	@echo '' >> ../test_results.txt

# Creating resulting binary file
$(OUT_DIR)bin/$(TARGET_NAME) : $(TEST_OBJ) $(CODE_OBJ)
	@echo 'Linking target: $(OUT_DIR)bin/$(TARGET_NAME)'
	$(CC) $(LD_FLAGS) $(TEST_OBJ) $(CODE_OBJ) $(LD_LIBS) -o $@
	@echo ''

# Pattern for code under test compilation
$(OUT_DIR)code/%.o : %.$(C_EXT)
	@echo 'Compiling file: $<'
	$(CC) -c $(C_FLAGS_CODE) $< -o $@
	@echo ''

# Pattern for test files compilation
$(OUT_DIR)test/%.o : %.$(C_EXT)
	@echo 'Compiling file: $<'
	$(CC) -c $(C_FLAGS_TEST) $< -o $@
	@echo ''

# header dependencies
-include $(DEPS)

out_dir :
	@mkdir -p $(OUT_DIR)bin
	@mkdir -p $(OUT_DIR)code
	@mkdir -p $(OUT_DIR)test

init :
	@echo ''
	@echo 'Building $(TARGET_NAME) PC unit tests:'
	@echo 'SRC files under test:'
	@echo $(CODE_SRC)
	@echo 'Test file sources:'
	@echo $(TEST_SRC)
	@echo ''

clean:
	@rm -rf $(subst /,,$(OUT_DIR))