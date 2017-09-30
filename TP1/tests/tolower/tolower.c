#include <stdio.h>
#include <unistd.h>

extern char* to_lower(char* a);

int main(int argc, char** argv){
  char* res = to_lower(argv[1]);

  printf("%p\n", res);

  return 0;
}
