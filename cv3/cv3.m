clear; clc; close all;
Ka_field = 100:100:1000;

Ka = Ka_field(3);

reg = mat2str([Ka, 0.001]);
tgr = mat2str([0.5, 0.1]);
set_param('SynchronousMachine_/Excitation System','reg',reg);
set_param('SynchronousMachine_/Excitation System','tgr',tgr);
out = sim("cv3/SynchronousMachine_.slx");
ni = (out.sigsOut.get(2).Values.max - 0.98 - 0.02)/0.02 * 100;
t = out.sigsOut.get(2).Values.Time;
Vt = out.sigsOut.get(2).Values.Data;

info = stepinfo(Vt, t, Vt(end), Vt(1));
tu = info.SettlingTime;

Pe = out.sigsOut.get(1).Values.Data-out.sigsOut.get(1).Values.Data(end);
[pks, loc] = findpeaks(Pe,"MinPeakHeight",0.001)
A1 = pks(1);
A3 = pks(2);
A2 = abs(min(Pe(loc(1):loc(2))));

kappa = abs(A2 + A3) / abs(A1 + A2);

disp([Ka, ni, tu, kappa]);

% fprintf("for 1 Ka\n");
% for Ka = Ka_field
% 
%     reg = mat2str([Ka, 0.001]);
%     tgr = mat2str([0.5, 0.1]);
%     set_param('SynchronousMachine_/Excitation System','reg',reg);
%     set_param('SynchronousMachine_/Excitation System','tgr',tgr);
%     out = sim("cv3/SynchronousMachine_.slx");
%     ni = (out.sigsOut.get(2).Values.max - 0.98 - 0.02)/0.02 * 100;
%     disp([Ka ni])
% end
% 
% Ka = 300;
% 
% Tb_field = 0.1:0.1:1;
% Ta_field = 0.001:0.001:0.01;
% fprintf("for 2 Ta\n");
% for Ta = Ta_field
%     reg = mat2str([Ka_field(1), Ta]);
%     tgr = mat2str([Tb_field(2), 0.1]);
%     set_param('SynchronousMachine_/Excitation System','reg',reg);
%     set_param('SynchronousMachine_/Excitation System','tgr',tgr);
% 
%     out = sim("cv3/SynchronousMachine_.slx");
%     ni = (out.sigsOut.get(2).Values.max - 0.98 - 0.02)/0.02 * 100;
%     disp([Ka ni])
% 
% end
% 
% fprintf("for 3 Tb\n");
% for Tb = Tb_field
%     reg = mat2str([Ka_field(1), Ta_field(1)]);
%     tgr = mat2str([Tb, 0.1]);
%     if Tb == 0.1
%         continue
%     end
%     set_param('SynchronousMachine_/Excitation System','reg',reg);
%     set_param('SynchronousMachine_/Excitation System','tgr',tgr);
% 
%     out = sim("cv3/SynchronousMachine_.slx");
%     ni = (out.sigsOut.get(2).Values.max - 0.98 - 0.02)/0.02 * 100;
%     disp([Ka ni])
% 
% end
%%

% s_info = stepinfo(out.sigsOut.get(2).Values,out.tout,out.sigsOut.get(2).Values(end),out.tout(end))


