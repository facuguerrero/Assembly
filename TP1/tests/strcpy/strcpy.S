#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 32

	.text
	.align	2

	.globl	str_cpy
	.ent	str_cpy
str_cpy:
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

	# Guardo el argumento
	sw	a0, ARG0_POS($fp)	# Puntero al string

  li	v0, 0
mystrlen_loop:
  lb	t0, 0(a0)
  beqz	t0, lowering
  addiu	a0, a0, 1
  addiu	v0, v0, 1
  j	mystrlen_loop

lowering:
	la t6, string_space
  add t5, zero, v0 #largo del loop
  lw a0, ARG0_POS($fp)

  li v0, 0
loop:
  beqz t5, return
  subu t5, t5, 1
  j copy

copy:
  lb t0, 0(a0) #caracter actual en t0
	sb t0, 0(t6)
  addiu a0, a0, 1
  addiu t6, 1

  j loop

return:
	sb zero, 0(t6) #terminar string '\0'
	la v0, string_space #cargar en return direccion del string
  move	sp, $fp
  lw	ra, 44(sp)
  lw	$fp, 40(sp)
  addu	sp, sp, 48
  j	ra

	.end str_cpy

	.data
string_space: .space 128
