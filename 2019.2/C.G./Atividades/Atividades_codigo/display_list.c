// Andre Oliveira de Sousa - 11325684

#include<GL/glut.h>
GLint rx = 0, ry = 0, rz = 0;
GLuint Cubo;

// Declaração das funções utilizadas
void display();
void init();
void linha();


int main(int argc, char** argv)
{
  glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500, 500); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Cubo 3D"); // Título da janela
  init();
  glutDisplayFunc(display); // chama a função que construímos para desenhar inclusive redesenha ao redimensionar janela

  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}


void init(){
  Cubo = glGenLists(1);
  glNewList(Cubo, GL_COMPILE);

    glColor3f(1.0, 0.0, 0.0);
    glBegin(GL_TRIANGLES);
      glVertex2f(0.0, 0.0);
      glVertex2f(1.0, 0.0);
      glVertex2f(0.0, 1.0);
    glEnd();
    glTranslatef(1.5, 0.0, 0.0);

  glEndList();
  glShadeModel(GL_FLAT);

}

void linha(){
  glBegin(GL_LINES);
    glVertex2f(0.0, 0.5);
    glVertex2f(15.0, 0.5);
  glEnd();
}

// Funções utilizadas


void display(){
  glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
  glClear(GL_COLOR_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela

  GLuint i;
  glColor3f(0.0, 1.0, 0.0);
  for (i = 0; i < 1; i++){
    glCallList(Cubo);
    linha();
    glFlush();
  } 


}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl