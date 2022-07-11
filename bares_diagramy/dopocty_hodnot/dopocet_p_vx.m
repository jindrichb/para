function p=dopocet_p_vx(v,x)
%vraci p z parametru s,t
citlivost = 1/10000000;
%dist = 100;
p=.00611658;
krok=1;
smer=0;
last=[9999,9998];
%prelast=9998;

h_x = XSteam('h_px',p,x);
h_v = dopocet_h_pv(p,v);
dist = h_x - h_v;

if dist > 0
    pripad = 1;
elseif dist < 0
    pripad = 2;
end

while (dist > citlivost && krok > .000000000000001)
    h_x = XSteam('h_px',p,x);
    h_v = dopocet_h_pv(p,v);
    
    if pripad == 1
        dist = h_v - h_x; 
    else
        dist = h_x - h_v; 
    end

    [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,pripad);

end

%p=p/10;
end