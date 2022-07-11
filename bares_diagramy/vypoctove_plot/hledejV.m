function out=hledejV(p,s0,citlivost,vol)
%probably obsolete func. I dare you to delete it.

krok_s = 1;
last_s = 0;
prelast_s = 0;
dist = 100;

while dist > citlivost
    holdit = XSteam('v_ps',p,s0);
    dist = vol - holdit;
    
    if dist < 0
        s0 = s0 - krok_s;
    elseif dist > 0
        s0 = s0 + krok_s;
    elseif dist == 0
        continue %disp("Bullseye!")
    end
    
    if prelast_s == s0
        krok_s = krok_s / 10;
    end
    prelast_s = last_s;
    last_s = s0;
    dist = abs(dist);
end

out=s0;
end