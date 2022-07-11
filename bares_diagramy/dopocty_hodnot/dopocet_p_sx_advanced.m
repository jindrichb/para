function [p]=dopocet_p_sx_advanced(s,x)
%vraci p z parametru h,t
citlivost_x = 1/100000;
citlivost_s = 1/1000;
dist_s = 100;
p=.00611658;
krok=1;
smer=0;
last=9999;
prelast=9998;
kontrola = 0;

dist_x= x - XSteam('x_ps',p,s);

if dist_x < 0 %vyssi s
    pripad = 1;
elseif dist_x > 0 %nizsi s
    pripad = 0;
else
    pripad = -1;
end

while kontrola == 0
    %while ((dist_x > citlivost_x)&&(krok > .0000000001)||(dist_s > citlivost_s))
    %a =XSteam('x_ps',p,s);
    dist_x = x - XSteam('x_ps',p,s);
    if abs(dist_x)<citlivost_x
        if x == 1
            h = XSteam('h_px',p,x);
            dist_s = s - XSteam('s_ph',p,h);
            if dist_s < 0
                p=p+krok;
            elseif dist_s > 0
                p=p-krok;
            elseif dist_s == 0
                continue
            else
                error('asi NaN')
            end
        elseif x==0
            p=p-krok;
            krok=krok*.95;
        end
    else
        [p,krok,smer,dist_x]=dopocet_p_sx_pomoc_p(dist_x,p,krok,smer,pripad);
    end
    
    if prelast == p
        krok = krok/10;
    end
    prelast = last;
    last = p;
    dist_x = abs(dist_x);
    %citlivost = p/1000000;
    %-------------------
    if krok < .0000000000000001
        error('out of bounds, I think')
    end
    if dist_x < citlivost_x
        if dist_s < citlivost_s
            kontrola =1;
        end
    end
    if krok < .000000000000001
        kontrola =1;
    end
end

if p < .00611658
    p=.00611658;
    warning('p too low, p set to min')
end
%p=p/10;
end