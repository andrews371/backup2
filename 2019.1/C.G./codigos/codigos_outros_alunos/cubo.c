//#include<stdio.h>
//#include<math.h>
#include<GL/glut.h>

void tela()
{ /*esta chave e da funcao tela*/
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-20.0, 30.0, -20.0, 30.0, 1, 100);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslated(0, 0, -20);

	glRotatef(45.0, 1.0, 0.0, 0.0);
	glRotatef(45.0, 0.0, 1.0, 0.0);

	glBegin(GL_LINES);
		glColor3f(1.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(10.0, 0.0, 0.0);

		glColor3f(0.0, 1.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 10.0, 0.0);

		glColor3f(0.0, 0.0, 1.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 10.0);

		glColor3f(1.0, 1.0, 1.0);
		glutWireCube(5.0);
	glEnd();

	glFlush();
}


void main(int argc, char **argv)
{
	glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(500,500);
	glutCreateWindow("Funciona, amem!");
	glutDisplayFunc(tela);
	glutMainLoop();
}





