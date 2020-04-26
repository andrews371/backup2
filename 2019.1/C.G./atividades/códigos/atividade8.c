// Andre Oliveira de Sousa - 11325684

#include<GL/glut.h>

void desenha_cubo()
{
	glClear(GL_COLOR_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela

	// muda para o sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity(); // inicializa a matriz de transformação atual
	glTranslated(0, 0, -20); // define a posição do objeto na cena

	// realiza operações de rotação no objeto
	glRotated(30, 1, 0, 0);
	glRotated(30, 0, 1, 0);
	glRotated(30, 0, 0, 1);

	glBegin(GL_LINES);

		// desenhando a reta x
		glColor3f(1.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(20.0, 0.0, 0.0);

		// desenhando a reta y
		glColor3f(0.0, 1.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 20.0, 0.0);

		// desenhando a reta z
		glColor3f(0.0, 0.0, 1.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 20.0);

		// desenhando o cubo
		glColor3f(0.0, 1.0, 1.0);
		glutWireCube(15);
	glEnd();

	glFlush(); // esse comando exibe o que está armazenado no buffer
			   // se esse comando não for chamado, a janela abrirá mas não exibirá nada que foi feito
			   // e que está apenas no buffer.
}

void init(){
	glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity(); // inicializa a matriz de projeção atual
	glOrtho(-50.0, 50.0, -50.0, 50.0, 1, 50); 

}

int main(int argc, char** argv)
{
	glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(500,500); // Tamanho da janela que abrirá
	glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
	glutCreateWindow("Cubo 3D"); // Título da janela
	init();
	glutDisplayFunc(desenha_cubo); // chama a função que construímos para desenhar
	glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
	return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl




