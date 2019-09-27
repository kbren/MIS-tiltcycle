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
rho_b = 3370;   % density of bed (kg/m^3)
% rho_b = 2650;
rho_w = 1000;   % density of water (kg/m^3)
% gamma = rho_i/rho_b;  % displaced bed by ice
% lambda = rho_i/rho_w; % (height ice)lambda = (height water)
secs_per_yr = 3600*24*365.25;

dt = 100*secs_per_yr;         % timestep in years 
%len = length(b); % number of points along the bed (x-axis) 

% This makes changes to the ice thickness: 
%cnt = 1;
%for ix = 1:100:floor(L2)
%    h2(cnt) = 3*(H2-hg)*sqrt((L2-ix)/L2)/2 + hg;
%    cnt = cnt + 1;
%end

% For no changes to the ice thickness: 
hxNew = h; 

% Gravity (m/s^2) :)
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
% D is the flexural rigidity 
%D = 10^25; %(N*meters) 
D = 1*10^20; 
% L is flexural length scale 
L = 132000; %(meters)
%L = 200000; %(meters)
%L = (D/(rho_b*g))^(1/4);
wp = zeros(length(x),length(x));
kei_mat = zeros(length(x),length(x));

for xi=1:length(x) 
    r = abs(x-x(xi))+1e-10;
    [ker,kei] = kelvin_function(0,r./L);
    kei_mat(xi,:) = kei;
    wp(xi,:) = ((P(xi)*L^2)./(2*pi*D)).*kei;%.*100000;
end

%wp_pt = (q.*L^4)./D;
wp_tot = sum(wp,1);

% changed to -wp_tot as opposed to +wp_tot in (Pollard and Deconto 2012)
db_dt = (-1/tau).*(b-b_eq-wp_tot'); 
%db_dt = (-1/tau).*(b-b_eq+wp_tot'); 

bNew = b + db_dt*dt;
 
return