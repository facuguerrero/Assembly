#include <stdio.h>
#include <unistd.h>

extern size_t equals(char a, char b);

int main(int argc, char** argv){
  int res = equals(*argv[1], *argv[2]);

  if (res) printf("Equals\n");
  else printf("Not Equals\n");

  return 0;
}
