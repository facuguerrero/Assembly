#include <mips/regdef.h>
#define TAM_SF 48
#define FP_SF 32
#define GP_SF 36
#define RA_SF 40
#define ARG0 48
#define ARG1 52
#define ARG2 56
#define ARG3 60
#define BUFF_IN 24
#define BUFF_OUT 28
#define LEN 16
#define POINTER 20

.text
.abicalls
.align 2

.globl palindrome
.ent palindrome

palindrome:
	.frame $fp, 48, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, 48
	sw $fp, 32(sp)
	.cprestore 36
	sw ra, 40(sp)
	move $fp, sp

	sw a0, ARG0($fp)                #guardamos el archivo de entrada
	sw a1, ARG1($fp)                #guardamos el tamanio buffer entrada
  sw a2, ARG2($fp)                #guardamos el archivo de salida
  sw a3, ARG3($fp)                #guardamos el tamanio buffer salida

  move a0, a1                     #a0 = tamanio del buffer entrada

  la t9, crear_buffer
  jalr t9                           	#Crea el buffer de entrada
  beq v0, zero, error_primer_buffer	#Si devuelve 0 ocurrio un error
  sw v0, BUFF_IN($fp)                 #Guardamos el buffer de entrada
  la t0, tam_buffer_entrada
  lw t1, ARG1($fp)
  sw t1, 0(t0)				    #Actualiza el tam del buffer entrada

  lw a0, ARG3($fp)                    #a0 = tam del buffer de salida
  la t9, crear_buffer
  jalr t9                           	#Crea el buffer de salida
  beq v0, zero, error_segundo_buffer	#Si devuelve 0 ocurrio un error
  sw v0, BUFF_OUT($fp)                #Guardamos el buffer de salida
  la t0, tam_buffer_salida
  lw t1, ARG3($fp)
  sw t1, 0(t0)				     #Actualiza el tam del buffer salida

loop:
  lw a0, ARG0($fp)                    #a0 = archivo de entrada
	addu a1, $fp, LEN                   #a1 = puntero a len
  lw a2, BUFF_IN($fp)                 #a2 = buffer de entrada

	la t9, leer_palabra
	jalr t9                          	#Lee la proxima palabra

	sw v0, POINTER($fp)               #Guardamos el puntero a la palabra
	beq v0, zero, error             #Salta si no se pudo leer la palabra

	move a0, v0                        #a0 = puntero a palabra
  lw a1, LEN ($fp)                   #a1 = len(palabra)
	la t9, es_capicua
	jalr t9                            #Llama a es_capicua

	beq v0, zero, continuar_loop       #Si no es capicua sigue el loop

	lw a0, ARG2($fp)                   #a0 = archivo de salida
	lw a1, POINTER($fp)                #a1 = puntero a la palabra
  lw a2, BUFF_OUT($fp)               #a2 = buffer de salida
  la t9, putch
  jalr t9                            #Escribe la palabra en el archivo
  beq v0, zero, error_escritura	   #Si devuelve 0 ocurrio un error

continuar_loop:

  lw a0, POINTER($fp)                #a0 = puntero a palabra
  la t9, myfree
  jalr t9                            #Llama a free(palabra)

  la t0, escribir_eof
  lw t1, 0(t0)					   #t1 = hay que escribir eof?
  beq t1, zero, loop           	   #salta si no hay que escribirlo

  lw a0, ARG2($fp)				   #a0 = archivo de salida
  lw a2, BUFF_OUT($fp)			   #a2 = buffer de salida
  la t9, putch
  jalr t9                      #Escribe todo lo que queda en el buffer
  beq v0, zero, error         	   #Si devuelve 0 ocurrio un error

terminar:
	move v0, zero
free_segundo_buffer:
	lw a0, BUFF_OUT($fp)                #Cargamos el buffer de salida
	la t9,myfree
	jalr t9								#Liberamos el segundo buffer
free_primer_buffer:
	lw a0, BUFF_IN($fp)                 #Cargamos el buffer de entrada
	la t9,myfree
	jalr t9								#Liberamos el primer buffer

return:
	lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

error_segundo_buffer:
	addiu v0, zero, 1					#Devuelve codigo de error 1
	b free_primer_buffer				#Libera el primer buffer
error_primer_buffer:
	addiu v0, zero, 1 					#Devuelve codigo de error 1
	b return        					#No libera nada

error_escritura:
	lw a0, POINTER($fp)                 #a0 = puntero a la palabra
	la t9, myfree
	jalr t9								#Libera la palabra
error:
	addiu v0, zero, 2 					#Devuelve codigo de error 2
	b free_segundo_buffer				#Libera ambos buffer

.end palindrome
.size palindrome,.-palindrome



.data

.globl pos_buffer_entrada
.globl tam_buffer_entrada
.globl pos_buffer_salida
.globl tam_buffer_salida
.globl eof_leido
.globl escribir_eof
.globl TAM


pos_buffer_entrada: .word -1
tam_buffer_entrada: .word 0
pos_buffer_salida: .word 0
tam_buffer_salida: .word 0
eof_leido: .word 0
escribir_eof: .word 0
TAM: .word 30
