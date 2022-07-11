function [outT, outS]=vypocetTS(konstTS,iso,input)
%cases isobara p,isoh h,such x,isochora V
%
%to do, T = konst,s = konst

switch iso
    case 'isobara'
        %potrebuji vyndat pripad kdy isobara prochazi oblasti mokre pary
        %k tomu vyuziji fakt o maximu teploty na mezi suchosti 374°C
        %XSteam('psat_T',373.94599)
        %tim dostanu tlak pod kterym potrebuji resit specialni pripady
        %p = 220.6400 bar
        if input >= 220.640
            %nad
            outT = [linspace(0,350,konstTS.rozliseni_isobary/2),...
                linspace(350.1,400,konstTS.rozliseni_isobary/2),...
                linspace(400.1,700,konstTS.rozliseni_isobary/2)];
            outS = paralist('s_pT',input,outT);
        else
            %pod
            Tmez = XSteam('Tsat_p',input);
            Smez_x0 = XSteam('sL_T',Tmez);
            Smez = XSteam('sV_T',Tmez);
            
            %plot pro nizka s, 100 bodu
            outS1 = linspace(Smez_x0,Smez,100);
            outS1(1) = [];
            outS1 = [linspace(0,Smez_x0,50),outS1];
            outT1 = paralist('T_ps',input,outS1);
            
            %xsteam vrací nan v těsném okolí, okolí je větší pro nižší
            %tlaky, chci to co nejhezčí takže to dělím na dva případy
            
            %plot pro vyssi s, 200 bodu
            if input<.03
                outT2 = linspace(Tmez+1,700,200);
            else
                outT2 = linspace(Tmez+.1,700,200);
            end
            outS2 = paralist('s_pT',input,outT2);
            outT = [outT1,outT2];
            outS = [outS1,outS2];
            
%             outT = [outT2];
%             outS = [outS2];
        end
%         else
%             Tmez = XSteam('psat_T',input);
%             outT = [linspace(0,Tmez,50),Tmez+.01,...
%                 linspace(Tmez+.02,700,200)];
%             outS = paralist('s_pT',input,outT);
%         end
    case 'isoh'
        if input > 3700
            smin = XSteam('s_ph',konstTS.tlak(1),3700)+.001;
        else
            smin = XSteam('s_ph',konstTS.tlak(1),input)+.001;
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
            
            outT2 = linspace(outT1(end),0,250);
            tlak = paralist('psat_T',outT2);
            outS2 = paralist('s_ph',tlak,input);
            
            outT = [outT1,outT2];
            outS = [outS1,outS2];
            
        else
            
            %smin = XSteam('s_ph',80*10,input);
            smax = XSteam('s_ph',.00611658,input);
            outS = linspace(smin,smax,konstTS.rozliseni_isoh);

            %outS = linspace(smin,konstTS.smax,konstTS.rozliseni_isoh);
            outT = paralist('T_hs',input,outS);
        end
        
            
    case 'such'
        %htx
        %psat_T vrátí tlak při T, v TS diagramu v oblasti mokré páry isobary a
        %istoermy splývají. Takže vím, že v oblasti mokré páry je tlak nezávislý na
        %entropii. Pak můžu použít převodní můstek mezi "T" a "s" skrze "p"
        %
        %x=konst
        %list T -> list p (sat)
        %jedna T,x -> jedna h
        %list p,h -> list s
        
        %maximalni teplota pro kterou to ma cenu pocitat je tesne pod 374°C
        %373.945°C
        %outT = linspace(0,373.94,konstTS.rozliseni_such);
        outT = [linspace(0.01,370,konstTS.rozliseni_such),linspace(370.1,373.944,50)];
        %outT = linspace(340.1,373.944,100);
        helperP = paralist('psat_T',outT);
        helperH = paralist('h_Tx',outT,input);
        
        outS=zeros(1,length(helperP));
        for i = (1:1:length(helperP))
            outS(i)=XSteam('s_ph',helperP(i),helperH(i));
        end
        %------------------------------------------------------------------
        %                               isochora
        %------------------------------------------------------------------
    case 'isochora'
        [outS,~,outT] = isochory_vypocet(input);       
    otherwise
        error('neznam tento vstup')
end

% outS=rmmissing(outS);
% outT=rmmissing(outT);

end