% Currently this is putting a block of ice on a bed (constant thickness in
% time and spans the whole domain). 
% What's broken is the b_eq, calculating the new bed equilibrium. As the
% the ice depresses the bed more water is supporting the ice so the b_eq
% should rise slightly, and currently its dropping dramatically!?!?
% In the absense of water b_eq should not change with this constant ice
% thickness setup (currently the water level is changing)

% 05/17/19: CODE DOES NOT BREAK!! but it also doesn't work. 
%           Bed doesn't change, it should go down to about -30. 
%           b currently has NaNs 
% NEXT TIME: do two time steps and see if b turns to Nans right away
%           fix it.

close all; 
clear all; 

tsteps = 100;

rho_i = 917;    % density of ice (kg/m^3) 
rho_b = 2650;   % density of bed (kg/m^3)
rho_w = 1000;   % density of water (kg/m^3)
gamma = rho_i/rho_b;  % displaced bed by ice
lambda = rho_i/rho_w; % (height ice)lambda = (height water)

% x = 0:10:1000;
% x = x.*1000;
% h1 = 5000.*ones(length(x),1); 
% h1_eq = zeros(length(x),1);
% L2 = 10; 
% H2 = 100;
% hg = 100;
% b = 0.*ones(length(x),1);
x = 0:1:470;
x = x.*1000;
h1_eq = 1400.*ones(length(x),1); 
h1_eq(1:50)=0.0; h1_eq(420:471)=0.0;
h1 = h1_eq.*(1500/1400);
b = 0.*ones(length(x),1);

% h_ice_sup_water = b.*1/lambda;
% h_ice_sup_water(b>0) = 0;
% h_ice_depress_bed = h1+h_ice_sup_water;

% b0 = b;
% b_eq = b0 - h_ice_depress_bed.*gamma;
b_eq = 0.*ones(length(x),1);
tau = 10; 

 
t = 0;
%while abs(b_eq-b)>1
%while abs((b0-b)/(b0-b_eq))>1
for t=1:tsteps
    plot(x,b,'b'); hold on; plot(x,h1+b,'k'); plot(x,b_eq,'r');%ylim([-100,100]);
%    H2 = mean(h1);
    [bNew,hxNew] = bedSpring_v2(x,h1,h1_eq,b,b_eq,tau);
    b = bNew; h1 = hxNew;
%    b_eq = b_eqNew;
%    t=t+1;
end



    