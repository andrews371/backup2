#include <GL/glut.h>

#define SENS_ROT	3.0
#define SENS_OBS	10.0
#define SENS_TRANSL	10.0

GLfloat obx, oby, obz, obx_ini, oby_ini, obz_ini;
GLfloat rx_ini, ry_ini;
GLfloat rx, ry;
int x_ini,y_ini,bot;

void DesenhaEixos(void){
     //glClear(GL_COLOR_BUFFER_BIT);
     //glColor3f(0.0,0.0,1.0);
	 glBegin(GL_LINES);
	  	glColor3f(1.0f,0.0f,0.0f); // Cor Vermelha para o eixo x.
	  	glVertex3f(0.0f,0.0f,0.0f);
	  	glVertex3f(1.0f,0.0f,0.0f);
	  	glColor3f(0.0f,1.0f,0.0f); // Cor Verde para o eixo y.
	  	glVertex3f(0.0f,0.0f,0.0f);
	  	glVertex3f(0.0f,1.0f,0.0f);
	  	glColor3f(0.0f,0.0f,1.0f); // Cor Azul para o eixo z.
	  	glVertex3f(0.0f,0.0f,0.0f);
	  	glVertex3f(0.0f,0.0f,10.0f);
	 glEnd();
	 //glFlush();
}

void Desenha(void){
	 /*
		O comando glMatrixMode deverá ser utilizado antes dos comandos que especi-
		ficam as formas de projeção, que são definidas com os comandos: glOrtho, glFrus-
		tum ou gluPerpective.
		Essas matrizes podem ser modificadas por uma série de comandos como glTrans-
		late, glRotate ou glScale, entre outros. A matriz que será modificada é definida pelo
		comando glMatrixMode executado com uma das constantes GL_MODELVIEW,
		GL_PROJECTION ou GL_TEXTURE
	 */
	 glPushMatrix(); // Empilhando a matriz atual.
	 glMatrixMode(GL_MODELVIEW); // Em relação ao(s) objeto(s) da cena.
	 glLoadIdentity(); // Matriz Identidade.
	 glTranslated(0,0,-2); // Realiza Translação. A matriz atual será multiplicada por esta matriz de translação.
	 // Ele recebe 3 valores de tipo double, ao qual são os eixos x, y e z, respectivamente.
	 glRotated(45,45,45,0); // Realiza Rotação. A matriz atual será multiplicada pela matriz de rotação.
	 // Ele recebe 4 valores, de tipo double. O primeiro é o ângulo(giro em sentido anti-horário) e os demais são 
	 // os eixos x, y e z, respectivamente.
	 //gluLookAt(1,2,-5,0,0,0,0,1,0); // Comentar este comando.
	 glClear(GL_COLOR_BUFFER_BIT);
	 DesenhaEixos();
	 glRotatef(rx,1,0,0); // Rotacionando o objeto em x.
	 glRotatef(ry,0,1,0); // Rotacionando o objeto em y.
	 glColor3f(0.0f,0.0f,1.0f); // Cor azul, ao qual será atribuído a chaleira.
	 glutWireTeapot(0.5f); // Desenhando uma chaleira.
	 glPopMatrix(); // Desempilhando a matriz, que foi empilhada pela função glPushMatrix.
	 glFlush();
}

// Função usada para especificar a posição do observador virtual
void PosicionaObservador(void)
{
	// Especifica sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	// Inicializa sistema de coordenadas do modelo
	glLoadIdentity();
	// Posiciona e orienta o observador
	glTranslatef(-obx,-oby,-obz);
	glRotatef(rx,1,0,0);
	glRotatef(ry,0,1,0);
}

void MovimentoMouse(int x, int y){
	 // Botão esquerdo ?
	if(bot==GLUT_LEFT_BUTTON)
	{
		// Calcula diferenças
		int dx = x_ini - x;
		int dy = y_ini - y;
		// E modifica ângulos
		ry = ry_ini - dx/SENS_ROT;
		rx = rx_ini - dy/SENS_ROT;
	}
	// Botão direito ?
	else if(bot==GLUT_RIGHT_BUTTON)
	{
		// Calcula diferença
		int dz = y_ini - y;
		// E modifica distância do observador
		obz = obz_ini + dz/SENS_OBS;
	}
	/*
	// Botão do meio ?
	else if(bot==GLUT_MIDDLE_BUTTON)
	{
		// Calcula diferenças
		int dx = x_ini - x;
		int dy = y_ini - y;
		// E modifica posições
		obx = obx_ini + dx/SENS_TRANSL;
		oby = oby_ini - dy/SENS_TRANSL;
	}
	*/
	PosicionaObservador();
	glutPostRedisplay(); // Pode ser que outros eventos estejam querendo fazer um
	// redisplay.
}

void BotaoMouse(int b, int s, int x, int y){
	 if((b == GLUT_LEFT_BUTTON) && (s == GLUT_DOWN)){
	 	glMatrixMode(GL_PROJECTION);
	 	glLoadIdentity();
	 	glOrtho(-1.0,1.0,-1.0,1.0,0.5,10); // Define as coordenadas do volume de recorte (clipping volume).
	 	// Definindo os valores, respectivamente, para : esquerda(left), direita(rigth), bottom(baixo),
	 	// cima(top), perto(near)), longe(far). 
	 	bot = b;
	 }
	 if((b == GLUT_RIGHT_BUTTON) && (s == GLUT_DOWN)){
	 	glMatrixMode(GL_PROJECTION);
	 	glLoadIdentity();
	 	gluPerspective(45,1.0f,0.5f,10.0f); // Projeção Perspectiva. Atualiza a matriz de projeção Perspectiva.
	 	// O primeiro argumento é o ângulo, em graus, na direção de y(usada para determinar o volume de visualização).
	 	// O segundo é a razão de aspecto que determina a área de visualização na direção x, e seu valor é a razão em x 
	 	// (largura) e y (altura)
	 	// O terceiro e o quarto são o Near e o Far.
	 	bot = -1;
	 }
	 /*
	 if(s==GLUT_DOWN)
	 {
		// Salva os parâmetros atuais
		x_ini = x; //se o botão estiver pressionado faça xInicial receber a posiçao x atual
		y_ini = y;
		bot = b;
	 }
	 */
	 glutPostRedisplay();
}

void Inicializa(void){
	 glClearColor(1.0f,1.0f,1.0f,1.0f);
	 glMatrixMode(GL_PROJECTION); // Em relação ao observador (câmera).
	 glLoadIdentity();
	 //gluPerspective(45,1.0f,0.5f,10.0f); // 45 é o ângulo, em relação a y.
	 glOrtho(-1.0f,1.0f,-1.0f,1.0f,0.5f,10.0f);
}

int main(int argc, char **argv){
	glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(400,400);
	glutCreateWindow("Chaleira");
	//glutDisplayFunc(Desenha);
	Inicializa();
	glutDisplayFunc(Desenha); // Registra a função de tratamento do evento de
	// pressionar/soltar botão do mouse.
	glutMouseFunc(BotaoMouse); // Função de callback, que vai tratar quando se aperta um
	// botão do Mouse.
	glutMotionFunc(MovimentoMouse); // Registra a função de tratamento do evento
	// de mover o mouse com um botão pressionado.
	glutMainLoop();
	return 0;
}