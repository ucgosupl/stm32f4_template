/*
 * File:    platform_specific.h
 * Author:  GAndaLF
 * Brief:   Symbol overrides used for PC tests.
 */

#ifndef _PLATFORM_SPECIFIC_H_
#define _PLATFORM_SPECIFIC_H_

/**
 * Keyword to declare function or variable as private.
 *
 * PRIVATE keyword is used for symbols that should be available externally only
 * for certain test or debug builds and should be static in production.
 */
#define PRIVATE              static

#endif /* _PLATFORM_SPECIFIC_H_ */
