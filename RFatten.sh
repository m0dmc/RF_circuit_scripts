#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc -lm - && ./a.out ; rm a.out ; exit

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//#define DEBUG
void ShowHead(float zi,float zo){
    printf("Calculate Zi=Zo=%dR attenuator networks: Pi(R1,R2,R3), T(Ra,Rb,Rc), PD driven from 0R, T network Zi=%dR Zo=%dR.\n",
	   (int)zo,(int)zi,(int)zo);
    printf("Atten(dB)\tPo/Pi\t Vo/Vi\t  R1\t  R2\t  R3\t  Ra\t  Rb\t  Rc\t  Rin\t  Rout\t(Zin)\t  Ri\t  Rat\t  Ro\n");
}
float Patt(float Att){              return(pow(10,-Att/10.0));    }
float Vatt(float Att){              return(pow(10,-Att/20.0));    }
float RParallel2(float A, float B){ return(A*B/(A+B));            }

float R13(float vat,float z){       return(z*(1+vat)/(1-vat));    }
float R2(float vat,float z){        return(z*(1-vat*vat)/(2*vat));}
void Check123(float vat,float z){
    float load,r1,r2;
    r1=R13(vat,z);
    r2=R2(vat,z);
    load = RParallel2(z,r1);
    printf("\t\tPi check atten = %4.2f, Impedance = %4.2f\n",load/(load+r2),RParallel2(r1,load+r2));
}
float Rac(float vat,float z){       return(z*(1-vat)/(1+vat));    }
float Rb(float vat,float z){        return(2*z*vat/(1-vat*vat));  }
void CheckABC(float vat,float z){
    float load,ra,rb;
    ra=Rac(vat,z);
    rb=Rb(vat,z);
    load=RParallel2(rb,ra+z);
    printf("\t\tT  check atten = %4.2f, Impedance = %4.2f\n",(load/(ra+load))*(z/(ra+z)),ra+load);
}
float Rout2R(float vat,float z){      return(z/(1-(2*vat)));        }
float Rin2R(float vat,float z){       return(z/(2*vat));            }
void CheckPD2R(float vat,float zo){
    float load,ra,rb;
    ra=Rin2R(vat,zo);
    rb=Rout2R(vat,zo);
    load=RParallel2(rb,zo);
    printf("\t\tPD check atten = %4.2f, Zo= %4.2f\n",load/(load+ra),RParallel2(rb,ra));
}
float Ri3R(float vat,float zi,float zo,float k){
    return(zi*(vat*vat*zi-2*vat*zo+zo)/k);
}
float Ra3R(float vat,float zi,float zo,float k){
    return(2*vat*zi*zo/k);
}
float Ro3R(float vat,float zi,float zo,float k){
    return(zo*(vat*vat*zi-2*vat*zi+zo)/k);
}
void CheckPD3R(float vat,float zi,float zo,float k){
    float pd3ri,pd3ro,pd3ra;
    pd3ri=Ri3R(vat,zi,zo,k);
    pd3ra=Ra3R(vat,zi,zo,k);
    pd3ro=Ro3R(vat,zi,zo,k);
    printf("\t\tT:   check atten = %4.2f, Zi= %4.2f, Zo= %4.2f\n",
	   (zo/(zo+pd3ro))*(RParallel2(pd3ra,zo+pd3ro)/(pd3ri+RParallel2(pd3ra,zo+pd3ro))),
	   pd3ri+RParallel2(pd3ro+zo,pd3ra),
	   pd3ro+RParallel2(pd3ri+zi,pd3ra));
    }
void ShowValues(int Att,float zi,float zo){
    float pd2ri=0,pd2ro=0,pd2zin=0;
    float pd3ri=0,pd3ro=0,pd3ra=0;
    float vat=Vatt(Att);
    float k=zo-vat*vat*zi;
    #ifdef DEBUG
    Check123(vat,zo);
    CheckABC(vat,zo);
    #endif
    if(vat<0.5){
	  #ifdef DEBUG
	  CheckPD2R(vat,zo);
	  #endif
	  pd2ri  = Rin2R(vat,zo);
	  pd2ro  = Rout2R(vat,zo);
	  pd2zin = pd2ri+RParallel2(pd2ro,zo);
      }
      if((k>0)&((vat*vat*zi-2*vat*zi+zo)>0)){
	    #ifdef DEBUG
	    CheckPD3R(vat,zi,zo,k);
	    #endif
	    pd3ri=Ri3R(vat,zi,zo,k);
	    pd3ra=Ra3R(vat,zi,zo,k);
	    pd3ro=Ro3R(vat,zi,zo,k);
	}
      printf("%5ddB\t\t%5.4f\t%6.3f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\t%5.1f\n",
	     Att,Patt(Att),vat,   R13(vat,zo),R2(vat,zo),R13(vat,zo),  Rac(vat,zo),Rb(vat,zo),Rac(vat,zo),
	     pd2ri,pd2ro,pd2zin,  pd3ri,pd3ra,pd3ro);
}
void main() {
    int i;
    float zi=250,zo=50;
    #ifdef DEBUG
    float dB[]={3,6,10,15,20,-1};
    #else
    float dB[]={1,2,3,5,6,10,15,20,25,30,40,-1};
    #endif
    ShowHead(zi,zo);
    for(i=0;dB[i]!=-1;i++)ShowValues(dB[i],zi,zo);	  
}
