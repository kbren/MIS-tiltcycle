%Explain what we're doing here...

close all; 
clear all; 

load('~/Research/MIS_tiltcycle/1Dvars.mat')

%rho_i = 917;    % density of ice (kg/m^3) 
%rho_b = 3370;   % density of bed (kg/m^3)
%rho_w = 1000;   % density of water (kg/m^3)
secs_per_yr = 3600*24*365.25;

h = squeeze(h);
hb = squeeze(hb);
time = time*secs_per_yr;

x = 1:1:300;
x = x.*1000;

h1_eq = h(:,1);

b = hb(:,1);
b0 = hb(:,1);
b_eq = hb(:,1);

tau = 3000*secs_per_yr; 

for ii = 1:length(time)
    t = time(ii);
    h1 = h(:,ii);
    
    plot(x,b,'b-'); 
    hold on;
    plot(x,h1,'k-'); 
    plot(x,b_eq,'r-');
    %plot(x,hb(:,ii),'g-');
    
    [bNew,hxNew] = bedSpring_v2(x,h1,h1_eq,b,b_eq,tau);
    b = bNew;
end    