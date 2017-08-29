#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>

#define ARRAY_SIZE 1024
#define INPUT_SIZE 1024

/* Tipo de argumentos esperados */
struct arguments{
  char* output_file;            /* file arg to ‘--output’ */
  char* input_file;             /* file arg to '--input' */
};

void print_help(){
  printf("Usage:\n \
  \ttp0 -h\n \
  \ttp0 -v\n \
  \ttp0 [options]\nOptions:\n \
  \t-v, --version    \tPrint version and quit.\n \
  \t-h, --help       \tPrint help and quit.\n \
  \t-i, --input      \tPath to input file.\n \
  \t-o, --output     \tPath to output file.\nExamples:\n \
  \ttp0 -i ~/input -o ~/output\n");
}

void print_version(){
  printf("tp0 [Guerrero - Schapira - De Rosa] 0.5\n");
}

/* Funcion que invierte una cadena de caracteres */
char* strrev(char *str){
      char *p1, *p2;

      if (! str || ! *str) return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2){
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}

/*Se hace una copia de la palabra recibida, se la invierte y se verifica
si son iguales o no */
int es_capicua(char* string){
  /*Pasamos a minuscula los caracteres*/
  char lower[strlen(string)];
  memset(lower, 0, sizeof(lower));

  int i;
  for(i = 0; i <= strlen(string); i++){
    lower[i] = tolower(string[i]);
  }
  /*Verificamos si es capicua*/
  char copy[strlen(lower)];
  strcpy(copy, lower);
  strrev(copy);
  if(!strcmp(lower, copy) && strlen(lower) > 1 ) return 1;
  return 0;
}

/*Chequea que palabras de la linea recibida son capicua*/
int palabras_en_linea(char* string, char* array_strings){
  	int len = strlen(string);
  	int init = 0;
  	int cant = 0;
    int words = 0;
    char new[100];

    int i, j;
    for(i = 0; i <= len; i++){
  	     int a = string[i];
         if( a>47 && a<58 ) continue;
         if( (a>64 && a<91) || (a > 96 && a<123) ) continue;
         if(a == 95 || a==45) continue;

       //Si estamos aca es porque es un caracter que quivale al espacio.
       memset(new, 0, sizeof(new));

       for(j = 0; j < (i - init); j++){
          new[j] = string[init + j];
       }

       if(es_capicua(new)){
          for(j = 0; j < (i - init); j++){
              array_strings[cant] = new[j];
              cant++;
          }
          array_strings[cant] = '\n';
          cant++;
          words++;
       }
       init = i + 1;
    }

  	return words;
}

int main(int argc, char* argv[]){
    /* Lectura de entrada */
    /* Default values. */
    struct arguments arguments;
    arguments.output_file = NULL;
    arguments.input_file = NULL;

    int c;
    while (1){
      static struct option long_options[] =
        {
          /* These options don’t set a flag.
             We distinguish them by their indices. */
          {"help", no_argument, 0, 'h'},
          {"version", no_argument, 0, 'v'},
          {"input",  required_argument, 0, 'i'},
          {"output",    required_argument, 0, 'o'},
          {0, 0, 0, 0}
        };
      /* getopt_long stores the option index here. */
      int option_index = 0;

      c = getopt_long (argc, argv, "hvc:i:o:", long_options, &option_index);

      /* Detect the end of the options. */
      if (c == -1) break;

      switch (c){
        case 0:
          /* If this option set a flag, do nothing else now. */
          if (long_options[option_index].flag != 0) break;
          printf ("option %s", long_options[option_index].name);
          if (optarg) printf (" with arg %s", optarg);
          printf ("\n");
          break;
        case 'h':
          print_help();
          exit(0);
          break;
        case 'v':
          print_version();
          exit(0);
          break;
        case 'i':
          arguments.input_file = optarg;
          break;
        case 'o':
          arguments.output_file = optarg;
          break;
        case '?':
          break;
        default:
          abort ();
        }
    }
    /* Print any remaining command line arguments (not options). */
    if (optind < argc){
        printf ("non-option ARGV-elements: ");
        while (optind < argc) printf ("%s ", argv[optind++]);
        putchar ('\n');
    }

  /*Procesamiento de palabra capicua*/
  char input[INPUT_SIZE];
  char array[ARRAY_SIZE];
  memset(array, 0, sizeof(array));

  FILE* entrada = fopen(arguments.input_file, "r");

  //Si no hay archivo, pedimos por teclado.
  if(!entrada){
      printf("Ingrese la oracion a evaluar:\n");
      fgets(input, INPUT_SIZE, stdin);

      palabras_en_linea(input, array);
  }

  //Si hay, procesamos las lineas.
  else{
    while( !feof(entrada) ){
      char ent[INPUT_SIZE];
      memset(ent, 0, sizeof(ent));
      /*Cargo una linea*/
      fgets(ent, sizeof(ent), entrada);

      if(ent[0] == '\0'){
        continue;
      }

      /*Proceso una linea*/
      char aux[INPUT_SIZE];
      memset(aux, 0, sizeof(aux));

      palabras_en_linea(ent, aux);
      strcat(array, aux);
    }
    fclose(entrada);
  }

  /*MANEJAMOS LA SALIDA*/

  FILE* salida = fopen(arguments.output_file, "w");

  //Si no hay archivo, imprimimos por pantalla
  if(!salida){
      printf("Palabras capicua:\n%s", array);
  }

  //Si hay archivo, lo guardamos en el
  else{
    fputs( array, salida);
    fclose(salida);
  }

  return 0;
}
