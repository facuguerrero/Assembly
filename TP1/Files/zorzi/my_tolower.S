#include <mips/regdef.h>
#define TAM_SF 24
#define FP_SF 16
#define GP_SF 20
#define ARG0 24
#define ASCII_A_MAY 65
#define ASCII_Z_MAY 90
#define DIF_MAY_MIN 32

.text
.abicalls
.align 2

.globl my_tolower
.ent my_tolower

my_tolower:
	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	move $fp, sp

	sw a0, ARG0($fp)                   #Guardamos el caracter
	
	blt a0, ASCII_A_MAY, return        #Salta si caracter es menor a A
	bgt a0, ASCII_Z_MAY, return        #Salta si caracter es mayor a Z
	addiu a0, a0, DIF_MAY_MIN          #Convierte a minuscula
	
return:
	move v0, a0                        #Pone el resultado en v0
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra
	
.end my_tolower
.size my_tolower,.-my_tolower 
