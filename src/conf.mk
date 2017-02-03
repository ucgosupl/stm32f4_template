################################################################################
# File:     conf.mk
# Author:   GAndaLF
# Brief:    Makefile configuration script for main_program target.
#
# This file contains configuration variables for main_program target.
# After setting these variables, actual build script is called.
################################################################################

# Name for output files.
TARGET_NAME := main_program

# Directory containing compilation result.
OUT_DIR := out/

# Defines passed as compiler arguments
GLOBAL_DEFS := \
STM32F40_41xxx \

# Paths to header files (.h).
# In the code path relative to this path should be provided.
INC_DIRS := \
./code \
./hw \
./utils \
./external/stm32 \
./external/cmsis \

# Paths to source files (.c and .S).
# In these paths source files are searched recursively in the subfolders.
SRC_DIRS := \
./code \
./hw \
./utils \

# Additional source files to compile.
C_SRC_FILES := \
./main.c \

# Paths to the precompiled libraries (.a).
LIB_DIRS := \
../lib \

# Precompiled libraries used.
# Here we provide only the name of the library. File name also contains lib
# prefix and .a extension. For example for math library we provide here only
# the name "m", but actual file name is "libm.a".
LIBS := \

# Linker script provided as an argument during linking.
LD_SCRIPT := linker.ld

include build.mk