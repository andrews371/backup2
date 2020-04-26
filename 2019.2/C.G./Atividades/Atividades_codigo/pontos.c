#include<stdio.h>    
#include<GL/glut.h> // biblioteca para usar o OpenGL
#include<stdlib.h>

void display()
{
  glClear(GL_COLOR_BUFFER_BIT); // Limpa o buffer antigo após redimensionamento da janela
 
  glBegin(GL_POINTS); // função para desenho de pontos
      glColor3f(1,0,0); // indica qual a cor o ponto terá
      glVertex3f (0.25, 0.25, 0.0); // coordenadas do ponto
      glColor3f (0,1,0);
      glVertex3f (0.75, 0.25, 0.0);
      glColor3f(0,0,1);
      glVertex3f (0.75, 0.75, 0.0);
  glEnd(); // fim da função para desenhar pontos "GL_POINTS"

  glFlush (); // Imprime na tela do pc o que estava no buffer ( todo o desenho feito )

}

void init(){
  glClearColor(0, 0, 0, 0.0); // Limpa o fundo de janela inserindo a cor especificada
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
}
		
int main(int argc, char** argv){

  glutInit(&argc, argv); // inicia a biblioteca glut
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(512,512); // Tamanho da janela que abrirá
  glutInitWindowPosition(100,100); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Pontos"); // Título da janela
  init();
  glutDisplayFunc(display); // chamada da função que realmente desenha. Necessário usar glutDisplayFunc 
   							// para poder usar comandos de redimentsionamento de janela, etc.

  glutMainLoop(); 
  return 0;
}
