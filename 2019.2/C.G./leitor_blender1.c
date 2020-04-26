#include<stdio.h>    
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>

// estrutura do nó da lista
typedef struct no
{
	float valor;
	struct no *prox;

}No;

// inserindo elemento no fim da lista
No* inserir_fim(No *lista, float dado){
	No *novo_no = (No *)malloc(sizeof(No));
	novo_no->valor = dado;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		No *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}

// imprimindo lista
void imprimir_lista(No *lista){
	No *percorre_lista = lista;
	int indice = 5;
	indice = indice * 2;
	// printf("%f\n", (percorre_lista+indice)->valor);
	while(percorre_lista != NULL){
		printf("%f\n", percorre_lista->valor);
		percorre_lista = percorre_lista->prox;
	}
	printf("\n");
}


// função principal
int main() {
	FILE *arq;
	char *ler;
	char linha[100];
	char str[10000] = "";
	int i, num;
	No *lista = NULL;

	// inserindo elementos através do teclado. Condição de parada: "0" digitado.
	/*while(1){
		scanf("%d", &num);
		if (num == 0)
			break;
		lista = inserir_fim(lista, num);
	}*/

	/*lista = inserir_fim(lista, 10);
	lista = inserir_fim(lista, 20);
	lista = inserir_fim(lista, 30);
	lista = inserir_fim(lista, 40);
	imprimir_lista(lista);*/

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
	bool flag = false;
	char face[4];
	char vert[10];
	float dado;

	// Lendo só os vértices e faces desejadas
	separar = strtok(str, separador);
	while(separar != NULL){

		if (separar[0] == 'c' && separar[1] == 'o' && separar[2] == 'o' && separar[3] == 'r' && separar[4] == 'd' &&\
			separar[5] == 'I' && separar[6] == 'n' && separar[7] == 'd' && separar[8] == 'e' && separar[9] == 'x') {

				flag = true;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(face, &separar[i + 1]);
						dado = atof(face);
						lista = inserir_fim(lista, dado);
					}
				}
		}

		else if (separar[0] == 'p' && separar[1] == 'o' && separar[2] == 'i' && separar[3] == 'n' && separar[4] == 't' &&\
			separar[5] == '=' && separar[6] == '"') {

				flag = true;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(vert, &separar[i + 1]);
						dado = atof(vert);
						lista = inserir_fim(lista, dado);
					}
				}
		}

		else if (strcmp(separar, "\"") == 0){
			flag = false;
		}

		else if (flag == true){
			dado = atof(separar);
			lista = inserir_fim(lista, dado);
		}

		separar = strtok(NULL, separador);
	}	

	imprimir_lista(lista);
	return 0;
}