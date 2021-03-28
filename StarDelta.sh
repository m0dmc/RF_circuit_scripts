#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc -lm - && ./a.out ; rm a.out ; exit

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
//#define DEBUG
typedef struct {
    float a;
    float b;
    float c;
}triple;
float RParallel2(float A, float B) { return(A*B/(A+B)); }
void ShowHead(bool sd){
    printf(sd?"Convert Star to Delta network:-\n":
	   "Convert Delta to Star network:-\n");
}
void ShowDelta(triple delta){
    printf("Delta:\t%5.1f\t%5.1f\t%5.1f\n",delta.a,delta.b,delta.c);
    #ifdef DEBUG
    printf("CheckDelta:\t%5.1f\t%5.1f\t%5.1f\n",
	   RParallel2(delta.a,delta.b+delta.c),
	   RParallel2(delta.b,delta.c+delta.a),
	   RParallel2(delta.c,delta.a+delta.b));
    #endif
}
void ShowStar(triple star){
    printf("Star:\t%5.1f\t%5.1f\t%5.1f\n",star.c,star.b,star.a);
    #ifdef DEBUG
    printf("CheckStar:\t%5.1f\t%5.1f\t%5.1f\n",
	   star.c+star.b,star.c+star.a,star.a+star.b);
    #endif
}
triple ConvertDeltaToStar(triple delta){
    float x=delta.a+delta.b+delta.c;
    return((triple){delta.b*delta.c/x,delta.c*delta.a/x,delta.a*delta.b/x});
}
triple ConvertStarToDelta(triple star){
    float x=star.a*star.b+star.b*star.c+star.a*star.c;
    return((triple){x/star.a,x/star.b,x/star.c});
}
void main() {
    bool StarToDelta=false;
    triple DataIn={65,200,75}; // Insert data values to convert here
    ShowHead(StarToDelta);
    if(StarToDelta){
	  ShowStar(DataIn);
	  ShowDelta(ConvertStarToDelta(DataIn));
      }else{
	  ShowDelta(DataIn);  
	  ShowStar(ConvertDeltaToStar(DataIn));  
      }
}
