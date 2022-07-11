function p=dopocet_p_ux(u,x)
%vraci p z parametru s,t
citlivost = 1/10000000;
%dist = 100;
p=.00611658;
krok=1;
smer=0;
last=[9999,9998];
%prelast=9998;

h_x = XSteam('h_px',p,x);
h_u = dopocet_h_pu(p,u);
dist = h_x - h_u;

if dist > 0
    pripad = 1;
elseif dist < 0
    pripad = 2;
end

while (dist > citlivost && krok > .000000000000001)
    h_x = XSteam('h_px',p,x);
    h_u = dopocet_h_pu(p,u);
    
    if pripad == 1
        dist = h_u - h_x; 
    else
        dist = h_x - h_u; 
    end

    [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,pripad);

end

%p=p/10;
end