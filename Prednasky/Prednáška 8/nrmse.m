function [NRMSE, Fit] = nrmse(mes_y,mes_time,sim_y,sim_time, tmax)

    yref = mes_y(mes_time > 0 & mes_time < tmax);
    ysim1 = interp1(sim_time,sim_y,mes_time,"linear","extrap");
    ysim = ysim1(mes_time > 0 & mes_time < tmax);

    NRMSE = norm(yref - ysim)/norm(yref-mean(yref));
    Fit = (1-NRMSE)*100;
    
end