
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
menos:      .byte '-'
teams:	    .space 1024

team:    .space 40
numChars: .word 6
#input:	  .space 6

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
		
		move  $a0, $v0 
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
		
		la $s1, buffer			#File Buffer
		la $s2, teams			#Teams Array
		la $s6, matrix			#Matrix
		addi $s6, $s6, 1
		li $t1, 0 			# Linea Flag - Indica si ya se encontro la primera coma.
		lb $s3, coma			
		lb $s5, salto		
		li $s7, 0
		
		
	 	
	Loop:	lb $t0, 0($s1)			#carga el caracter

		beq $t0, $zero, rfend 		#Se verifica que se acabo el string
		beq $t0, $s5, lin 		#Se verifica un salto de linea
		beq $t1, 1, points 		#Si ya hubo una coma, pasa a guardar los puntos
		beq $t0, $s3, com		#Se verifica si es una coma
		
		sb $t0, 0($s2)			#Guarda el caracter
		addi $s2,$s2, 1			#Se aumenta el indice del array de equipos
		j continue
		
		
	com:	li $t1, 1			#Cuando encuentra la primera coma e flag pasa a 1.
		
		
		sb $t0, 0($s2)			#se agrega una coma al array de equipos
		#hay que ver si se agrega como byte o como word pero hay que alinearlo.
		addi $s2,$s2, 1			#se aumenta el indice
		j continue			
	
	points: li $t2, 0			#caracteres	
		li $t3, 0			#Numero 1
		li $t4, 0 			#Numero 2
		la $a0, ($s1)
	
	contarCaracteres:
		beq $t0, $s3, guardar
		beq $t0, $zero, guardar
		addi $t2, $t2, 1
		addi $s1, $s1, 1
		lb $t0, ($s1)
		j contarCaracteres
		
	guardar:
		jal stringToInt
		
		sll $t9, $s7, 2
		add $t9, $t9, $s6
		sw $v0, 0($t9)			#Guarda los puntos
		addi $s7, $s7, 1
		j continue
		
	lin:	li $t1, 0 			#Cuando hay un salto de linea, el flag pasa a 0
	
     continue:  			
		addi $s1,$s1,1			#Se aumenta el indice del buffer
		j Loop
		
		
		
	rfend:					#Guarda la coma y cambia el flag para no guardar
		jr $ra
		
		
serch:		#Retorna el indicice del equipo - a0 equipo - v0 indice
		li $t0, 0
		la $t1, teams
		lb $t3, coma
		
		
	ingreso:	
		la $t2, ($a0)			#Carga la direccion del  ingreso
	
	stringCmp:				#Compara byte por byte el nombre
		lb $t4, ($t1)   		#Carga byte de equipo
		lb $t5, ($t2)			#Carga byte de ingreso
		bne $t4, $t5, out		#Si no son iguales sale
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		j stringCmp			
	out:
		bne $t4, $t3, next		#Primero valida si la salida fue por por la compa, si no continua.
		move $v0, $t0 			#Si la salida fue por la coma, quiere decir que todo el nombre es igual. Retorna el indice
		j sReturn			#Sale de la funcion 
		
	next:	
		lb $t4, ($t1)			#En el caso de que no haya sigo por una coma. continua recorriendo los equipos
		beq $t4, $zero, sReturnN	#Si el buffer ya llego al final, sale de la funcion retornando -1.
		beq $t4, $t3, saltar		#Si llega a una coma, vuelve a comparar.
		addi $t1, $t1, 1
		j next

	saltar:
		addi $t1, $t1, 1		#Avanza uno para omitir la coma
		addi $t0, $t0, 1		#Como avanza a un nuevo equipo, el indice aumenta 1.
		j ingreso			#Vuelve a comparar
		
	sReturnN:
		li $v0, -1			#retorna -1		
	sReturn: 	
		jr $ra				#Salida de la funcion
		
stringToInt:
		#la $a1, input
		#la $a1, $a0
		#lw $a1, 0($a1)
		
		#add $t0, $zero, $a0
		#lb $a0, 0($t0)
		lb $t9, menos				#cargo el menos
		lb $t8, 0($a0)			#cargo la direccion del buffer
		li $t7, 0
		
		bne $t8, $t9, positive			#veo si es positivo o negativo
		li $t6, 1				#flag si es negativo
		addi $a0, $a0, 1			#aumento el buffer
		lb $t8, 0($a0)				#cargo el siguiente byte
		
	positive:
		beq $t2, 2, int2			#veo si tiene dos caracteros
		beq $t2, 1, int1			#si tiene un caracter
		
	int2:	addi $t7, $t8, -48			#resto -48 para sacar el numero
		mul $t7, $t7, 10 			#multiplico por 10 (base decimal)
		addi $a0, $a0, 1			#aumento el buffer
		lb $t8, 0($a0)				#cargo el siguiente byte
	int1:	
		addi $t8, $t8, -48			#resto 48 para sacar el numero
		add $t7, $t7, $t8			#sumo al numero anterior. si no habia, es 0
		#move $a0, $s0			
	
		bne $t6, 1, ret				#aqui debe de convertirse el numero a negativo.
		
	ret:	move $v0, $t7				#retorno
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
