figure
tiledlayout(2,1)
nexttile
plot(modelSE.t, modelSE.U)
ylabel('U [pu]')
grid;

nexttile
plot(modelSE.t, modelSE.P)
ylabel('P [pu]')
xlabel('t [s]')
grid;

