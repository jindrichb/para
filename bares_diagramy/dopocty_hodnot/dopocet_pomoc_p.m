function [p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,citlivost,smer,krok,last,pripad)
%[p,dist,smer,krok,last]=dopocet_pomoc_p(p,dist,smer,krok,last,pripad)
%
%p zde znaci obecne velicinu, jedna se o pozustatek vyvoje
%
%platne pripady 1,2
%
%pripad = 1 -> dist > 0; p-krok
%pripad = 2 -> dist > 0; p+krok
%
%funkce kontroluje vzdalenost tlaku od pozadovane hodnoty a upravuje
%hodnotu p dle vzajemne polohy
%
%

switch pripad
    case 1
        if abs(dist)<citlivost
            %continue
        elseif dist > 0
            %chci p-
            smer = 1;
            p = p - krok;
        elseif dist < 0
            %chci p+
            smer = 0;
            p = p + krok;
            %dist = abs(dist);
        elseif dist == 0
            %continue
        else %musí být nan
            if smer == 0
                p = p + .9 * krok;
            elseif smer == 1
                p = p - .9 * krok;
            end
            krok = krok * .1;
            dist = 100;
        end
    case 2
        if abs(dist)<citlivost
            %continue
        elseif dist > 0
            %chci p+
            smer = 1;
            p = p + krok;
        elseif dist < 0
            %chci p-
            smer = 0;
            p = p - krok;
            %dist = abs(dist);
        elseif dist == 0
            %continue
        else %musí být nan
            if smer == 1
                p = p + .9 * krok;
            elseif smer == 0
                p = p - .9 * krok;
            end
            krok = krok * .1;
            dist = 100;
        end
end

if last(2) == p
    krok = krok/10;
end

last(2) = last(1);
last(1) = p;
dist = abs(dist);
         %.000000000000001
if krok < .0000000000000000001
    error('out of bounds, I think')
end


end