#include <mips/regdef.h>
#define TAM_SF 40
#define S0_SF 24
#define FP_SF 28
#define GP_SF 32
#define RA_SF 36
#define ARG0 40
#define ARG1 44
#define ARG2 48
#define NEW_POINTER 16

.text
.abicalls
.align 2

.globl myrealloc
.ent myrealloc

myrealloc:							
	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
	sw s0, S0_SF(sp)
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	sw ra, RA_SF(sp)
	move $fp, sp
	
	sw a0, ARG0($fp)             # guardamos el puntero
	sw a1, ARG1($fp)             # guardamos el tamanio del bloque
    sw a2, ARG2($fp)             # guardamos el tamanio a agregar

	addu a0, a1, a2				 #a0 = nuevo tamanio bloque
	la t9, mymalloc
	jalr t9						 #Llama a malloc
	beq v0, zero, return		 #Si devuelve cero ocurrio un error
	
	sw v0, NEW_POINTER($fp)		 #Guardamos el puntero nuevo
	addu s0, zero, zero			 #s0 = indice actual
	
loop:
	lw t0, ARG1($fp)			 #t0 = tamanio original
	bgeu s0, t0, terminar		 #salta si ya copio todo
	
	lw t0, ARG0 ($fp)			 #t0 = puntero viejo
	addu t0, t0, s0				 #t0 = puntero viejo + indice
	
	lw t1, NEW_POINTER($fp)		 #t1 = puntero nuevo
	addu t1, t1, s0				 #t1 = puntero nuevo + indice
	
	lbu t2, 0(t0)				 #Cargo el byte a copiar en t2
	sb t2, 0(t1)				 #Guardo el byte
	
	addiu s0, s0, 1				 #incremento el indice
	b loop						 #Vuelve al loop
	
terminar:
	lw a0, ARG0($fp)			 #a0 = puntero viejo
	la t9, myfree
	jalr t9						 #Libera el puntero viejo
	lw v0, NEW_POINTER($fp)		 #v0 = puntero nuevo
	
return:
	lw s0, S0_SF($fp)
	lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra
	
.end myrealloc
.size myrealloc,.-myrealloc 
