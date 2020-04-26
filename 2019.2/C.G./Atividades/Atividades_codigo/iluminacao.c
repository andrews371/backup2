// Andre Oliveira de Sousa - 11325684

#include<GL/glut.h>
#include<stdio.h>
#include<stdbool.h>

float projec = 200;

bool liga = false;

// protótipos
void desenha();
void display();
void projecao(int w, int h);
void redesenha(int w, int h);
void teclado (unsigned char tecla, GLint x, GLint y);

void desenha()
{ 
 
  // hablitando o z-buffer
  glEnable(GL_DEPTH_TEST);	

  // muda para o sistema de coordenadas do modelo
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity(); // inicializa a matriz de transformação atual

  glTranslated(0, 0, -300); // define a posição do objeto na cena
  glPushMatrix();

  glColor3f(1.0, 1.0, 1.0);
  glutSolidTeapot(30); 


}

void display() {

  // materiais, posições da iluminação, cor da iluminação
  GLfloat mat_specular[] = {1.0, 1.0, 1.0, 1.0};
  GLfloat mat_shininess[] = {50.0};
  GLfloat left_position[] = {-30.0, 0.0, 1.0, 0.0};
  GLfloat right_position[] = {30.0, 0.0, 1.0, 0.0};
  GLfloat white_light[] = {1.0, 1.0, 1.0, 1.0};
  GLfloat blue_light[] = {0.0, 0.0, 1.0, 1.0};
  GLfloat red_light[] = {1.0, 0.0, 0.0, 1.0};
  GLfloat lmodel_ambient[] = {0.1, 0.1, 0.1, 1.0};

  glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
  glShadeModel(GL_SMOOTH);

  glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
  glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);

  // luz azul, posição esquerda
  glLightfv(GL_LIGHT1, GL_POSITION, left_position);
  glLightfv(GL_LIGHT1, GL_DIFFUSE, blue_light);
  glLightfv(GL_LIGHT1, GL_SPECULAR, blue_light);

  // luz vermelha, posição direita
  glLightfv(GL_LIGHT2, GL_POSITION, right_position);
  glLightfv(GL_LIGHT2, GL_DIFFUSE, red_light);
  glLightfv(GL_LIGHT2, GL_SPECULAR, red_light);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);

  glEnable(GL_DEPTH_TEST);

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela
  glDrawBuffer(GL_BACK);

  // desenhando a chaleira
  desenha();
  glutSwapBuffers();
}

void projecao(int w, int h){
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual

  if (w <= h) {
    glOrtho(-projec, projec, -projec*h/w, projec*h/w, 1, 600);  // projeção paralela
  }  
  else {
     glOrtho(-projec*w/h, projec*w/h, -projec, projec, 1, 600);  // projeção paralela
  }
 
}

void redesenha(int w, int h) {
  glViewport(0,0,w,h); // mapeando toda a janela começando de 0,0 até o comprimento maximo w e altura maxima h
  projecao(w, h); // função que irá projetar o desenho em tela
  
}

void teclado (unsigned char tecla, GLint x, GLint y){
  switch (tecla){
  	// ligando e desligando o sistema de iluminação
    case 'l': 
    case 'L': if(liga == false){
                glEnable(GL_LIGHTING);
                liga = true;
              } 

              else {
                glDisable(GL_LIGHTING);
                liga = false;
              }
              break;

    // habilitando a iluminação à esquerda azul
    case '1':      
                glEnable(GL_LIGHT1);
          
              break;

    // habilitando a iluminação à direita vermelha
    case '2': 
                glEnable(GL_LIGHT2);
 
                         
              break;


    // desabilitando as iluminações azul e vermelha
    case '0': 
    			glDisable(GL_LIGHT1);
                glDisable(GL_LIGHT2);
 
                         
              break;

  }
    glutPostRedisplay();
}

int main(int argc, char** argv)
{
  glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowSize(1000, 1000); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Iluminacao"); // Título da janela
  glutKeyboardFunc(teclado);
  glutDisplayFunc(display); // chama a função que construímos para desenhar inclusive redesenha ao redimensionar janela
  glutReshapeFunc(redesenha);

  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl