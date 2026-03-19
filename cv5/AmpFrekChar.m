f = 0.5:0.05:3.5;
A = ones(size(f));
iter = 1;

for f1 = f

    set_param('SynchronousMachine/Signal Generator', "Frequency", num2str(f1))
    out = sim('SynchronousMachine');

    Pe = out.sigsOut.get(1).Values.Data - 0.8;

    Au = 0.01;
    [pks, loc] = findpeaks(Pe, 'MinPeakHeight', 0.001);
    Ay = pks(end);

    A(iter) = Ay/Au;

    iter = iter + 1;

end

plot(f,A)