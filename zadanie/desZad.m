close all; clear; clc;
warning('off','all')



%% handlers
fig1 = figure(1);
ax1 = tiledlayout(fig1,2,1, "TileSpacing","tight","Padding","tight");
ax11 = nexttile(ax1,1);
ax12 = nexttile(ax1,2);
% ax21 = nexttile(ax1,3);
% ax22 = nexttile(ax1,4);

%% simulacie
set_param('SynchronousMachine', 'StopTime', '20')

Kpe_values = 0:0.1:0.5;

results = struct();


for i = 1:length(Kpe_values)

    Kpe = Kpe_values(i);
    assignin('base','Kpe',Kpe);

    out = sim("SynchronousMachine");

    results(i).Pe  = out.Pe.Data;
    results(i).Vt  = out.Vt.Data;
    results(i).Ref = out.V_ref.Data;
    results(i).t   = out.tout;

    subplot(2,1,1)
    plot(results(i).t, results(i).Vt, 'LineWidth', 1.5); hold on;

    subplot(2,1,2)
    plot(results(i).t, results(i).Pe, 'LineWidth', 1.5); hold on;
end

% subplot(2,1,1)
% plot(results(1).t, results(1).Ref, '--', 'LineWidth', 1.5);







function ploting_helper(ax,title_str,xlabel_str,ylabel_str)
    legend(ax, 'show', 'Location', 'bestoutside');
    grid(ax,"on");
    title(ax,title_str);
    xlabel(ax,xlabel_str);
    ylabel(ax,ylabel_str);
end














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
