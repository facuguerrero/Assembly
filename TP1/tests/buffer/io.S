#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 48
#define ARG1_POS 52
#define BUFFER_POS 56

	.text
	.align	2

	.globl	read_write
	.ent	read_write
read_write:
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
	sw	a0, ARG0_POS($fp)	# Guardo en $fp + ARG0_POS a0, que es el file descriptor del stream
	sw	a1, ARG1_POS($fp)	# Guardo en $fp + ARG1_POS a1, que es el tamaño del buffer

	lw a0, ARG1_POS($fp) #tam del buffer como size
	lw t9, mymalloc
	jal ra, t9 #salto a malloc
	sw v0, BUFFER_POS($fp) #guardamos buffer de malloc en t0
while:
	# Intentamos leer un byte de informaci�n de stdin, usando
	# el stack del proceso como lugar de almacenamiento.
	#
	li	v0, SYS_read 			  # ver dentro de <sys/syscall.h>.
	lw	a0, ARG0_POS($fp)   # a0: file descriptor number.
	lw	a1, BUFFER_POS($fp)	# a1: data pointer.
	lw	a2, ARG1_POS($fp)	  # a2: available space.
	syscall

	# Verificamos el retorno de la llamada a SYS_read: si termin�
	# bien, continuamos. De lo contrario, retornamos al sistema.
	#
	# Primero, inspeccionamos el valor del registro a3: debe ser
	# cero cuando no han ocurrido errores, y distinto de cero en
	# los dem�s casos.
	#
	bne	a3, zero, read_error

	# En este punto, sabemos que $a3 es nulo: necesitamos revisar
	# el valor de retorno de SYS_read, i.e. cantidad de bytes que
	# se acaban de leer. Si la cantidad es exactamente 1, quiere
	# decir que tenemos le�do un caracter en memoria; si es nula,
	# quiere decir que el stream ha llegado al final. Si ocurren
	# otros valores, los tratamos como error.
	#
	beq	v0, zero, eof

	b while

read_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall

eof:
	# Finalmente, volvemos al sistema operativo devolviendo un
	# c�digo de retorno nulo.
	#
	# Primero, restauramos los valores de los registros relevantes,
	# y luego destru�mos nuestro stack frame.
	#
	la	v0, BUFFER_POS($fp)
	move	sp, $fp
	lw	ra, 44(sp)
	lw	$fp, 40(sp)
	addu	sp, sp, 48
	j	ra
	.end	read_write
