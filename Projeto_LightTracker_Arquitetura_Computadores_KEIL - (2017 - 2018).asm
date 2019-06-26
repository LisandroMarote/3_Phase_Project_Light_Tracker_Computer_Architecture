                                                        




 ; FUNCTION Init (BEGIN)
                               
                               
           SETB    EA
                               
           SETB    ET0
                               
           SETB    EX0
                               
           ANL     TMOD,#0F0H
                               
           ORL     TMOD,#02H
                               
           MOV     TH0,#037H
                               
           MOV     TL0,#037H
                               
           SETB    TR0
                               
           SETB    IT0
                               
           SETB    LED
                               
           RET     
 ; FUNCTION Init (END)

 ; FUNCTION External0_ISR (BEGIN)
                               
                               
           CLR     LED
                               
           RETI    
 ; FUNCTION External0_ISR (END)

 ; FUNCTION Timer0_ISR (BEGIN)
                               
                               
     R     INC     R0
                               
           RETI    
 ; FUNCTION Timer0_ISR (END)

 ; FUNCTION main (BEGIN)
                               
                               
     R     LCALL   Init
 ?C0004:
                               
                               
                               
     R     MOV     A,R0
     R     CJNE    A,R2,?C0006
                               
                               
           CLR     servo
                               
           JB      R3,?C0006
           CLR     A
     R     MOV     R1,A
ER V9.57.0.0   PROJETO                                         06/02/2018 09:59:02 PAGE 4   

                               
 ?C0006:
                               
     R     MOV     A,R0
           CJNE    A,#064H,?C0008
                               
                               
           CLR     A
     R     MOV     R0,A
                               
           SETB    servo
                               
     R     INC     R1
                               
 ?C0008:
                               
           JNB     R3,?C0004
                               
                               
     R     MOV     A,R1
           CJNE    A,#0AH,?C0004
                               
                               
           SETB    LED
                               
     R     MOV     A,dir+01H
     R     ORL     A,dir
           JNZ     ?C0011
                               
                               
     R     MOV     A,R2
           CLR     C
           SUBB    A,#0CH
           JC      ?C0012
                               
                               
     R     MOV     dir,#00H
     R     MOV     dir+01H,#01H
                               
           SJMP    ?C0004
 ?C0012:
                                           
                                           
003B 0500        R     INC     R2
                                           
003D E4                CLR     A
003E F500        R     MOV     R1,A
                                           
                                           
0040 80C1              SJMP    ?C0004
0042         ?C0011:
                                           
                                           
0042 E500        R     MOV     A,R2
0044 B40307            CJNE    A,#03H,?C0015
                                           
                                           
0047 E4                CLR     A
0048 F500        R     MOV     dir,A
004A F500        R     MOV     dir+01H,A
                                           
004C 80B5              SJMP    ?C0004
C51 COMPILER V9.57.0.0   PROJETO                                                           06/02/2018 09:59:02 PAGE 5   

004E         ?C0015:
                                           
                                           
004E 1500        R     DEC     R2
                                           
0050 E4                CLR     A
0051 F500        R     MOV     R1,A
                                           
                                           
                                          
                                           
                                           
0053 80AE              SJMP    ?C0004
             ; FUNCTION main (END)



MODULE INFORMATION:   STATIC OVERLAYABLE
   CODE SIZE        =    116    ----
   CONSTANT SIZE    =   ----    ----
   XDATA SIZE       =   ----    ----
   PDATA SIZE       =   ----    ----
   DATA SIZE        =      5    ----
   IDATA SIZE       =   ----    ----
   BIT SIZE         =   ----    ----
END OF MODULE INFORMATION.



