#include <stdio.h>
#include <unistd.h>

extern char* str_cpy(char* a);

int main(int argc, char** argv){
  char* res = str_cpy(argv[1]);

  printf("%s\n", res);

  return 0;
}
