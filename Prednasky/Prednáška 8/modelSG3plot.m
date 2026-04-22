% x = sol.Solution;
% t = sol.Time;

% Vypocet napatia

A = (xds+xe)*(xq+xe);
id = 1/A*(xq+xe)*(Us0*cos(x(:,1))-x(:,3));
iq = 1/A*(xds+xe)*Us0*sin(x(:,1));


uq = -xe * id + Us0 * cos(x(:,1));
ud = -xq * iq;

U = sqrt(uq.^2 + ud.^2);


Te = x(:,3).*iq - (xq-xds)*id.*iq;

% 
figure
tiledlayout(2,1)
nexttile
plot(t, U)
ylabel('U [pu]')
grid;


nexttile
plot(t, Te)
ylabel('P [pu]')
xlabel('t [s]')
grid;
