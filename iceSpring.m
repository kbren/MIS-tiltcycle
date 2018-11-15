clear all
close all

%% Set up 
rho_i = 917;
rho_w = 1028;
rho_b = 265; %average density of rock

g = 9.81;
n = 3;
m = 1/3;

year = 3600*24*365;
accum = 0.0/year; %0.5/year;

A_glen =4.227e-25;
C = 7.624e6;
theta0 = 0.9;

omega0 = ((A_glen*(rho_i*g)^(n+1) * (1-(rho_i/rho_w))^n / (4^n * C))^(1/(m+1))) * theta0^(n/(m+1));
beta = (m+n+3)/(m+1);
lambda = rho_w/rho_i;
gamma = rho_b/rho_i;

nt = 20000; %20e3;
tf = nt*1*year;
dt = tf/nt;

%% Define initial conditions
h = 2154.90; %initial mean thickness of glacier
xg = 386676.99; %initial length of glacier (terminus position)
hg = 545.59;
bg = -486.68;
bedslope = -1e-3; %negative means prograde slope
icedivide = bg - (xg+gamma*bg)*bedslope;

x = [1:100:400e3]; %was at 600e3
bx = icedivide + bedslope.*x; %b_0
hx = zeros(1,length(x));
%hx_forbg = zeros(1,length(x));
cnt = 1;
for xi = 1:100:floor(xg)
    hx(cnt) = (3*(h-hg)*sqrt(xg-xi))/(2*sqrt(xg)) + hg;
%    hx_forbg(xi) = (3*(h)*sqrt(xg-xi))/(2*sqrt(xg));
    cnt = cnt + 1;
end
b_0 = bx + hx.*gamma; %bx and -
%ind = find(x==floor(xg));
%b = bx(ind);
%xg = x(ind);
bx_eq = -hx.*gamma;
%%
% get things started
tau = 3000;%/(dt/year); %timescale of solid earth response (years)
xg_t(1) = xg;
h_t(1) = h;
b_t(1) = bg;
hg_t(1) = hg;

bx_t = zeros(nt,length(x));
bx_eq_t = zeros(nt,length(x));
hx_t = zeros(nt,length(x));
bx_t(1,:) = bx;
bx_eq_t(1,:) = bx_eq;
hx_t(1,:) = hx;

%% Run two-stage model
for t = 2:nt %100kyr to steady state (original comment)
  
    omega = omega0;%((A_glen*(rho_i*g)^(n+1) * (1-(rho_i/rho_w))^n / (4^n * C))^(1/(m+1))) * theta0^(n/(m+1));
    
    % calculate grounding line ice height
    hg = -(rho_w/rho_i)*bg; % with bedrock rebound, this shouldn't be a steady-state solution as it's written now...
    
    % calculate internal ice flux
    Q = (rho_i*g/(C*xg))^n * (h^(2*n + 1));
   
    % calculate flux across the grounding line
    Q_g = omega*(hg^beta);
    
    % find change in height and length of ice
    dh_dt = accum - (Q_g/xg) - (h/(xg*hg))*(Q-Q_g);
    dxg_dt = (Q-Q_g)/hg;
    
    % find new height and length of ice
    dh = dh_dt*dt;
    h = h + dh;
    dxg = dxg_dt*dt;
    xg = xg + dxg;
    
    h_t(t) = h;
    xg_t(t) = xg;
    hg_t(t) = hg;
    
    [bNew,bx_eqNew,hxNew] = bedSpring(hx_t(t-1,:),xg_t(t),h_t(t),hg,bx,bx_eq,b_0,tau); 
    
    ind1 = find(x==floor(xg/100)*100+1);
    ind2 = ind1+1;
    bg = (bNew(ind1)+bNew(ind2))/2;
    bx = bNew;
    bx_eq = bx_eqNew;
    
    b_t(t) = bg;
    bx_t(t,:) = bx;
    bx_eq_t(t,:) = bx_eq;
    hx_t(t,:) = hxNew;

    
end

%% Fourier transform
ft = fft(xg_t); %what does this mean?
f_range = (0:nt-1).*(1/nt);
ft_power = abs(ft).^2/nt;
% figure(1)
% plot(f_range,ft_power);
% xlabel('frequency');
% ylabel('power');
% title('power in frequency space');

[pks, pk_locs] = findpeaks(ft_power,'Threshold',2e10);
freqs = f_range(pk_locs);
freq = freqs(freqs>0);

%%
% plot some things to see what's happening through time
% figure(1)
% plot((2:nt),dhs_nl(2:nt));
% title('dh_dt');

% figure(2)
% plot((2:nt),xgs_nl(2:nt));
% title('length');
% 
% figure(3)
% plot((2:nt),hs_nl(2:nt));
% title('height');
% 
% figure(4)
% plot((2:nt),b_nl(2:nt));
% title('bed');
% 
% figure(5)
% plot((2:nt),dArea(2:nt));
% title('dArea');
% 
% figure(6)
% plot(xgs_nl(2:nt),b_nl(2:nt));

% figure(6)
% plot((2:nt),dArea(2:nt));
% title('dArea');
