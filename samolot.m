clear all;
clc;

A=[-0.313 56.7 0; -0.0139 -0.426 0 ; 0 56.7 0 ];
B=[0.232; 0.0203; 0]; 
C=[0 0 1];
D=[0];

[L,M]= ss2tf(A,B,C,D);
G=tf(L,M)
Gm=feedback(G,1);
%figure
%subplot(1,2,1);
%rlocus(G);
%subplot(1,2,2);
%rlocus(Gm);
%pause();
%t=0:0.01:200;
%figure
%subplot(1,2,1);
%step(t,G);
%subplot(1,2,2);
%step(t,Gm);
%pause();


fsamolot = sugfis;
fsamolot = addInput(fsamolot,[-10 10],'Name','E');
fsamolot = addInput(fsamolot,[-10 10],'Name','delE');
fsamolot = addMF(fsamolot,'E','trimf',[-20 -10 0],'Name','N');
fsamolot = addMF(fsamolot,'E','trimf',[-10 0 10],'Name','Z');
fsamolot = addMF(fsamolot,'E','trimf',[0 10 22],'Name','P');
fsamolot = addMF(fsamolot,'delE','trimf',[-20 -10 0],'Name','N');
fsamolot = addMF(fsamolot,'delE','trimf',[-10 0 10],'Name','Z');
fsamolot = addMF(fsamolot,'delE','trimf',[0 10 20],'Name','P');
%figure
%subplot(1,2,1)
%plotmf(fsamolot,'input',1)
%title('Input 1')
%subplot(1,2,2)
%plotmf(fsamolot,'input',2)
%title('Input 2')
fsamolot = addOutput(fsamolot,[-20 20],'Name','U');
fsamolot = addMF(fsamolot,'U','constant',-20,'Name','NB');
fsamolot = addMF(fsamolot,'U','constant',-10,'Name','NM');
fsamolot = addMF(fsamolot,'U','constant',0,'Name','Z');
fsamolot = addMF(fsamolot,'U','constant',10,'Name','PM');
fsamolot = addMF(fsamolot,'U','constant',20,'Name','PB');
rules = [...
    "E==N & delE==N => U=NB"; ...
    "E==Z & delE==N => U=NM"; ...
    "E==P & delE==N => U=Z"; ...
    "E==N & delE==Z => U=NM"; ...
    "E==Z & delE==Z => U=Z"; ...
    "E==P & delE==Z => U=PM"; ...
    "E==N & delE==P => U=Z"; ...
    "E==Z & delE==P => U=PM"; ...
    "E==P & delE==P => U=PB" ...
    ];
fsamolot = addRule(fsamolot,rules);
%pause();
%figure
%gensurf(fsamolot)
%title('Control surface of type-1 FIS')
Kp=6;
Ki=2;
Kd=2.5;
GE = 10;
GCE = GE*(Kp-sqrt(Kp^2-4*Ki*Kd))/2/Ki;
GCU = Ki/GE;
GU = Kd/GCE;
disp(GE);
disp(GCE);
disp(GCU);
disp(GU);
