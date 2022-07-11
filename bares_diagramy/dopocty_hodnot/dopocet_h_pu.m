function [h]=dopocet_h_pu(p,u)
%vraci p z parametru h,t
citlivost = 1/1000000;
dist = 100;
h=100;
krok=100;
smer=0;
last=[9999,9998];
%prelast=9998;



while (dist > citlivost && krok > .000000000000001)
    %a =XSteam('h_px',p,x);
    dist = u - XSteam('u_ph',p,h);
    [h,dist,smer,krok,last]=dopocet_pomoc_p(h,dist,citlivost,smer,krok,last,2);
end


%p=p/10;
end