#include<stdio.h>    
//#include<GL/glut.h> // biblioteca para usar o OpenGL
//#include<stdlib.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>
#include <time.h>

int main(){
clock_t inicio, fim;
float tempo;

inicio = clock();
for (int i = 0; i < 1000000; i++)
	for (int j = 0; j < 2000; j++);

fim = clock();

tempo = fim - inicio;
tempo = tempo / CLOCKS_PER_SEC;
printf("%f\n", tempo);

return 0;


}