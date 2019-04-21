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

/*Mensajes*/
mensaje_bienvenida: .asciz "\n\t\tBIENVENIDO\n\n\tJUEGO MAYOR O MENOR\n\n1. Single Player\n2. Multiplayer"
mensaje_ingreso: .asciz "\nIngrese una opcion:"
ingreso_valor: .asciz "%d"
mensaje_error: .asciz "\nEl valor ingresado no es valido\n"


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


modo_juego:

	MOV r10, lr

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

	MOV r11, #0					/*R11 contendra el turno del jugador*/
	MOV r12, #0					/*R12 sera el inicio del juego*/

	CMP r1, #1					@En caso ser 1 se llama a single player
	BEQ single_player

	CMP r1, #2					@En caso ser 2 se llama a multiplayer
	BEQ multiplayer

	B error						@En caso el numero ingresado no es valido


single_player:
	/*Jugar contra la computadora*/
	CMP r12, #0					@Si r12 esta en 0 lanzara los dados (unicamente al inicio)
	BEQ lanzar_dados

	CMP r11, #0					@Si r11 esta en 0 es turno del jugador1
	BEQ jugador1
	BGT computadora



jugador1:
	
lanzar_dados:

multiplayer:
	B fin

error:
	LDR r0, =mensaje_error 				@Mensaje de Error
	BL puts
	BL getchar					@Refresca el buffer
	B modo_juego

fin:
	MOV r0, #0
	MOV r3, #0
	LDMFD sp!, {lr}
	BX lr
