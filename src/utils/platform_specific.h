/*
 * File:    platform_specific.h
 * Author:  GAndaLF
 * Brief:   Platform specific definitions.
 */

#ifndef _PLATFORM_SPECIFIC_H_
#define _PLATFORM_SPECIFIC_H_

/**
 * @defgroup utils_platform
 * @{
 */

/**
 * Keyword to declare function or variable as private.
 *
 * PRIVATE keyword is used for symbols that should be available externally only
 * for certain test or debug builds and should be static in production.
 */
#define PRIVATE              static

/** External crystal frequency */
#define HSE_FREQ              8000000ULL
/** Core clock frequency */
#define MCU_CLOCK_FREQ        168000000ULL
/** AHB bus frequency */
#define AHB_CLOCK_FREQ        MCU_CLOCK_FREQ
/** APB2 bus frequency */
#define APB2_CLOCK_FREQ       (MCU_CLOCK_FREQ / 2)
/** APB1 bus frequency */
#define APB1_CLOCK_FREQ       (MCU_CLOCK_FREQ / 4)

/**
 * @}
 */

#endif /* _PLATFORM_SPECIFIC_H_ */
