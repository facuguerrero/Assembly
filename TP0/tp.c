#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <argp.h>

#define ARRAY_SIZE 1024
#define INPUT_SIZE 1024

/* Funciones y constantes para el procesamiento de flags*/
const char* argp_program_version = "tp0 [Guerrero, Schapira, De Rosa] 0.1";

/* Informacion a mostrar en --help*/
static char doc[] = "\nOptions: \vExample:\n\ttp0 -i ~/input -o ~/output";

/* Opciones agregadas a las basicas */
static struct argp_option options[] = {
  {"input",  'i', "PATH", 0, "Location of the input file."},
  {"output",   'o', "PATH",  0, "Location of the output file." },

  { 0 }
};

/* Tipo de argumentos esperados */
struct arguments{
  char* output_file;            /* file arg to ‘--output’ */
  char* input_file;             /* file arg to '--input' */
};

/* Parseo de una opcion */
static error_t parse_opt(int key, char *arg, struct argp_state *state) {
  /* Obtenemos el argumento de entrada a partir de argp_state */
  struct arguments *arguments = state->input;

  switch (key) {
    case 'o':
      arguments->output_file = arg;
      break;
    case 'i':
      arguments->input_file = arg;
      break;
    default:
      return ARGP_ERR_UNKNOWN;
    }
  return 0;
}

/* Parser de argumentos */
static struct argp argp = { options, parse_opt, 0, doc };

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
  /* Parte de los flags */

  struct arguments arguments;

  /* Default values. */
  arguments.output_file = NULL;
  arguments.input_file = NULL;

  /* Parse our arguments; every option seen by parse_opt will be
     reflected in arguments. */
  argp_parse (&argp, argc, argv, 0, 0, &arguments);

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
