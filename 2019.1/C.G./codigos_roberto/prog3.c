#include <GL/glut.h> // OBS : Essa biblioteca já tem gl.h e GLU.h
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

/** Neste Exemplo, vamos desenhar um losango, usando 4 retas. */

void init(void){
	 glClearColor(1.0,1.0,1.0,0.0); // Fornece os valores para limpeza do buffer de cor no modo RGBA.
	 glOrtho(0,256,0,256,-1,1); // Seleciona o modo de projeção Ortogonal.
} 

void display(void){
	 //int i;
	 //glClearColor(1.0,1.0,1.0,0.0);
	 glClear(GL_COLOR_BUFFER_BIT); // Limpa toda a janela para a cor do comando glClearColor.
	 glColor3f(0.0,0.0,0.0); // Seleciona a cor preta para a linha. 3f indica que a função recebe 3 valores de ponto flutuante
	 // como argumentos da função glColor3f.
	 glBegin(GL_LINES); // Definindo a primitiva que se quer desenhar, ou seja, uma linha. Depois disso, tem que informar as coordenadas 
	 // do ponto inicial e final.
	 glVertex2i(20,100);  glVertex2i(100,20);  // Fornece as coordenadas do ponto inicial e final. OBS : O primeiro glVertex2i
	 // informa o ponto inicial e o outro é o final. OBS : 2i indica dois valores de tipo inteiro.
	 glVertex2i(100,20); glVertex2i(180,100);
	 glVertex2i(20,100); glVertex2i(100,180);
	 glVertex2i(100,180); glVertex2i(180,100);
	 glEnd();
	 glFlush(); // Determina que se completem os comandos enviados, esvaziando buffers com comandos. 
}

void keyboard(unsigned char key, int x, int y){ // Pelo que estou lembrado, isso será uma função de callback.
	 switch(key){
	 	case 27:
	 	 exit(0);
	 	 break;
	 }
}

int main(int argc, char* argv[]){
	glutInit(&argc,argv); // OBS : Observei que tem que colocar este comando, com os argumentos da função main.
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB); // Indica que vamos usar um buffer para geração de imagens
	// e cores no modo RGB.
	glutInitWindowSize(150,150); // Especifica as dimensões da janela em pixels.
	glutInitWindowPosition(100,100); // Especifica a coordenada superior esquerda da janela.
	glutCreateWindow("Desenha uma linha"); // Cria a janela e devolve um identificador único para a janela.
	// Até que o comando glutMainLoop seja chamado, a janela não será mostrada.
	init(); // Chamando a função init.
	glutDisplayFunc(display);
	glutKeyboardFunc(keyboard); // Determinam as funções que usaremos para ler do teclado.
	glutMainLoop(); // É o último comando que chamamos. Ele faz com que todas as janelas criadas sejam mostradas.
	// Uma vez que encontramos neste loop, só saímos quando o programa se encerra.
	return 0; 
}