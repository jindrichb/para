vin = .002;
dist_max = .00001;


fig = figure;
hold on;

outv = [];
outs = [];
tcka = linspace(1,800);

for t = tcka
    outv = [outv,XSteam('v_pt',1000,t)];
    outs = [outs,XSteam('s_pt',1000,t)];
end

% isobara
plot(outs, tcka)

% aktualni max isochora v = .0032
[out_s, ~, out_T]=isochory_vypocet( XSteam('vV_T',373.94));
plot(out_s, out_T)
hold on
% nalezeni horniho bodu pro zadane v
% teplota je zbytecne vysoka, najdi mez
t = 800;
step_t = 400;
p = 1000;

% xsteam(v_pt)
n = 0;
dist = 100;
while n < 500 && abs(dist) > dist_max
    n = n + 1;
    vt = XSteam('v_pt',p,t);
    dist = vin - vt;
    
    if abs(dist) > dist_max && dist < 0
        % vin is smaller number -> t down
        t = t - step_t;
    elseif abs(dist) > dist_max && dist > 0
        % vin is bigger number -> t up
        step_t = step_t / 2;
        t = t + step_t;
    else
        % good enough
        continue
    end
end

disp(["vin = ", vin, ' v = ', vt, ' at t = ',t])
smax = XSteam('s_pt',p,t);
tmax = t;
pmax = p;
% plot(s,t)

% now try to plot a line according to this vol

tlist = linspace(t,1);
plist = [];
slist = [];
for t = tlist
    if t < 361
        disp('t')
    end
    n = 0;
    dist = 100;
    p = 1000;
    step_p = 100;
    while n < 500 && abs(dist) > dist_max
        n = n + 1;
        vt = XSteam('v_pt',p,t);
        dist = vin - vt;
        
        if abs(dist) > dist_max && dist > 0
            % vin is smaller number -> t down
            p =  p - step_p;
        elseif abs(dist) > dist_max && dist < 0
            % vin is bigger number -> t up
            step_p = step_p / 2;
            p = p + step_p;
        else
            % good enough
            continue
        end
    end

    plist = [plist, p];
    slist = [slist, XSteam('s_pt',p,t)];
end
    
plot(slist,tlist)
    
    
    
    
    
    
    



