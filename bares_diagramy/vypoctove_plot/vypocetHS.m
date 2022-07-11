%[outH, outS]=vypocetHS(konst,iso,input)
%valid iso: isoterma, isobara, such, isochora
%
%also valid iso: isoterma_exp
%isoterma_exp is an experiment of isoterma with way fewer points. It is not
%so smooth.

function [outH, outS]=vypocetHS(konst,iso,input)

%todo kontroly vstupu ->až budu vědět co vlastně vstupuje

% test=[100];
% max=90;
% min=10;
% bodu=9;   #*2-1
% for i=[1,10,10,10,10,10]
%     max=max/i;
%     min=min/i;
%     test=[test,linspace(max,min,bodu)];
% end

% tlak=[100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,19,18,17,16,...
%     14,12,10,9,8,7,6,5,4,3,2,1.5,1,.8,.6,.4,.2,.08,.06,.04,.02,.01,...
%     .008,.006,0.004,0.002,0.001]*10;
tlak = [1000,950,900,850,800,750,700,650,600,550,500,450,400,350,...
    300,250,220.6346373627326,220,215,210,205,200,190,180,170,160,150,140,...
    130,120,110,100,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,...
    10,9,8.500,8,7.500,7,6.500,6,5.500,5,4.500,4,3.500,3.000,2.500,...
    2.000,1.500,1,0.9000,0.8500,0.8000,0.7500,0.7000,0.6500,0.6000,...
    0.5500,0.5000,0.4500,0.4000,0.3500,0.3000,0.2500,0.2000,0.1500,...
    0.1000,0.09000,0.08500,0.08000,0.07500,0.07000,0.06500,0.06000,...
    0.05500,0.05000,0.04500,0.04000,0.03500,0.03000,0.02500,0.02000,...
    0.01500,0.01];
%switch přepíná dle vstupu varianty výpočtu
switch iso
    case 'isoterma'
        %------------------------------------------------------------------
        %                               isoterma
        %------------------------------------------------------------------

        %entropie nasycene pary pri teplotě # je XSteam('sV_T',#)
        %použitá pro dělení isotermy pokud překračuje do oblasti mokré
        %páry. Vrací NaN pokud nepřekračuje
        stredPs = XSteam('sV_T',input);
        %psat = XSteam('psat_T',input);
        %Nastaví počet bodů na izotermách překračujících mez sytosti
        %v oblasti suche páry
        rozliseniSuch=200;
        if konst.bigplot==0 %1=yes, 0=no
            
            rozliseniMok=100;
            
            %porovnávám jestli je celá izoterma v oblasti suché páry.
            if ~isnan(stredPs) %jak napsat neni nan...
                
                %pokud není, je nutné ji rozdělit na části pod a nad
                
                %entalpie bodu na mezi suchosti
                %stredPh=XSteam('hV_T',input);
                %a příslušný tlak
                %stredP=XSteam('p_hs',stredPh,stredPs);
                stredP = XSteam('psat_T',input);
                %z toho spočítám rozdělení bodů
                
                %část isotermy v oblasti suché páry
                rangeUpper=linspace(stredP,konst.Pmin,rozliseniSuch);
                %část isotermy v oblasti mokré páry
                rangeLower=linspace(0,1,rozliseniMok);
                
                %body v oblasti mokré páry
                outTH1=paralist('h_Tx',input,rangeLower);
                outTS1=paralist('s_pH',stredP,outTH1);
                
                %body v oblasti suché páry
                outTH2=paralist('h_pT',rangeUpper,input);
                outTS2=paralist('s_pT',rangeUpper,input);
                
                %spojení úseků v jeden celek který je pak funkcí vrácen
                outH=[outTH1,outTH2];
                outS=[outTS1,outTS2];
            else
                %pokud je nan (pokud nepřekračuje do oblasti mokré páry)
                %tak ji nemusím dělit, stačí spočítat najednou
                outH = paralist ('h_pT',tlak,input);
                outS = paralist ('s_pT',tlak,input);
                outS=rmmissing(outS);
                outH=rmmissing(outH);
            end
        else
            if ~isnan(stredPs) %jak napsat neni nan...
                
                %pokud není, je nutné ji rozdělit na části pod a nad
                
                %entalpie bodu na mezi suchosti
                %stredPh=XSteam('hV_T',input);
                %a příslušný tlak
                %stredP=XSteam('p_hs',stredPh,stredPs);
                stredP = XSteam('psat_T',input);
                %z toho spočítám rozdělení bodů
                
                %část isotermy v oblasti suché páry
                rangeUpper=linspace(stredP,konst.Pmin,rozliseniSuch);
                
                %body v oblasti suché páry
                outH=paralist('h_pT',rangeUpper,input);
                outS=paralist('s_pT',rangeUpper,input);
                
            else
                %pokud je nan (pokud nepřekračuje do oblasti mokré páry)
                %tak ji nemusím dělit, stačí spočítat najednou
                outH = paralist ('h_pT',tlak,input);
                outS = paralist ('s_pT',tlak,input);
                outS=rmmissing(outS);
                outH=rmmissing(outH);
            end
        end
    case 'isoterma_exp'
        %------------------------------------------------------------------
        %                               isoterma_exp
        %------------------------------------------------------------------
        
        %Nastaví počet bodů na izotermách překračujících mez sytosti
        %v oblasti suche páry
        rozliseniSuch=50;
        rozliseniMok=100;
        
        %entropie nasycene pary pri teplotě # je XSteam('sV_T',#)
        %použitá pro dělení isotermy pokud překračuje do oblasti mokré
        %páry. Vrací NaN pokud nepřekračuje
        stredPs = XSteam('sV_T',input);
        
        %porovnávám jestli je celá izoterma v oblasti suché páry.
        if ~isnan(stredPs) %jak napsat neni nan...
            
            %pokud není, je nutné ji rozdělit na části pod a nad
            
            %entalpie bodu na mezi suchosti
            stredPh=XSteam('hV_T',input);
            %a příslušný tlak
            stredP=XSteam('p_hs',stredPh,stredPs);
            
            %z toho spočítám rozdělení bodů
            
            %část isotermy v oblasti suché páry
            %rangeUpper=linspace(stredP,konst.Pmin,rozliseniSuch);
            k=6;
            if (stredP/k) > konst.Pmin
                rangeUpper=linspace(stredP,stredP/k,20);
                if stredP/(k^2) > konst.Pmin
                    rangeUpper = [rangeUpper,linspace((stredP/k+stredP/(10*k)),stredP/(k^2),rozliseniSuch)];
                    if stredP/(k^3)>konst.Pmin
                        rangeUpper = [rangeUpper,linspace(stredP/k^3+stredP/(10*k^3),konst.Pmin,rozliseniSuch)];
                    else
                        rangeUpper = [rangeUpper,linspace(stredP/k^2+stredP/(10*k^2),konst.Pmin,rozliseniSuch)];
                    end
                else
                    rangeUpper = [rangeUpper,linspace((stredP/k+stredP/(10*k)),konst.Pmin,rozliseniSuch)];
                end
            else
                rangeUpper=linspace(stredP,konst.Pmin,50);
            end
            rangeUpper(1) = [];
            %část isotermy v oblasti mokré páry
            rangeLower=linspace(.6,1,rozliseniMok);
            
            %body v oblasti mokré páry
            outTH1=paralist('h_Tx',input,rangeLower);
            outTS1=paralist('s_pH',stredP,outTH1);
            
            %body v oblasti suché páry
            outTH2=paralist('h_pT',rangeUpper,input);
            outTS2=paralist('s_pT',rangeUpper,input);
            
            %spojení úseků v jeden celek který je pak funkcí vrácen
            outH=[outTH1,outTH2];
            outS=[outTS1,outTS2];
            outS=rmmissing(outS);
            outH=rmmissing(outH);
        else
            %pokud je nan (pokud nepřekračuje do oblasti mokré páry)
            %tak ji nemusím dělit, stačí spočítat najednou
            outH = paralist ('h_pT',tlak,input);
            outS = paralist ('s_pT',tlak,input);
            outS=rmmissing(outS);
            outH=rmmissing(outH);
        end
        
    case'isobara'
        %------------------------------------------------------------------
        %                               isobara
        %------------------------------------------------------------------
        
        %počet bodů na isobarách
        rozliseni=konst.rozliseni_isobary;
        
        SminP = XSteam('s_ph',input,1);
        %do h=4200 nefunguje, funguje "po isotermu 800 °C"
        SmaxP = XSteam('s_pT',input,800);
        %SmaxP = XSteam('s_ph',input,HmaxP);
        outS = linspace(SminP,SmaxP,rozliseni);
        outH = paralist('h_ps',input,outS);
        outS = rmmissing(outS);
        outH = rmmissing(outH);
    case 'such'
        %------------------------------------------------------------------
        %                               suchost
        %------------------------------------------------------------------
        %XSteam(h_px)
        outH = paralist('h_px',konst.tlak_vypocet_x,input);
        
        %
        rm_these = [];
        outS=zeros(1,length(outH));
        %i=0;
        for i=1:length(outH)
            outS(i) = XSteam('s_ph',konst.tlak_vypocet_x(i),outH(i));
            if isnan(outS(i))
                rm_these = [rm_these,i];
            end
        end
        %outS=transpose(outS);
        for i = 1:length(rm_these)
            rm = length(rm_these)-i+1;
            outS = outS(outS ~= rm_these(rm));
            outH = outH(outH ~= rm_these(rm));
        end
%         outS=rmmissing(outS);
%         outH=rmmissing(outH);
        %------------------------------------------------------------------
        %                               isochora
        %------------------------------------------------------------------
    case 'isochora'
        [outS,outH,~] = isochory_vypocet(input,'hs');
        
    otherwise
        error('neznam tento vstup')
end
%XSteam v některých případech vrací nan, nepodařilo se mi najít rozumný
%vzorec dle kterého to dělá, nemohu tedy ošetřit vstupní podmínky. Pro
%účely plot potřebuji odebrat nan hodnoty z listů

% outS=rmmissing(outS);
% outH=rmmissing(outH);




end