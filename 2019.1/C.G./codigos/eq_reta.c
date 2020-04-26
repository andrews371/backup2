#include <stdio.h>
#include <time.h>

/** Abaixo é para calcular os pontos, usando a Equação da Reta. */
void calcularEQReta(float coordenadas[]){
     float m = (coordenadas[3] - coordenadas[1])/(coordenadas[2] - coordenadas[0]);
     float b = coordenadas[1] - (m * coordenadas[0]);
     float aux = coordenadas[0], auy;
     int p = 1;
     while(aux <= coordenadas[2]){
        auy = (m * aux) + b;
        printf("\n\tPonto %d : (%.2f,%.2f)\n",p,aux,auy);
        ++p;
        ++aux;
     }
}

/** ALgoritmo DDA . http://webserver2.tecgraf.puc-rio.br/~mgattass/cg/pdf/06A_RasterizacaoPPT.pdf
void calcularDDA(float coordenadas[]){
     float m = (coordenadas[3] - coordenadas[1])/(coordenadas[2] - coordenadas[0]);
     float b = coordenadas[1] - (m * coordenadas[0]);
     float aux = coordenadas[0], auy;
     int p = 1;
     while(aux <= coordenadas[2]){
        auy = (m * aux) + b;
        printf("\n\tPonto %d : (%.2f,%.2f)\n",p,aux,auy);
        ++p;
        ++aux;
     }
}
*/

/*
int modulo(int valor){
	if(valor >= 0)
		return valor;
	return (valor * (-1));
}


void calcularDDA(int coordenadas[]){
	 int x = coordenadas[2] - coordenadas[0];
	 int y = coordenadas[3] - coordenadas[1];
	 int qt, i;
	 float sx, sy, sx1 = coordenadas[0], sy1 = coordenadas[1];
	 if(modulo(x) > modulo(y))
	 	qt = modulo(x);
	 else
	 	qt = modulo(y);
	 sx = x/qt;
	 sy = y/qt;
	 printf("\n\tPonto %d : (%d,%d)",1,(int)sx,(int)sy);
	 for(i = 2; i <= qt; ++i){
	 	sx1 += sx;
	 	sy1 += sy;
	 	printf("\n\tPonto %d : (%d,%d)",i,(int)sx1,(int)sy1);
	 }
}
*/

int fabs(int d){
    if(d >= 0)
        return d;
    return (d * (-1));
}

void plotaponto(int x, int y){
     printf("\n\tPonto : (%d,%d)",x,y);
}

void lineDDA (int xa, int xb, int ya, int yb)
{
    int dx,dy,passos,k;
    float somax, somay, x,y;
    dx=xb-xa; dy=yb-ya;
    if(fabs(dx)>fabs(dy))
    passos=fabs(dx);
    else passos=fabs(dy);
    somax=dx/passos; somay=dy/passos;
    x=xa; y=ya;
    plotaponto((int)x,(int)y);
    for(k=1;k<=passos;k++) {
    x+=somax; y+=somay;
    plotaponto((int)x,(int)y);
}
}

void Bresenham(int x1,int y1, int x2, int y2)
{
    int dx,dy,x,y,xfinal,p,const1,const2;
    dx=fabs(x1-x2); dy=fabs(y1-y2);
    p=2*dy-dx;
    const1=2*dy; const2=2*(dy-dx);
    if(x1>x2) {
    x=x2; y=y2; xfinal=x1; }
    else {
    x = x1; y=y1; xfinal=x2; }
    plotaponto(x,y);
    while(x<xfinal) {
    x++;
    if (p<0) p+=const1;
    else { y++; p+=const2; }
    plotaponto(x,y);
}
}

int main(void){
    int coordenadas[] = {1,1,5,7};
    //calcularEQReta(coordenadas); // Resultado : Funcionou.
    //calcularDDA(coordenadas);
    //lineDDA (1,5,1,7);
    clock_t t;
    float sec;
    t = clock();
    calcularEQReta(coordenadas);
    Bresenham(1,1,100,100);
    t = clock() - t;
    sec = ((float)t)/CLOCKS_PER_SEC;
    printf("\n\tTempo : %.2f segundo(s)",sec);
    return 0;
}
