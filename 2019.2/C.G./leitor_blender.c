// Andre Oliveira de Sousa - 11325684

#include<stdio.h>    
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>
#include<GL/glut.h>

// estrutura do nó de faces da lista
typedef struct lados
{
	int valor;
	struct lados *prox;

}Lados;

// estrutura do nó de vértices da lista
typedef struct vertices
{
	float x, y, z;
	struct vertices *prox;

}Vertices;

// Variáveis globais
GLint rx = 30, ry = 30, rz = 30;
int tam_faces = 0, tam_vertices = 0, tam_vert_por_face = 0;
Lados *lista_faces = NULL;
Vertices *lista_vertices = NULL;

// variável para criar a lista de exibição
GLuint objeto;

// protótipos
void desenha_obj();
void init();
void display();
void projecao(int w, int h);
void redesenha(int w, int h) ;
void teclado (unsigned char tecla, GLint x, GLint y);

Lados* inserir_fim_face(Lados *lista, int dado);
Vertices* inserir_fim_vertice(Vertices *lista, float x, float y, float z);
Lados* busca_face(int f, Lados *lista, int *tam_faces);
Vertices* busca_vertice(int v, Vertices *lista, int *tam_vertices);

// função principal
int main(int argc, char** argv)
{
	printf("\nPressionar as teclas x, y ou z para rotacionar em torno de x, y ou z respectivamente.\n");

	// lendo arquivo
	FILE *arq;
	char *ler;
	char linha[100];
	char str[10000] = "";
	int i, num;

	// lendo arquivo todo
	arq = fopen("cubo.x3d", "r");
	while(!feof(arq)){
		ler = fgets(linha, 100, arq);
		if (ler){
			strcat(str, linha);
		}
		i++;
	}
	fclose(arq);
	printf("\n");

	// Variáveis usadas para ler os vértices e faces desejadas
	char *separar;
	char separador[] = " \n";
	int flag = 0;
	int flag_coord = 1;
	char face[4];
	char vert[10];
	float dado;
	float coord[3];
	bool flag_vert_face = false;

	// Lendo só os vértices e faces desejadas
	separar = strtok(str, separador);
	while(separar != NULL){

		if (separar[0] == 'c' && separar[1] == 'o' && separar[2] == 'o' && separar[3] == 'r' && separar[4] == 'd' &&\
			separar[5] == 'I' && separar[6] == 'n' && separar[7] == 'd' && separar[8] == 'e' && separar[9] == 'x') {

				flag = 1;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(face, &separar[i + 1]);						
						dado = atoi(face);				
						lista_faces = inserir_fim_face(lista_faces, dado);
						tam_vert_por_face++;
					}
				}
		}

		else if (separar[0] == 'p' && separar[1] == 'o' && separar[2] == 'i' && separar[3] == 'n' && separar[4] == 't' &&\
			separar[5] == '=' && separar[6] == '"') {

				flag = 2;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(vert, &separar[i + 1]);						
						dado = atof(vert);

						// setando o x do vértice
						coord[0] = dado;
						flag_coord++;
					}
				}
		}

		else if (strcmp(separar, "\"") == 0){
			flag = 0;
		}

		else if (flag == 1){
			dado = atoi(separar);
			if (dado != -1){
				lista_faces = inserir_fim_face(lista_faces, dado);
			}		
			
			if (dado == -1){
				tam_faces++;
				flag_vert_face = true;
			}
			if (flag_vert_face == false){
				tam_vert_por_face++;
			}
		}

		else if (flag == 2){
			dado = atof(separar);	

			if (flag_coord == 1){
				// setando o x do vértice
				coord[0] = dado;
				flag_coord++;
			}

			else if (flag_coord == 2){
				// setando o y do vértice
				coord[1] = dado;
				flag_coord++;
			}

			else {
				// setando o z do vértice
				coord[2] = dado;
				flag_coord = 1;
				lista_vertices = inserir_fim_vertice(lista_vertices, coord[0], coord[1], coord[2]);
				tam_vertices++;
			}
			
		}

		separar = strtok(NULL, separador);
	}	


 	glutInit(&argc,argv); // inicia a biblioteca glut. É a primeira rotina rotina a ser chamada
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(500, 500); // Tamanho da janela que abrirá
	glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
	glutCreateWindow("Objeto 3D"); // Título da janela
	init();
	glutKeyboardFunc(teclado);
	glutDisplayFunc(display); // chama a função que construímos para desenhar
	glutReshapeFunc(redesenha);
	glutMainLoop(); // até esse comando ser chamado a janela não é exibida.

	return 0;
}


// FUNÇÕES
void desenha_obj()
{

  Lados *acessa_face;
  Vertices *acessa_vertice;

  // Desenhando o objeto importado do blender
  glColor3f(0,1,0);

  // acessando a lista de faces e pegando a posição inicial
  acessa_face = busca_face(0, lista_faces, &tam_faces);

  // desenhando face por face
  for (int i = 0; i < tam_faces; i++){
  			
	while (acessa_face != NULL){
		glBegin(GL_LINE_LOOP);
	
		// Faces
		for (int j = 0; j < tam_vert_por_face; j++){
			acessa_vertice = busca_vertice(acessa_face->valor, lista_vertices, &tam_vertices);
			acessa_face = acessa_face->prox;
			glVertex3f(acessa_vertice->x, acessa_vertice->y, acessa_vertice->z);
		}
		glEnd();
	}
  }

}

void init(){

  objeto = glGenLists(2);
  glNewList(objeto, GL_COMPILE);

    glColor3f(1.0, 1.0, 1.0);
    desenha_obj();

  glEndList();
  glShadeModel(GL_FLAT);

}


void projecao(int w, int h){
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity(); // inicializa a matriz de projeção atual

  if (w <= h) {
    glOrtho(-10.0, 10.0, -10.0*h/w, 10.0*h/w, 1, 20);   // projeção paralela
  }  
  else {
     glOrtho(-10.0*w/h, 10.0*w/h, -10.0, 10.0, 1, 20);   // projeção paralela
  }
  // glutPostRedisplay();  
}
 

void redesenha(int w, int h) {
  glViewport(0,0,w,h); // mapeando toda a janela começando de 0,0 até o comprimento maximo w e altura maxima h
  projecao(w, h); // função que irá projetar o desenho em tela
  // glutPostRedisplay();
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


void display(){
  glClearColor(0.0, 0.0, 0.0, 0.0); // indica a cor que será usada no fundo da janela
  glClear(GL_COLOR_BUFFER_BIT); // pinta o buffer com a cor indicada para o funda da janela

  // muda para o sistema de coordenadas do modelo
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity(); // inicializa a matriz de transformação atual
  glTranslated(0, 0, -15); // define a posição do objeto na cena

 // realiza operações de rotação no objeto
  glRotated(rx, 1, 0, 0);
  glRotated(ry, 0, 1, 0);
  glRotated(rz, 0, 0, 1);

  // fazendo chamada à lista de exibição
  glCallList(objeto);
  glFlush(); // esse comando exibe o que está armazenado no buffer
         	 // se esse comando não for chamado, a janela abrirá mas não exibirá nada que foi feito
         	 // e que está apenas no buffer.
  } 


// inserindo as faces no fim da lista
Lados* inserir_fim_face(Lados *lista, int dado){
	Lados *novo_no = (Lados *)malloc(sizeof(Lados));
	novo_no->valor = dado;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		Lados *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}


// inserindo os vértices no fim da lista
Vertices* inserir_fim_vertice(Vertices *lista, float x, float y, float z){
	Vertices *novo_no = (Vertices *)malloc(sizeof(Vertices));

	novo_no->x = x;
	novo_no->y = y;
	novo_no->z = z;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		Vertices *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}

// buscando faces
Lados* busca_face(int f, Lados *lista, int *tam_faces){
	Lados *percorre_lista = lista;

	if (f >= *tam_faces){
		printf("Índice de face inválido.\n");
		exit(0);
	}

	for (int i = 0; i < f; i++){
		if (percorre_lista != NULL){
			percorre_lista = percorre_lista->prox;
		}
	}

	return percorre_lista;
	printf("\n");
}

// buscando vértices
Vertices* busca_vertice(int v, Vertices *lista, int *tam_vertices){
	Vertices *percorre_lista = lista;

	if (v >= *tam_vertices){
		printf("Índice de vértice inválido.\n");
		exit(0);
	}

	for (int i = 0; i < v; i++){
		if (percorre_lista != NULL){
			percorre_lista = percorre_lista->prox;
		}
	}

	return percorre_lista;

	printf("\n");
}