#include <mips/regdef.h>
#include <sys/syscall.h>
#define TAM_SF 48
#define S0_SF 16
#define S1_SF 20
#define S2_SF 24
#define S3_SF 28
#define FP_SF 32
#define GP_SF 36
#define RA_SF 40
#define ARG0 48
#define ARG1 52
#define ARG2 56
#define ASCII_NEWLINE 10

.text
.abicalls
.align 2

.globl putch
.ent putch

putch:

	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
	sw s0, S0_SF(sp)
	sw s1, S1_SF(sp)
	sw s2, S2_SF(sp)
	sw s3, S3_SF(sp)
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	sw ra, RA_SF(sp)
	move $fp, sp
	
	sw a0, ARG0($fp)                 #Guardamos el archivo de salida
	sw a1, ARG1($fp)                 #Guardamos el puntero a la palabra
    sw a2, ARG2($fp)                 #Guardamos el buffer

    la t0, pos_buffer_salida
    lw s0, 0(t0)                     #s0 = pos actual del buffer

    addu s1, zero, zero              #s1 = indice de la palabra = 0
    
    la t0, escribir_eof
    lw t1, 0(t0)                     #t1 = eof debe ser escrito?
    beq t1,zero, loop     		     #Salta si eof no debe ser escrito
    
#Si no salta es la ultima escritura en el archivo
    move s3, zero					 #s3 = cant bytes escritos = 0
    la t0, tam_buffer_salida
    sw s0, 0(t0)                     #Actualiza el tamanio del buffer 
									 #a la posicion actual
    b escribir_todo
    

loop:
    lw a1, ARG1($fp)                 #Cargamos el puntero a la palabra
    addu t3, a1, s1                  #t3 = palabra + indice
    lbu s2, 0(t3)                    #s2 = caracter a escribir

    lw a2, ARG2($fp)                 #Cargamos el puntero al buffer
    addu t5, a2, s0                  #t5 = buffer + pos_actual
    sb s2, 0(t5)                     #Guardamos el caracter

    addiu s0,s0,1                    #Incrementamos pos_actual
    la t0, tam_buffer_salida
    lw t1, 0(t0)                     #Cargamos el tamanio del buffer
    bltu s0, t1, continuar_loop      #Salta si pos_actual < tam_buffer
    move s3, zero					 #s3 = cant bytes escritos = 0

#Si no salta hay que volver a escribir el archivo y vaciar el buffer

escribir_todo:
    lw a0, ARG0($fp)                 #Cargamos el archivo de salida 
    lw a1, ARG2($fp)                 #Cargamos el buffer 
    addu a1, a1, s3					 #a1 = buffer + cant bytes escritos
    la t0, tam_buffer_salida
    lw a2, 0(t0)                     #Cargamos tam total del buffer 
    subu a2, a2, s3					 #a2 = tam - cant bytes escritos
    li v0, SYS_write
    syscall
    
    bne a3, zero, error			     #Salta si ocurrio un error
    addu s3, s3, v0					 #s3 = cant bytes escritos
    la t0, tam_buffer_salida
    lw t1, 0(t0)                     # t1 = tamanio total del buffer 
    blt s3, t1, escribir_todo       #Si escribio menos vuelve a escribir
    
    addu s0, zero, zero              #Pos_actual = 0
    
    la t0, escribir_eof
    lw t1, 0(t0)                     #t1 = eof escrito ?
    bne t1, zero, terminar      	 #Termina si EOF fue escrito

continuar_loop:
    addu s1, s1, 1                   #Incrementa el indice de la palabra
    bne s2, ASCII_NEWLINE, loop      #Vuelve al loop si no es \n

terminar:
	addiu v0, zero, 1			      #Devuelve 1 si no ocurrio un error
	
return:
    la t0, pos_buffer_salida
    sw s0, 0(t0)    				  #Actualiza la posicion actual                  
    lw s0, S0_SF($fp)
    lw s1, S1_SF($fp)
    lw s2, S2_SF($fp)
    lw s3, S3_SF($fp)
    lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

error:
	move v0, zero						#Devuelve 0 si ocurrio un error
	b return

.end putch
.size putch,.-putch
