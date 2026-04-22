figure

plot(modelSE.f, modelSE.AmpPe)
hold on;
plot(modelHF.f, modelHF.AmpPe)
ylabel('A_{Pe} [-]')
xlabel('f [Hz]')
legend('Model SimScape', 'Model HF')
grid;
