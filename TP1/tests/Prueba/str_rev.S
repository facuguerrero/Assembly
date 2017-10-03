#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 48

	.text
	.align	2

	.globl	str_rev
	.ent	str_rev
str_rev:
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
  beqz	t0, stringreverse
  addiu	a0, a0, 1
  addiu	v0, v0, 1
  j	mystrlen_loop

stringreverse:
  lw a0, ARG0_POS($fp) #load address
  add t0, a0, zero   #starting address
  addi t1, v0, -1     #j = length-1
  add t5, v0, zero #Largo del loop
  la t6, string_space #cargamos puntero en t6

loop:
  beqz t5, return #condicion de loop
  subu t5, t5, 1 #resta de variable de loop
  add t2, t0, t1 #carga de direccion s[j]
  lb t3, 0(t2)   #the lb string[j]
  sb t3, 0(t6)   #dest[i] = src[j]
  addi t1, t1, -1     #j--
  addiu t6, t6, 1 #Avanza en el string a escribir

  j loop

return:
  la v0, string_space #cargar en return direccion del string
	lw    gp, 36(sp)
  lw    $fp, 40(sp)
  lw    ra, 44(sp)
  addu  sp, sp, 48
  jr ra

	.end str_rev
	.data
string_space: .space 128
