<h1 align="center"> 💻Practica 2</h1>


Ejercicios
=================

1 ) Implementar un programa en el lenguaje assembler que muestre en la pantalla de comandos un mensaje previamente almacenado en memoria de datos, aplicando la interrupción por software INT 7 [Resolucion](#Ejercicio_1)
 
2 ) Escribir un programa que muestre en pantalla todos los caracteres disponibles, comenzando con el caracter cuyo código es el número 01H [Resolucion](#Ejercicio_2)

3 ) Escribir un programa que muestre en pantalla las letras del abecedario, sin espacios, intercalandolo mayúsculas y minúsculas (AaBb...), sin incluir texto en la memoria de datos del programa. Tener en cuenta que el código de "A" es 41H, el de "a" es 61H y que el resto de los codigos son correlativos según el abecedario [Resolucion](#Ejercicio_3)

4 ) Escribir un programa que solicite el ingreso de un número (de un digito) por teclado e inmediatamente lo muestre en la pantalla de comandos, haciendo uso de las interrupciones por software INT 6 e INT 7. [Resolucion](#Ejercicio_4)

5 ) Modificar el programa anterior agregando una subrutina llamada ES_NUM que verifique si el caracter ingresado es realmente un número. De no serlo, el programa debe mostrar el mensaje “CARACTER NO VALIDO”. La subrutina debe recibir el código del caracter por referencia desde el programa principal y debe devolver vía registro el valor 0FFH en caso de tratarse de un número o el valor 00H en caso contrario. Tener en cuenta que el código del “0” es 30H y el del “9” es 39H. [Resolucion](#Ejercicio_5)

6 )  Escribir un programa que solicite el ingreso de un número (de un dígito) por teclado y muestre en pantalla dicho número expresado en letras. Luego que solicite el ingreso de otro y así sucesivamente. Se debe finalizar la ejecución al ingresarse en dos vueltas consecutivas el número cero. [Resolución](#Ejercicio_6)

7 )  Escribir un programa que efectúe la suma de dos números (de un dígito cada uno) ingresados por teclado y muestre el resultado en la pantalla de comandos. Recordar que el código de cada caracter ingresado no coincide con el número que representa y que el resultado puede necesitar ser expresado con 2 dígitos. [Resolución](#Ejercicio_7)

8 ) Escribir un programa que efectúe la resta de dos números (de un dígito cada uno) ingresados por teclado y muestre el resultado en la pantalla de comandos. Antes de visualizarlo el programa debe verificar si el resultado es positivo o negativo y anteponer al valor el signo correspondiente. [Resolución](#Ejercicio_8)

9 ) Escribir un programa que aguarde el ingreso de una clave de cuatro caracteres por teclado sin visualizarla en pantalla. En caso de coincidir con una clave predefinida (y guardada en memoria) que muestre el mensaje "Acceso permitido", caso contrario el mensaje "Acceso denegado". [Resolución](#Ejercicio_9)

10 ) Escribir un programa que, mientras ejecuta un lazo infinito, cuente el número de veces que se presiona la tecla F10 y acumule este valor en el registro DX. [Resolución](#Ejercicio_10)

Ejercicio_1
===========
```Assembly
ORG 1000H
 MENSAJE DB "ARQUITECTURA DE COMPUTADORAS-"
         DB "FACULTAD DE INFORMATICA-"
         DB 55H
         DB 4EH
         DB 4CH
         DB 50H
 FIN DB ?
ORG 2000H
 MOV BX, OFFSET MENSAJE
 MOV AL, OFFSET FIN - OFFSET MENSAJE
 INT 7    
 INT 0
END
```

Ejercicio_2
===========
```Assembly
ORG 1000H
 MENSAJE DB 01H
ORG 2000H
 MOV BX, OFFSET MENSAJE
 MOV AL, 1 ;Solo voy a imprimir un caracter
 REPETIR: INT 7    
 INC BYTE PTR [BX]
 CMP BYTE PTR [BX], 7FH
 JNZ REPETIR
 INT 0
END
```


Ejercicio_3
===========
```Assembly
ORG 1000H
 MAY DB 41H ; "A"
 MIN DB 61H ; "a"
 ; La letra "Z" (mayuscula) tiene el codigo 5A
ORG 2000H
 MOV AL, 2 		       ; SE IMPRIME EN PANTALLA DE A 2 CARACTERES
 MOV BX, OFFSET MAY ; A PARTIR DE LA DIRECCION MAY
 PROX: INT 7
 INC MIN            ;PASO AL SIGUIENTE CARACTER
 INC MAY            ;PASO AL SIGUIENTE CARACTER
 CMP MAY, 5BH       ;CARACTER SIGUIENTE A LA Z (ASI TOMO LA Z)
 JNZ PROX           ;MIENTRAS NO LLEGUE AL CARACTER, AVANZO
 INT 0
END
```
Ejercicio_4
===========
```Assembly
ORG 1000H
 MSJ DB "INGRESE UN NUMERO:"
 FIN DB ?
ORG 1500H
 NUM DB ?
ORG 2000H
 MOV BX, OFFSET MSJ  ;PARA IMPRIMIR SIEMPRE TIENE SER EL REGISTRO BX
 MOV AL, OFFSET FIN-OFFSET MSJ
 INT 7               ;IMPRIMO EL MENSAJE NORMAL 
 MOV BX, OFFSET NUM  ;PARA TOMAR EL VALOR PUEDE SER CUALQUIER REGISTRO
 INT 6               ;INGRESO UN VALOR POR TECLADO Y LO CARGO A NUM
 MOV AL, 1           ;AL INDICA LA CANTIDAD DE CARACTERES
 INT 7
 MOV CL, NUM
 INT 0
END
```

Responder brevemente:

a ) Con referencia a la interrupción ***INT 7***, ¿Qué se almacena en los registros BX y AL?

En BX se almacena la direccion de memoria en donde comienza el string, y en AL se almacena la cantidad de caracteres que voy a imprimir.

b ) Con referencia a la interrupción ***INT 6***, ¿Qué se almacena en BX?

En BX se tiene la dirección de memoria donde se va a guardar el carácter el caracter leido.

c ) En el programa anterior, ¿Qué hace la segunda interrupción INT 7? ¿Qué queda almacenado en el registro CL? 

Como en bx, quedo guardado la direccion del numero que ingresamos, luego a AL, mando 1 para que solo me imprima el caracter leido. En el registro CL queda el codigo ASCII del caracter leido.

Ejercicio_5
===========
```Assembly
ORG 1000H
 MENSAJE DB "INGRESE UN NUMERO: "
 FIN DB ?
 MENSAJE2 DB "CARACTER NO VALIDO"
 FIN2 DB ?
 NUEVE DB 39H
ORG 1500H    ;ESTA PUEDE SER CUALQUIER DIRECCION, LO PONEMOS POR COMODIDAD
 NUM DB ?
 
ORG 3000H
 ES_NUM:INT 6
 CMP NUM,30H
 JS NO_ES      ;SI EL VALOR ES MENOR AL 0, NO ES VALIDO
 CMP  NUM,40H  ;SI EL VALOR ES MAYOR A 9, TAMPOCO ES VALIDO
 JNS NO_ES
 
 MOV DX,0FFH   ;MANDO ESTE VALOR PARA INDICAR QUE ES CORRECTO
 MOV AL, 1     ;IMPRIMO SOLO 1 CARACTER
 INT 7
 JMP TERMINO   ;TERMINO NORMAL
 
 NO_ES: MOV DX, 00H       ;MANDO EL VALOR E IMPRIMO EL MENSAJE
 MOV BX, OFFSET MENSAJE2
 MOV AL, OFFSET FIN2-OFFSET MENSAJE2
 INT 7
 
TERMINO: RET

ORG 2000H 
 MOV BX, OFFSET MENSAJE
 MOV AL, OFFSET FIN-OFFSET MENSAJE
 INT 7
 
 MOV BX, OFFSET NUM
 CALL ES_NUM
 
 MOV CL, NUM ;MANDO EL CARACTER/NUMERO INGRESADO
 INT 0
END
```
Ejercicio_6
===========
```Assembly
ORG 1000H
 CERO DB "CERO " ; Todos los nombres tienen 6 caracteres para 
      DB "UNO " ; facilitar posicionarnos al imprimir el nombre del numero
      DB "DOS "
      DB "TRES "
      DB "CUATRO"
      DB "CINCO "
      DB "SEIS "
      DB "SIETE "
      DB "OCHO "
      DB "NUEVE "
 MSJ DB "INGRESE UN NUMERO:"
 FIN DB ?
 
ORG 1500H
 NUM DB ?
 
ORG 2000H
 MOV CL, 0                      ; CONT 0 DE FORMA CONSECUTIVA
 OTRO: MOV BX, OFFSET MSJ
 MOV AL, OFFSET FIN-OFFSET MSJ
 INT 7                          ; IMPRIMO EL MENSAJE
 
 MOV BX, OFFSET NUM
 INT 6                          ; LEO UN CARACTER
 CMP NUM, 30H                   ; COMPARO CON 0
 JNZ NO_CERO
 
 INC CL                         ; VOY A NRO 1
 JMP SEGUIR
 
 NO_CERO:MOV CL, 0              ;REINICIO EL CONTADOR DE 0 CONSECUTIVOS
 
 SEGUIR: MOV BX, OFFSET CERO 
  MOV AL, 6                     ;IMPRIMO SIEMPRE 6 CARACTERES
 
 LOOP: CMP NUM, 30H
  JZ IMPRIME                    ;SI ENCONTRE EL NOMBRE, IMPRIMO
   ADD BX, 6                    ;AVANZO DE NOMBRE
   DEC NUM                      ;AL LLEGAR AL NUMERO 0, ESTARA POSICIONADO
  JMP LOOP
  
 IMPRIME:INT 7
  CMP CL, 2
  JNZ OTRO                      ; HASTA QUE SE INGRESE DOS VECES SEGUIDAS EL "0" CERO
 INT 0 
END
```
Ejercicio_7
===========
```Assembly
ORG 1000H
 MSJ DB "INGRESE UN NUMERO:"
 FIN DB ?
 ORG 1500H
 NUM1 DB ?
 NUM2 DB ?
 RES_D DB "0"                  ; DOCENA DEL RESULTADO 
 RES_U DB ?                    ; UNIDAD DEL RESULTADO

ORG 2000H
 MOV BX, OFFSET MSJ
 MOV AL, OFFSET FIN-OFFSET MSJ
 INT 7                         ;IMPRIMO EL MENSAJE
 MOV BX, OFFSET NUM1
 INT 6                         ;LEO EL NUM1
 MOV BX, OFFSET MSJ
 INT 7                         ;PIDO OTRO NUMERO
 MOV BX, OFFSET NUM2
 INT 6                         ;LEO EL NUM2
 MOV AL, NUM2 
 SUB AL, 30H                   ; PARA QUEDARME CON EL ENTERO
 
 ADD AL, NUM1                  ; SUMO EL PRIMER NUMERO
 CMP AL, 3AH                   ; SI NO SUPERO 9, IMPRIMO
 JS NUM_OK                     ; SI ES MENOR QUE 9
 
 SUB AL, 10                    ; ME QUEDO CON LA UNIDAD
 INC RES_D                     ;PASA DE SER "0" A "1"
 
 NUM_OK: MOV RES_U, AL         ;COPIO EL VALOR EN RES U
 MOV BX, OFFSET RES_D          ; IMPRIMO 2 CARACTERES
 MOV AL, 2
 INT 7
 INT 0
END
```

Ejercicio_8
===========
```Assembly
ORG 1000H
 MSJ DB "INGRESE UN NUMERO:"
 FIN DB ?
 ORG 1500H
 NUM1 DB ?
 NUM2 DB ?
 RES_D DB "0"                  ; DOCENA DEL RESULTADO 
 RES_U DB ?                    ; UNIDAD DEL RESULTADO

ORG 2000H
 MOV BX, OFFSET MSJ
 MOV AL, OFFSET FIN-OFFSET MSJ
 INT 7                         ;IMPRIMO EL MENSAJE
 MOV BX, OFFSET NUM1
 INT 6                         ;LEO EL NUM1
 MOV BX, OFFSET MSJ
 INT 7                         ;PIDO OTRO NUMERO
 MOV BX, OFFSET NUM2
 INT 6                         ;LEO EL NUM2
 MOV AL, NUM1 
 
 CMP AL, NUM2                  ;SI EL RESULTADO DA NEGATIVO
 JS NUM_NO_OK                  
 SUB AL, NUM2                  ;SINO, ES UNA RESTA NORMAL
 JMP NUM_OK                    ;IMPRIMO EL NUMERO
 
 NUM_NO_OK: MOV AL, NUM2
 SUB AL, NUM1               
 MOV RES_D, 2DH                     ;PASA DE SER "0" A "-"
 
 NUM_OK: ADD AL, 30H
 MOV RES_U, AL         
 MOV BX, OFFSET RES_D          ; IMPRIMO 2 CARACTERES
 MOV AL, 2
 INT 7
 INT 0
END

```
Ejercicio_9
===========
```Assembly
ORG 1000H
MSJ DB "INGRESE UN NUMERO:"
FIN DB ?
CONTRA DB "AB"
CONTRA_PARTE2 DB "CZ"
CANT DB 4H

MENSAJE DB "CORRECTA"
FIN_MENSAJE DB ?
MENSAJE2 DB "INCORRECTA"
FIN_MENSAJE2 DB ?

ORG 3000H
 LEER_CONTRA:MOV BX, SP
 ADD BX,2
 BUCLE: MOV CL,[BX]
 MOV DX, BX
 MOV BX, OFFSET NUM
 INT 6
 MOV AL, 1
 INT 7
 
 CMP CL,NUM
 JNZ INCORRECTO
 
 MOV BX, DX
 INC BX
 DEC CANT
 JNZ BUCLE
 
 CMP CANT,0
 JZ CUMPLE
 
 INCORRECTO: MOV BX, OFFSET MENSAJE2
 MOV AL, OFFSET FIN_MENSAJE2 - OFFSET MENSAJE2
 INT 7 
 JMP TERMINAR
 
 
 CUMPLE:MOV BX, OFFSET MENSAJE
 MOV AL, OFFSET FIN_MENSAJE - OFFSET MENSAJE
 INT 7 
 JMP TERMINAR
 
TERMINAR: RET

ORG 1500H
NUM DB ?

ORG 2000H
MOV BX, OFFSET MSJ
MOV AL, OFFSET FIN-OFFSET MSJ
INT 7
MOV BX, CONTRA_PARTE2
PUSH BX
MOV BX, CONTRA
PUSH BX
CALL LEER_CONTRA

INT 0
END
```
Ejercicio_10
============