#include<stdio.h>    
#include<GL/glut.h> // biblioteca para usar o OpenGL
#include<time.h>    // biblioteca para usar funções de tempo


void exibir(){

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  clock_t t;
  int cont = 0;
  float tempo;
  int x1 = -40, y1 = -40, x2 = -30, y2 = -20;
  //glClearColor(1.0,1.0,1.0,1.0); // indica a cor que será usada no fundo da janela

  // "glClear(GL_COLOR_BUFFER_BIT);" Este comando pinta os buffers indicados com a cor 
  // especificada em glClearColor. 
  glClear(GL_COLOR_BUFFER_BIT);
  glPointSize(10.0f);

  // Aqui começam as configurações e inicialização das funções

  //Eq da reta
  glLoadIdentity();
  glTranslated(-15,0,0);
  //gluOrtho2D(-80, 30, -80, 30); //left, right, bottom, up. Posiciona a tela em comparação ao objeto. 
  glColor3d(1,0,0);
  glBegin(GL_POINTS);
    t = clock();
    for (cont = 0; cont <= 10000; cont++){
      EqReta(x1, y1, x2,y2);
    }
    
    t = clock() - t;
    tempo = (float)t/CLOCKS_PER_SEC;
    printf("\nTempo equação da reta: %f segundos\n\n", tempo);
  glEnd();

  // Bresenham
  glLoadIdentity();
  glTranslated(0,0,0);
  //gluOrtho2D(-80, 30, -80, 30); //left, right, bottom, up. Posiciona a tela em comparação ao objeto.
  glColor3d(0,1,0);
  glBegin(GL_POINTS);
    //glColor3d(0,1,0);
    t = clock();
    for (cont = 0; cont <= 10000; cont++){
      Bresenham(x1, y1, x2,y2);
    }

    t = clock() - t;
    tempo = (float)t/CLOCKS_PER_SEC;
    printf("\nTempo Bresenham: %f segundos\n\n", tempo);
  glEnd();

  // DDA
  glLoadIdentity();
  glTranslated(15,0,0);
  //gluOrtho2D(-80, 30, -80, 30); //left, right, bottom, up. Posiciona a tela em comparação ao objeto. 
  glColor3d(0,0,1);
  glBegin(GL_POINTS);
    t = clock();
    for (cont = 0; cont <= 10000; cont++){
      DDA(x1, y1, x2,y2);
    }
    
    t = clock() - t;
    tempo = (float)t/CLOCKS_PER_SEC;
    printf("\nTempo DDA: %f segundos\n\n", tempo);
  glEnd();

  // Reta nativa GL
  glLoadIdentity();
  glTranslated(-5, -25 , 0); // Operação no objeto em relação à tela
  //gluOrtho2D(-80, 30, -80, 30); // left, right, bottom, up. Posiciona a tela em comparação ao objeto.
                                // Mínimo e máximo em comparação às diminsões do objeto  

 // Cor usada para desenhar objetos (para ficar visível tem que ser diferente da usada para limpar a tela)
  glColor3f(0.0,0.0,0.0);
  glBegin(GL_LINES);
    t = clock();
    for (cont = 0; cont <= 10000; cont++){
      glVertex2f(-40,-40);
      glVertex2f(-30,-20);
    }
    t = clock() - t;
    tempo = (float)t/CLOCKS_PER_SEC;
    printf("\nTempo Bresenham do GL: %f segundos\n\n", tempo);  
  glEnd();


  glFlush();
}

void DDA(int x1, int y1, int x2, int y2){
  float dx, dy, tam, xT, yT, j;
  
  dx = x2 - x1;
  dy = y2 - y1;

  tam = abs(dx) > abs(dy) ? abs(dx) : abs(dy);

  xT = dx/tam;
  yT = dy/tam;

  glVertex2i(x1, y1);

  for(j = 1; j < tam; j++){
    x1 += xT;
    y1 += yT;
    glVertex2i(x1, y1);
    
    
  }
}

void Bresenham(int x1, int y1, int x2, int y2){
  int dx, dy, x, y, xfinal, p, const1, const2;

  dx = fabs(x1-x2);
  dy = fabs(y1-y2);
  
  p = 2 * dy - dx;

  const1 = 2 * dy;
  const2 = 2 * (dy - dx);

  if(x1 > x2){
    x = x2;
    y = y2;
    xfinal = x1;  
  }else{
    x = x1;
    y = y1;
    xfinal = x2;  
  }
  
  glVertex2i(x ,y);

  while(x <= xfinal) {
    x++;
    if(p < 0){
      p+= const1;
    }else{
      y++;
      p+= const2;     
    }
    
    glVertex2i(x, y);
  }
}

void EqReta(int x1, int y1, int x2, int y2){
  // Foi utilizada a equação Y-Yo = m(x-x0)
  float xf, yf; 
  // XF e YF foram utilizadas dentro do Laço de Repetição
  // Para servirem como o ponto futuro, em que o XF será
  //incrementando para, dessa forma, chegarmos em um YF
  
  int dx = x2 - x1;
  int dy = y2 - y1;

  float m = (float)dy / (float)dx;
  // Acima o cálculo do coeficiente Angular

  glVertex2i(x1, y1);
  //Plota Pontos

  for(xf = x1; xf < x2; xf++){
    dx = xf - x1;
    yf = (m * (float)dx) + (float)y1;
    //Acima descobrimos o valor de YF tendo como partida um XF. 
    glVertex2i(xf, yf);
  } 
}

void init() {
  glClearColor(1,1,1,1); // indica a cor que será usada no fundo da janela
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual
  gluOrtho2D(-80, 30, -80, 3); 
}

int main(int argc, char** argv){

  glutInit(&argc, argv); // inicia a biblioteca glut
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(512,512); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Retas usando o OpenGL"); // Título da janela
  init();
  glutDisplayFunc(exibir);

  glutMainLoop(); 
  return 0;
}



// Obs.: 

// glOrtho(-80, 30, -80, 30, -1, 1); Usado em 3D. Posiciona a tela em comparação ao objeto. 
// Os dois primeiros parâmetros são o mínimo e o máximo do x que irá variar que nós vamos ver e 
// os próximos dois são o mínimo e o máximo do y que irá variar que nós vamos ver.
// bom deixar uma margem de sobra para ver todo o objeto. 
// É o referencial para a partir de que ponto até que ponto vamos ver os objetos
// os dois últimos parâmetros aqui não estão sendo usados, que seria o near, far. 
// Aqui a projeção é em 2D por isso não usamos.