#include <mips/regdef.h>
#include <sys/syscall.h>
#define TAM_SF 40
#define S0_SF 16
#define S1_SF 20
#define FP_SF 24
#define GP_SF 28
#define RA_SF 32
#define ARG0 40
#define ARG1 44

.text
.abicalls
.align 2

.globl getch
.ent getch

getch:

	.frame $fp, TAM_SF, ra
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, TAM_SF
	sw s0, S0_SF(sp)
	sw s1, S1_SF(sp)
	sw $fp, FP_SF(sp)
	.cprestore GP_SF
	sw ra, RA_SF(sp)
	move $fp, sp
	
	sw a0, ARG0($fp)                  #Guardamos el archivo de entrada
	sw a1, ARG1($fp)                  #Guardamos el puntero al buffer
	
    la t0, pos_buffer_entrada
    lw s0, 0(t0)                      #s0 = pos actual del buffer
    
    la t0, tam_buffer_entrada
    lw a2, 0(t0)                      #a2 = tam actual del buffer

    bltu s0, a2, leer_caracter        #Salta si pos actual < tam buffer       

#Si no salta hay que volver a leer del archivo y llenar el buffer
    
	la t0, eof_leido
	lw t1, 0(t0)					  #t1 = eof fue leido?
	bne t1, zero, leyo_eof			  #salta si fue leido
	
    move s1,zero					  #s1 = cantidad bytes leidos = 0
    move s0, zero					  #Pos actual = 0

#Lectura del archivo

leer_archivo:
	lw a0, ARG0($fp)                  # a0 = archivo de entrada
	lw a1, ARG1($fp)                      
	addu a1, a1, s1				 #a1=puntero buffer + cant bytes leidos
	la t0, tam_buffer_entrada
    lw a2, 0(t0)                      
	subu a2, a2, s1					  #a2=tam buffer - cant bytes leidos
	li v0, SYS_read
	syscall
	bne a3, zero, error			        #Salta si hubo un error
	beq v0, zero, eof_fue_leido      	#Si es cero leyo eof
	
	addu s1, s1, v0						#s1 = cant bytes leidos
	la t0, tam_buffer_entrada
    lw t1, 0(t0)						#t1 = tam buffer entrada
    blt s1, t1, leer_archivo	   #Si bytes leidos < tam vuelve a leer
    b leer_caracter	                    #Si ya leyo todo salta
	
eof_fue_leido:
	la t0, tam_buffer_entrada		#Si leyo menos bytes pero todavia 
	sw s1, 0(t0)					#hay cosas en el buffer
	             					#Actualizo el tamanio del buffer
	la t0, eof_leido
	addiu t1, zero, 1
	sw t1, 0(t0)					#Actualiza eof leido
	beq s1, zero, leyo_eof			#Salta si no leyo nada


leer_caracter:
    
    lw a1, ARG1($fp)                  #Cargo el puntero al buffer
    addu t2, s0, a1                   #t2 = buffer + pos
    lbu v0, 0(t2)                     #v0 = caracter leido
    addiu s0, s0, 1                   #Incremento la posicion actual

    la t0, pos_buffer_entrada
    sw s0, 0(t0)                   #Guardamos la pos actual del buffer

return:
	lw s0, S0_SF($fp)
	lw s1, S1_SF($fp)
    lw ra, RA_SF($fp)
	lw gp, GP_SF($fp)
	lw $fp, FP_SF($fp)
	addiu sp, sp, TAM_SF
	jr ra

leyo_eof:
	la t0, escribir_eof
	addiu t1,zero,1
	sw t1, 0(t0)						#Actualizo escribir_eof
	addu v0, zero, zero					#Devuelvo 0
	b return

error:
	addiu v0, zero, -1					#Devuelvo -1 
	b return

.end getch
.size getch,.-getch
