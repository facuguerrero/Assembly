#include <mips/regdef.h>
#define TAM_SF 48
#define S0_SF 24
#define S1_SF 28
#define FP_SF 32
#define GP_SF 36
#define RA_SF 40
#define ARG0 48
#define ARG1 52
#define CHAR1 16
#define CHAR2 20

.text
.abicalls
.align 2

.globl es_capicua
.ent es_capicua

es_capicua:
	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
    sw s0, S0_SF(sp)
    sw s1, S1_SF(sp)
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	sw ra, RA_SF(sp)
	move $fp, sp
	
	sw a0, ARG0($fp)          	# Guardamos el puntero a la palabra 
	sw a1, ARG1($fp)          	# Guardamos la longitud 

	beq a1, zero, return_false  #Si len es 0 devuelve false
	
	addu s0, zero, zero         #Inicializamos la variable inicio
	subu s1, a1, 1              #Inicializamos la variable final

loop:
	lw t0, ARG0($fp)          	#Recuperamos el puntero a la palabra
    addu t0, t0, s0         	#t0 = palabra + inicio
	lbu a0, 0(t0)           	# Leemos el  caracter palabra[inicio]
	la t9, my_tolower       
	jalr t9              	    #Llamamos a tolower() con el caracter
	sw v0, CHAR1($fp)           #Guardamos el caracter en minuscula
	lw a0, ARG0($fp)            #Recuperamos el puntero a la palabra
    addu t0, a0, s1             #t0 = palabra + final
	lbu a0, 0(t0)	            #Leemos el  caracter palabra[final]
	la t9, my_tolower
	jalr t9              	    #Llamamos a tolower() con el caracter
	sw v0, CHAR2($fp)           #Guardamos el caracter en minuscula
	move t0, v0                 #t0 = segundo caracter
	lw t1, CHAR1($fp)           #t1 = primer caracter
	bne t0, t1, return_false    #Si son distintos devuelve false

	addiu s0, s0, 1             #Suma uno (un byte) a inicio
	subu s1, s1, 1              #Resta uno (un byte) a final
	blt s0, s1, loop		    #Si inicio < final vuelve al loop

return_true:
	addiu v0, zero, 1
	b return

return_false:
	addu v0, zero, zero

return:
	lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
    lw s1, S1_SF($fp)
    lw s0, S0_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

.end es_capicua
.size es_capicua,.-es_capicua
