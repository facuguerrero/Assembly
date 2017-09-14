#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

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
 * @return: FAIL | SUCCESS*/
int write_result(FILE* output_fp, char* result);

int main(int argc, char** argv){
  //Esto hay que reemplazarlo por los args
  FILE* input_fp = open_input(argv[1]);
  FILE* output_fp = open_output(argv[2]);
  //Lectura del archivo
  char* input_string = read_input(input_fp, INIT_SIZE);
  //TODO: Cambiarlo por una funcion que devuelva solo los palindromos
  char* result_string = input_string;
  //Escritura del resultado
  write_result(output_fp, result_string);

  if (input_string) free(input_string);
  fclose(input_fp);

  return 0;
}

char* read_input(FILE* fp, size_t size){
  char* string;
  int char_;
  size_t len = 0; //Tamaño actual del arreglo

  //Arreglo inicial
  string = malloc(sizeof(char)*size);
  if (!string){
    printf("%s%s\n", ALLOC_ERROR, strerror(errno));
    return NULL; //realloc error
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
  int written = fputs(result, fp);
  //Si no se logró escribir completo o hubo algún error, se notifica.
  if (written == EOF){
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
    printf("%s\n", DEFAULT_INPUT_MESSAGE);
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
    printf("%s\n", DEFAULT_OUTPUT_MESSAGE);
    output_fp = DEFAULT_OUTPUT;
  }
  return output_fp;
}
