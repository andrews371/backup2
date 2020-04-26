// Andre Oliveira de Sousa - 11325684

#include<GL/glut.h>

GLint rx = 0, ry = 0, rz = 0;

void desenha_boneco()
{ 
  // muda para o sistema de coordenadas do modelo
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity(); // inicializa a matriz de transformação atual

  // tronco do boneco
  glTranslated(0, 0, -20); // define a posição do objeto na cena

  // realiza operações de rotação no objeto
  glRotated(rx, 1, 0, 0);
  glRotated(ry, 0, 1, 0);
  glRotated(rz, 0, 0, 1);

  glColor3f(1.0, 1.0, 1.0);
  glutSolidSphere(40, 30, 36); // raio, fatia (se diminuir fica mais "quadriculado") e pilha

  // cabeça do boneco
  glTranslated(0, 56, 0);
  glColor3f(1.0, 1.0, 1.0);
  glutSolidSphere(20, 30, 36); // raio, fatia e pilha

  // olho esquerdo
  glTranslated(-7, 0, 0);
  glColor3f(0.0, 0.0, 0.0);
  glutSolidSphere(4, 30, 36); // raio, fatia e pilha

  // olho direito
  glTranslated(14, 0, 0);
  glColor3f(0.0, 0.0, 0.0);
  glutSolidSphere(4, 30, 36); // raio, fatia e pilha


  glFlush(); // esse comando exibe o que está armazenado no buffer
         // se esse comando não for chamado, a janela abrirá mas não exibirá nada que foi feito
         // e que está apenas no buffer.
}

void display(){
  glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
  glClear(GL_COLOR_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual
  glOrtho(-80.0, 80.0, -80.0, 80.0, 1, 100);  // projeção paralela
  glViewport(0 , 0, 400, 400);
  desenha_boneco();
}

void teclado (unsigned char tecla, GLint x, GLint y){
  switch (tecla){
    // rotação
    case 'x':
    case 'X': rx++;
              break;
    case 'y':
    case 'Y': ry++;
              break;
    case 'z':
    case 'Z': rz++;
          break;
  }
    display();
}

int main(int argc, char** argv)
{
  glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500, 500); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Boneco de Neve"); // Título da janela
  glutDisplayFunc(display); // chama a função que construímos para desenhar inclusive redesenha ao redimensionar janela
  glutKeyboardFunc(teclado);

  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl