ts = [1:1000:20000];

figure(1)
%plot(x,hx_t(ts,:))
plot(x,hx_t(ts,:)+bx_t(ts,:))
hold on
plot(x,bx_t(ts,:))
%legend('1','5001','10001','15001','20001','25001','30001','35001','40001')

figure(2)
plot(1:length(xg_t),xg_t)

%figure(2)
%plot3(xg_t,h_t,b_t);
