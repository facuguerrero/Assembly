#include <stdio.h>
#include <unistd.h>

extern char* palindrome(char* a);

int main(int argc, char** argv){
  int res = palindrome(argv[1]);

  if (res) printf("palindrome!\n");
  else printf("not palindrome!\n");

  return 0;
}
