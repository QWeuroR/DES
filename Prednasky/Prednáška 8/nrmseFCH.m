function [NRMSE, Fit] = nrmseFCH(mes_y,mes_time,sim_y,sim_time)

    yref = mes_y;
    ysim = sim_y;

    NRMSE = norm(yref - ysim)/norm(yref-mean(yref));
    Fit = (1-NRMSE)*100;
    
end