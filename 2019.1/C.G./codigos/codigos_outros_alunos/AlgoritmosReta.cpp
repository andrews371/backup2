#include <iostream>
#include <GL/glut.h>
#include <math.h>
#include <chrono>
#include <unistd.h>
#include <time.h>

using namespace std;
void display();



int main(int argc, char *argv[])
{   
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(400, 400);
	glutInitWindowPosition(100, 100);	
	glutCreateWindow("Desenhos Retas");
	glutDisplayFunc(display);

	glutMainLoop();
	return 0;
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



void display()
{
	glClearColor(0,0,0,1);
	glClear(GL_COLOR_BUFFER_BIT);
	gluOrtho2D(-80, 30, -80, 30);
    glPointSize(10.0f);

	glBegin(GL_POINTS);
	glColor3d(1, 0, 0);
	auto start = std::chrono::steady_clock::now();
	//int i;
	EqReta(-40, -40, -30, -20);
	
	auto endEqReta = std::chrono::steady_clock::now();
	
	cout << "Tempo Equação da Reta: " << std::chrono::duration_cast<std::chrono::nanoseconds>(endEqReta - start).count() << "ns";
	
	
	
            
	glColor3d(0, 1, 0);
	
	start = std::chrono::steady_clock::now();
	
		Bresenham(-40, -40, -30, -20);
	    
	auto endBresenham = std::chrono::steady_clock::now();
	cout << "\nTempo Algoritmo de Bresenham: " << std::chrono::duration_cast<std::chrono::nanoseconds>(endBresenham - start).count() << "ns";
        
	start = std::chrono::steady_clock::now();
	glColor3d(0, 0, 1);
	
	DDA(-40, -40, -30, -20);
	
	
	auto endDDA = std::chrono::steady_clock::now();
	
	cout << "\nTempo Algoritmo DDA: " << std::chrono::duration_cast<std::chrono::nanoseconds>(endDDA - start).count() << "ns\n";
	glEnd();
	
    	
	glBegin(GL_LINES);
	
		start = std::chrono::steady_clock::now();
		glColor3d(1, 1, 1);
		glVertex2i(-40, -40);
		glVertex2i(-30, -20);
		
		auto endBresenhamOpGL = std::chrono::steady_clock::now();
		
		cout << "\nTempo Algoritmo Bresenham do GL: " << std::chrono::duration_cast<std::chrono::nanoseconds>(endBresenhamOpGL - start).count() << "ns\n";
	glEnd();
	glFlush();
}






