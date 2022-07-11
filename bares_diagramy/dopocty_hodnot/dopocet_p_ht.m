function [p,pripad]=dopocet_p_ht(h,t)
%vraci p z parametru h,t
citlivost = 1/1000000;
dist = 100;
p=1.001*10;
krok=10;
smer=0;
last=[9999,9998];

if t < 373.945
    if h < XSteam('hV_T',t)
        pripad =  2;
    else
        pripad = 1;
    end
else
    pripad = 1;
end

switch pripad
    case 1
        while (dist > citlivost && krok > .000000000000001)
            %a =XSteam('h_pT',p,t);
            dist = h - XSteam('h_pT',p,t);
            
            [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,1);
            
        end
    case 2
        p = XSteam('psat_T',t);
end
%p=p/10;
end