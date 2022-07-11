function p=dopocet_p_su(s,u)
%vraci p z parametru s,t
citlivost = 1/10000000;
dist = 100;
p=1.001*10;
krok=10;
smer=0;
last=[9999,9998];
%prelast=9998;


while (dist > citlivost && krok > .000000000000001)
    %a =XSteam('h_pT',p,t);
    dist = u - XSteam('u_ps',p,s);
    
    [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,1);

end

%p=p/10;
end