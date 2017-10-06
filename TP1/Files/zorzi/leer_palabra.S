#include <mips/regdef.h>
#define TAM_SF 40
#define S0_SF 24
#define FP_SF 28
#define GP_SF 32
#define RA_SF 36
#define ARG0 40
#define ARG1 44
#define ARG2 48
#define POINTER 16
#define ASCII_A_MAY 65
#define ASCII_Z_MAY 90
#define ASCII_A_MIN 97
#define ASCII_Z_MIN 122
#define ASCII_CERO 48
#define ASCII_NUEVE 57
#define ASCII_GUION 45
#define ASCII_GUIONBAJO 95
#define ASCII_NEWLINE 10

.text
.abicalls
.align 2

.globl leer_palabra
.ent leer_palabra

leer_palabra:
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

	sw a0, ARG0($fp)                  #Guardamos el puntero al archivo
	sw a1, ARG1($fp)                  #Guardamos el puntero a longitud
    sw a2, ARG2($fp)                  #Guardamos el puntero al buffer

    la t0, TAM
	lw a0, 0(t0)            		  #Carga TAM en a0
	la t9, mymalloc
	jalr t9             			  #Llama a malloc
	beq v0, zero, terminar_con_error	#Si devuelve 0 ocurrio un error

	sw v0, POINTER($fp)          	  #Guardamos el puntero a la palabra
	addu s0, zero, zero     		  #Inicializamos len(palabra) en 0

loop:
	lw a0, ARG0($fp)                  #Recuperamos el puntero al archivo
  lw a1, ARG2($fp)                  #Recuperamos el puntero al buffer
	la t9, getch
	jalr t9                           #Leemos un caracter, queda en v0
	beq v0, -1, error		          #Si devuelve -1 ocurrio un error


	beq v0, ASCII_GUION, es_caracter       #Salta si es -

	beq v0, ASCII_GUIONBAJO, es_caracter   #Salta si es _

	sgeu t0, v0, ASCII_A_MAY               #Mayor que "A"
	sleu t1, v0, ASCII_Z_MAY               #Menor que "Z"
	beq t0, t1, es_caracter                #Salta si es letra mayuscula

	sgeu t0, v0, ASCII_A_MIN               #Mayor que "a"
	sleu t1, v0, ASCII_Z_MIN               #Menor que "z"
	beq t0, t1, es_caracter                #Salta si es letra minuscula

	sgeu t0, v0, ASCII_CERO                #Mayor que "0"
	sleu t1, v0, ASCII_NUEVE               #Menor que "9"
	beq t0, t1, es_caracter                #Salta si es un numero

no_es_caracter:
	lw a0, POINTER($fp)               #Recuperamos puntero a palabra
	addu t0, s0, a0                   #t0 = palabra + len
	addiu t1, zero, ASCII_NEWLINE
	sb t1, 0(t0)                      #Guardamos el "\n"

	lw a1, ARG1($fp)	              #Cargamos puntero a len
	sw s0, 0(a1)                      #Guardamos el len
	b terminar                        #Sale del loop

es_caracter:
	lw a0, POINTER($fp)               #Recuperamos puntero a palabra
	addu t0, s0, a0                   #t0 = palabra + len
	sb v0, 0(t0)                      #Guardamos el caracter

	addiu s0, s0, 1                   #Incrementamos len en 1

	la t0, TAM
	lw t1, 0(t0)                      #Carga TAM en t1
	remu t2, s0, t1                   #t2 = len % tam

	bne t2, zero, loop                #Salta si el modulo no es 0

	lw a0, POINTER($fp)               #a0 =  puntero a palabra
	move a1, s0						  #a1 = len
	la t0, TAM
	lw a2, 0(t0)            		  #a2 = TAM

	la t9, myrealloc
	jalr t9                           #Llama a realloc
	beq v0, zero, error	              #Si devuelve 0 ocurrio un error
	sw v0, POINTER($fp)          	  #Guardamos el nuevo puntero

	b loop                            #Vuelve siempre al loop

terminar:
	lw v0, POINTER($fp)               #v0 = puntero a la palabra

return:
    lw s0, S0_SF($fp)
	lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

error:
	lw a0, POINTER($fp)              # Recuperamos puntero a palabra
	la t9, myfree
	jalr t9						     #Llama a free con la palabra
terminar_con_error:
	move v0, zero					 #Devuelve 0 si ocurrio un error
	b return

.end leer_palabra
.size leer_palabra,.-leer_palabra
