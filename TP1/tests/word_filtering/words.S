#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 48

    .text
    .align  2

    .globl  verificar_char
    .ent    verificar_char

verificar_char:
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

  # Guardo el argumento
  sw  a0, ARG0_POS($fp)   # Puntero al string

  li	v0, 0
mystrlen_loop:
  lb	t0, 0(a0)
  beqz	t0, reading
  addiu	a0, a0, 1
  addiu	v0, v0, 1
  j	mystrlen_loop

reading:
  lw a0, ARG0_POS($fp)
  la t6, string_space
  li t8, 0 #contador de palindromos
  li t7, 0 #longitud palabra actual
  add t5, v0, zero
loop:
  beqz t5, space
  add t5, t5, -1
  lb t0, 0(a0) #caracter actual en t0

  #Chequeamos los distintos intervalos de caracteres posibles.
  li t2, 95 # ascii for _
  sub t2, t0, t2 #Si la resta da 0, no es un espacio
  beqz t2, add_char

  li t2, 45  #ascii for -
  sub t2, t0, t2
  beqz t2, add_char

  li t2, 47 #limite inferior del intervalo numeros
  sub t2, t0, t2 #char - lim inferior de intervalo numeros
  blez t2, space #si no pertenece al intervalo, es espacip

  li t2, 57 # char -lim superior intervalo numeros
  sub t2, t0, t2
  blez t2, add_char

  li t2, 64 #char - lim inferior intervalo mayus
  sub t2, t0, t2
  blez t2, space

  li t2, 90 #lim superior intervalo mayus
  sub t2, t0, t2
  blez t2, add_char

  li t2, 96 #lim inferior intervalo lower
  sub t2, t0, t2
  blez t2, space

  li t2, 122 #lim superior intervalo lower
  sub t2, t0, t2
  blez t2, add_char

  j space

add_char:
  addiu t7, t7, 1
  sb t0, 0(t6)
  addiu t6, t6, 1
  addiu a0, a0, 1

  j loop

space:
  addi t0, zero, 0 #fin de string
  sb t0, 0(t6) #agregar '\0'
  addiu a0, a0, 1 #avanzar en palabra original
  beqz t7, check_end #si es una palabra vacia, sigue procesando
  #guardo a0 y t5
  sw a0, 52($fp)
  sw t5, 56($fp)
  la a0, string_space #parametro de palindrome
  #salto a palindrome
  la t9, palindrome #para jump and link
  jal ra, t9 #salto a la funcion
  #vuelta de palindrome
  lw a0, 52($fp) #recuperamos la posicion del string actual
  lw t5, 56($fp) #recuperamos la longitud total
  la t6, string_space #en el proximo ciclo, se empieza a escribir de cero el arreglo
  add t7, zero, zero
  bnez v0, sumar_palindromo #si volvio 0 de palindromo, sumamos 1 a la cantidad
  #continuacion lectura
  j loop #leemos la proxima palabra

sumar_palindromo:
  addi t8, t8, 1
  j loop

check_end:
  #se verifica si termino el string con un espacio
  beqz t5, return
  j loop

return:
  add v0, zero, t8 #se guarda la cantidad de palindromos
  move  sp, $fp
  lw    ra, 44(sp)
  lw    $fp, 40(sp)
  addu  sp, sp, 48
  jr ra

  .end verificar_char
  .data
string_space: .space 128
