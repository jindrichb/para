function [p,krok,smer,dist_x]=dopocet_p_sx_pomoc_p(dist_x,p,krok,smer,pripad)
%dist_x, p, krok, smer, pripad
%
%[p,smer]=dopocet_p_sx_pomoc_p(dist_x,p,krok,smer,pripad)

if dist_x < 0
    if pripad == 0
        smer = 1;
        p = p - krok;
    elseif pripad == 1
        smer = 0; %?? snad?
        p = p + krok;
    else
        error('neznam pripad');
        %warning('neznam pripad');
    end
    
elseif dist_x > 0
    if pripad == 0
        smer = 0;
        p = p + krok;
    elseif pripad == 1
        smer = 1; %?? snad?
        p = p - krok;
    else
        error('neznam pripad');
        %warning('neznam pripad');
    end
elseif dist_x == 0
    disp('toto by nikdy nemelo nastat')
else %musí být nan
    if smer == 1
        p = p + .9 * krok;
    elseif smer == 0
        p = p - .9 * krok;
    end
    krok = krok * .1;
    dist_x = 100;
end
end