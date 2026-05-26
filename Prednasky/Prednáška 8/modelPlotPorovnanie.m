figure
tiledlayout(2,1)

nexttile
plot(modelSE.t, modelSE.U)
hold on;
plot(model3.t, model3.U)
ylabel('U [pu]')
grid;

legend('Model SimScape', 'Model 3. rád')

nexttile
plot(modelSE.t, modelSE.P)
hold on;
plot(model3.t, model3.P)
ylabel('P [pu]')
xlabel('t [s]')
grid;

