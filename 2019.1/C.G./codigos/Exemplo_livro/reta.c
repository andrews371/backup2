#include <GL/glut.h>
#include <stdio.h>
#include <time.h>

int pontos;


float Reta_dois_pontos(float x)
{ 
	float x0,y0,x1,y1;
	x0 = -40; y0 = -40; x1 = -30; y1 = -20;
	float y;

	y = (y1-y0)/(x1-x0)*(x-x0) - y0;
	return(y);
}

void display()
{
	float x0,y0,x1,y1;
	x0 = -40; y0 = -40; x1 = -30; y1 = -20;
	int	i ;
	float x,y;

	
	for (i=0;i<pontos;i++)
	{
		x = x0 + i * (x1 - x0)/pontos;
		y = Reta_dois_pontos(x);

		glClear(GL_COLOR_BUFFER_BIT);
  		glColor3f (0.0, 0.0, 0.0);
		glBegin(GL_POINTS);
		glVertex2f(x,y);
		glEnd();
	}
	glFlush();
	glutSwapBuffers();

}


void init()
{  
  glClearColor(1.0,1.0,1.0,1.0); // indica a cor que será usada no fundo da janela
  glOrtho (-45, -25, -45, -15, -1, 1); // Posiciona a tela em comparação ao objeto. Os dois primeiros parâmetros são o mínimo
  // e o máximo do x que irá variar que nós vamos ver e os próximos dois são o mínimo e o máximo do y irá variar que nós vamos ver.
  // bom deixar uma margem de sobra para ver todo o objeto. É o referencial para a partir de que ponto até que ponto vamos ver o objeto
}

int main(int argc, char **argv)
{
	clock_t t;
  int cont = 0;
  float tempo = 0;

  glutInit(&argc, argv); // inicia a biblioteca glut
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(256,256); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Retas usando o OpenGL"); // Título da janela
  init();

  t = clock();
  glutDisplayFunc(display);
  t = clock() - t;
  tempo = (float)t/CLOCKS_PER_SEC;
  printf("\nTempo: %.2f\n\n", tempo);


  glutMainLoop();
	return 0;
}