/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#ifndef MORSE_H_IS_INCLUDED
#define MORSE_H_IS_INCLUDED
#include <stdint.h>
    
#define DOT  1
#define DASH 3

typedef struct morse_code_ {
    char symbol;
    uint8_t code[7];
} MORSE_CODE;
    
extern const MORSE_CODE ITU_morse[];


#endif
/* [] END OF FILE */
