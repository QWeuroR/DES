figure

plot(modelSE.f, modelSE.AmpPe)
hold on;
plot(model3.f, model3.AmpPe)
ylabel('A_{Pe} [-]')
xlabel('f [Hz]')
legend('Model SimScape', 'Model 3. rád')
grid;
