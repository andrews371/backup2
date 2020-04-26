#include <GL/glut.h>

void init(void){
	 //glMatrixMode(GL_MODELVIEW);
     //glLoadIdentity();
	 glClearColor(1.0,1.0,1.0,0.0); // Cor de fundo da janela. Fornece os valores para limpeza do buffer de cor no modo RGBA.
	 glClear(GL_COLOR_BUFFER_BIT); // Limpa toda a janela para a cor do comando glClearColor.
	 glOrtho(0,256,0,256,-1,1); // Seleciona o modo de projeção Ortogonal.
}


void AlteraTamanhoJanela(GLsizei w, GLsizei h){
	 GLsizei largura, altura;
	 if(h == 0) // Evita divisão por zero.
	 	h = 1; 
	 // Abaixo, vai atualizar as variáveis.
	 largura = w;
	 altura = h;
	 // Abaixo, especifica as dimensões da Viewport.
	 glViewport(0,0,largura,altura);
	 // Inicializa o sistema de coordenadas.
	 glMatrixMode(GL_PROJECTION);
	 glLoadIdentity();
	 // Estabelece a janela de seleção (esquerda,direita,inferior,superior)
	 // mantendo a proporção com a janela de visualização.
	 if(largura <= altura)
	 	gluOrtho2D(-40.0f,40.0f,-40.0f*altura/largura,40.0f*altura/largura);
	 else
	 	gluOrtho2D(-40.0f*largura/altura,40.0f*largura/altura,-40.0f,40.0f);
}	 
	 //glClearColor(1.0,1.0,1.0,0.0); // Fornece os valores para limpeza do buffer de cor no modo RGBA.


void display(void){

}

void keyboard(unsigned char key, int x, int y){
	 if(key == 27) // Quando apertar ESC, então a janela será fechada.
	 	exit(0);
}

int main(int arg, char* argv[]){
	glutInit(&arg,argv);
	
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	
	glutInitWindowSize(400,400);
	glutInitWindowPosition(500,200);
	glutCreateWindow("Casinha");
	init();
	glutDisplayFunc(display);
	glutKeyboardFunc(keyboard);
	glutMainLoop();
	return 0;
}