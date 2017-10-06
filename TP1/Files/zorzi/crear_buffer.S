#include <mips/regdef.h>
#define TAM_SF 32
#define FP_SF 16
#define GP_SF 20
#define RA_SF 24
#define ARG0 32

.text
.abicalls
.align 2

.globl crear_buffer
.ent crear_buffer

crear_buffer:
	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	sw ra, RA_SF(sp)
	move $fp, sp
	
	sw a0, ARG0($fp)               #Guardamos el tamanio del buffer

    la t9, mymalloc                    
    jalr t9                        #Llama a malloc

return:							
    lw ra, RA_SF($fp)			
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

.end crear_buffer
.size crear_buffer,.-crear_buffer
