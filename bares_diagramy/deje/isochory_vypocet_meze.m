function [out_s, out_h, out_T]=isochory_vypocet_meze(vol,p1,t1,x1,p2,t2,x2,bodu,varargin)
%[out_s, out_h, out_T]=isochory_vypocet_meze(vol,p1,x1,x2,p2,varargin)
%
%varargin = 1 for hs 
%
%find saturated vapour volume using T, vV_T
%vol = 20;

%kontrola vstupu
if nargin == 8
    hs=0;
elseif nargin == 9
    if strcmp(varargin(1),'hs')
        hs=1;
    else
        error('unknown input')
    end
else
    error('too many input arguments')
end
s_lower = [];
t_lower = [];
h_lower = [];
s_higher = [];
t_higher = [];
h_higher = [];
%rozdeleni intervalu dle pripadu zadani
if x1==1 && x2==1
    %all is upper
    [s_higher,t_higher,h_higher]=sucho(vol,t1,t2,p1,bodu);
elseif x1==1 && x2~=1
    %the unfortunate case
    [~,pmez]=mezni_teplota_tlak(vol);
    [s_lower,t_lower,h_lower]=mokro(vol,p2,pmez,bodu,hs);
    tmez=XSteam('Tsat_p',pmez)+.001;
    [s_higher,t_higher,h_higher]=sucho(vol,tmez,t1,p1,bodu);
elseif x1~=1 && x2~=1
    %all is lower
    [s_lower,t_lower,h_lower]=mokro(vol,p1,p2,bodu,hs);
    % possibly goes high value to low value
    % which breaks rm_these filter used to sync
    % higher and lower intervals
    % resulting in function returning empty lists
    % solution is to make sure the lists go low value to high value
    if s_lower(1) > s_lower(length(s_lower))
        s_lower = flip(s_lower);
        t_lower = flip(t_lower);
        h_lower = flip(h_lower);
    end
elseif isnan(x1) || isnan(x2)
    warndlg('Too many NaNs. Something went wrong.')
    out_s = [-1,-1];
    out_h = [-1,-1];
    out_T = [-1,-1];
    return
end

out_s=[s_lower,s_higher];
out_h=[h_lower,h_higher];
out_T=[t_lower,t_higher];

if out_s(1) > out_s(length(out_s))
    out_s = flip(out_s);
    out_h = flip(out_h);
    out_T = flip(out_T);
end
rm_these=[];
last_s = 0;
for s = (1:length(out_s))
    if out_s(s) > last_s
        last_s = out_s(s);
    else
        rm_these(end+1) = s;
    end
end

if ~(isempty(rm_these))
    if rm_these(1)==2
        rm_these = [1,rm_these];
    end
    for rm = (1:length(rm_these))
        out_s = out_s([1:rm_these(length(rm_these)-rm+1)-1,...
            rm_these(length(rm_these)-rm+1)+1:end]);
        out_h = out_h([1:rm_these(length(rm_these)-rm+1)-1,...
            rm_these(length(rm_these)-rm+1)+1:end]);
        out_T = out_T([1:rm_these(length(rm_these)-rm+1)-1,...
            rm_these(length(rm_these)-rm+1)+1:end]);
    end
end

end %function

%-------------------------------------------------------------------------
%               hledani mezni teploty a tlaku
%-------------------------------------------------------------------------
function [temperature,pmez]=mezni_teplota_tlak(vol)
%function [temperature,pmez]=mezni_teplota_tlak(vol)

temperature=1;

citac = 0;
%holdit = 0;
stepT = 1;
lastT = 0;
pre_lastT = 0;
citlivost = vol/10000000;
dist = 100;

%nelezeni saturacni teploty pro dany objem
while (dist>citlivost && stepT > .00000001)
    holdit = XSteam('vV_T',temperature);
    dist = vol - holdit;
    
    if dist < 0
        temperature = temperature + stepT;
    elseif dist > 0
        temperature = temperature - stepT;
    elseif dist == 0
        %continue
        %disp("jackpot")
    end
    
    if temperature > 373.94
        temperature = 373.94;
        citac = citac + 1;
        if citac > 5
            disp(vol)
            error("Max temperature reached")
        end
    end
    
    if pre_lastT == temperature
        stepT = stepT * .1;
    end
    pre_lastT = lastT;
    lastT = temperature;
    
    dist = abs(dist);
end

%convert T to p using saturation pressure psat_T
pmez = XSteam('psat_T',temperature);
%disp(pmez)
end

%-------------------------------------------------------------------------
%               interval suche pary
%-------------------------------------------------------------------------
function [s_higher,t_higher,h_higher]=sucho(vol,t1,t2,p0,bodu)
p=p0;
%horni cast v - init
%p=pmez;
%tmez=XSteam('Tsat_p',pmez)+.001;
%tlist=linspace(tmez,800,bodu);
tlist=linspace(t1,t2,bodu);
t_higher=tlist;
h_higher=zeros(1,bodu);
s_higher=zeros(1,bodu);
citlivost = .000001;



for i = (1:bodu)
    dist = 1000;
    last = [0,0];
    smer=1;
    krok=1;
    
    %t0 = 150;
    
    while (dist > citlivost && krok > .00000000000001)
        %a = XSteam('v_pT',p,tlist(i));
        dist = vol - XSteam('v_pT',p,tlist(i));
        if abs(dist)<citlivost
            %continue
        elseif dist < 0
            %chci p+
            smer = 1;
            p = p + krok;
        elseif dist > 0
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
        if last(2) == p
            krok = krok/10;
        end
        
        last(2) = last(1);
        last(1) = p;
        dist = abs(dist);
        %.000000000000001
        if krok < .0000000000000001
            error('step is too small, out of bounds, I think')
        end
        
    end
    
    
    %t_higher(i)=tlist(i);
    s_higher(i)=XSteam('s_pT',p,tlist(i));
    h_higher(i)=XSteam('h_pT',p,tlist(i));
    
end
end

%-------------------------------------------------------------------------
%               interval mokre pary
%-------------------------------------------------------------------------
function [s_lower,t_lower,h_lower]=mokro(vol,p1,p2,bodu,hs)
%function [s_lower,t_lower,h_lower]=mezni_teplota_tlak(vol)

%dolni cast v - init
plist=linspace(p2,p1,bodu);

s_lower = zeros(1,bodu);
t_lower = s_lower;
h_lower = s_lower;

citlivost = .000001;
last = 0;
prelast = 0;

krok_s = .5;
dist=1000;
%dolní cast v - loop
for i = (1:bodu)
    p = plist(bodu-i+1);
    %s0 = hledejV(p,s0,citlivost,vol);
    s0=4;
    %(dist > citlivost && krok > .000000000000001)
    while (dist > citlivost && krok_s > .0000001)
        
        dist = vol - XSteam('v_ps',p,s0);
               
        if dist < 0
            s0 = s0 - krok_s;
        elseif dist > 0
            s0 = s0 + krok_s;
        elseif dist == 0
            %continue
            %disp("Bullseye!")
        else %nan
            disp('nan')
        end
        
        if prelast == s0
            krok_s = krok_s / 10;
        end
        prelast = last;
        last = s0;
        dist = abs(dist);
    end
    dist=100;
    krok_s=1;
    h = XSteam('h_ps',p,s0);
    %tento if "ořezává" zbytečné body pro hs diagram
    if hs == 1
        if h > 1650
            s_lower(i) = s0;
            t_lower(i) = XSteam('T_ps',p,s0);
            h_lower(i) = XSteam('h_ps',p,s0);
        else
            break
        end
    else
        s_lower(i) = s0;
        t_lower(i) = XSteam('T_ps',p,s0);
        h_lower(i) = XSteam('h_ps',p,s0);
    end
end

end






