% Currently this is putting a block of ice on a bed (constant thickness in
% time and spans the whole domain). 
% What's broken is the b_eq, calculating the new bed equilibrium. As the
% the ice depresses the bed more water is supporting the ice so the b_eq
% should rise slightly, and currently its dropping dramatically!?!?
% In the absense of water b_eq should not change with this constant ice
% thickness setup (currently the water level is changing) 

close all; 
clear all; 

rho_i = 917;    % density of ice (kg/m^3) 
rho_b = 2650;   % density of bed (kg/m^3)
rho_w = 1000;   % density of water (kg/m^3)
gamma = rho_i/rho_b;  % displaced bed by ice
lambda = rho_i/rho_w; % (height ice)lambda = (height water)

x = 0:10;
h1 = 100.*ones(length(x)); 
L2 = 10; 
H2 = 100;
hg = 100;
b = -10.*ones(length(x));

h_ice_sup_water = b.*1/lambda;
h_ice_sup_water(b>0) = 0;
h_ice_depress_bed = h1+h_ice_sup_water;

b_eq = b - h_ice_depress_bed.*gamma;
b0 = b;
tau = 10; 

for t=1:10 
    plot(x,b,'b'); hold on; plot(x,h1+b,'k'); plot(x,b_eq,'r');ylim([-100,100]);
    H2 = mean(h1);
    [bNew,b_eqNew,hxNew] = bedSpring(h1,L2,H2,hg,b,b_eq,b0,tau);
    b = bNew; b_eq = b_eqNew; h1 = hxNew; 
end



    