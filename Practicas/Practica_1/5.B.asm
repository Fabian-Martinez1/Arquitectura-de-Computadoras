ORG 1000H
 A DW 5H
 B DW 6H
 C DW 2H
 D DW ?
ORG 3000H
 CALCULO: MOV AX, A 
 ADD AX, B
 SUB AX, C
 MOV DX, AX
ORG 2000H
 CALL CALCULO
HLT
END