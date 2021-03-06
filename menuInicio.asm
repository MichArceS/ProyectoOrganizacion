
.data 

buffer:     .space 1024
buffer2:    .space 1024
savebuffer: .space 1024
matrix:	    .space 512
teams:	    .space 512
encabezado: .space 1024
team:       .space 32
temp:       .space 32
temp2:	    .space 32
string:     .space 4
numChars:   .word 6

text1:      .asciiz "\nBienvenido!\n"
text2:      .asciiz "Selecciona una opcion: \n"
text3:	    .asciiz "1) Tabla de posiciones\n"
text4:      .asciiz "2) Ingresar partido\n"
text5:      .asciiz "3) Mostrar Top 3\n"
text6:	    .asciiz "4) Salir\n"
text7: 	    .asciiz "Ingrese: \n"
textErr:    .asciiz "El equipo no existe\n"
file1:      .asciiz "C:\\Users\\User\\Desktop\\Trabajos Espol\\Quinto Semestre\\Organizaci�n de Computadores\\Proyecto\\ProyectoOrganizacion\\TablaIni.txt"
file2:      .asciiz "C:\\Users\\User\\Desktop\\Trabajos Espol\\Quinto Semestre\\Organizaci�n de Computadores\\Proyecto\\ProyectoOrganizacion\\ingreso.txt"

file3:	    .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\TablaIni.txt"
file4:      .asciiz "D:\\Universidad\\5 Semestre\\Organizacion de Computadores\\Proyecto 1P\\ProyectoOrganizacion\\ingreso.txt"



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
	fileReading:
		#Opening a file
		li $v0, 13
		la $a0, file3
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
		jal bubbleSort
		
	#Menu
	menu:
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
		j Save
	case2:
		li $v0, 4
		la $a0, text4
		syscall
		j enterMatch
	case3:
		li $v0, 4
		la $a0, text5
		syscall
		j SaveTop3
	case4:
		li $v0, 4
		la $a0, text6
		syscall
		j Exit
		
		#Make Buffer File
	Save:	jal saveFile
		
		#Opening a file
		li $v0, 13
		la $a0, file4
		li $a1, 1
		syscall
		move $s0, $v0	
		
		li $v0, 15
		move $a0, $s0
		la $a1, savebuffer
		li $a2, 512
		syscall
		
		#Closing the file
		li $v0, 16
		move $a0, $s0
		syscall
		
		li $v0, 4
		la $a0, savebuffer
		syscall
		
		j menu
	
	ordenar:
		li $a0, 0
		li $a1, 4
		jal intercambio
Exit:
	li $v0, 10
	syscall
	
	
	

readFile:
		#Reservar
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		la $s1, buffer			#File Buffer
		la $s2, teams			#Teams Array
		li $t8, 0			#Index of teams
		la $s6, matrix			#Matrix
		li $t1, 0 			# Linea Flag - Indica si ya se encontro la primera coma.
		la $t7, encabezado		#encabezado buffer
		li $t9, 0			# Encabezado flag
		lb $s3, coma			
		lb $s5, salto		
		li $s7, 0
		
		
	 	
	Loop:	lb $t0, 0($s1)			#carga el caracter

		beq $t0, $zero, rfend 		#Se verifica que se acabo el string
		beq $t9, $zero, encab	 	#si es la primera linea se guarda el encabezado
		beq $t1, 1, points 		#Si ya hubo una coma, pasa a guardar los puntos
		beq $t0, $s3, com		#Se verifica si es una coma
		
		sb $t0, 0($s2)			#Guarda el caracter
		addi $s2,$s2, 1			#Se aumenta el indice del array de equipos
		j continue
		
	encab: 	
		beq $t0, $s5, gSalto		#al primer salto de linea cambia.
		lb $t0, 0($s1)
		sb $t0, 0($t7)
		addi $s1,$s1, 1
		addi $t7, $t7, 1
		j encab
	gSalto:	
		li $t9, 1
		addi $s1, $s1, -1
		j continue
		
	com:	li $t1, 1			#Cuando encuentra la primera coma e flag pasa a 1.
	
		sb $t0, 0($s2)			#se agrega una coma al array de equipos
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
		la $s2, teams
		addi $t8, $t8, 32
		add $s2, $s2, $t8
		
	guardar:
		add $a2, $t2, $zero		#ingresa el argumento
		jal stringToInt			#llama a la funcion
		
		sll $t9, $s7, 2			#Alinea los elementos
		add $t9, $t9, $s6
		sw $v0, 0($t9)			#Guarda los puntos
		addi $s7, $s7, 1
		j continue

			
     continue:  
     		beq $t0, $zero, rfend			
		addi $s1,$s1,1			#Se aumenta el indice del buffer
		j Loop
		
	rfend:					#Guarda la coma y cambia el flag para no guardar
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra

	
saveFile:
		addi $sp, $sp, -16
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t3, 12($sp)
		
		
		la $s1, matrix
		la $s2, teams
		li $t8, 0 
		la $t0, ($s1)
		la $t1, savebuffer
		lb $s3, coma
		lb $s4, salto
		li $t6, 0
		
		la $t7, encabezado
	aggEncabezado:
		lb $t2, ($t7)
		beq $t2, $s4, tim1
		sb $t2, ($t1)
		addi $t7, $t7, 1
		addi $t1, $t1, 1
		j aggEncabezado
		
		
	tim1:
		li $t6, 0				#contador
		addi $t3, $t0, -512			
		beq $t3, $s1, readReturn
		sb $s4, ($t1)
		addi $t1, $t1, 1
	tim:
		lb $t5, ($s2)
		beq $t5, $s3, comma
		beq $t5, $zero, readReturn
		sb  $t5, ($t1)
		addi $t1, $t1, 1
		addi $s2, $s2, 1
		j tim
	
	comma:	
		sb $s3, ($t1)
		addi $t1, $t1, 1
		addi $t6, $t6, 1
		addi $t8, $t8, 32
		la $s2, teams
		add $s2, $s2, $t8
	byte:
		
		beq $t6, 9, tim1
		lw $a0, ($t0)
		jal IntToString				
		
	guardarAscii:
		addi $t3, $t0, -516			
		beq $t3, $s1, readReturn		#Identifica si termino de recorrer la matriz
		beq $v1, 0, cont			#Si ya no hay caracteres por reccorrer
		lb $t2, ($v0)				#cargo el byte
		sb  $t2, ($t1)				#Guarda los caracteres ascii de la string
		addi $t1, $t1, 1			#Aumenta el buffer
		addi $v0, $v0, 1
		addi $v1, $v1, -1			#resta el caracter
		j guardarAscii
	
	cont:
		
		sb $s3, ($t1)
		addi $t1, $t1, 1
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		j byte
	
	readReturn:
		sb $s4, ($t1)
		addi $t1, $t1, 1
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t3, 12($sp)
		addi $sp, $sp, 16
		
		jr $ra
		
		
serch:		#Retorna el indicice del equipo - a0 equipo - v0 indice
		addi $sp, $sp, -24
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $t5, 20($sp)
		
		li $t0, 0			#indice
		la $t1, teams
		lb $t3, coma
		
		
	ingreso:	
		la $t2, ($a0)			#Carga la direccion del  ingreso
		sll $t6, $t0, 5
		add $t6, $t6, $t1
		
	stringCmp:				#Compara byte por byte el nombre
		
		lb $t4, ($t6)   		#Carga byte de equipo
		lb $t5, ($t2)			#Carga byte de ingreso
		bne $t4, $t5, out		#Si no son iguales sale
		addi $t6, $t6, 1
		addi $t2, $t2, 1
		j stringCmp			
	out:
		bne $t4, $t3, next		#Primero valida si la salida fue por por la compa, si no continua.
		move $v0, $t0 			#Si la salida fue por la coma, quiere decir que todo el nombre es igual. Retorna el indice
		j sReturn			#Sale de la funcion 
		
	next:					#En el caso de que no haya sigo por una coma. continua recorriendo los equipos
		addi $t0, $t0, 1		#Como avanza a un nuevo equipo, el indice aumenta 1.
		bge $t0, 16, sReturnN		#Si el buffer ya llego al final, sale de la funcion retornando -1.
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
		sw $zero, ($v0)
		li $v1, 0
		li $t1, 10
		lb $t2, menos
		bge $a0, 0, positivo
		
		sb $t2, ($v0)			#Si es negativo, guardo el caracter menos al principio
		addi $v0, $v0, 1
		addi $v1, $v1, 1
		
		addi $a0, $a0, -1		#Convieto el numero a positivo y lo trabajo como positivo
		not $a0, $a0
		
		
	positivo:
		blt $a0, 10, caract1		#si es menor a 10 solo tiene un caracter
		div $a0, $t1			#si es mayor se divide para 10
		mfhi $a0			#sacamos el modulo
		mflo $t2			#sacamos el residuo y lo guardamos para ser procesado por caract1
		
		addi $t2, $t2, 48		#al modulo le sumamos 48 para sacar el ascii
		sb $t2, ($v0)			#guardamos el primer caracter
		addi $v0, $v0, 1		#aumento el buffer
		addi $v1, $v1, 1		#aumento los caracteres
		
	caract1:
		addiu $a0, $a0, 48		#al residuo le sumo 48 para sacar el ascii
		sb $a0, ($v0)			#guardo el ultimo carcater
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
		
		la $a0, buffer
		li $v0, 8
		syscall
		
		move $v0, $a0
		jal serch
		
		move $t0, $v0 #$t0 -> indice del equipo local
		
		blt $t0, $zero, errorEquipos #Comprobar si el equipo existe

		li $v0, 4
		la $a0, textVisitante
		syscall
	
		la $a0, buffer
		li $v0, 8
		syscall
		
		move $v0, $a0
		jal serch
		
		move $t1, $v0 #$t1 -> indice del equipo visitante
		
		blt $t1, $zero, errorEquipos #Comprobar si el equipo existe

		li $v0, 4
		la $a0, textMarcadorL
		syscall 
	
		li $v0, 5
		syscall
		move $t2, $v0 #$t2 -> goles del equipo local
			
		li $v0, 4
		la $a0, textMarcadorV
		syscall
		
		li $v0, 5
		syscall
		move $t3, $v0 #$t3 -> goles del equipo visitante
		
		#Bloque switch

		blt $t3, $t2, localGanador
		blt $t2, $t3, visitanteGanador
		j empate

		localGanador:
			add $t4, $zero, $t3
			add $t5, $zero, $t2
			add $t6, $zero, $t1
		
			move $a0, $t0
			move $a1, $t2
			move $a2, $t3
			jal winner

			move $a0, $t6
			move $a1, $t4
			move $a2, $t5
			jal looser
			j exitEnterMatch
		
		visitanteGanador:
			add $t4, $zero, $t2
			add $t5, $zero, $t3
			add $t6, $zero, $t0
		
			move $a0, $t1
			move $a1, $t3
			move $a2, $t2
			jal winner

			move $a0, $t6
			move $a1, $t4
			move $a2, $t5
			jal looser
			j exitEnterMatch
		
		empate:
			add $t4, $zero, $t3
			add $t5, $zero, $t2
			add $t6, $zero, $t1
		
			move $a0, $t0
			move $a1, $t2
			move $a2, $t3
			jal tie

			move $a0, $t6
			move $a1, $t4
			move $a2, $t5
			jal tie
			j exitEnterMatch

		errorEquipos:
			li $v0, 4
			la $a0, textErr
			syscall

		exitEnterMatch: 
			add $v0, $zero, $zero
			add $a0, $zero, $zero
			add $a1, $zero, $zero
			add $a2, $zero, $zero
			add $t0, $zero, $zero
			add $t1, $zero, $zero
			add $t2, $zero, $zero
			add $t3, $zero, $zero
			jal bubbleSort
			j Save
			
winner:	# $a0 -> indice, $a1 -> goles a favor, $a2 -> goles en contra
		la $t9, matrix
		
		#cargar direcci�n de los puntos
		mul $t0, $a0, 8
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 3	#sumar tres puntos
		sw  $t1, 0($t0) 
		
		#cargar direcci�n de los partidos jugados
		mul $t0, $a0, 8
		addi $t0, $t0, 1
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 1	#aumentar partidos jugados
		sw  $t1, 0($t0)
		
		#cargar direcci�n de los partidos ganados
		mul $t0, $a0, 8
		addi $t0, $t0, 2
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 1	#aumentar partidos ganados
		sw  $t1, 0($t0)
		
		#cargar direcci�n de goles a favor
		mul $t0, $a0, 8
		addi $t0, $t0, 5
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a1	#aumentar goles
		sw  $t1, 0($t0)
		add $t2, $t1, $zero
		
		#cargar direcci�n de goles en contra
		mul $t0, $a0, 8
		addi $t0, $t0, 6
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a2	#aumentar goles
		sw  $t1, 0($t0)
		add $t3, $t1, $zero
		
		#cargar direcci�n de diferencia de goles
		mul $t0, $a0, 8
		addi $t0, $t0, 7
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		
		sub $t1, $t2, $t3	#restar a favor y en contra
		sw  $t1, 0($t0)
		
		add $v0, $zero, $zero
		add $a0, $zero, $zero
		add $a1, $zero, $zero
		add $a2, $zero, $zero
		add $t8, $zero, $zero
		add $t9, $zero, $zero
		add $t0, $zero, $zero
		add $t1, $zero, $zero
		add $t2, $zero, $zero
		add $t3, $zero, $zero
				
		jr $ra

looser:	#$a0 -> indice, $a1 -> goles a favor, $a2 -> goles en contra
		la $t9, matrix
		
		#cargar direcci�n de los partidos jugados
		mul $t0, $a0, 8
		addi $t0, $t0, 1
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 1	#aumentar partidos jugados
		sw  $t1, 0($t0)
		
		#cargar direcci�n de los partidos perdidos
		mul $t0, $a0, 8
		addi $t0, $t0, 4
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 1	#aumentar partidos perdidos
		sw  $t1, 0($t0)
		
		#cargar direcci�n de goles a favor
		mul $t0, $a0, 8
		addi $t0, $t0, 5
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a1	#aumentar goles
		sw  $t1, 0($t0)
		add $t2, $t1, $zero
		
		#cargar direcci�n de goles en contra
		mul $t0, $a0, 8
		addi $t0, $t0, 6
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a2	#aumentar goles
		sw  $t1, 0($t0)
		add $t3, $t1, $zero
		
		#cargar direcci�n de diferencia de goles
		mul $t0, $a0, 8
		addi $t0, $t0, 7
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		
		sub, $t1, $t2, $t3	#restar a favor y en contra
		sw  $t1, 0($t0)
		
		add $v0, $zero, $zero
		add $a0, $zero, $zero
		add $a1, $zero, $zero
		add $a2, $zero, $zero
		add $t8, $zero, $zero
		add $t9, $zero, $zero
		add $t0, $zero, $zero
		add $t1, $zero, $zero
		add $t2, $zero, $zero
		add $t3, $zero, $zero
		
		jr $ra
		
tie:	##$a0 -> indice, $a1 -> goles a favor, $a2 -> goles en contra
		la $t9, matrix

		#cargar direcci�n de los puntos
		mul $t0, $a0, 8
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0) 
		
		addi, $t1, $t8, 1	#sumar un puntos
		sw  $t1, 0($t0)
		
		#cargar direcci�n de los partidos jugados
		mul $t0, $a0, 8
		addi $t0, $t0, 1
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi, $t1, $t8, 1	#aumentar partidos jugados
		sw  $t1, 0($t0)
		
		#cargar direcci�n de goles a favor
		mul $t0, $a0, 8
		addi $t0, $t0, 5
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a1	#aumentar goles
		sw  $t1, 0($t0)
		add $t2, $t1, $zero
		
		#cargar direcci�n de goles en contra
		mul $t0, $a0, 8
		addi $t0, $t0, 6
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		add, $t1, $t8, $a1	#aumentar goles
		sw  $t1, 0($t0)
		add $t2, $t1, $zero
		
		#cargar direcci�n de los partidos empatados
		mul $t0, $a0, 8
		addi $t0, $t0, 3
		mul $t0, $t0, 4
		add $t0, $t0, $t9
		lw $t8, 0($t0)
		
		addi $t1, $t8, 1	#aumentar partidos empatados
		sw  $t1, 0($t0)
				
		add $v0, $zero, $zero
		add $a0, $zero, $zero
		add $a1, $zero, $zero
		add $a2, $zero, $zero
		add $t8, $zero, $zero
		add $t9, $zero, $zero
		add $t0, $zero, $zero
		add $t1, $zero, $zero
		add $t2, $zero, $zero
		add $t3, $zero, $zero
		
		jr $ra

intercambio:	#Funcion que intercambia elementos del los arreglos, a0 Indice 1 y a1 indice 2.
		addi $sp, $sp, -32
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $s1, 16($sp)
		sw $s2, 20($sp)
		sw $s3, 24($sp)
		sw $ra, 28($sp)
		
		la $s1, temp
		la $s4, temp2
		
		la $s2, matrix
		la $s3, teams
		li $t0, 0
	
		mul $t1, $a0, 32
		add $t1, $s2, $t1
		
		mul $t4, $a0, 32
		add $t4, $s3, $t4
	
	l1:	beq $t0, 32, ll2
		lb $t2, ($t1)
		lb $t5, ($t4)
		sb $t2, ($s1)
		sb $t5, ($s4)
		addi $t1, $t1, 1
		addi $t4, $t4, 1
		addi $s1, $s1, 1
		addi $s4, $s4, 1
		addi $t0, $t0, 1
		j l1
		
	ll2: 	li $t0, 0	
	
		mul $t1, $a0, 32
		add $t1, $s2, $t1
		
		mul $t2, $a1, 32
		add $t2, $s2, $t2
		
		mul $t4, $a0, 32
		add $t4, $s3, $t4
		
		mul $t5, $a1, 32
		add $t5, $s3, $t5
		
	l2:	beq $t0, 32, ll3
		lb $t3, ($t2)
		lb $t6, ($t5)
		sb $t3, ($t1)
		sb $t6, ($t4)
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		addi $t5, $t5, 1
		addi $t0, $t0, 1
		j l2
	
	ll3:	li $t0, 0	
	
		la $s1, temp
		la $s4, temp2
			
		mul $t2, $a1, 32
		add $t2, $s2, $t2
		
		mul $t4, $a1, 32
		add $t4, $s3, $t4
	
	l3:	beq $t0, 32, interReturn
		lb $t3, ($s1)
		lb $t5, ($s4)
		sb $t3, ($t2)
		sb $t5, ($t4)
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		addi $s1, $s1, 1
		addi $s4, $s4, 1
		addi $t0, $t0, 1
		j l3
		
	interReturn:
	
		
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		addi $sp, $sp, 28
		jr $ra
	
		
	
bubbleSort:  #Funcion que ordena la matriz 	
		
		#Reseverva
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		li $s1, 16			#n
		li $t0, 0 			#i
		la $s0, matrix			#matriz
		
	for1: 	
		bge $t0, $s1, end 	
		addi $t1, $t0, 1		#j = i+1
	for2:	
		bge $t1, $s1, cont1
		
		mul $t4, $t0, 32
		add $t4, $t4, $s0
		lw $s2, 0($t4)
		
		mul $t4, $t1, 32
		add $t4, $t4, $s0
		lw $s3, 0($t4)
	
		blt $s3, $s2, cont2
		
		add $a0, $zero, $t0
		add $a1, $zero, $t1
		
		jal intercambio
	
	cont2:	addi $t1, $t1,1
		j for2
		
	cont1:	addi $t0, $t0, 1
		j for1
		 
	end:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra

saveTop3:
		addi $sp, $sp, -16
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t3, 12($sp)
		
		la $s1, matrix
		la $s2, teams
		li $t8, 0 
		la $t0, ($s1)
		la $t1, buffer2
		lb $s3, coma
		lb $s4, salto
		li $t6, 0
		li $s7, 0
		j timTop3
		
	tim1Top3:
		li $t6, 0				#contador
		sb $s4, ($t1)
		addi $t1, $t1, 1
		
	timTop3:
		lb $t5, ($s2)
		beq $t5, $s3, commaTop3
		beq $t5, $zero, readReturnTop3
		sb  $t5, ($t1)
		addi $t1, $t1, 1
		addi $s2, $s2, 1
		j timTop3
	
	commaTop3:	
		sb $s3, ($t1)
		addi $t1, $t1, 1
		addi $t6, $t6, 1
		addi $t8, $t8, 32
		la $s2, teams
		add $s2, $s2, $t8
		
	byteTop3:
		
		beq $t6, 9, tim1Top3
		lw $a0, ($t0)
		jal IntToString				
		
	guardarAsciiTop3:
		addi $t3, $t0, -516
		beq $t3, $s1, readReturnTop3		#Identifica si termino de recorrer la matriz
		beq $v1, 0, contTop3			#Si ya no hay caracteres por reccorrer
		lb $t2, ($v0)				#cargo el byte
		sb  $t2, ($t1)				#Guarda los caracteres ascii de la string
		addi $t1, $t1, 1			#Aumenta el buffer
		addi $v0, $v0, 1
		addi $v1, $v1, -1			#resta el caracter
		j guardarAsciiTop3
	
	contTop3:
		
		sb $s3, ($t1)
		addi $t1, $t1, 1
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		addi $s7, $s7, 1
		beq $s7, 24, readReturnTop3
		j byteTop3
	
	readReturnTop3:
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t3, 12($sp)
		addi $sp, $sp, 16
		
		jr $ra
		
SaveTop3:	
		jal bubbleSort
		
		jal saveTop3
		
		#Opening a file
		li $v0, 13
		la $a0, file2
		li $a1, 1
		syscall
		move $s0, $v0	
		
		li $v0, 15
		move $a0, $s0
		la $a1, buffer2
		li $a2, 512
		syscall
		
		#Closing the file
		li $v0, 16
		move $a0, $s0
		syscall
		
		li $v0, 4
		la $a0, buffer2
		syscall
		
		j menu
