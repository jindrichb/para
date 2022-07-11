function [p]=dopocet_p_hx(h,x)
%vraci p z parametru h,t
citlivost = 1/1000000;
%dist = 100;
p=.00611658;
krok=1;
smer=0;
last=[9999,9998];
%prelast=9998;

dist = h - XSteam('h_px',p,x);
if dist < 0 
    pripad = 1;
elseif dist > 0 
    pripad = 2;
else
    %pripad = -1;
    %dist = 0 -> p je nalezeno
    return
end

while (dist > citlivost && krok > .000000000000001)
    %a =XSteam('h_px',p,x);
    dist = h - XSteam('h_px',p,x);
    [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,pripad);
%     if abs(dist)<citlivost
%         %continue
%     elseif dist > 0
%         %chci p+
%         smer = 1;
%         p = p - krok;
%     elseif dist < 0
%         %chci p-
%         smer = 0;
%         p = p + krok;
%         %dist = abs(dist);
%     elseif dist == 0
%         %continue
%     else %musí být nan
%         if smer == 0
%             p = p + .9 * krok;
%         elseif smer == 1
%             p = p - .9 * krok;
%         end
%         krok = krok * .1;
%         dist = 100;
%     end
%     if last(2) == p
%         krok = krok/10;
%     end
%     
%     last(2) = last(1);
%     last(1) = p;
%     dist = abs(dist);
%     if krok < .0000000000000001
%         error('out of bounds, I think')
%     end
    
end


%p=p/10;
end