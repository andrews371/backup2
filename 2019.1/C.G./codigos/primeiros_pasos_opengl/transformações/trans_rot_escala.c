#include<stdio.h>
#include<stdlib.h>
#include<GL/glut.h>

void desenha()
{
  // muda para as coordenadas do modelo
  glMatrixMode(GL_MODELVIEW);

  // inicializa  a matriz de transformação atual
  glLoadIdentity();

  // limpa a janela de visualização com a cor de fundo 
  // definida previamente
  glClear(GL_COLOR_BUFFER_BIT); 

  // aplica uma transformação sobre a casinha que será desenhada
  // essa ordem é melhor, pois evita confusões e age em relação aos eixos 
  // x e y ou x, y e z do objeto (não da tela). Já a translação age no eixo x e y 
  // ou x, y e z da tela que é o que queremos. Portanto essa sequência é a mais intuitiva
  glTranslatef(15,0,0);
  // aplica uma transformação sobre a casinha que será desenhada
  glRotatef(90,0,0,1);
  // aplica uma transformação sobre a casinha que será desenhada
  glScalef(1,1.5,1);  

  // desenha uma casinha composta de um quadrado e um triângulo

  // altera a cor do desenho para azul
  glColor3f(0.0, 0.0, 1.0);
  // desenha a casa
  glBegin(GL_QUADS);
    glVertex2f(-15,-15);
    glVertex2f(-15,5);
    glVertex2f(15,5);
    glVertex2f(15,-15);
  glEnd();

  // altera a cor do desenho para branco
  glColor3f(1,1,1);
  // desenha a porta e a janela
  glBegin(GL_QUADS);
    glVertex2f(-4,-14.5);
    glVertex2f(-4,0);
    glVertex2f(4,0);
    glVertex2f(4,-14.5);
    glVertex2f(7,-5);
    glVertex2f(7,-1);
    glVertex2f(13,-1);
    glVertex2f(13,-5);
  glEnd();

  // altera a cor do desenho para azul
  glColor3f(0,0,1);
  // desenha as linhas da janela
  glBegin(GL_LINES);
    glVertex2f(7,-3);
    glVertex2f(13,-3);
    glVertex2f(10,-1);
    glVertex2f(10,-5);
  glEnd();

  //altera a cor do desenho para vermelho
  glColor3f(1,0,0);
  // desenha o telhado 
  glBegin(GL_TRIANGLES);
    glVertex2f(-15,5);
    glVertex2f(0,17);
    glVertex2f(15,5);
  glEnd();


  glFlush();
  
}

void init(){
  glClearColor(0.0,0.0,0.0, 0.0); // indica a cor que será usada no fundo da janela
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual
  glOrtho(-45, 45, -45, 45, -1, 1); 
}

int main(int argc, char** argv)
{
  glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500,500); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Exemplo RedBook"); // Título da janela
  init();
  glutDisplayFunc(desenha); // chama a função que construímos para desenhar
  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl




