#include<stdio.h>
#include<stdlib.h>
#include<GL/glut.h>

void display()
{
  glClear(GL_COLOR_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela
  glColor3f(1.0, 1.0, 1.0);
  glBegin(GL_POLYGON);
    glVertex3f(0.25,0.25,0.0);
    glVertex3f(0.75,0.25,0.0);
    glVertex3f(0.75,0.75,0.0);
    glVertex3f(0.25,0.75,0.0);
  glEnd();

  glFlush();
  
}

void init(){
  glClearColor(0.0,0.0,0.0, 0.0); // indica a cor que será usada no fundo da janela
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual
  glOrtho(0.0, 1.0, 0.0, 0.0, -1, 1); 

}

int main(int argc, char** argv)
{
  glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500,500); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Exemplo RedBook"); // Título da janela
  init();
  glutDisplayFunc(display); // chama a função que construímos para desenhar
  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl




