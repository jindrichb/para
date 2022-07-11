function [outH_hs,outS_hs,outT_ts,outS_ts]=isotermicky_fce(s1,t1,p1,x1,s2,p2,x2)
%[outH_hs,outS_hs,outT_ts,outS_ts]=isotermicky_fce(h1,t1,h2)
bodu=50;
%h1=2880;
%h2=2200;
%t1=202;
input=t1;
%--------------
%diagram = 2;
%1=hs
%2=ts

%--------------
%[t,p,v,s,x,h,u]=dopocetNeznamych(h1,t1,4);
%---------------
%[t2,p2,v2,s2,x2,h2,u2]=dopocetNeznamych(h2,t1,4);

%serazeni tak aby body s indexy 1 vzdy byli "vetsi"
%[t1,p1,~,s1,~,~,~,~,p2,~,s2,x2,~,~]=...
%    serad_body_deje(t,p,v,s,x,h,u,t2,p2,v2,s2,x2,h2,u2);
if s2>s1
    s=s1;
    s1=s2;
    s2=s;
    p=p1;
    p1=p2;
    p2=p;
elseif s1>s2
    %nothing, they are sorted already
elseif s1==s2
    warning("body s plivaji")
    [outH_hs,outS_hs,outT_ts,outS_ts]=deal(0,0,0,0);
    return
end

%rozlustim pripad zadani t,v,s,x,h,u a dpoctu (naleznu) druhy bod
%mam nalezene dva body - B1 a B2 ze zadanych hodnot
%kopiruj isobaru s omezenim mezi body - 2 pripady hs,ts (s pv 3)

%--------------------------
%hs
%if diagram ==1
    %fig = openfig('figs\hs_mez.fig','visible');
    %hold on
    %----------------
    stredPs = XSteam('sV_T',input);
    rozliseniSuch=round((bodu+bodu)/3);
    rozliseniMok=round((bodu)/3);
    stredVs = XSteam('sL_T',input);
    %porovnávám jestli je celá izoterma v oblasti suché páry.
    if ~isnan(stredPs) %jak napsat neni nan...
        if s1>stredPs && s2<stredPs
            %pokud není, je nutné ji rozdělit na části pod a nad
            
            %entalpie bodu na mezi suchosti
            %stredPh=XSteam('hV_T',input);
            %a příslušný tlak
            %stredP=XSteam('p_hs',stredPh,stredPs);
            stredP = XSteam('psat_T',input);
            %z toho spočítám rozdělení bodů
            
            %část isotermy v oblasti suché páry
            rangeUpper=linspace(stredP,p1,rozliseniSuch);
            %část isotermy v oblasti mokré páry
            if x1 > x2 %ujisti ktery bod je v oblasti mokre pary
                x=x2;
            else
                x=x1;
            end
            rangeLower=linspace(x,1,rozliseniMok);
            
            %body v oblasti mokré páry
            outTH1=paralist('h_Tx',input,rangeLower);
            outTS1=paralist('s_pH',stredP,outTH1);
            
            %body v oblasti suché páry
            outTH2=paralist('h_pT',rangeUpper,input);
            outTS2=paralist('s_pT',rangeUpper,input);
            
            %spojení úseků v jeden celek který je pak funkcí vrácen
            outH=[outTH1,outTH2];
            outS=[outTS1,outTS2];
        elseif s1<stredPs && s2>stredVs
            outS = linspace(s1,s2,bodu);
            %h1 = XSteam('h_ps',p1,s1);
            %h2 = XSteam('h_ps',p2,s2);
            plist = exp(linspace(log(p1),log(p2),bodu));
            outH = zeros(1,bodu);
            for i = 1:bodu
                p = plist(i);
                s = outS(i);
                outH(i) = XSteam('h_ps',p,s);
            end
            % outH = paralist('h_ps',p2,s2);
        elseif s2<stredVs && s1>stredVs && s1<stredPs
            %s2 je velmi dole
            %s1 je v mokru
            tlak = linspace(p2,p1,bodu);
            hlower =paralist ('h_pT',tlak,input); 
            outH = [hlower,XSteam('h_ps',p1,s1)];
            slower = paralist ('s_pT',tlak,input);
            outS = [slower,s1];
            
%         elseif s2<stredVs && s1>stredPs
%             %s2 je velmi dole
%             %s1 je velmi nahore
%             psat=XSteam('psat_T',input);
%             tlak=[lispace(p2,psat,bodu),linspace(psat,p1,bodu)];
%             outH = paralist ('h_pT',tlak,input);
%             outS = paralist ('s_pT',tlak,input);
        else
            tlak = linspace(p2,p1,bodu);
            outH = paralist ('h_pT',tlak,input);
            outS = paralist ('s_pT',tlak,input);
            %outS=rmmissing(outS);
            %outH=rmmissing(outH);
        end
    else
        %pokud je nan (pokud nepřekračuje do oblasti mokré páry)
        %tak ji nemusím dělit, stačí spočítat najednou
        tlak = linspace(p2,p1,bodu);
        outH = paralist ('h_pT',tlak,input);
        outS = paralist ('s_pT',tlak,input);
    end
    %---------------- 
    outS_hs=rmmissing(outS);
    outH_hs=rmmissing(outH);
    %plot(outS,outH)
%end
%---------------------
%ts
%if diagram ==2
    %fig = openfig('figs\ts_mez.fig','visible');
    hold on
    %----------------
    outS=linspace(s1,s2,bodu);
    outT=linspace(t1,t1,bodu);
    %----------------    
    outT_ts=outT;
    outS_ts=outS;
    %plot(outS,outT)
%end




end