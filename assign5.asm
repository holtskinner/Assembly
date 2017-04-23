**************************************
*
* Name: Holt Skinner
* ID: 14204311
* Date: 4-24-2017
* Lab5
*
* Program description: This program runs the euclidian algorithm on two arrays, Tale 1 and table 2.
* For each value in the arrays, the program passes the values at the same index (e.g.table1[1] and table2[1])
* to a subroutine via call by value in registers A and B respectively. The Subroutine calculates the GCD of the two values passed in.
* The subroutine passes the result back to main via pass by value over the stack. This value is then stored into a third Table called Result
* at the corresponding index. (e.g. result[1]) In addition, the subroutine to calculate the GCD is transparent by pushing all registers on the stack before execution,
* and all subroutine variables are implemented on the stack.
* 
*
* Pseudocode of Main Program:
*       
*        int  *x = &table1[0], *y = &table2[0], *z = &result[0], *temp;      
*        while (*x != $FF) {
*           *z = sub(*x, *y);
*           x++;
*           y++;
*        } 
* ---------------------------------------
*
* Pseudocode of Subroutine:
*   int sub (int dividend, int divisor) {
*       int remainder;
*       DO {
*           REMAINDER = DIVIDEND;                   
*           WHILE (REMAINDER >= DIVISOR) {                                                         
*                REMAINDER = REMAINDER - DIVISOR;                     
*           }
*
*       GCD = DIVISOR;
*       DIVIDEND = DIVISOR;
*       DIVISOR = REMAINDER;
*       } UNTIL (REMAINDER == 0);
*  }
* start of data section


        ORG     $B000
TABLE1  FCB     222,  37, 16,  55,  5,  3,   3, 22, $FF
TABLE2  FCB     37,  222, 240,  5, 65, 15,  22,  3, $FF

        ORG     $B020
RESULT  RMB     8

* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your subroutine must not access any of these variables
Z       RMB     2               temporary Location for Result Address

        ORG     $C000
        LDS     #$01FF          * initialize stack pointer
* start of your program
        LDX     #RESULT         Load address of Result into x
        STX     Z               Store address of Result into Z
        LDX     #TABLE1         Load Address of table1 into x
        LDY     #TABLE2         Address of Table2 into Y
WHILE   LDAA    0,X             A = *x
        CMPA    #$FF            A-$FF
        BEQ     DONE            Branch if equal to Endwhil (DONE)
        LDAB    0,Y             B = *y (*X is already in A)
        PSHX                    Push X onto Stack (Pointer to Table 1)
        JSR     SUB             Call SUB
        PULA                    Pull top of Stack into A (Returned Value)
        LDX     Z               X = Z
        STAA    0,X             *x = A
        INX                     x++;
        STX     Z               z = x
        PULX                    Get Address of table1 off stack
        INX                     x++;
        INY                     y++;
        BRA     WHILE           Go back to Top of loop
DONE    BRA     DONE
        END

* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*       AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM

        ORG     $D000
* start of your subroutine 
SUB     DES             * Open hole for return value
        PSHA            * Push Dividend Parameter onto stack -1
        PSHB            * Push Divisor Parameter onto stack -1
        DES             * Open hole for GCD Variable -1
        DES             * Open hole for remainder
        PSHX            * push X register onto stack -2
        PSHY            * Push Y onto Stack -2
        TPA             * Transfer CC into A 
        PSHA            * Push CC on stack -1
        TSX             * Copy SP + 1 into X
        LDY     10,X    * Load Return Address into Y
        STY     9,X     * Put return address back (With hole for return at bottom)
        LDAB    #05     * Load 3 into B
        ABX             * Add 3 to Address X (X points to Remainder)

* (Remainder = 0,X)(GCD = 1,X) (Divisor = 2, X) (Dividend = 3, X)

DO      LDAA    3,X       A = DIVIDEND                
        STAA    0,X       REMAINDER = A

WHILE2  LDAA    0,X       A = REMAINDER
        CMPA    2,X       A - DIVISOR
        BLO     ENDWHL    Branch if Divisor < REMAINDER
        SUBA    2,X       A -= DIVISOR     
        STAA    0,X       REMAINDER = A   
        BRA     WHILE2    Back to Top of Loop
ENDWHL  
        LDAA    2,X       A = DIVISOR
        STAA    1,X       GCD = A
        STAA    3,X       DIVIDEND = A
        LDAA    0,X       REMAINDER = A
        STAA    2,X       DIVISOR = a
UNTIL   TST     0,X       Test Remainder for 0
        BNE     DO        Go back to DO if remainder != 0
        LDAB    1,X       B = GCD
        STAB    6,X       Store GCD in space reserved for return value

        PULA              Pull old CC off stack into A
        TAP               Put A back into CC
        PULY              Pull Y off stack
        PULX              Pull X off stack
        INS
        INS               Bump Stack pointer 2X
        PULB              Pull Old B off stack
        PULA              Pull Old A off stack
        RTS               Go back to Main
