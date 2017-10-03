#include <mips/regdef.h>
#include <sys/syscall.h>

#define ARG0_POS 32

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

  #Calculo la longitud de la palabra
  li t9, 0
mystrlen_loop:
  lb    t0, 0(a0)
  beqz  t0, lowering
  addiu a0, a0, 1
  addiu t9, t9, 1
  j mystrlen_loop

lowering:
  la t6, string_lower
  add t5, zero, t9 #largo del loop
  lw a0, ARG0_POS($fp)

lower_loop:
  beqz t5, stringreverse
  subu t5, t5, 1
  j lower

lower:
  lb t0, 0(a0) #caracter actual en t0

  li t2, 64 #limite inferior del intervalo mayusculas
  li t3, 91 #limite superior del intervalo mayusculas

  sub t2, t0, t2 #char - lim inferior de mayusculas
  blez t2, add_char #si no pertenece al intervalo

  sub t3, t3, t0 #lim sup - char
  blez t3, add_char #si no pertenece al intervalo

  li t4, 32
  addu t0, t0, t4 #se pasa a minuscula

add_char:
  sb t0, 0(t6)
  addiu t6, t6, 1
  addiu a0, a0, 1

  j lower_loop

stringreverse:
  la a0, string_lower #load address
  add t0, a0, zero    #starting address
  addi t1, t9, -1     #j = length-1
  add t5, t9, zero    #Largo del loop
  la t6, string_rev   #cargamos puntero en t6

rev_loop:
  beqz t5, comparing #condicion de loop
  subu t5, t5, 1   #resta de variable de loop
  add t2, t0, t1   #carga de direccion s[j]
  lb t3, 0(t2)     #the lb string[j]
  sb t3, 0(t6)     #dest[i] = src[j]
  addi t1, t1, -1  #j--
  addiu t6, t6, 1  #Avanza en el string a escribir

  j rev_loop

comparing:
  add t3, zero, t9 #largo del loop
  la a0, string_rev
  la a1, string_lower
loop:
  beqz t3, eqs
  subu t3, t3, 1
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
    move    sp, $fp
    lw  ra, 44(sp)
    lw  $fp, 40(sp)
    addu    sp, sp, 48
    j   ra

  .end palindrome
  .data
string_lower: .space 128
string_rev: .space 128
