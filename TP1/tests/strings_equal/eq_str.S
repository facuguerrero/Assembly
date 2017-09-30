#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 32
#define ARG1_POS 36

	.text
	.align	2

	.globl	equal_str
	.ent	equal_str
equal_str:
	.frame $fp, 48, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 48

	.cprestore 32
	sw	ra, 44(sp)
	sw	$fp, 40(sp)
	sw	gp, 36(sp)
	move	$fp, sp

	# Guardo los argumentos
	sw	a0, ARG0_POS($fp)	# Puntero al string 1
	sw	a1, ARG1_POS($fp)	# Puntero al string 2

  li	v0, 0
mystrlen_loop:
  lb	t0, 0(a0)
  beqz	t0, comparing
  addiu	a0, a0, 1
  addiu	v0, v0, 1
  j	mystrlen_loop

comparing:
  add t3, zero, v0 #largo del loop
  lw a0, ARG0_POS($fp)
  lw a1, ARG1_POS($fp)
loop:
  beqz t3, eqs
  subu t3, t3, 1
  j compare

compare:
  lb t0, 0(a0) #cargamos el puntero
  lb t1, 0(a1) #primeros 4 bytes del char 2
  subu t2, t0, t1 #resta de los chars
  bnez t2, not_eq #salta a iguales
  addiu a0, a0, 1
  addiu a1, a1, 1
  j loop

not_eq:
  move v0, zero # Se devuelve cero si no son iguales
  b return # Salto al fin

eqs:
  li t2, 1 # Se devuelve uno en caso de igualdad
  move v0, t2

return:
  move	sp, $fp
  lw	ra, 44(sp)
  lw	$fp, 40(sp)
  addu	sp, sp, 48
  j	ra

	.end	equal_str
