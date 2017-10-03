#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 48
#define ARG1_POS 52

	.text
	.align	2

	.globl	equals
	.ent	equals
equals:
	.frame $fp, 48, ra
	.set    noreorder
	.cpload t9
	.set    reorder
	subu    sp, sp, 48

	.cprestore 32
	sw  ra, 44(sp)
	sw  $fp, 40(sp)
	sw  gp, 36(sp)
	move    $fp, sp

	# Guardo los argumentos
	sw	a0, ARG0_POS($fp)	# Puntero al string 1
	sw	a1, ARG1_POS($fp)	# Puntero al string 2

compare:
  # Verificamos si dos caracteres son iguales
  lw a0, ARG0_POS($fp) # a0: char1
  lw a1, ARG1_POS($fp) # a1: char2
  subu t1, a0, a1 #resta de los chars
  beq t1, zero, eqs #salta a iguales

not_eq:
  move v0, zero # Se devuelve cero si no son iguales
  b return # Salto al fin

eqs:
  li t2, 1 # Se devuelve uno en caso de igualdad
  move v0, t2

return:

	lw    gp, 36(sp)
	lw    $fp, 40(sp)
	lw    ra, 44(sp)
	addu  sp, sp, 48
	jr ra

	.end	equals
