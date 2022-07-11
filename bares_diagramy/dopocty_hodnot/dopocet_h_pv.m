function [h]=dopocet_h_pv(p,v)
%vraci p z parametru h,t
citlivost = 1/1000000;
dist = 100;
h=100;
krok=100;
smer=0;
last=[9999,9998];
%prelast=9998;



while (dist > citlivost && krok > citlivost * 1000)
    %a =XSteam('h_px',p,x);
    if dist < 1 && (h < 99 || h > 4001)
        if h < 100
            h = 100;
        elseif h > 4001
            h = 4000;
        end
        break 
    end
    dist = v - XSteam('v_ph',p,h);
    [h,dist,smer,krok,last]=dopocet_pomoc_p(h,dist,citlivost,smer,krok,last,2);
end


%p=p/10;
end