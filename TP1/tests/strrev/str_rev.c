#include <stdio.h>
#include <unistd.h>
#include <string.h>

extern char* str_rev(char* a);

int main(int argc, char** argv){
  char* res = str_rev(argv[1]);

  if (!strcmp(res, "")) printf("Empty string\n");

  printf("%s\n", res);

  return 0;
}
