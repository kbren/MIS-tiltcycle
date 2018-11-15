function [bNew,b_eqNew,hxNew] = bedSpring(h1,L2,H2,hg,b,b_eq,b0,tau);
 
rho_i = 917;
rho_b = 265;
gamma = rho_b/rho_i;

dt = 1;
len = length(b); %2000;

% h1(1:len) = 0;
h2 = zeros(1,len);
 
% for ix = 1:floor(L1)
%     h1(ix) = 3*(H1-hg)*sqrt((L1-ix)/L1)/2 + hg;
% end
%  

cnt = 1;
for ix = 1:100:floor(L2)
    h2(cnt) = 3*(H2-hg)*sqrt((L2-ix)/L2)/2 + hg;
    cnt = cnt + 1;
end

hxNew = h2;

dh = h2 - h1; %dh needs to just be the ice change that's above floatation

b_eqNew = b_eq - dh.*gamma;
db_dt = (-1/tau)*(b-b0-b_eqNew);
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
