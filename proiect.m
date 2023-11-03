clear; close all; clc;
%PROIECT LA SRR
%PROCES CU REGLARE A TEMPERATURII INTR-UN RECIPIENT
%% Partea fixata
kp=ureal('kp',4,'Percentage',25);
Tf=ureal('Tp',250,'Percentage',10);
tau=10;
Hp=tf(kp,[Tf 1]);
[x,y]=pade(tau,1);
Htau=tf(x,y);
Hf=Hp*Htau;
figure(1);
step(Hf,Hf.nominal,'g');
legend('Hf','Hf.nominal');
title('Rãspunsul indicial la semnal treaptã');
figure(13);
nyquist(Hf,Hf.nominal,'r');title('Analiza in frecventa a procesului');
%% Alegerea si acordarea regulatorului prin metoda Kapelovici
kr_K=(0.6*Tf.Nominal)/(kp.Nominal*tau);
Ti_K=3*tau; 
nr_K=[kr_K*Ti_K kr_K]; 
dr_K=[Ti_K 0]; 
Hr_K=tf(nr_K,dr_K); 
Hd_K=series(Hr_K,Hf); 
figure(2)
Ho_K=feedback(Hd_K,1);
step(Ho_K,Ho_K.Nominal,150);grid;
title('Raspunsul treaptã al sitemului închis cu regulator convenþional')
%% Analiza stabilitatii si a sensibilitatii
T=Ho_K;
figure(13);
step(T,T.Nominal,150)
title('T')
S=1-T;
figure(3)
step(S,S.Nominal,150)
title('S')
figure(4)
bode(Ho_K,Ho_K.nominal,'r')
title('Diagrama Bode')
figure(5)
nyquist(Ho_K,Ho_K.nominal,'r')
title('Diagrama Nyquist')
Rs=Hr_K*S;
figure(6);
19
step(Rs,Rs.nominal,'r')
grid;
title('Rs')
Ps=Hf*S;
figure(7);
step(Ps,Ps.nominal,'r')
grid;
title('Ps')
%% Regulator robust Hinf
s=tf('s');
W1=5*(0.005*s+1)^2/(0.1*s+1)^2;
W2=[];
W3=s^2/40000;
HG=augtf(Hf.nominal,W1,W2,W3);
HRinf=hinf(HG);
HD=series(HRinf,Hf);
Ho=feedback(HD,1);
figure(8);
step(Ho,Ho.nominal,'r')
grid;
title('Raspunsul indicial in bucla inchisa cu regulator Hinf');
%% Regulatorul optimal Hinfopt
[gama,HRopt,~]=hinfopt(HG);
% Bucla inchisa
Hdopt=series(HRopt,Hf);
Hoopt=feedback(Hdopt,1);
figure(9);
step(Hoopt)
grid;
title('Raspunsul indicial in bucla inchisa cu regulator Hinf optimal')
%% Regulatorul H2 (h2lqg)
s=tf('s');W31=100*(0.005*s+1)^2/(0.1*s+1)^2;W32=[];W33=s^2/40000;
HG=augtf(Hf.nominal,W31,W32,W33);
HR=h2lqg(HG);
HD=series(HR,Hf);
Ho=feedback(HD,1);
[HR,CL]=h2lqg(HG);
%Bucla inchisa
Hd2=series(HR,Hf);
Ho2=feedback(Hd2,1);
figure(10);
step(Ho2,Ho.nominal);
grid;
title('Raspunsul indicial in bucla inchisa cu regulator H2LQG')
%% Regulator de ordin redus
HRred=reduce(HR,3);
Hdred=series(HRred,Hf);
Hored=feedback(Hdred,1);
figure(11);
step(Hored,Hored.nominal);
grid;
title('Raspuns indicial cu regulator robust redus la ordinul 3');
%% Regulator de ordin redus
20
HRred=reduce(HR,2);
Hdred=series(HRred,Hf);
Hored=feedback(Hdred,1);
figure(12);
step(Hored,Hored.nominal);
grid;
title('Raspuns indicial cu regulator robust redus la ordinul 2');
