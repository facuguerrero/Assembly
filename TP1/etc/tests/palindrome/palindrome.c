#include <stdio.h>
#include <unistd.h>

extern size_t palindrome(char* a);

int main(int argc, char** argv){
  size_t res = palindrome(argv[1]);

  //printf("%s\n", res);

  if (res) printf("palindrome!\n");
  else printf("not palindrome!\n");

  return 0;
}
