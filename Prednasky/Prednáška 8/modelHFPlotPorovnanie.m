figure
tiledlayout(2,1)

nexttile
plot(modelSE.t, modelSE.U - abs(U0))
hold on;
plot(modelHF.t+1, modelHF.U)
ylabel('\Delta U [pu]')
grid;

legend('Model SimScape', 'Model HF')

nexttile
plot(modelSE.t, modelSE.P - abs(P0))
hold on;
plot(modelHF.t+1, modelHF.P)
ylabel('\Delta P [pu]')
xlabel('t [s]')
grid;

