%KaField = [100 150 200 300 400 500 1000];
KaField = 300;


for Ka = KaField
    
    reg = mat2str([Ka, 0.001]);

    set_param('SynchronousMachine/Excitation System', "reg", reg)
    out = sim('SynchronousMachine');
    Vt = out.sigsOut.get(2).Values.Data;
    t = out.sigsOut.get(2).Values.Time;

    ni = (max(Vt) - 0.98-0.02)/0.02*100;

    Pe = out.sigsOut.get(1).Values.data - 0.8;
    [pks, loc] = findpeaks(Pe, 'MinPeakHeight', 0.001);

    A1 = pks(1);
    A3 = pks(2);
    A2 = abs(min(Pe(loc(1):loc(2))));

    kapa = abs((A2+A3)/(A1+A2));

    info = stepinfo(Vt,t, Vt(end), Vt(1));
    tu = info.SettlingTime;

    disp([Ka ni tu kapa])
end