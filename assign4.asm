***************************************
*
* Name: Holt Skinner
* Date: April 5, 2017
* Lab 4
*
* Program description: This program runs the euclidian algorithm on two arrays, Tale 1 and table 2.
* For each value in the arrays, the program passes the values at the same index (e.g.table1[1] and table2[1])
* to a subroutine via call by value in registers A and B respectively. The Subroutine calculates the GCD of the two values passed in.
* The subroutine passes the result back to main via pass by value over the stack. This value is then stored into a third Table called Result
* at the corresponding index. (e.g. result[1])
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
*       static int remainder;
*       DO {
*           REMAINDER = DIVIDEND;                   
*           WHILE (REMAINDER >= DIVISOR) {                                                         
*                REMAINDER = REMAINDER - DIVISOR;                     
*           }
*
*       GCD = DIVISOR;
*       DIVIDEND = DIVISOR;
*       DIVISOR = REMAINDER;
*  } UNTIL (REMAINDER == 0);
*
*       
***************************************
* start of data section

        ORG     $B000
TABLE1  FCB     222, 37, 16, 55,  55, 1, 3, 22, $FF
TABLE2  FCB     37, 222, 240, 5, 55, 15, 22, 3, $FF

        ORG     $B020
RESULT  RMB     8
Z       RMB     2               temporary Location for Result Address       

* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your subroutine must not access any of these variables, including
* N and PRIME

        ORG     $C000
        LDS     #$01FF          initialize stack pointer
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
        INX                    	x++;
        STX     Z               z = x
        PULX                    Get Address of table1 off stack
        INX                    	x++;
        INY                    	y++;
        BRA     WHILE           Go back to Top of loop
DONE    BRA     DONE
        END
* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your main program must not access any of these variables, including


                ORG     $D000
GCD             RMB     1
REMAINDER       RMB     1
DIVIDEND        RMB     1           
DIVISOR         RMB     1   
* start of your subroutine 
SUB             STAA    DIVIDEND        DIVIDEND = A
                STAB    DIVISOR         DIVISOR = B

DO              LDAA    DIVIDEND        A = DIVIDEND                
                STAA    REMAINDER       REMAINDER = A

WHILE2          LDAA    REMAINDER       A = REMAINDER
                CMPA    DIVISOR         A - DIVISOR
                BLO     ENDWHL          Branch if Divisor < REMAINDER
                SUBA    DIVISOR         A -= DIVISOR     
                STAA    REMAINDER       REMAINDER = A   
                BRA     WHILE2          Back to Top of Loop
ENDWHL                

                LDAA    DIVISOR         A = DIVISOR
                STAA    GCD             GCD = A
                STAA    DIVIDEND        DIVIDEND = A
                LDAA    REMAINDER       REMAINDER = A
                STAA    DIVISOR         DIVISOR = a
UNTIL           TST     REMAINDER       Test Remainder for 0
                BNE     DO              Go back to DO if remainder != 0
                PULX                    Pull return address off stack
                LDAA    GCD             
                PSHA                    Push A onto Stack (GCD) For return
                PSHX                    Put return address back on stack
                RTS                     Go back to Main
