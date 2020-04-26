// Andre Oliveira de Sousa - 11325684

#include<GL/glut.h>
#include<stdio.h>

GLfloat rMercurio = 0, rVenus = 0, rTerra = 0, rMarte = 0, rJupiter = 0, rSaturno = 0, 
	  rUrano = 0;

float projec = 200;

// protótipos
void sistema_solar();
void display();
void projecao(int w, int h);
void redesenha(int w, int h);
void teclado (unsigned char tecla, GLint x, GLint y);

void sistema_solar()
{ 
 
  // hablitando o z-buffer
  glEnable(GL_DEPTH_TEST);	

  // muda para o sistema de coordenadas do modelo
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity(); // inicializa a matriz de transformação atual

  glTranslated(0, 0, -300); // define a posição do objeto na cena
  glPushMatrix();

  // Sol
  glColor3f(1.0, 1.0, 0.0);
  glutSolidSphere(30, 30, 36); // raio, fatia (se diminuir fica mais "quadriculado") e pilha

  // Mercúrio
  glRotatef((rMercurio), 0, 1, 0);
  glTranslated(40, 0, 0);
  glColor3f(1.0, 0.0, 0.0);
  glutSolidSphere(4, 30, 36); // raio, fatia e pilha

  // Vênus
  glPopMatrix();
  glPushMatrix();
  glRotated(rVenus, 0, 1, 0);
  glTranslated(60, 0, 0);
  glColor3f(0.0, 1.0, 0.0);
  glutSolidSphere(6, 30, 36); // raio, fatia e pilha
 

  // Terra
  glPopMatrix();
  glPushMatrix();
  glRotated(rTerra, 0, 1, 0);
  glTranslated(-80, 0, 0);
  glColor3f(0.0, 0.0, 1.0);
  glutSolidSphere(4.4, 30, 36); // raio, fatia e pilha

  // Marte
  glPopMatrix();
  glPushMatrix();
  glRotated(rMarte, 0, 1, 0);
  glTranslated(-100, 0, 0);
  glColor3f(1.0, 0.0, 1.0);
  glutSolidSphere(2.5, 30, 36); // raio, fatia e pilha

  // Júpiter
  glPopMatrix();
  glPushMatrix();
  glRotated(rJupiter, 0, 1, 0);
  glTranslated(120, 0, 0);
  glColor3f(0.0, 1.0, 1.0);
  glutSolidSphere(8, 30, 36); // raio, fatia e pilha

  // Saturno
  glPopMatrix();
  glPushMatrix();
  glRotated(rSaturno, 0, 1, 0);
  glTranslated(140, 0, -40);
  glColor3f(0.5, 0.0, 1.0);
  glutSolidSphere(8, 30, 36); // raio, fatia e pilha

  // Urano
  glPopMatrix();
  glPushMatrix();
  glRotated(rUrano, 0, 1, 0);
  glTranslated(160, 0, 55);
  glColor3f(0.0, 0.5, 0.5);
  glutSolidSphere(7, 30, 36); // raio, fatia e pilha


}

void display() {
  glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela
  glDrawBuffer(GL_BACK);
  sistema_solar();
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

  	// rotação dos planetas
    case 'r': rMercurio += 8;
    		  rVenus += 6;
    		  rTerra += 4;
    		  rMarte += 3;
    		  rJupiter += 2;
    		  rSaturno += 1;
    		  rUrano += 0.5;
    		  break;

    case 'R': rMercurio -= 8;
    		  rVenus -= 6;
    		  rTerra -= 4;
    		  rMarte -= 3;
    		  rJupiter -= 2;
    		  rSaturno -= 1;
    		  rUrano -= 0.5;
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
  glutCreateWindow("Boneco de Neve"); // Título da janela
  glutKeyboardFunc(teclado);
  glutDisplayFunc(display); // chama a função que construímos para desenhar inclusive redesenha ao redimensionar janela
  glutReshapeFunc(redesenha);

  glutMainLoop(); // até esse comando ser chamado a janela não é exibida.
  return 0;
}

// Obs.: comandos iniciados com glut são da glut, iniciados em glu são da glu
// iniciados com gl são do opengl, e iniciados em GL_ são constantes do opengl