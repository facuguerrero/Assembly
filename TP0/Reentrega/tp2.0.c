#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <stdbool.h>
#include <ctype.h>
#include <unistd.h>
#include <errno.h>

#define DEFAULT_INPUT stdin
#define DEFAULT_OUTPUT stdout

#define SIZE_INC 256
#define INIT_SIZE 1024

#define ALLOC_ERROR "An error ocurred while allocating memory! Error: "
#define REALLOC_ERROR "An error ocurred while reallocating memory! Error: "
#define INPUT_OPEN_ERROR "An error ocurred while opening input file! Error: "
#define OUTPUT_OPEN_ERROR "An error ocurred while opening output file! Error: "
#define DEFAULT_INPUT_MESSAGE "Input file is now stdin."
#define DEFAULT_OUTPUT_MESSAGE "Output file is now stdout."
#define RESULT_WRITING_ERROR "An error ocurred while writing the result! Error: "
#define PALINDROME_ERROR_MESSAGE "An error ocurred while checking for palindromes!"

#define READING_ERROR 1
#define WRITING_ERROR 2
#define PALINDROME_ERROR 3

#define FAIL 1
#define SUCCESS 0

/*Lee el string entrante y lo devuelve.
 * @param fp: File Pointer de input
 * @param size: Tamaño inicial del arraglo, que se modifica con la entrada
 * @return: Devuelve el string leido.*/
char* read_input(FILE* fp, size_t size);
/*Se abre el input_file y se devuelve su fp. En caso de error al abrir,
  se utiliza DEFAULT_INPUT.
 * @param path: Direccion del archivo a abrir.
 * @return: File Pointer de input [default: DEFAULT_INPUT].*/
FILE* open_input(char* path);
/*Se abre el output_file y se devuelve su fp. En caso de error al abrir,
  se utiliza DEFAULT_OUTPUT.
 * @param path: Direccion del archivo a abrir.
 * @return: File Pointer de output [default: DEFAULT_OUTPUT].*/
FILE* open_output(char* path);
/*Se escriben los palíndromos en el archivo indicado.
 * @param output_fp: File Pointer del archivo a escribir.
 * @param result: String a escribir en el archivo.
 * @return: FAIL | SUCCESS.*/
int write_result(FILE* output_fp, char* result);
/*Cierra los dos archivos recibidos.
 * @param fp1, fp2: File Pointer de archivo a cerrar.*/
void close_files(FILE* fp1, FILE* fp2);
/*Invierte la cadena recibida.
 * @param str: Cadena de caracteres a invertir
 * @return: Cadena recibida, en orden inverso.*/
char* strrev(char* str);
/*Devuelve un arreglo listo para escribir en un archivo que contiene, uno en
cada linea, los palindromos del string recibido.
 * @param string: Cadena a analizar en busca de palindromos.
 * @return: Cadena que contiene solo palindromos, uno por linea.*/
char* get_palindromes(char* string);
/*Verifica si una cadena es un palindromo o no.
 * @param string: cadena a analizar
 * @return: True | False*/
bool is_palindrome(char* string);

int main(int argc, char** argv){
  //Esto hay que reemplazarlo por los args
  FILE* input_fp = open_input(argv[1]);
  FILE* output_fp = open_output(argv[2]);
  //Lectura del archivo
  char* input_string = read_input(input_fp, INIT_SIZE);
  if (!input_string){
    close_files(output_fp, input_fp);
    return READING_ERROR;
  }
  //Calculo de palindromos
  char* result_string = get_palindromes(input_string);
  free(input_string);
  if (!result_string){
    printf("%s\n", PALINDROME_ERROR_MESSAGE);
    close_files(input_fp, output_fp);
    if (result_string) free(result_string);
    return PALINDROME_ERROR;
  }
  //Escritura del resultado
  int written = write_result(output_fp, result_string);
  if (written == FAIL){
    close_files(input_fp, output_fp);
    if (result_string) free(result_string);
    return WRITING_ERROR;
  }
  //Se liberal la memoria del string
  if (result_string) free(result_string);
  //Se cierran los archivos
  close_files(input_fp, output_fp);

  return SUCCESS;
}

char* read_input(FILE* fp, size_t size){
  char* string;
  int char_;
  size_t len = 0; //Tamaño actual del arreglo

  //Arreglo inicial
  string = malloc(sizeof(char)*size);
  if (!string){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    return NULL;
  }
  //Ciclo principal
  while( EOF != (char_ = fgetc(fp)) ){
    string[len++] = char_; //Se suma uno a la longitud del string
    //Si el string alcanza el largo máximo, hay que redimensionar el arreglo
    if (len == size){
      string = realloc(string, sizeof(char)*(size += SIZE_INC));
      if (!string){
        printf("%s%s\n", REALLOC_ERROR, strerror(errno));
        return NULL;
      }
    }
  }
  //Fin de linea
  string[len++] = '\0';

  return realloc(string, sizeof(char)*len); //Usamos solo la memoria necesaria!
}

int write_result(FILE* fp, char* result){
  //Se escribe el resultado
  int written = fprintf(fp, "%s", result);
  //Si no se logró escribir completo o hubo algún error, se notifica.
  if (written < 0){
    printf("%s%s\n", RESULT_WRITING_ERROR, strerror(errno));
    return FAIL;
  }
  return SUCCESS;
}

FILE* open_input(char* path){
  //Se intenta abrir el archivo
  FILE* input_fp = fopen(path, "r");
  //En caso de error, se notifica y se define stdin como input_fp
  if (!input_fp){
    printf("%s%s\n", INPUT_OPEN_ERROR, strerror(errno));
    printf("%s\n\n", DEFAULT_INPUT_MESSAGE);
    input_fp = DEFAULT_INPUT;
  }
  return input_fp;
}

FILE* open_output(char* path){
  //Se intenta abrir el archivo
  FILE* output_fp = fopen(path, "w");
  //En caso de error, se notifica y se define stdout como output_fp
  if (!output_fp){
    printf("%s%s\n", OUTPUT_OPEN_ERROR, strerror(errno));
    printf("%s\n\n", DEFAULT_OUTPUT_MESSAGE);
    output_fp = DEFAULT_OUTPUT;
  }
  return output_fp;
}

void close_files(FILE* fp1, FILE* fp2){
  fclose(fp1);
  fclose(fp2);
}

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

char* get_palindromes(char* string){
  int len = strlen(string);
  int init = 0;
  int cant = 0;
  //Arreglo donde se guardan las palabras individuales
  char* new = malloc(sizeof(char)*len);
  if (!new){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    return NULL;
  }

  //Arreglo para devolver, dinamico
  int size = len;
  char* return_array = malloc(sizeof(char)*size);
  if (!return_array){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    return NULL;
  }
  memset(return_array, 0, sizeof(char)*size);
  //Ciclo principal
  int i, j;
  for(i = 0; i < len; i++){
    int a = string[i];
    /*Si la letra actual corresponde a un caracter válido, seguimos con las
    siguiente*/
    if( a>47 && a<58 ) continue;
    if( (a>64 && a<91) || (a > 96 && a<123) ) continue;
    if( a == 95 || a==45 ) continue;

    //Si estamos aca es porque es un caracter que quivale al espacio.
    memset(new, 0, sizeof(char)*len); //Reseteamos el array
    for(j = 0; j < (i - init); j++){ //Copiamos la nueva palabra
      new[j] = string[init + j];
    }
    //En caso de ser capicua, la agregamos al string de palabras
    if(is_palindrome(new)){
      //Se agrega letra por letra
      for(j = 0; j < (i - init); j++){
        return_array[cant] = new[j];
        cant++;
        //En caso de alcanzar el limite, se redimensiona
        if (cant == size){
          return_array = realloc(return_array, sizeof(char)*(size += size/4) );
          if (!return_array){//Control de error
            printf("%s%s\n", REALLOC_ERROR, strerror(errno));
            return NULL;
          }
        }
      }
      //Fin de palabra
      return_array[cant] = '\n';
      cant++;
      //En caso de alcanzar el limite, se redimensiona
      if (cant == size){
        return_array = realloc(return_array, sizeof(char)*(size += size/4) );
        if (!return_array){//Control de error
          printf("%s%s\n", REALLOC_ERROR, strerror(errno));
          return NULL;
        }
      }
    }
    init = i + 1;
  }
  free(new);

  return realloc(return_array, sizeof(char)*cant);
}

bool is_palindrome(char* string){
  /* Si tiene un solo caracter entonces es palindromo */
  int len = strlen(string);
  if (len < 1) return false;
  else if (len == 1) return true;
  /*Analizamos la palabra*/
  bool result = false;
  /*Pasamos a minuscula los caracteres*/
  char* lower = malloc(sizeof(char)*len);
  if (!lower){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    return false;
  }
  memset(lower, 0, sizeof(char)*len);
  //Pasamos a minuscula
  int i;
  for(i = 0; i < len; i++){
    lower[i] = tolower((unsigned char)string[i]);
  }
  lower[i] = '\0'; //Fin de cadena
  /*Verificamos si es capicua*/
  char* copy = malloc(sizeof(char)*len);
  if (!copy){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    free(lower);
    return false;
  }
  /*Se copia y se invierte*/
  strcpy(copy, lower);
  strrev(copy);
  if(!strcmp(lower, copy)) result = true;
  //Se liberan los strings usados
  free(lower);
  free(copy);

  return result;
}
