function [out_s, out_h, out_T]=isochory_vypocet(vol,varargin)
%[out_s, out_h, out_T]=isochory_vypocet(vol,diagram)
%
%varargin = 1 for hs 
%

if nargin == 1
    hs=0;
elseif nargin == 2
    if strcmp(varargin(1),'hs')
        hs=1;
    else
        error('unknown input')
    end
else
    error('too many input arguments')
end

t_max = 373.945;
krajni_vol = XSteam('vV_T',t_max);
if vol >= 0 % krajni_vol
%find saturated vapour volume using T, vV_T
%vol = 20;
    temperature=1;
    
    %for vol = [100,50,20,5,1,.33,.1,.05,.033,.025,.02,.01]
    %for vol = [100,.01,.005,.004,.0031712]
    %for vol = [100,50,20,10,5,2,1,.5,.2,.1,.05,.02,.01,.005,.0031712]
    %for vol = [.0031712]
    %for vol = [linspace(10,100,200),linspace(1,10,100)]
    %for vol = [linspace(.005,.01,500)]
    
    citac = 0;
    %holdit = 0;
    stepT = 1;
    lastT = 0;
    pre_lastT = 0;
    citlivost = vol/10000000;
    dist = 100;
    if vol >= krajni_vol
        % má průsečík s x = 1
        while (dist > citlivost && stepT > .00000001)
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

            if temperature > t_max
                temperature = t_max;
                citac = citac + 1;
                if citac > 5
                    disp(vol)
                    error("dosazena maximalni teplota")
                end
            end


            if pre_lastT == temperature
                stepT = stepT * .1;
            end
            pre_lastT = lastT;
            lastT = temperature;

            dist = abs(dist);
        end
    else
        % může mít průsečík s x = 0
        while (dist>citlivost && stepT > .00000001)
            holdit = XSteam('vL_T',temperature);
            dist = vol - holdit;

            if dist > 0
                temperature = temperature + stepT;
            elseif dist < 0
                temperature = temperature - stepT;
            elseif dist == 0
                %continue
                %disp("jackpot")
            end

            if temperature > t_max
                temperature = t_max;
                citac = citac + 1;
                if citac > 5
                    disp(vol)
                    error("dosazena maximalni teplota")
                end
            end


            if pre_lastT == temperature
                stepT = stepT * .1;
            end
            pre_lastT = lastT;
            lastT = temperature;

            dist = abs(dist);
        end
    end
    %convert T to p using saturation pressure psat_T
    pmez = XSteam('psat_T',temperature);
    %disp(pmez)
    
    %now you have volume and pressure at saturation point
    %split intervals
    %lower interval - create pressure points
    %               - run "find volume" using fixed pressure points changing s
    %                   v_ps
    
    %dolni cast v - init
    %plist=linspace(.01,pmez,100);
    plist=linspace(.00611658,pmez,100);
    
    s0 = 6.5;
    s_lower = zeros(1,length(plist));
    t_lower = s_lower;
    h_lower = s_lower;
    last = 0;
    prelast = 0;
    
    krok_s = .5;
    dist=1000;
    %dolní cast v - loop
    for i = (1:length(plist))
        p = plist(length(plist)-i+1);
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
    
    %horni cast v - init
    bodu = 60;
    
    p=pmez;
    tmez=XSteam('Tsat_p',pmez)+.001;
    tlist=linspace(tmez,800,bodu);
    t_higher=tlist;
    h_higher=zeros(1,bodu);
    s_higher=zeros(1,bodu);
    citlivost = .000001;
    
    
    
    for i = (1:bodu)
        dist = 1000;
        last = [0,0];
        smer=1;
        krok=pmez/10;
        
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
                error('out of bounds, I think')
            end
            
        end
        
        
        %t_higher(i)=tlist(i);
        s_higher(i)=XSteam('s_pT',p,tlist(i));
        h_higher(i)=XSteam('h_pT',p,tlist(i));
        
    end
    
    out_s=[flip(s_lower),s_higher];
    out_h=[flip(h_lower),h_higher];
    out_T=[flip(t_lower),t_higher];
    
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
        for rm = (1:length(rm_these))
            out_s = out_s([1:rm_these(length(rm_these)-rm+1)-1,...
                rm_these(length(rm_these)-rm+1)+1:end]);
            out_h = out_h([1:rm_these(length(rm_these)-rm+1)-1,...
                rm_these(length(rm_these)-rm+1)+1:end]);
            out_T = out_T([1:rm_these(length(rm_these)-rm+1)-1,...
                rm_these(length(rm_these)-rm+1)+1:end]);
        end
    end
    
elseif vol < krajni_vol
    out_s = [0,0];
    out_h = [0,0];
    out_T = [0,0];
end
end


