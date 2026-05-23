close all
clear

%% Step Response comparison
mode = 1;

set_param('desZadsim', 'StopTime', '10')

Kpe_values = [0 0.3];

results = struct();
figure


for i = 1:length(Kpe_values)

    Kpe = Kpe_values(i);
    assignin('base','Kpe',Kpe);

    out = sim("desZadsim.slx");

    results(i).Pe  = out.sigsOut.get(1).Values.Data;
    results(i).Vt  = out.sigsOut.get(2).Values.Data;
    results(i).Ref = out.sigsOut.get(3).Values.Data;
    results(i).t   = out.tout;

    subplot(2,1,1)
    plot(results(i).t, results(i).Vt, 'LineWidth', 1.5); hold on;

    subplot(2,1,2)
    plot(results(i).t, results(i).Pe, 'LineWidth', 1.5); hold on;
end

subplot(2,1,1)
plot(results(1).t, results(1).Ref, '--', 'LineWidth', 1.5);
% 
% figure
% 
% subplot(2,1,1)
% plot(results(1).t, results(1).Vt, 'LineWidth', 1.5); hold on;
% plot(results(2).t, results(2).Vt, 'LineWidth', 1.5);
% plot(results(1).t, results(1).Ref, '--', 'LineWidth', 1.5);
% 
% grid on
% box on
% ylabel('V_t')
% title('Step Response (Kpe = 0 vs 0.3)')
% legend('Vt (Kpe=0)', 'Vt (Kpe=0.3)', 'Ref')
% 
% xlim([0 results(1).t(end)])
% 
% subplot(2,1,2)
% plot(results(1).t, results(1).Pe, 'LineWidth', 1.5); hold on;
% plot(results(2).t, results(2).Pe, 'LineWidth', 1.5);
% 
% grid on
% box on
% xlabel('Time [s]')
% ylabel('P_e')
% legend('Kpe=0', 'Kpe=0.3')
% 
% xlim([0 results(1).t(end)])

% 
% %% Step Response
% mode = 1;
% set_param('desZadsim', 'StopTime', '50')
% out = sim("desZadsim.slx");
% 
% Pe = out.sigsOut.get(1).Values.Data;
% Vt = out.sigsOut.get(2).Values.Data;
% Ref = out.sigsOut.get(3).Values.Data;
% t = out.tout;
% 
% figure
% 
% subplot(2,1,1)
% plot(t, Vt, 'LineWidth', 1.5); hold on;
% plot(t, Ref, 'LineWidth', 1.5)
% grid on
% box on
% ylabel('V_t')
% title('Step Response')
% xlim([0 t(end)])
% 
% subplot(2,1,2)
% plot(t, Pe, 'LineWidth', 1.5)
% grid on
% box on
% xlabel('Time [s]')
% ylabel('P_e')
% xlim([0 t(end)])
% 
% %% Frequency Characteristic
% set_param('desZadsim', 'StopTime', '10')
% mode = 0;
% f = 0.5:0.1:3.5;
% A = zeros(size(f));
% i = 1;
% 
% for fi = f
%     set_param('desZadsim/Signal Generator','Frequency',num2str(fi))
%     out = sim("desZadsim.slx");
%     Pe = out.sigsOut.get(1).Values.Data - 0.69444;
%     [pks, loc] = findpeaks(Pe ,'MinPeakHeight',0.001);
% 
%     Au = 0.01;
%     Ay = pks(end);
% 
%     A(i) = Ay/Au;
%     i = i+1;
% end
% 
% figure
% hold on
% grid on
% box on
% 
% plot(f, A, 'o-', 'LineWidth', 1.5, 'MarkerSize', 6)
% 
% xlabel('Frequency [Hz]')
% ylabel('Gain A = Ay / Au')
% title('Amplitude Frequency Characteristic')
