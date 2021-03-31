#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc - && ./a.out $1 $2 $3 $4; rm a.out ; exit

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
//#define DEBUG
typedef struct {
    float a;
    float b;
    float c;
}triple;
bool TripleValid(triple t){ return((t.a>0)|(t.b>0)|(t.c>0)); }
float RParallel2(float A, float B) { return(A*B/(A+B)); }
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
void ShowUsage(){
    printf("Append parameters sd x.xx y.yy z.zz to convert star to delta.\n");
    printf("Append parameters ds x.xx y.yy z.zz to convert delta to star.\n");
}
void main(int argc,char *argv[]) {
    triple DataIn={0,0,0};
    if(argc==5){
	  DataIn.a=strtof(argv[2],NULL);
	  DataIn.b=strtof(argv[3],NULL);
	  DataIn.c=strtof(argv[4],NULL);
	  if((strcmp(argv[1],"sd")==0)&(TripleValid(DataIn))){
		ShowStar(DataIn);
		ShowDelta(ConvertStarToDelta(DataIn));
	    } else if((strcmp(argv[1],"ds")==0)&(TripleValid(DataIn))){
		ShowDelta(DataIn);  
		ShowStar(ConvertDeltaToStar(DataIn));
	    } else {
		ShowUsage();
	    }
      } else {
	  ShowUsage();
      }	
}
