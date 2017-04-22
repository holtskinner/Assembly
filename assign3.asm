**************************************
*
* Name: Holt Skinner
* Date: 3 March 2017
* Lab3 - Greatest Common Divisor Calculator
*
* Program description: This program calculates the Greatest Common Divisor by running the Euclidian algorithm.
* The euclidian Algorithm takes two numbers (shown as num1 and num2) calulates the remainder of the two using the division algorithm.
* The divisor from the division algorithm becomes the gcd of the current pair and The remainder from the division operation is stored as the new divisor
* for the next run of the loop. When the remainder is equal to zero. The divisor of the previous operation is the gcd of the first two numbers.
* The remainder and divisor are stored in register A and B respecively. The gcd variable is stored in memory.
*
* Pseudocode:
*   // data
*   unsigned int num1 = 105;
*   unsigned int num2 = 6;
*   unsigned int gcd;
*
*   unsigned int divisor;
*   unsigned int remainder;
*
*   // program
*   gcd = num1;
*   divisor = num2;
*   
*   do {
*       remainder = gcd;
*       while (remainder >= divisor) { // while !(remainder < divisor)
*           remainder = remainder - divisor;  // remainder %= divisor;
*       }
*       gcd = divisor;
*       divisor = remainder;
*   } while (remainder > 0); //until remainder == 0
*
**************************************

* start of data section

        ORG     $B000
NUM1    FCB     50
NUM2    FCB     3

        ORG     $B010
GCD     RMB     1       * GCD in Memory

* define any other variables that you might need here using RMB (not FCB or FDB)
* Remainder and divisor will be stored in registers

        ORG     $C000
* start of your program
        LDAA    NUM1    * A = NUM1;
        STAA    GCD     * GCD = A;
        LDAB    NUM2    * B = NUM2; Divisor
DO      LDAA    GCD     * A = GCD
WHILE   CBA             * Compare A to B A-B Sets Carry to 1 if remainder < divisor
        BLO     ENDWHIL * ENd While if remainder < divisor
        SBA             * Subtract B from A (A - B -> A)
        BRA     WHILE   * Go to beginning of While
ENDWHIL STAB    GCD     * Store B in GCD (GCD = divisor)
        TAB             * Transfer A to B B = A (divisor = remainder)
UNTIL   TSTA            * Test A for Zero (until remainder == 0)
        BEQ     DONE    * Branch if Z == 1
        BRA     DO      * GO back to DO
DONE    BRA     DONE    * END!





