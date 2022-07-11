function [outH_hs,outS_hs,outT_ts,outS_ts]=isoentalpicky_fce(konstTS,h1,s1,s2,t2)
%[outH_hs,outS_hs,outT_ts,outS_ts]=isoentalpicky_fce(konstTS,h1,s1,s2)

bodu = 50;

%seradit
if s2>s1
    hold = s1;
    s1=s2;
    s2=hold;
end
%h-s
%outH_hs = [h1,h1];
%outS_hs = [s1,s2];

%ts
outT_ts = [];
outS_ts = [];
input = h1;

if input > 3700
    smin = XSteam('s_ph',konstTS.tlak(1),3700)+.001;
else
    smin = XSteam('s_ph',konstTS.tlak(1),input)+.001;
end

if smin <= s2
    smin=s2;
end

if (1000<=input)&&(input<=1400)
    %v tomto rozmezi tento krasny jednoduchy XSteam vraci poněkud
    %hranaté hodnoty. Je potřeba to řešit jinak! Třeba přepočtem
    %"na druhou stranu"
    %s_ph
    %sice by šlo odhadnout a napočítat si tlaky ale zatím to mám
    %přepočtem z teploty, cílem je mít počet bodů jako parametr,
    %takže je otázka jestli to vůbec počítat předem.
    %psat_T
    
    %oriznuti na hodnotu maximalniho tlaku, dela hezky graf
    %T_ph
    
    %outS1 = linspace(smin,3.2,100);
    outS1 = (smin:.01:smin+.4);
    outT1 = paralist('T_hs',input,outS1);
    
    outT2 = linspace(outT1(end),t2,bodu);
    tlak = paralist('psat_T',outT2);
    outS2 = paralist('s_ph',tlak,input);
    
    outT_ts = [outT1,outT2];
    outS_ts = [outS1,outS2];
else
    
    %smin = XSteam('s_ph',80*10,input);
    smax = XSteam('s_ph',.00611658,input);
    if smax >= s1
        smax = s1;
    end
    outS_ts = linspace(smin,smax,bodu);
    
    %outS = linspace(smin,konstTS.smax,konstTS.rozliseni_isoh);
    outT_ts = paralist('T_hs',input,outS_ts);
end
outS_hs = outS_ts;
outH_hs = input * ones(1,length(outS_ts));
end