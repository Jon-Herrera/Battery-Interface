#include "batt.h"
#include <stdio.h>

int set_batt_from_ports(batt_t *batt){
    char battM;
    int x = BATT_VOLTAGE_PORT;
    int y = BATT_STATUS_PORT;
    //bounds check
    if (x < 0){
        return 1;
    }
    //calculating volts and percent
    int battV = x;
    battV = battV >> 1;
    int battP = x;
    battP = (battV - 3000) >> 3;
    if (battP <0) battP = 0;
    if (battP >100) battP = 100;
    if ((y >> 4) & 1){
        battM = 1;
    } else{
        battM = 2;
    }
    //setting fields
    batt->mlvolts = battV;
    batt->percent = battP;
    batt->mode = battM;
    return 0;
}
// Uses the two global variables (ports) BATT_VOLTAGE_PORT and
// BATT_STATUS_PORT to set the fields of the parameter 'batt'.  If
// BATT_VOLTAGE_PORT is negative, then battery has been wired wrong;
// no fields of 'batt' are changed and 1 is returned to indicate an
// error.  Otherwise, sets fields of batt based on reading the voltage
// value and converting to precent using the provided formula. Returns
// 0 on a successful execution with no errors. This function DOES NOT
// modify any global variables but may access global variables.
//
// CONSTRAINT: Avoids the use of the division operation as much as
// possible. Makes use of shift operations in place of division where
// possible.
//
// CONSTRAINT: Uses only integer operations. No floating point
// operations are used as the target machine does not have a FPU.
// 
// CONSTRAINT: Limit the complexity of code as much as possible. Do
// not use deeply nested conditional structures. Seek to make the code
// as short, and simple as possible. Code longer than 40 lines may be
// penalized for complexity.

int set_display_from_batt(batt_t batt, int *display){
    //bit mask array
    char bits[10] = {0b0111111, 0b0000110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111};
    int left = 0;
    int right = 0;
    int mid = 0;
    *display = 0;
    //percent mode branch
    if (batt.mode == 1){
        int perc = batt.percent;
        *display |= (1 << 0);//percent
        right = perc % 10; //finding digits
        mid = (perc/10) % 10;
        left = (perc/100) % 10;
        if (left != 0){ //setting bits in display based on digits
            *display |= (bits[left] << 17);
        }
        if (mid != 0 || left != 0){ //condition for if it's at 100%
            *display |= (bits[mid] << 10);
        }
        *display |= (bits[right] << 3); //always show right
    } else if (batt.mode == 2) { // volts mode
        int volt = batt.mlvolts;
        int round = 0; //calc for whether or not to round up
        if (volt % 10 > 5){
            round = 1;
        }
        *display |= (1 << 1);//volts
        *display |= (1 << 2);//decimal
        right = (volt/10) % 10 + round; //finding digits
        mid = (volt / 100) % 10;
        left = (volt / 1000) % 10;
        if (right == 10){ // subsequent rounding if initial round sets next digit to 10
            right = 0;
            mid += 1;
            if (mid == 10){
                mid = 0;
                left += 1;
            }
        }
        *display |= (bits[left] << 17); // always set every digit
        *display |= (bits[mid] << 10);
        *display |= (bits[right] << 3);
    }
    if (batt.percent > 5) *display |= (1 << (24)); //battery level setting
    if (batt.percent > 29) *display |= (1 << (25));
    if (batt.percent > 49) *display |= (1 << (26));
    if (batt.percent > 69) *display |= (1 << (27));
    if (batt.percent > 89) *display |= (1 << (28));
    return 0;
}

// Alters the bits of integer pointed to by 'display' to reflect the
// data in struct param 'batt'.  Does not assume any specific bit
// pattern stored at 'display' and completely resets all bits in it on
// successfully completing.  Selects either to show Percent (mode=1) or
// Volts (mode=2). If Volts are displayed, only displays 3 digits
// rounding the lowest digit up or down appropriate to the last digit.
// Calculates each digit to display changes bits at 'display' to show
// the volts/percent according to the pattern for each digit. Modifies
// additional bits to show a decimal place for volts and a 'V' or '%'
// indicator appropriate to the mode. In both modes, places bars in
// the level display as indicated by percentage cutoffs in provided
// diagrams. This function DOES NOT modify any global variables but
// may access global variables. Always returns 0.
// 
// CONSTRAINT: Limit the complexity of code as much as possible. Do
// not use deeply nested conditional structures. Seek to make the code
// as short, and simple as possible. Code longer than 65 lines may be
// penalized for complexity.

int batt_update(){
    batt_t batt;
    int display = 0; //blanking display to make sure i set everything/ nothing is inferred
    if (set_batt_from_ports(&batt) != 0){
        return 1;
    }
    if (set_display_from_batt(batt, &display)){
        return 1;
    }
    //setting display port
    BATT_DISPLAY_PORT = display;
    return 0;
}   
// Called to update the battery meter display.  Makes use of
// set_batt_from_ports() and set_display_from_batt() to access battery
// voltage sensor then set the display. Checks these functions and if
// they indicate an error, does NOT change the display and returns 1.
// If functions succeed, modifies BATT_DISPLAY_PORT to show current
// battery level and returns 0.
// 
// CONSTRAINT: Does not allocate any heap memory as malloc() is NOT
// available on the target microcontroller.  Uses stack and global
// memory only.