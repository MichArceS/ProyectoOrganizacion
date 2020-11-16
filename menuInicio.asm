
.data 

text1:      .asciiz "Bienvenido!\n"
text2:      .asciiz "Selecciona una opcion: \n"
text3:	    .asciiz "1) Tabla de posiciones\n"
text4:      .asciiz "2) Ingresar partido\n"
text5:      .asciiz "3) Mostrar Top 3\n"
text6:	    .asciiz "4) Salir\n"
text7: 	    .asciiz "Ingrese: \n"
file:       .asciiz "C:\\Users\\User\\Desktop\\Trabajos Espol\\Quinto Semestre\\Organización de Computadores\\Proyecto\\ProyectoOrganizacion\\TablaIni.txt"
buffer:     .space 1024

.text
main:
	#Menu
	li $v0, 4
	la $a0, text1
	syscall
	
	li $v0, 4
	la $a0, text2
	syscall
	
	li $v0, 4
	la $a0, text3
	syscall
	
	li $v0, 4
	la $a0, text4
	syscall
	
	li $v0, 4
	la $a0, text5
	syscall
	
	li $v0, 4
	la $a0, text6
	syscall
	
	li $v0, 4
	la $a0, text7
	syscall
	
	#Inserting an Integer
	li $v0, 5
        syscall
	
	#Switch Statement
	move $t0, $v0 
	beq $t0, 1, case1
	beq $t0, 2, case2
	beq $t0, 3, case3
	beq $t0, 4, case4
	
	case1:
		li $v0, 4
		la $a0, text3
		syscall
		j fileReading
	case2:
		li $v0, 4
		la $a0, text4
		syscall
		j main
	case3:
		li $v0, 4
		la $a0, text5
		syscall
		j main
	case4:
		li $v0, 4
		la $a0, text6
		syscall
		j Exit
	fileReading:
		#Opening a file
		li $v0, 13
		la $a0, file
		li $a1, 0
		syscall
		move $s0, $v0

		#Reading a file
		li $v0, 14
		move $a0, $s0
		la $a1, buffer
		li $a2, 1024
		syscall

		#Printing content
		li $v0, 4
		la $a0, buffer
		syscall

		#Closing the file
		li $v0, 16
		move $a0, $s0
		syscall
		j main
	
Exit:
	li $v0, 10
	syscall