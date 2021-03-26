#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc -lm - && ./a.out ; rm a.out ; exit

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
float LuH(float Diameter, float Length, int Turns){
return(Diameter*Diameter*Turns*Turns/((18*Diameter) + (40*Length)));
} // From ARRL handbook
void ShowHead(){
    printf("L     \t\t\tDiameter(mm)  \t\tLength(mm) \t\tTurns\n");
}
float mmToInch(float(mm)){return(mm/25.4);}
void ShowValues(float Diameter, float Length,int Turns){
    float L;
    L=LuH(mmToInch(Diameter),mmToInch(Length),Turns);
    if(L<1){
	  printf("%5.2fnH \t\t\t%5.2f \t\t%5.2f \t\t\t%d\n",
		 1000*L,Diameter, Length, Turns);
      } else {
	  printf("%5.2fuH \t\t\t%5.2f \t\t%5.2f \t\t\t%d\n",
		 L,Diameter, Length, Turns);
      }
}

void main() {
    int i,j;
    ShowHead();

    for(i=4;i<9;i++)
       for(j=3;j<=9;j++)
	  ShowValues(i,0.5*j,j);
}
