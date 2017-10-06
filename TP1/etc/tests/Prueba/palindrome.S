#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 48
#define STORE_POS 52

  .text
  .align  2

  .globl  palindrome
  .ent    palindrome
palindrome:
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

  #Si es palindroma:
isPalindrome:

  #Vamos ejecutando las funciones necesarias.
  lw a0, ARG0_POS($fp) #Palabra recibida por parametros
  la t9, to_lower #Almacenamos la direccion de tolower en t9
  jal ra, t9 #Saltamos a la funcion tolower

  move a0, v0 #Recuperamos el resultado de la funcion tolower
  sw a0, STORE_POS($fp) #Guardamos a0 para luego recuperarlo
  la t9, str_rev
  jal ra, t9

  lw a0, STORE_POS($fp) #Recuperamos a0 por si fue modificado en la funcion
  move a1, v0 #Recuperamos el resultado en a1 para poder comparar las palabras
  la t9, equals
  jal ra, t9
  #El retorno de equal_str es el retorno de palindrome (True-False)

return:
  lw    gp, 36(sp)
  lw    $fp, 40(sp)
  lw    ra, 44(sp)
  addu  sp, sp, 48
  jr ra

  .end palindrome
