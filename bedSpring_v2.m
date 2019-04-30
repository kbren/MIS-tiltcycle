function [bNew,b_eqNew,hxNew] = bedSpring(h1,L2,H2,hg,b,b_eq,b0,tau);
% All heights are relative to sea surface height (currently unchanging)
% all changes in the sea level are absorbed by changes in the bed

% h1 = height of ice along x-axis at the previous timestep (vector)
% L2 = current length of the ice (scalar)
% H2 = current mean thickness of the ice (scalar) 
% hg = thickness of ice at the grounding line (scalar) 
% b = current bed elevation (vector) positive going up, zero is water
%      surface, magnitude of b (when negative) is equivalent to water thickness
% b_eq = current equilibrium bed (vector) 
% b0 = initial bed height (vector) 
% tau = timescale (scalar)

% TO DO: 
% Add the affect of water weight beyond the ice sheet edge. 
% Likely use a linear or exponential damping effect of bed depression 
% away from the ice sheet. 
% Our goal is do a 1D experiment to see how the bed responds to loading
% (the ice sheet should encompass the entire domain) 
% Our second goal is to do a 2D experiment to figure out how to deal with
% the cliff at the edge of the ice sheet (see comments above) 

% Need to incorporate equations for w_b

rho_i = 917;    % density of ice (kg/m^3) 
rho_b = 2650;   % density of bed (kg/m^3)
rho_w = 1000;   % density of water (kg/m^3)
gamma = rho_i/rho_b;  % displaced bed by ice
lambda = rho_i/rho_w; % (height ice)lambda = (height water)

dt = 1;         % timestep in years 
len = length(b); % number of points along the bed (x-axis) 

h2 = zeros(1,len);  % initiating new thickness of ice sheet 

% This makes changes to the ice thickness: 
%cnt = 1;
%for ix = 1:100:floor(L2)
%    h2(cnt) = 3*(H2-hg)*sqrt((L2-ix)/L2)/2 + hg;
%    cnt = cnt + 1;
%end

% For no changes to the ice thickness: 
h2 = h1;
hxNew = h2; 

% q is the applied load 
q = rho_i*g.*hi + rho_w*g.*hw - rho_i*g.*hi_eq - rho_w*g.*hw_eq;

dx = x(2)-x(1);  
P = q.*dx; 
L = 132000; %(meters)
D = 10^25; %(N*meters)   
wp = zeros(length(x),length(x)); 

for xi = x 
    r = abs(x-x(xi));
    [kei,ker] = kelvin_function(0,r./L);
    wp(xi,:) = (P.*L^2)/(2*pi*D).*kei;
end

wp_tot = sum(wp,2);

dhb_dt = (-1/tau).*(hb-hb_eq+wp_tot); 

%dh = h2 - h1; %dh needs to just be the ice change that's above floatation

b_eqNew = b0 - h_ice_depress_bed.*gamma;
%db_dt = (-1/tau)*(b-b0-b_eqNew);
db_dt = (-1/tau)*(b-b_eqNew);
bNew = b + db_dt*dt;

% figure
% plot(h1);
% hold on
% plot(h2);
%  
% peak = (sum(h1)-sum(h2))*dx/(3*sqrt(2*pi)*abs(10000*(L2-L1)));
%  
% for ix = 1:len
%     b_eqNew(ix) = b_eq(ix) + peak*exp(-((ix-L2)^2)/2*(10000*(L2-L1))^2);
%     db_dt(ix) = -(b(ix) - b0(ix) - b_eqNew(ix))/tau;
%     bNew(ix) = b(ix) + db_dt(ix)*dt;
% end
% figure
% plot(b_eq);
% hold on
%plot(b);
 
return