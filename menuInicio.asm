
.data 

buffer:     .space 1024
matrix:	    .space 512
teams:	    .space 1024
team:       .space 40
string:     .space 8
numChars:   .word 6

text1:      .asciiz "Bienvenido!\n"
text2:      .asciiz "Selecciona una opcion: \n"
text3:	    .asciiz "1) Tabla de posiciones\n"
text4:      .asciiz "2) Ingresar partido\n"
text5:      .asciiz "3) Mostrar Top 3\n"
text6:	    .asciiz "4) Salir\n"
text7: 	    .asciiz "Ingrese: \n"
file:       .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\TablaIni.txt"
file2:      .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\ingreso.txt"



textLocal:	.asciiz "Ingrese equipo local: \n"
textVisitante:	.asciiz "Ingrese equipo visitante: \n"
textMarcadorL:	.asciiz "Ingrese el marcador del equipo local: \n"
textMarcadorV:	.asciiz "Ingrese el marcador del equipo visitante: \n"

salto:      .byte '\n'
coma:	    .byte ','
menos:      .byte '-'



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

		#Processing File
		jal readFile
		
		#Make Buffer File
		jal saveFile
		
		#Opening a file
	Save:	li $v0, 13
		la $a0, file2
		li $a1, 1
		syscall
		move $s0, $v0	
		
		li $v0, 15
		move $a0, $s0
		la $a1, buffer
		li $a2, 512
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
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		la $s1, buffer			#File Buffer
		la $s2, teams			#Teams Array
		la $s6, matrix			#Matrix
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
		la $a0, ($s1)			#Guarda en el argumento, la referencia a los caracteres
	
	contarCaracteres:
		beq $t0, $s3, guardar		#preguntar si es una coma
		beq $t0, $s5, guardarLin	#preguntar si es un salto de linea
		beq $t0, $zero, guardar		#pretuntar si ya acabo el buffer
		addi $t2, $t2, 1		#Cuento un caracter mas
		addi $s1, $s1, 1		#Muevo el buffer
		lb $t0, ($s1)
		j contarCaracteres
	
	guardarLin:
		li $t1, 0			#Si encontro una linea, hace el flag 0 
		addi $t2, $t2, -1		#Se quita un caracter, porque por algun motivo el salto de linea tiene 2 caracteres,
						#pero el codigo ascii solo reconoce uno jeje
	guardar:
		add $a2, $t2, $zero		#ingresa el argumento
		jal stringToInt			#llama a la funcion
		
		sll $t9, $s7, 2			#Alinea los elementos
		add $t9, $t9, $s6
		sw $v0, 0($t9)			#Guarda los puntos
		addi $s7, $s7, 1
		j continue
		
	lin:	li $t1, 0 			#Cuando hay un salto de linea, el flag pasa a 0
	
     continue:  
     		beq $t0, $zero, rfend			
		addi $s1,$s1,1			#Se aumenta el indice del buffer
		j Loop
		
		
		
	rfend:					#Guarda la coma y cambia el flag para no guardar
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra

	
saveFile:
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		la $s1, matrix
		la $t0, ($s1)
		la $t1, buffer
		
	byte:
		lw $a0, ($t0)
		jal IntToString
		
	guardarAscii:
		addi $t3, $t0, -512
		beq $t3, $s1, readReturn
		beq $v1, 0, readReturn
		sb  $v0, ($t1)
		addi $t1, $t1, 1
		addi $v1, $v1, -1
		j guardarAscii
		
	readReturn:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
		
		
serch:		#Retorna el indicice del equipo - a0 equipo - v0 indice
		addi $sp, $sp, -24
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $t5, 20($sp)
		
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
		
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)
		addi $sp, $sp, -24
		jr $ra				#Salida de la funcion
		
stringToInt:	#Recibe en a0 el puntero al buffer y $a2 la cantidad de caracteres 
		#Retorna en v0 el int.

		#la $a1, input
		#la $a1, $a0
		#lw $a1, 0($a1)
		
		#add $t0, $zero, $a0
		#lb $a0, 0($t0)
		
		#Reserva
		addi $sp, $sp, -16
		sw $t6, 0($sp)
		sw $t7, 4($sp)
		sw $t8, 8($sp)
		sw $t9, 12($sp)
		
		lb $t9, menos				#cargo el menos
		lb $t8, 0($a0)				#cargo la direccion del buffer
		li $t7, 0
		li $t6, 0				#flag si el numero es negativo
		
		bne $t8, $t9, positive			#veo si es positivo o negativo
		li $t6, 1				#flag si es negativo
		addi $a0, $a0, 1			#aumento el buffer
		addi $a2, $a2, -1
		lb $t8, 0($a0)				#cargo el siguiente byte
		
	positive:
		beq $a2, 2, int2			#veo si tiene dos caracteros
		beq $a2, 1, int1			#si tiene un caracter
		
	int2:	addi $t7, $t8, -48			#resto -48 para sacar el numero
		mul $t7, $t7, 10 			#multiplico por 10 (base decimal)
		addi $a0, $a0, 1			#aumento el buffer
		lb $t8, 0($a0)				#cargo el siguiente byte
	int1:	
		addi $t8, $t8, -48			#resto 48 para sacar el numero
		add $t7, $t7, $t8			#sumo al numero anterior. si no habia, es 0
		#move $a0, $s0			
	
		bne $t6, 1, ret				#aqui debe de convertirse el numero a negativo.
		not $t7, $t7
		addi $t7, $t7, 1
		
	ret:	move $v0, $t7				#retorno
		
		lw $t6, 0($sp)
		lw $t7, 4($sp)
		lw $t8, 8($sp)
		lw $t9, 12($sp)
		addi $sp, $sp, 16
		
		jr $ra
		
IntToString:	#Recibe en a0 el numero y retorna en v0 la direccion al caracter en ascii y v1 la cantidad de caracteres.
		#Reserva
		addi $sp, $sp, -16
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t6, 12($sp)
		
		la $v0, string
		li $v1, 0
		li $t1, 10
		la $t2, menos
		bge $a0, 0, positivo
		
		sb $t2, ($v0)			#Si es negativo, guardo el caracter menos al principio
		addi $v0, $v0, 1
		addi $v1, $v1, 1
		
		addi $a0, $a0, -1		#Convieto el numero a positivo y lo trabajo como positivo
		not $a0, $a0
		
		
	positivo:
		blt $a0, 10, caract1		#si es menor a 10 solo tiene un caracter
		div $a0, $t6			#si es mayor se divide para 10
		mfhi $t2			#sacamos el modulo
		mflo $a0			#sacamos el residuo y lo guardamos para ser procesado por caract1
		
		addi $t2, $t2, 48		#al modulo le sumamos 48 para sacar el ascii
		sb $t2, ($v0)			#guardamos el primer caracter
		addi $v0, $v0, 1		#aumento el buffer
		addi $v1, $v1, 1		#aumento los caracteres
		
	caract1:
		addi $t0, $a0, 48		#al residuo le sumo 48 para sacar el ascii
		sb $t0, ($v0)			#guardo el ultimo carcater
		addi $v0, $v0, 1		#aumento el buffer
		addi $v1, $v1, 1		#aumento los caracteres
		
	IReturn:
		la $v0, string			#recupero el inicio del buffer
		
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t6, 12($sp)
		addi $sp, $sp, 16
		
		jr $ra				#retorno la funcion
		
		
		
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
