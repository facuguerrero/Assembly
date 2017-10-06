#include <stdio.h>
#include <unistd.h>

extern char* str_rev(char* a);

int main(int argc, char** argv){
  char* res = str_rev(argv[1]);

  printf("%s\n", res);

  return 0;
}
