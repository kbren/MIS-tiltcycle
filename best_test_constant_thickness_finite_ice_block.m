% Currently this is putting a block of ice on a bed (constant thickness in
% time and spans only part of the domain). 

% Not Working: (06/11/19) 
%   - The bed does not depress away from the ice sheet 
%   - When water is added, it eventually goes back to zero 
%        bed depression because the sea surface height doesn't change
%   - Kelvin function affects seem really small 

close all; 
clear all; 

tsteps = 6000;

rho_i = 917;    % density of ice (kg/m^3) 
rho_b = 2650;   % density of bed (kg/m^3)
rho_w = 1000;   % density of water (kg/m^3)
gamma = rho_i/rho_b;  % displaced bed by ice
lambda = rho_i/rho_w; % (height ice)lambda = (height water)

x = 0:10:1000;
x = x.*1000;
h1 = 5000.*ones(length(x),1); 
h1(80:end)=0.0;
h1_eq = zeros(length(x),1);
L2 = 10; 
H2 = 100;
hg = 100;
b = -500.*ones(length(x),1);

h_ice_sup_water = b.*1/lambda;
h_ice_sup_water(b>0) = 0;
h_ice_depress_bed = h1+h_ice_sup_water;

b0 = b;
%b_eq = b0 - h_ice_depress_bed.*gamma;
b_eq = b; %0.*ones(length(x),1);
tau = 2000; 

 
t = 0;
%while abs(b_eq-b)>1
%while abs((b0-b)/(b0-b_eq))>1
for t=1:tsteps
    plot(x,b,'b'); hold on; plot([800000 800000],[-1600 200]);%plot(x,h1+b,'k'); 
    %plot(x,h1,'g'); 
    plot(x,b_eq,'r');%ylim([-100,100]);
    H2 = mean(h1);
    [bNew,hxNew] = bedSpring_v2(x,h1,h1_eq,b,b_eq,tau);
    b = bNew; h1 = hxNew;
%    b_eq = b_eqNew;
%    t=t+1;
end

plot(x,bNew,'k','linewidth',2);


    