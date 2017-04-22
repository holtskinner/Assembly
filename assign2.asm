**************************************
*
* Name: Holt Skinner
* Date: 2-20-2017
* Lab2
*
* Program description: Program that divides two Unsigned numbers
*
* C Code:
*   // Data Section
*   unsigned int dividend = 104; // Arbitrary
*   unsigned int divisor = 6;
*   unsigned int quotient;
*   unsigned int remainder;
*   
*   // Program Section
*   quotient = 0;
*   remainder = dividend;
*   
*   if (divisor == 0) {
*       quotient = 0xFF;
*       remainder = 0xFF;
*       return 0;
*   }
*
*   while (remainder >= divisor) {
*       quotient++;
*       remainder = remainder - divisor;    
*   }
*   return 0;
**************************************

* start of data section

                ORG     $B000
DIVIDEND        FCB     101       * unsigned int dividend = 101;
DIVISOR         FCB     6         * unsigned int divisor = 6;

                ORG     $B010
QUOTIENT        RMB     1         * The quotient
REMAINDER       RMB     1         * The remainder
* define any other variables that you might need here using RMB (not FCB or FDB)

* start of program section
                ORG     $C000
                CLR     QUOTIENT   * quotient = 0;
                LDAA    DIVIDEND   * load dividend into A
                STAA    REMAINDER  * Store A into remainder. remainder = dividend
IF              TST     DIVISOR    * Test Divisor for 0, Set Z to 1 if yes
                BNE     WHILE      * Branch to ENDIF (WHILE) if Z flag is not set
THEN            CLR     REMAINDER  * Set Remainder to Zero (Quotient is already zero)               
                COM     QUOTIENT   * 1's comp Quotient (set it to $FF)
                COM     REMAINDER  * 1's Comp remainder (set it to $FF)
                BRA     DONE       * Go to end of program
WHILE           LDAA    REMAINDER  * Load Remainder into A, dont need to load
                CMPA    DIVISOR    * Compare A (Remainder) to Divisor (in Memory)
                BLO     DONE       * Branch if remainder is lower than Divisor (We're done)
BLOCK           INC     QUOTIENT   * quotient++;
                SUBA    DIVISOR    * Subtract divisor from Content of A (Remainder) and load result back into A
                STAA    REMAINDER  * Store content of A in remainder
                BRA     WHILE      * Go back to beginning of WHILE
DONE            BRA     DONE       * Weird Infinite loop to end program???
