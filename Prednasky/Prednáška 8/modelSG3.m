function dxdt = modelSG3(t,x, inputVectorData, inputVectorTime, param)

% param = [xd xds xq Tdos H D xe efd0 tm];

xd = param(1);
xds = param(2);
xq = param(3);
Tdos = param(4);
H = param(5);
D = param(6);
xe = param(7);
Ub0 = param(8);
Tm = param(9);
Us0 = param(10);
Uref0 = param(11);
Kp = param(12);
Ki = param(13);


om = 2*pi*50;

A = (xds+xe)*(xq+xe);
id = 1/A*(xq+xe)*(Us0*cos(x(1))-x(3));
iq = 1/A*(xds+xe)*Us0*sin(x(1));

Te = x(3)*iq - (xq-xds)*id*iq;

uq = -xe * id + Us0 * cos(x(1,:));
ud = -xq * iq;

U = sqrt(uq.^2 + ud.^2);

% if t < 1
%     Uref = Uref0;
% else
%     Uref = Uref0 + 0.02;
% end
Uref = interp1(inputVectorTime,inputVectorData,t, 'previous');

e = Uref - U;

Ub = Kp*e + x(4);


dxdt(1,:) = om*x(2);
dxdt(2,:) = 1/(2*H)*(Tm - Te - D*x(2));
dxdt(3,:) = 1/(Tdos)*(Ub - x(3) + (xd - xds)*id);
dxdt(4,:) = Ki*e;


end

