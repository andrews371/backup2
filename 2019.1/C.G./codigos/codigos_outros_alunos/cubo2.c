#include <GL/glut.h>
#include <stdio.h>

int firstRun = 1;
int runToSide = 0;
 
void linhas(){

    glClearColor(0,0,0,1);
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-500.0,500.0,-500.0,500.0, -500, 500);

    glMatrixMode(GL_MODELVIEW);
    glTranslated(40, 0, 0);


    if(firstRun){       //função rotacionar
        glRotated(90, 1, 0, 0);
        firstRun = 0;
    }

    glRotated(runToSide, 0, 0, 1);
    glColor3f(1.0, 1.0, 0.0);
	glutWireCube(80.0);
    


    glBegin(GL_LINES);

        
        glTranslated(40, 0, 0);

		glColor3f(1.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(500.0, 0.0, 0.0);
        glTranslated(50, 0, 0);

		glColor3f(0.0, 1.0, 0.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 500.0, 0.0);
        glTranslated(50, 0, 0);

		glColor3f(0.0, 0.0, 1.0);
		glVertex3f(0.0, 0.0, 0.0);
		glVertex3f(0.0, 0.0, 500.0);
        glTranslated(50, 0, 0);

		glEnd();
    glFlush();
    
    glTranslated(-40, 0, 0);
}




void arrowsAction(int key, int x, int y){       //função de chamada das teclas.
    switch(key){
        case GLUT_KEY_RIGHT:
            runToSide = 10;
            glutPostRedisplay();
            break;
        case GLUT_KEY_LEFT:
            runToSide = -10;
            glutPostRedisplay();
            break;
    }
}

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE);
    glutInitWindowSize(500, 500);
    glutCreateWindow("kyllder Medeiros");
    glutSpecialFunc(arrowsAction);
    glutDisplayFunc(linhas);
    glutMainLoop();
}
