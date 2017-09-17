#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <stdbool.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>

#define ARRAY_SIZE 1024
#define INPUT_SIZE 1024
#define SALIDA 10

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
  printf("tp0 [Guerrero - Schapira - De Rosa] 0.8\n");
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
  /* Si tiene un solo caracter no se considera*/
  int len = strlen(string);
  if (len <= 1) return 0;

  /*Pasamos a minuscula los caracteres*/
  char lower[100];
  memset(lower, 0, sizeof(lower));
  int i;
  for(i = 0; i < len; i++){
    lower[i] = tolower((unsigned char)string[i]);
  }

  /*Verificamos si es capicua*/
  char copy[100];

  memset(copy, 0, sizeof(copy));
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
    for(i = 0; i < len; i++){
  	   int a = string[i];
       /*Si la letra actual corresponde a un caracter válido, seguimos con las
       siguiente*/
       if( a>47 && a<58 ) continue;
       if( (a>64 && a<91) || (a > 96 && a<123) ) continue;
       if(a == 95 || a==45) continue;

       //Si estamos aca es porque es un caracter que quivale al espacio.
       memset(new, 0, sizeof(new)); //Reseteamos el array
       for(j = 0; j < (i - init); j++){ //Copiamos la nueva palabra
          new[j] = string[init + j];
       }
       //En caso de ser capicua, la agregamos al string de palabras
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

bool check_continuar(char* input){
  strtok(input, "\n");
  if (strcmp(input, "salir")) return true;
  return false;
}

int main(int argc, char* argv[]){
    /* Archivos */
    char* output_file = NULL;
    char* input_file = NULL;
    /* Procesamiento de parametros de entrada*/
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

      c = getopt_long(argc, argv, "hvc:i:o:", long_options, &option_index);

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
          input_file = optarg;
          break;
        case 'o':
          output_file = optarg;
          break;
        case '?':
          break;
        default:
          abort();
      }
  }
  /* Print any remaining command line arguments (not options). */
  if (optind < argc){
      printf ("non-option ARGV-elements: ");
      while(optind < argc) printf("%s ", argv[optind++]);
      putchar('\n');
  }

  /*Procesamiento de palabra capicua*/
  char input[INPUT_SIZE];
  char array[ARRAY_SIZE];

  FILE* entrada = fopen(input_file, "r");
  FILE* salida = fopen(output_file, "w");

  //Si no hay archivo, pedimos por teclado.
  if(!entrada){
    bool exito = true;
    while( exito ){

      //Se recibe la oracion a evaluar
      memset(array, 0, sizeof(array));
      memset(input, 0, sizeof(input));

      printf("Ingrese la oracion a evaluar:\n");
      fgets(input, INPUT_SIZE, stdin);

      palabras_en_linea(input, array);
      //Salida del programa para cada linea
      if(!salida){ //Si no hay archivo, imprimimos por pantalla
        printf("Palabras capicua:\n%s", array);
      }
      else { //Si hay archivo, lo guardamos en él
        fputs( array, salida);
      }

      //Verificamos si se quiere seguir o no
      printf("¿Desea salir?['salir' para cortar la ejecucion]\n");
      memset(input, 0, sizeof(input));
      fgets(input, INPUT_SIZE, stdin);
      exito = check_continuar(input);
    }
  } else { //Si hay, procesamos las lineas.
    memset(array, 0, sizeof(array));
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

    //Salida del programa
    if(!salida){ //Si no hay archivo, imprimimos por pantalla
      printf("Palabras capicua:\n%s", array);
    } else { //Si hay archivo, lo guardamos en él
      fputs( array, salida);
    }
  }

  if (salida) fclose(salida);

  return 0;
}
