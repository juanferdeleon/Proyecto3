/*Proyecto 3*/
/*Juego Mayor o Menor*/
/*Juan Fernando De Leon Quezada*/
/*Carne 17822*/
/*Jose Amado Garcia*/
/*Carne 181469*/

.data
.align 2

/*Variables*/
opcion_de_juego: .word 0
opcion_mayor_menor: .word 0

/*Mensajes*/
mensaje_bienvenida: .asciz "\n\t\tBIENVENIDO\n\n\tJUEGO MAYOR O MENOR\n\nModos de juego:\n\n\t1. Single Player\n\t2. Multiplayer"
mensaje_ingreso: .asciz "\nIngrese una opcion: "
ingreso_valor: .asciz "%d"
mensaje_error: .asciz "\nEl valor ingresado no es valido\n"
mensaje_mayor_menor: .asciz "\nEl sigiente valor sera MENOR(0) O MAYOR(1):"

/*Mensajes turnos*/
turno_jugador1: .asciz "\n\t\tTURNO JUGADOR 1"
turno_jugador2: .asciz "\n\t\tTURNO JUGADOR 2"
turno_computadora: .asciz "\nTURNO COMPUTADORA"

/*Menajes de dados*/
mensaje_dados: .asciz "\n-------------VALOR DE DADOS: %ld---------------\n"
mensaje_dados1: .asciz "\nDado 1: %d\n"
mensaje_dados2: .asciz "Dado 2: %d\n"

/*Mensaje Marcadores*/
mensaje_marcador: .asciz "\n\*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n\t\tMARCADOR\n"
marcador_jugador1: .asciz ">>>JUGADOR 1: %d\n"
marcador_jugador2: .asciz ">>>JUGADOR 2: %d\n"

/*Mensajes victorias*/
jugador1_gano: .asciz "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n\t\tJUAGODR 1 HA GANADO\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
jugador2_gano: .asciz "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n\t\tJUAGODR 2 HA GANADO\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

.text
.align 2
.global main
.type main, %function

main:
	STMFD sp!, {lr}

	/*Menu principal*/
	LDR r0, =mensaje_bienvenida
	BL puts

	/*Modo de juego*/
	BL modo_juego

	B fin


modo_juego:

	PUSH {lr}					@Guarda la instruccion donde fue llamada la subrutina

	/*Ingreso de opcion de juego*/
	LDR r0, =mensaje_ingreso			@Mensaje de ingreso
	BL puts
	LDR r0, =ingreso_valor				@Espacio para ingresar valor
	LDR r1, =opcion_de_juego			@variable donde se almacena el valor ingresado
	BL scanf

	CMP r0, #0					@Verifica si el valor ingresado es un numero
	BEQ error

	/*Seleccion modo de juego*/
	LDR r1, =opcion_de_juego			@Valor ingresado
	LDR r1, [r1]

	MOV r10, #0					/*R10 contendra el turno del jugador*/
	MOV r11, #0					/*R11 sera el inicio del juego*/
	MOV r7, #0					/*R7 sera el marcador del jugador1*/
	MOV r8, #0					/*R8 sera el marcador del jugador 2*/

	CMP r1, #1					@En caso ser 1 se llama a single player
	BEQ single_player

	CMP r1, #2					@En caso ser 2 se llama a multiplayer
	BEQ multiplayer

	BGT error					@En caso el numero ingresado no es valido

	POP {lr}					@Devuelve a donde fue llamada la subrutina


single_player:
	/*Jugar contra la computadora*/
	BL ganar

	CMP r11, #0					@Si r11 esta en 0 lanzara los dados (unicamente al inicio)
	BLEQ lanzar_dados

	CMP r10, #0					@Si r10 esta en 0 es turno del jugador1
	BLEQ jugador1
	CMP r10, #1
	BLEQ computadora

	B single_player

multiplayer:
	/*Jugar contra una persona*/
	BL ganar

	CMP r11, #0					@Si r11 esta en 0 lanzara los dados (unicamente al inicio)
	BLEQ lanzar_dados

	CMP r10, #0					@Si r10 esta en 0 es turno del jugador1
	BLEQ jugador1
	CMP r10, #1
	BLEQ jugador2

	B multiplayer

ganar:
	CMP r7, #10
	BEQ ganar_jugador1

	CMP r8, #10
	BEQ ganar_jugador2

	MOV pc, lr

ganar_jugador1:
	LDR r0, =jugador1_gano
	BL puts
	POP {pc}

ganar_jugador2:
	LDR r0, =jugador2_gano
	BL puts
	POP {pc}

jugador1:

	PUSH {lr}

	/*Turno del jugador 1*/

	LDR r0, =turno_jugador1
	BL puts

	LDR r0, =mensaje_mayor_menor			@Pregunta si el sigiente valor sera mayor o menor
	BL puts

	LDR r0, =ingreso_valor				@Ingreso de valor
	LDR r1, =opcion_mayor_menor
	BL scanf

	CMP r0, #0					@Progra defensiva en caso ingrese mal el dato
	BEQ error_jugador1

	LDR r1, =opcion_mayor_menor			@Carga opcion ingresada
	LDR r1, [r1]

	CMP r1, #0					@En caso el jugador haya elegio que el resultado sera menor
	BLEQ menor

	CMP r1, #1					@En caso el jugador haya elegido que el resultado sera mayo
	BLEQ mayor

	BGT error_jugador1				@En caso haya ingresado mal el valor

	MOV r10, #1					@Cambio de turno

	POP {pc}


jugador2:

	PUSH {lr}

	/*Turno del jugador 2*/

	LDR r0, =turno_jugador2
	BL puts

	LDR r0, =mensaje_mayor_menor			@Pregunta si el sigiente valor sera mayor o menor
	BL puts

	LDR r0, =ingreso_valor				@Ingreso de valor
	LDR r1, =opcion_mayor_menor
	BL scanf

	CMP r0, #0					@Progra defensiva en caso ingrese mal el dato
	BEQ error_jugador2

	LDR r1, =opcion_mayor_menor			@Carga opcion ingresada
	LDR r1, [r1]

	CMP r1, #0					@En caso el jugador haya elegio que el resultado sera menor
	BLEQ menor

	CMP r1, #1					@En caso el jugador haya elegido que el resultado sera mayo
	BLEQ mayor

	BGT error_jugador2				@En caso haya ingresado mal el valor

	MOV r10, #0					@Cambio de turno

	POP {pc}


computadora:
	/*Turno de la computadora*/

	PUSH {lr}

	LDR r0, =turno_computadora
	BL puts

	MOV r12, #2					@Se generara un numero aleatoreo entre 1 y 2
	BL RANDOM
	MOV r1, #1

	CMP r1, #1
	BLEQ menor

	CMP r1, #2
	BLEQ mayor

	MOV r10, #0

	POP {pc}

menor:
	PUSH {lr}

	MOV r6, r9					/*R6 Guardara el valor anterior de los dados*/

	BL lanzar_dados					@Lanzar los dados para el nuevo valor

	CMP r9, r6					@En caso el nuevo valor sea menor se da un punto
	BLT punto

	POP {lr}

	BEQ menor					@En caso sea igual se lanzan nuevamente los dados

	MOV pc, lr

mayor:
	PUSH {lr}

	MOV r6, r9					/*R6 Guardara el valor anterior de los dados*/

	BL lanzar_dados					@Lanzar los dados para el nuevo valor

	CMP r9, r6
	BGT punto					@En caso el nuevo valor sea menor se da un punto

	POP {lr}

	BEQ mayor					@En caso sea igual se lanzan nuevamente los dados

	MOV pc, lr

punto:
	/*Subrutina llamada cuando algun jugador realiza un punto*/
	CMP r10, #0
	BEQ punto_jugador1
	BGT punto_jugador2

punto_jugador1:
	ADD r7, #1
	POP {pc}

punto_jugador2:
	ADD r8, #1
	POP {pc}

lanzar_dados:
	/*Lanzar dos dados y obtener numeros aleatoreos*/
	MOV r11, #1

	PUSH {lr}					@Guarda la instruccion en donde fue llamada la subrutina

	/*Marcador actual*/
	LDR r0, =mensaje_marcador
	BL puts

	LDR r0, =marcador_jugador1			@Marcador jugador 1
	MOV r1, r7
	BL printf

	LDR r0, =marcador_jugador2			@arcador jugador 2
	MOV r1, r8
	BL printf

	/*Primer dado*/
	MOV r12, #6
	BL RANDOM					@Llama a la subrutina que genera numeros aleatorios
	MOV r2, r12					@Asigna el valor aleatorio para luego sumarlo a dado 2

	/*Segundo dado*/
	MOV r12, #6
	BL RANDOM
	MOV r3, r12

	/*Suma dado 1 y dado 2*/
	MOV r1, #0
	ADD r1, r2, r3

	MOV r9, r1					/*R9 Contendra la suma de los dados*/

	LDR r0, =mensaje_dados				@Imprime el valor de los dados
	BL printf

	POP {pc}

error:
	POP {lr}

	LDR r0, =mensaje_error 				@Mensaje de Error
	BL puts
	BL getchar					@Refresca el buffer

	B modo_juego

error_jugador1:
	LDR r0, =mensaje_error				@Mensaje de error
	BL puts
	BL getchar					@Refresca el buffer*/

	POP {lr}

	B jugador1

error_jugador2:
	LDR r0, =mensaje_error				@Mensaje de error
	BL puts
	BL getchar					@Refresca el buffer*/

	POP {lr}

	B jugador2


fin:
	MOV r0, #0
	MOV r3, #0
	LDMFD sp!, {lr}
	BX lr
