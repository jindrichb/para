function [outH_hs,outS_hs,outT_ts,outS_ts]=isobaricky_fce(p,s1,h,s2,h2,varargin)
% [outH_hs,outS_hs,outT_ts,outS_ts]=isobaricky_fce(p,s,h,s2,h2)
input=p;
if nargin == 5
    bodu = 30;
elseif nargin == 6
    bodu = varargin{1};
end
%---------------

%serazeni tak aby body s indexy 1 vzdy byli "vetsi"
if h>h2
    %h1=h;
    s1=s1;
elseif h<h2
    %h1=h2;
    %h2=h;
    s1_ = s1;
    s1 = s2;
    s2 = s1_;
elseif h==h2
    error("body splyvaji")
end


%rozlustim pripad zadani t,v,s,x,h,u a dpoctu (naleznu) druhy bod
%mam nalezene dva body - B1 a B2 ze zadanych hodnot
%kopiruj isobaru s omezenim mezi body - 2 pripady hs,ts (s pv 3)

%--------------------------
%hs
%fig = openfig('figs\hs_mez.fig','visible');

%SminP = XSteam('s_ph',input,h1);
%do h=4200 nefunguje, funguje "po isotermu 800 °C"
%SmaxP = XSteam('s_ph',input,h2);
%SmaxP = XSteam('s_ph',input,HmaxP);
outS = linspace(s1,s2,bodu);
outH = paralist('h_ps',input,outS);

rmthese = [];
for i = 1:length(outH)
    if isnan(outH)
        rmthese = [rmthese,i];
    end
end
if rmthese
    for i = 1:length(rmthese)
        indx = length(rmthese) - i;
        outH = outH(outH ~= indx);
        outS = outS(outS ~= indx);
    end
end
    
% outS_hs=rmmissing(outS);
% outH_hs=rmmissing(outH);
%plot(outS,outH)
outS_hs = outS;
outH_hs = outH;
%---------------------
%ts
%fig = openfig('figs\ts_mez.fig','visible');

%potrebuji vyndat pripad kdy isobara prochazi oblasti mokre pary
%k tomu vyuziji fakt o maximu teploty na mezi suchosti 374°C
%XSteam('psat_T',373.94599)
%tim dostanu tlak pod kterym potrebuji resit specialni pripady
%p = 220.6400 bar
if input >= 220.640
    %nad
    outS = linspace(s1,s2,bodu);
    outT = paralist('t_ps',input,outS);
    %outT = linspace(t1,t2,bodu);
    %outS = paralist('s_pT',input,outT);
else
    %pod
    Tmez = XSteam('Tsat_p',input);
    Smez_x0 = XSteam('sL_T',Tmez);
    Smez = XSteam('sV_T',Tmez);
    
    %poovnej polohu bodu pomoci s
    if s2>Smez
        %oba jsou vysoko
        outS = linspace(s1,s2,bodu);
        outT = paralist('t_ps',input,outS);
    elseif s1<Smez_x0
        %ten vetsi je nizko => oba jsou nizko
        outS = linspace(s1,s2,bodu);
        outT = paralist('t_ps',input,outS);
    elseif (s1<Smez && s2>Smez_x0)
        %je v oblasti mokre pary
        outS = linspace(s1,s2,bodu);
        outT = Tmez*ones(1,bodu);
    elseif (s1>Smez && (Smez_x0<s2 && s2<Smez))
        %je tam prechod z mokre pary do suche smerem nahoru
        ska = linspace(s1,Smez,bodu);
        tcka = paralist('t_ps',input,ska);
        outS = [ska,Smez,s2];
        outT = [tcka,Tmez,Tmez];
    elseif ( (Smez>s1 && s1>Smez_x0) && Smez_x0>s2)
        ska = linspace(s2,Smez_x0,bodu);
        tcka = paralist('t_ps',input,ska);
        outS = [ska,Smez_x0,s1];
        outT = [tcka,Tmez,Tmez];
    elseif(s1>Smez && (Smez_x0>s2))
        ska = [linspace(s2,Smez_x0,bodu),linspace(Smez,s1,bodu)];
        tcka = paralist('t_ps',input,ska);
        outS = ska;
        outT = tcka;
    else
        error("neznamy stav")
    end
end

outS_ts=outS;
outT_ts=outT;
%plot(outS,outT)




end