#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc -lm - && ./a.out ; rm a.out ; exit

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
void ShowHead(int z){
    printf("Calculate Zin=Zout=%dR attenuator networks: Pi(R1,R2,R3), T(Ra,Rb,Rc)\n",z);
    printf("Atten(dB)\tPo/Pi\t Vo/Vi\t\t  R1\t  R2\t  R3\t  Ra\t  Rb\t  Rc\n");
}
float Patt(float Att){              return(pow(10,-Att/10.0));    }
float Vatt(float Att){              return(pow(10,-Att/20.0));    }
float RParallel2(float A, float B){ return(A*B/(A+B));            }
float R13(float vat,float z){       return(z*(1+vat)/(1-vat));    }
float R2(float vat,float z){        return(z*(1-vat*vat)/(2*vat));}
float Rac(float vat,float z){       return(z*(1-vat)/(1+vat));    }
float Rb(float vat,float z){        return(2*z*vat/(1-vat*vat));  }
void Check123(float vat,float z){
    float load,r1,r2;
    r1=R13(vat,z);
    r2=R2(vat,z);
    load = RParallel2(z,r1);
    printf("\t\tPi check atten = %f, Impedance = %f\n",load/(load+r2),RParallel2(r1,load+r2));
}
void CheckABC(float vat,float z){
    float load,ra,rb;
    ra=Rac(vat,z);
    rb=Rb(vat,z);
    load=RParallel2(rb,ra+z);
    printf("\t\tT check atten = %f, Impedance = %f\n",(load/(ra+load))*(z/(ra+z)),ra+load);
}
void ShowValues(int Att,float z){
    float vat;
    vat=Vatt(Att);
    printf("%5ddB\t\t%5.4f\t%6.3f\t\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\n",
	   Att,Patt(Att),vat,R13(vat,z),R2(vat,z),R13(vat,z),Rac(vat,z),Rb(vat,z),Rac(vat,z));
//    Check123(vat,z);    CheckABC(vat,z);
}
void main() {
    int i,z=50;
    float dB[]={1,2,3,5,6,10,15,20,25,30,40,-1};
    ShowHead(z);
    for(i=0;dB[i]!=-1;i++)ShowValues(dB[i],z);	  
}
