#!/usr/bin/bash
tail -n+3 "$0"|gcc -xc -lm - && ./a.out ; rm a.out ; exit

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//float Vp(float Vpp){ return(Vpp/2); }
float Vrms(float Vpp){ return(Vpp/(2*sqrt(2))); }
float PowerW(float Vpp, float Imp){return(Vrms(Vpp)*Vrms(Vpp)/Imp);}
float PdBm(float Vpp, float Imp){return(10*log10(1000*PowerW(Vpp,Imp)));}
float Vpp_dBm(float dBm, float Imp){
    return(sqrt(Imp*powf(10,dBm/10)/1000)*2*sqrt(2));
}
void ShowHead(){
//    printf("Vpp  \t\tVp   \t\tVrms \t\tP50R \t\tPdBm\n");
    printf("Vpp   \t\t\tVrms \t\t\tP50R \t\tPdBm\n");
}
void ShowValues(float Vpp, float Imp){
    /*
    if(PowerW(Vpp,Imp)<1){
	  printf("%6.2f \t\t%6.2f \t\t%6.2f \t\t%6.2fmW  \t%6.2f\n",
		 Vpp,Vp(Vpp),Vrms(Vpp),1000*PowerW(Vpp,Imp),PdBm(Vpp,Imp));
      } else {
	  printf("%6.2f \t\t%6.2f \t\t%6.2f \t\t%6.2f W  \t%6.2f\n",
		 Vpp,Vp(Vpp),Vrms(Vpp),PowerW(Vpp,Imp),PdBm(Vpp,Imp));
      }
      */
    if(PowerW(Vpp,Imp)<1){
	  printf("%6.2fV \t\t%6.2fV \t\t%6.2fmW  \t%6.2fdBm\n",
		 Vpp,Vrms(Vpp),1000*PowerW(Vpp,Imp),PdBm(Vpp,Imp));
      } else {
	  printf("%6.2fV \t\t%6.2fV \t\t%6.2f W  \t%6.2fdBm\n",
		 Vpp,Vrms(Vpp),PowerW(Vpp,Imp),PdBm(Vpp,Imp));
      } 
}

void main() {
    float Vpp,Imp=50.0;
    int i;
    float V[]={0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,
	       1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,
	       10,20,30,40,50,-1};
    float dB[]={1,2,3,5,6,7,8,9,10,11,12,13,14,15,
		16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,-1};
    ShowHead();
 //   for(i=0;0<(Vpp=V[i]);i++)ShowValues(Vpp,Imp);
    for(i=0;dB[i]!=-1;i++) ShowValues(Vpp_dBm(dB[i],50),Imp);	  
}
/*
Vpp       Vp        Vrms     P50R      PdBm
00.50     00.25     00.18    00.62mW    -2.04
00.60     00.30     00.21    00.90mW    -0.46
00.70     00.35     00.25    01.22mW    00.88
00.80     00.40     00.28    01.60mW    02.04
00.90     00.45     00.32    02.03mW    03.06
01.00     00.50     00.35    02.50mW    03.98
01.00     00.50     00.35    02.50mW    03.98
02.00     01.00     00.71    10.00mW    10.00
03.00     01.50     01.06    22.50mW    13.52
04.00     02.00     01.41    40.00mW    16.02
05.00     02.50     01.77    62.50mW    17.96
06.00     03.00     02.12    90.00mW    19.54
07.00     03.50     02.47    122.50mW   20.88
08.00     04.00     02.83    160.00mW   22.04
09.00     04.50     03.18    202.50mW   23.06
10.00     05.00     03.54    250.00mW   23.98
10.00     05.00     03.54    250.00mW   23.98
20.00     10.00     07.07    01.00W     30.00
30.00     15.00     10.61    02.25W     33.52
40.00     20.00     14.14    04.00W     36.02
50.00     25.00     17.68    06.25W     37.96
60.00     30.00     21.21    09.00W     39.54
70.00     35.00     24.75    12.25W     40.88
80.00     40.00     28.28    16.00W     42.04
90.00     45.00     31.82    20.25W     43.06
100.00    50.00     35.36    25.00W     43.98
100.00    50.00     35.36    25.00W     43.98
200.00    100.00    70.71    100.00W    50.00
300.00    150.00    106.07   225.00W    53.52
400.00    200.00    141.42   400.00W    56.02
*/
