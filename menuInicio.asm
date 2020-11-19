
.data 

text1:      .asciiz "Bienvenido!\n"
text2:      .asciiz "Selecciona una opcion: \n"
text3:	    .asciiz "1) Tabla de posiciones\n"
text4:      .asciiz "2) Ingresar partido\n"
text5:      .asciiz "3) Mostrar Top 3\n"
text6:	    .asciiz "4) Salir\n"
text7: 	    .asciiz "Ingrese: \n"
file:       .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\TablaIni.txt"
file2:      .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\ingreso.txt"
buffer:     .space 1024

matrix:	    .space 256
textLocal:	.asciiz "Ingrese equipo local: \n"
textVisitante:	.asciiz "Ingrese equipo visitante: \n"
textMarcadorL:	.asciiz "Ingrese el marcador del equipo local: \n"
textMarcadorV:	.asciiz "Ingrese el marcador del equipo visitante: \n"

salto:      .byte '\n'
coma:	    .byte ','
teams:	    .space 1024

team:    .space 40
numChars: .word 6
input:	  .space 6

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
		jal enterMatch
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
		
		#Closing the file
		li $v0, 16
		move $a0, $s0
		syscall

		#Printing content
		jal readFile
		
		la $a0, team
		li $a1, 40
		li $v0, 8
		syscall
		
		la $a0, team
		j serch
		
		la $a0, ($v0)
		li $v0, 1
		syscall
		
		#Opening a file
	Save:	li $v0, 13
		la $a0, file2
		li $a1, 1
		syscall
		move $s0, $v0	
		
		li $v0, 15
		move $a0, $s0
		la $a1, matrix
		li $a2, 256
		syscall
		
		#Closing the file
		li $v0, 16
		move $a0, $s0
		syscall
		j main
			
Exit:
	li $v0, 10
	syscall
	
	
	

readFile:
		#Reservar
		addi $sp,$sp, -40
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $s1, 20($sp)
		sw $s2, 24($sp)
		sw $s3, 28($sp)
		sw $s4, 32($sp)
		sw $s5, 36($sp)
		
		la $t1, buffer			#File Buffer
		la $t2, teams			#Teams Array
		la $s6, matrix			#Matrix
		li $t4, 0 			# Linea Flag
		lb $s3, coma
		lb $s5, salto
		
		
	 	
	Loop:	lb $s2, 0($t1)			#carga el caracter

		beq $s2, $zero, rfend 		#Se verifica que se acabo el string
		beq $s2, $s5, lin 		#Se verifica un salto de linea
		beq $t4, 1, points 		#Si ya hubo una coma, guarda los puntos
		beq $s2, $s3, com		#Se verifica si es una coma
		
		sb $s2, 0($t2)			#Guarda el caracter
		addi $t2,$t2, 1			#Se aumenta el indice del array de equipos
		j continue
		
		
	com:	li $t4, 1		#Cuando encuentra la primera coma
		
	team:					#Guarda la coma y cambia el flag para no guardar
		sb $s2, 0($t2)			#los otros elementos.
		addi $t2,$t2, 1			#Aqui se puede identificar por caso para guardar 
		j continue			#El elemento de la columna
	
	points: beq $s2, $s3, continue
		sb $s2, 0($s6)			#Guarda los puntos
		addi $s6,$s6, 1
		j continue
		
	lin:	li $t4, 0 			#Cuando hay un salto de linea, el flag pasa a 0
	
     continue:  #addi $t0,$t0,1			#Se aumenta el indice del buffer	
		addi $t1,$t1,1	
		j Loop
		
		
		
	rfend:	add $s1, $t2, $t3		#Guarda la coma y cambia el flag para no guardar
		sb $s2, 0($s1)
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $s1, 20($sp)
		lw $s2, 24($sp)
		lw $s3, 28($sp)
		lw $s4, 32($sp)
		lw $s4, 36($sp)
		addi $sp,$sp, 40
		
		jr $ra
		
		
serch:		#Retorna el indicice del equipo - a0 equipo - v0 indice
		li $t0, 0
		la $t1, teams
		lb $t3, coma
		
		
	ingreso:	
		la $t2, ($a0) 
	
	stringCmp:
		lb $t4, ($t1)   #team
		lb $t5, ($t2)	#input
		bne $t4, $t5, out
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		j stringCmp	
	out:
		bne $t4, $t3, next
		bne $t5, $zero, next
		sw $t0, ($v0) 
		j sReturn
		
	next:	
		beq $t4, $zero, sReturn
		beq $t4, $t3, saltar
		addi $t1, $t1, 1
		j next

	saltar:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j ingreso
		
	sReturn: 
		jr $ra
stringToInt:
		la $a1, input
		lw $a1, 0($a1)
		
		add $t0, $zero, $a0
		lb $a0, 0($t0)
		addi $a0, $a0, -48
		move $a0, $s0
		
		jr $ra
enterMatch:
		li $v0, 4
		la $a0, textLocal
		syscall
	
		li $v0, 8
        	syscall
        	move $a0, $s0
        	
		li $v0, 4
		la $a0, textVisitante
		syscall
	
		li $v0, 8
	        syscall
		move $a0, $s1
		
		li $v0, 4
		la $a0, textMarcadorL
		syscall
	
		li $v0, 5
        	syscall
        	move $a0, $s2
        	
		li $v0, 4
		la $a0, textMarcadorV
		syscall
		
		li $v0, 5
        	syscall
        	move $a0, $s3
        	
        	jr $ra