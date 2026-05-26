clear; clc; close all;
% out = sim("SynchronousMachine");
% 
% ni = (out.sigsOut.get(2).Values.max - 0.98 - 0.02)/0.02 * 100;
% t = out.sigsOut.get(2).Values.Time;
% Vt = out.sigsOut.get(2).Values.Data;
% 
% info = stepinfo(Vt, t, Vt(end), Vt(1));
% tu = info.SettlingTime;
% 
% Pe = out.sigsOut.get(1).Values.Data-out.sigsOut.get(1).Values.Data(end);
% [pks, loc] = findpeaks(Pe,"MinPeakHeight",0.0001);
% A1 = pks(1);
% A3 = pks(2);
% A2 = abs(min(Pe(loc(1):loc(2))));
% 
% kappa = abs(A2 + A3) / abs(A1 + A2);
% 
% disp([ni, tu, kappa]);


syms T1 T2 Kp Ki a1 b1;
S = solve((a1+b1*Kp)/Ki==T1*T2, (1+Kp+b1*Ki)/Ki==T1+T2,Kp,Ki);
T1 = 1;
T2 = 2.5;
Tw = 2.67;
qn1 = 0;
g0 = 0.774;
b1 = - (g0-qn1) *Tw;
a1 = g0/2*Tw;
Kp = eval(S.Kp);
Ki = eval(S.Ki);



% syms T1 T2 Kp Ki a1 b1;
% 
% S = solve((a1+b1*Kp)/Ki==T1*T2, (1+Kp+b1*Ki)/Ki==T1+T2,Kp,Ki);
% 
% T1 = 1;
% T2 = 2.5;
% Tw = 2.67;
% qn1 = 0;
% g0 = 0.774;
% 
% b1 = -(g0-qn1)*Tw;
% a1 = g0/2*Tw;
% 
% Kp = eval(S.Kp);
% Ki = eval(S.Ki);
