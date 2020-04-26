#include<stdio.h>    
#include<GL/glut.h> // biblioteca para usar o OpenGL
#include<stdlib.h>
#include<math.h>
#include<time.h>    // biblioteca para usar funções de tempo
#define REPETICOES 10000

void display()
{
  clock_t inicio, fim;
  float xi, xf, yi, yf, x, y, m, dy, dx, p, y_aux, tempo;

  	xi = 1; yi = 1; // ponto P1
  	xf = 7; yf = 3; // ponto P2

	glClear(GL_COLOR_BUFFER_BIT); // Limpa o buffer antigo após redimensionamento da janela

	glBegin(GL_POINTS); // função para desenho de pontos

	inicio = clock(); // inicío da marcação de tempo para e eq. da reta
	for (int i = 0; i <= REPETICOES; i++){ // REPETICOES é uma constante no valor de 10000
	 	// eq. da reta
  		m = (yf - yi) / (xf - xi);

  		// indica qual a cor o ponto terá
  		glColor3f(1,0,0); 
  		glVertex3f(xi,yi,0.0); // desenha o 1º ponto
  		glVertex3f(xf,yf,0.0); // desenha o 2º ponto

  		for (x = xi + 1; x < xf; x++){
    		y = m * (x - xi) + yi; // equação da reta
    		y = round(y);
    		glVertex3f(x,y,0.0); 
  		}
    }

    fim = clock(); // fim da marcação de tempo para e eq. da reta
    tempo = fim - inicio;
    tempo = (tempo * 1000 / CLOCKS_PER_SEC);  // CLOCKS_PER_SECOND é uma constante = 1000000
    

    printf("\nTempo eq. reta %f milissegundos\n", tempo); 

    inicio = clock(); // inicío da marcação de tempo para o algoritmo DDA
    xi = xi + 4; xf = xf + 4;
    for (int i = 0; i <= REPETICOES; i++){
    	// DDA
      	m = (yf - yi) / (xf - xi);

      	// indica qual a cor o ponto terá
      	glColor3f(0,1,0);
      	glVertex3f(xi,yi,0.0);
      	glVertex3f(xf,yf,0.0);  

    	y_aux = yi;

    	for (x = xi + 1; x < xf; x++){
    		y_aux = y_aux + m;
    		y = round(y_aux);
    		glVertex3f(x,y,0.0);
    	}
    }

    fim = clock(); // fim da marcação de tempo para o algoritmo DDA
    tempo = fim - inicio;
    tempo = (tempo * 1000 / CLOCKS_PER_SEC);

    printf("Tempo DDA %f milissegundos\n", tempo); 


    inicio = clock(); // inicío da marcação de tempo para o algoritmo de Bresenham
    xi = xi + 4; xf = xf + 4;
    for (int i = 0; i <= REPETICOES; i++){
    	// Bresenham	
      	m = (yf - yi) / (xf - xi);

  	  	// indica qual a cor o ponto terá
      	glColor3f(0,0,1);
      	glVertex3f(xi,yi,0.0);
      	glVertex3f(xf,yf,0.0);  

      	y = yi;

      	dx = xf - xi; dy = yf- yi;
      	p = (2 * dy) - dx;

      	for (x = xi + 1; x < xf; x++){
      		if (p < 0) {
      			p = p + (2 * dy);
      		}
      		else {
      			y = y + 1; p = p + (2 * dy) - (2 * dx);
      		}
      		glVertex3f(x,y,0.0);
    	  }
    }

    fim = clock(); // fim da marcação de tempo para o algoritmo de Bresenham
    tempo = fim - inicio;
    tempo = (tempo * 1000 / CLOCKS_PER_SEC);

    printf("Tempo Bresenham %f milissegundos\n\n", tempo); 

    glEnd(); // fim da função para desenhar pontos "GL_POINTS"


    glBegin(GL_LINES);
    inicio = clock(); // inicío da marcação de tempo para o algoritmo de Bresenham nativo
    xi = xi + 4; xf = xf + 4;
    for (int i = 0; i <= REPETICOES; i++){
    	// Bresenham	
  	  	// indica qual a cor o ponto terá
      	glColor3f(0,0,1);
      	glVertex3f(xi,yi,0.0);
      	glVertex3f(xf,yf,0.0);  

    	
    }

    fim = clock(); // fim da marcação de tempo para o algoritmo de Bresenham nativo
    tempo = fim - inicio;
    tempo = (tempo * 1000 / CLOCKS_PER_SEC);

    printf("Tempo de Bresenham nativo %f milissegundos\n\n", tempo); 


 	glEnd(); // fim da função para desenhar pontos "GL_POINTS"

 	glFlush (); // Imprime na tela do pc o que estava no buffer ( todo o desenho feito )

}

void init(){
 	glClearColor(0, 0, 0, 0.0); // Limpa o fundo de janela inserindo a cor especificada
 	glMatrixMode(GL_PROJECTION);
 	glLoadIdentity();
 	glOrtho(0.0, 30, 0.0, 30.0, -1.0, 1.0);
 	glPointSize(10.0f); // Faz com que possamos visualizar o ponto aumentado
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
