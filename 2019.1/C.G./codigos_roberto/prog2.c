#include <GL/glut.h> // OBS : Essa biblioteca já tem gl.h e GLU.h
#include <stdlib.h>

/*
	Compilando este código-fonte : gcc prog2.c -o prog2.exe -lglut -lGL -lGLU -lm
	Executando : ./prog2.exe
	Referência : https://processolinux.wordpress.com/2009/07/31/compilando-codigo-em-c-e-opengl-no-linux/
*/

// A GLUT é baseada em Eventos.

/*
	Para limpar a tela, usam-se duas funções : Uma para especificar a cor de fundo(glClearColor) e outra para
	pintar o fundo da janela com essa cor(glClear).
*/

void display(void){
	 /** Os dois primeiros comandos abaixo, servem para definir a limpeza e a cor do fundo da janela criada. */
	 glClear(GL_COLOR_BUFFER_BIT);  // Limpa toda a janela para a cor do comando glClearColor.
	 glClearColor(1.0,1.0,1.0,0.0); // Fornece os valores para limpeza do buffer de cor no modo RGBA.
	 glColor3f(1,0,0); // Definindo a cor de desenho. Aqui é o modo RGB. Então, o 1 está ativando apenas a cor vermelha.
	 glBegin(GL_TRIANGLES); // Realizando o desenho, com uso de uma primitiva.
	 // Como o triângulo têm três vértices. então tem que definir esses 3 vértices.
	 glVertex2f(-0.5,-0.5); // Coordenada x e y do vértice.
	 glVertex2f(0.0,0.5);
	 glVertex2f(0.5,-0.5);
	 glEnd();
	 glFlush(); // Determina que se completem os comandos enviados, esvaziando buffers com comandos. 
}

void keyboard(unsigned char key, int x, int y){
	 if(key == 27) // Quando apertar ESC, então a janela será fechada.
	 	exit(0);
}

int main(int arg, char* argc[]){
	glutInit(&arg,argc); // É preciso colocar este comando.
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB); // Uso do buffer, para gerar imagens e cores no modo RGB. Inicialização da GLUT em si.
	glutInitWindowSize(300,300); // Tamanho da janela.
	glutInitWindowPosition(400,600); // Posição da janela na tela.
	glutCreateWindow("Janela Grafica. Mostre Triangulo"); // Criando a janela. A String recebida é o nome(identificador) que damos a janela criada.
	glutDisplayFunc(display); // Toda vez que o GLUT determinar que a janela tem de ser desenhada, ele chamará
	// a função aqui determinada.
	glutKeyboardFunc(keyboard); // Aqui é para evento do teclado. Quando apertar alguma tecla do teclado.
	glutMainLoop(); // É o último comando que chamamos. Ele faz com que todas as janelas criadas sejam mostradas.
	// Uma vez que encontramos neste loop, só saímos quando o programa se encerra.
	return 0;
}