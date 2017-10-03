#include <stdio.h>
#include <unistd.h>

extern size_t verificar_char(char* a);
extern size_t palindrome(char* a);

int main(int argc, char** argv){
  size_t res = verificar_char(argv[1]);

  printf("%d\n", res);

  return 0;
}
