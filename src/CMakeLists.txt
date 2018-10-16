cmake_minimum_required(VERSION 3.0)

# System Generic - no OS bare-metal application
set(CMAKE_SYSTEM_NAME Generic)

# Setup arm processor and bleeding edge toolchain
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(CMAKE_NM arm-none-eabi-nm)
set(CMAKE_STRIP arm-none-eabi-strip)
set(CMAKE_RANLIB arm-none-eabi-ranlib)

# When trying to link cross compiled test program, error occurs, so setting test compilation to static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Don't know if following setting works also for Ninja
set(CMAKE_VERBOSE_MAKEFILE ON)

# Allow assembler
enable_language(ASM)

project(template_stm32f4)

set(INCLUDE_DIRS
    code
    hw
    utils
    external/stm32
    external/cmsis
)

set(CPP_SRCS
	 
)

set(C_SRCS
    hw/core_init/core_init.c
	hw/gpio_f4/gpio_f4.c
	hw/startup/hardfault.c
    hw/startup/vectors.c
	main.c
)

set(ASM_SRCS
    hw/startup/startup.S
)

set(GLOBAL_DEFINES
    -DSTM32F40_41xxx
)

include_directories(${INCLUDE_DIRS})
add_definitions(${GLOBAL_DEFINES})

# Compiler flags used for C and ASM files
set(CORE_FLAGS "-mcpu=cortex-m4 -mthumb")

# Debug flag
set(CORE_FLAGS "${CORE_FLAGS} -g")

# Hardware float support
set(CORE_FLAGS "${CORE_FLAGS} -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffast-math")

# Compiler flags specific for C++ files
# -std - C++ standard: c++98, gnu++98, c++11, gnu++11, c++14, gnu++14
# -fno-rtti - disable virtual class information used by dynamic_cast and typeid
# -fno-exceptions - disable exception handling
# fverbose-asm - additional comments for generated assembler code
# -MMD - create dependency files
set(CXX_FLAGS "-std=gnu++14 -O0 -g -fno-rtti -fno-exceptions -fverbose-asm -MMD")

# Compiler flags specific for C files
# -std - C standard: c89, c99, gnu89,gnu99, iso9899:119409
# -O0 - optimization level: -O0, -O1, -O2, -O3, -Os
# fverbose-asm - additional comments for generated assembler code
# -MMD - create dependency files
set(C_FLAGS "-std=gnu89 -O0 -ffunction-sections -fdata-sections -fverbose-asm -MMD")

set(ASM_FLAGS "-x assembler-with-cpp")

# Warning flags for C++
# -Wall - standard warnings
# -Wextra - extended warnings
set(CXX_WARNINGS "-Wall -Wextra")

# Warning flags for C
# -Wall - standard warnings
# -Wextra - extended warnings
# -Wstrict-prototypes - additional warnings for function prototypes
set(C_WARNINGS "-Wall -Wextra -Wstrict-prototypes")

set(LD_SCRIPT ${CMAKE_SOURCE_DIR}/linker.ld)
# Linker flags
# -Wl, -Map - map file to be created
# -T - file with linker script
# -g - debug flag
# -Wl,--gc-sections - unused function removal
set(LD_FLAGS "-Wl,-Map=${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.map,--cref -T${LD_SCRIPT} -g -Wl,--gc-sections")

set(CMAKE_CXX_FLAGS "${CORE_FLAGS} ${CXX_FLAGS} ${CXX_WARNINGS}")
set(CMAKE_C_FLAGS "${CORE_FLAGS} ${C_FLAGS} ${C_WARNINGS}")
set(CMAKE_ASM_FLAGS "${ASM_FLAGS} ${CORE_FLAGS} ${CXX_WARNINGS}")
set(CMAKE_LD_FLAGS "${CORE_FLAGS} ${LD_FLAGS}")

# Remove default static libraries for win32
set(CMAKE_C_STANDARD_LIBRARIES "")
# Used for linker flags instead of libraries
link_libraries(${CMAKE_LD_FLAGS})

set(elf_file ${CMAKE_PROJECT_NAME}.elf)
set(map_file ${CMAKE_PROJECT_NAME}.map)
set(hex_file ${CMAKE_PROJECT_NAME}.hex)
set(bin_file ${CMAKE_PROJECT_NAME}.bin)
set(lss_file ${CMAKE_PROJECT_NAME}.lss)
set(dmp_file ${CMAKE_PROJECT_NAME}.dmp)

# create executable
add_executable(${elf_file} ${CPP_SRCS} ${C_SRCS} ${ASM_SRCS})

#generate hex file
add_custom_command(
	OUTPUT ${hex_file}

	COMMAND
		${CMAKE_OBJCOPY} -O ihex ${elf_file} ${hex_file}

	DEPENDS ${elf_file}
)

# #generate bin file
add_custom_command(
	OUTPUT ${bin_file}

	COMMAND
		${CMAKE_OBJCOPY} -O binary ${elf_file} ${bin_file}

	DEPENDS ${elf_file}
)

# #generate extended listing
add_custom_command(
	OUTPUT ${lss_file}

	COMMAND
		${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lss_file}

	DEPENDS ${elf_file}
)

# #generate memory dump
add_custom_command(
	OUTPUT ${dmp_file}

	COMMAND
		${CMAKE_OBJDUMP} -x --syms ${elf_file} > ${dmp_file}

	DEPENDS ${elf_file}
)

#postprocessing from elf file - generate hex bin etc.
add_custom_target(
	${CMAKE_PROJECT_NAME}
	ALL
	DEPENDS ${hex_file} ${bin_file} ${lss_file} ${dmp_file}
)

set_target_properties(
	${CMAKE_PROJECT_NAME}

	PROPERTIES
		OUTPUT_NAME ${elf_file}
)

# create custom toolchain setup
# static libraries and lib directories
# preserving preprocessor output, assembly listings etc

