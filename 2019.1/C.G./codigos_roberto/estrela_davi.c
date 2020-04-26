#include <GL/glut.h>
#include <stdlib.h>

/*
	Compilando este código-fonte : gcc prog3.c -o prog3.exe -lglut -lGL -lGLU -lm
	Executando : ./prog3.exe
	Referência : https://processolinux.wordpress.com/2009/07/31/compilando-codigo-em-c-e-opengl-no-linux/
*/

// A GLUT é baseada em Eventos.

/*
	Para limpar a tela, usam-se duas funções : Uma para especificar a cor de fundo(glClearColor) e outra para
	pintar o fundo da janela com essa cor(glClear).
*/

/**
	Neste exemplo, vai ser feita uma Estrela de Davi, com o uso de seis retas.
	No total, teremos seis vértices e doze coordenadas. Cada Vértice é formado por duas coordenadas do plano cartesiano xy.
*/


void init(void){
	 glClearColor(1.0,1.0,1.0,0.0); // Fornece os valores para limpeza do buffer de cor no modo RGBA.
	 glOrtho(0,256,0,256,-1,1); // Seleciona o modo de projeção Ortogonal.
}

void display(void){
	 glClear(GL_COLOR_BUFFER_BIT); // Limpa toda a janela para a cor do comando glClearColor.
	 //glClearColor(1.0,1.0,1.0,0.0); // Fornece os valores para limpeza do buffer de cor no modo RGBA.
	 glColor3f(0.0,0.0,1.0); // Seleciona a cor azul para a linha. 3f indica que a função recebe 3 valores de ponto flutuante
	 // como argumentos da função glColor3f.
	 glBegin(GL_LINES); // Definindo a primitiva que se quer desenhar, ou seja, uma linha. Depois disso, tem que informar as coordenadas 
	 // do ponto inicial e final.
	 // Desenhando o primeiro triângulo.
	 // OBS : Lembre-se que com dois pontos, se define uma reta.
	 glVertex2i(120,80);  glVertex2i(90,160);  // Fornece as coordenadas do ponto inicial e final. OBS : O primeiro glVertex2i
	 // informa o ponto inicial e o outro é o final. OBS : 2i indica dois valores de tipo inteiro.
	 glVertex2i(120,80); glVertex2i(150,160);
	 glVertex2i(90,160); glVertex2i(150,160);
	 // Desenhando o segundo triângulo.
	 glVertex2i(90,110); glVertex2i(150,110);
	 glVertex2i(90,110); glVertex2i(120,190);
	 glVertex2i(150,110); glVertex2i(120,190);
	 glEnd();
	 glFlush(); // Determina que se completem os comandos enviados, esvaziando buffers com comandos. 
}

void keyboard(unsigned char key, int x, int y){
	 if(key == 27) // Quando apertar ESC, então a janela será fechada.
	 	exit(0);
}

int main(int arg, char* argv[]){
	glutInit(&arg,argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(300,300);
	glutInitWindowPosition(200,200);
	glutCreateWindow("Exiba Estrela de Davi");
	init();
	glutDisplayFunc(display); 
	glutKeyboardFunc(keyboard); // Determinam as funções que usaremos para ler do teclado.
	glutMainLoop();
	return 0;
}