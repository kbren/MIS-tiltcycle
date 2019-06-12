function [bNew,hxNew] = bedSpring(x,h,h_eq,b,b_eq,tau);
% All heights are relative to sea surface height (currently unchanging)
% all changes in the sea level are absorbed by changes in the bed

% h = height of ice along x-axis at the previous timestep (vector)
% h_eq = equilibrium height of ice when bed is in equilibrium (vector)
% b = current bed elevation (vector) positive going up, zero is water
%      surface, magnitude of b (when negative) is equivalent to water thickness
% b_eq = current equilibrium bed (vector) 
% tau = timescale (scalar)

% TO DO: 

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

% This makes changes to the ice thickness: 
%cnt = 1;
%for ix = 1:100:floor(L2)
%    h2(cnt) = 3*(H2-hg)*sqrt((L2-ix)/L2)/2 + hg;
%    cnt = cnt + 1;
%end

% For no changes to the ice thickness: 
hxNew = h; 

% Gravity :)
g = 9.81;

% specifying the water thickness (needs to be positive or zero)
% and eq thickness based on the height of the bed 
hw = -1*b;
hw_eq = -1*b_eq;

hw(hw<0.0)=0.0;
hw_eq(hw_eq<0.0)=0.0;

hw(h>0.0)= 0.0;
hw_eq(h_eq>0.0)=0.0;
    
% q is the applied load    
q = rho_i*g.*h + rho_w*g.*(hw) - rho_i*g.*h_eq - rho_w*g.*(hw_eq);

dx = x(2)-x(1);  
P = q.*dx; 
L = 132000; %(meters)
D = 10^25; %(N*meters)   
wp = zeros(length(x),length(x));

for xi=1:length(x) 
    r = abs(x-x(xi));
    [kei,ker] = kelvin_function(0,r./L);
    %kei(isinf(kei)) = 12000000.0;
    kei(isinf(kei)) = 0.0;
    wp(xi,:) = ((P'.*L^2)./(2*pi*D)).*kei;%.*100000;
end

wp_pt = (q.*L^4)./D;
wp_tot = sum(wp,1)+wp_pt';

db_dt = (-1/tau).*(b-b_eq+wp_tot'); 

bNew = b + db_dt*dt;

%dh = h2 - h1; %dh needs to just be the ice change that's above floatation

%b_eqNew = b0 - h_ice_depress_bed.*gamma;
%db_dt = (-1/tau)*(b-b0-b_eqNew);
%db_dt = (-1/tau)*(b-b_eqNew);

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