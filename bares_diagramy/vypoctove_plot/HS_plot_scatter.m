function HS_diagram=HS_plot_scatter(konst,barva,popisky,isobary,isotermy,...
    suchosti,isochory)
%HS_plot(konst,barva,popisky,isobary,isotermy,suchosti,isochory)
%HS_plot(konstHS,barvy,'y','y','y','y','y') nebo cokoli jiného pro
%"vypnuto"
%Vymaluje HS diagram vodní páry v rozmezí definovaném pomocí konst.

%tlak = tlakGen(konst.bodu);
%tlak=tlak*10;
HS_diagram = figure;


%x=1;
%suchH=paralist ('h_px',tlak,x);
%suchS=paralist ('sV_p',tlak);
%fig = figure;
Y=42;
X=29.7;
xMargin = .5;
yMargin = .5;
xSize=X-2*xMargin;
ySize=Y-2*yMargin;

set(HS_diagram, 'Units','centimeters', 'Position',...
    [0 0 X Y]/2);
set(HS_diagram, 'PaperUnits','centimeters')
set(HS_diagram, 'PaperSize',[X Y])
set(HS_diagram, 'PaperPosition',[xMargin yMargin xSize ySize])
set(HS_diagram, 'PaperOrientation','portrait')
hold on
%osy s od 5 po 9,5 a h od 1700 po 4200
axis([konst.smin konst.smax konst.hmin konst.hmax])
%rozlišení os
%_ticks(min:krok:max)
xticks(konst.smin:.5:konst.smax);
yticks(konst.hmin:100:konst.hmax);
%názvy os
xlabel('Entropie s (kJ kg-1 K-1)');
ylabel('Entalpie h (kJ kg-1)');
%mřížka
grid on
grid minor
%hranice suchosti x=1
%plot(suchS,suchH,'Color',barva.hs_such_H)

%--------------------------------------------------------------------------
%          suchosti
%--------------------------------------------------------------------------
if suchosti == 'y'
    for i = linspace(.6,1,41)
        [malujH,malujS] = vypocetHS(konst,'such',i);
        plot(malujS,malujH,'Color',barva.hs_such_H,'linestyle','none','marker','.')
    end
    clear max;
    clear min;
end

%--------------------------------------------------------------------------
%       isobary
%--------------------------------------------------------------------------
if isobary == 'y'
    %isobary ktere chci vymalovat "major"
    isobaryM = [100,10,1,.1,.01,.001]*10;
    
    %isobary ktere chci vymalovat "minor"
    isobary_p = [100,80,60,50,40,30,20,15,10,8,6,4,3,2,1.5,1,...
        .8,.6,.4,.3,.2,.15,.1,.08,.06,.04,.03,.02,.015,.01,.008,...
        .006,.004,.003,.002,0.001]*10;
    %isobary = isobary*10;
    
    %a jejich vymalovani "minor"
    for i = isobary_p
        [malujH,malujS] = vypocetHS(konst,'isobara',i);
        plot(malujS,malujH,'Color',barva.hs_p_H,'linestyle','none','marker','.')
    end
    
    % vymalovani "major"
    for i = isobaryM
        [malujH,malujS] = vypocetHS(konst,'isobara',i);
        plot(malujS,malujH,'Color',barva.hs_p_H,'linestyle','none','marker','.')
    end
end

%--------------------------------------------------------------------------
%       isotermy
%--------------------------------------------------------------------------
if isotermy == 'y'
    %minor
    for i = linspace(10,800,80)
        [malujH,malujS] = vypocetHS(konst,'isoterma',i);
        plot(malujS,malujH,'Color',barva.hs_T_H,'linestyle','none','marker','.')
    end
    
    %major
    for i=[10,50,100,150,200,250,300,350,400,450,500,550,600,650,700,...
            750,800]
        [malujH,malujS] = vypocetHS(konst,'isoterma',i);
        plot(malujS,malujH,'Color',barva.hs_T_H,'linestyle','none','marker','.');
%         %labels
%         text(9,malujH(length(malujH))+20,num2str(i)+" °C",...
%             'Color',barva.hs_T_H);
%         %text2line(p,.9,-10,num2str(i),barva.hs_T_H)
%         %plot(malujS,malujH,'r')
    end
end

%--------------------------------------------------------------------------
%       isochory
%--------------------------------------------------------------------------
if isochory == 'y'
    for vol=[100,50,20,10,5,2,1,.5,.2,.1,.05,.02,.01,.005]
    %vol = 20;
        [malujS,malujH] = vypocetHS(konst,'isochora',vol);
        
        plot(malujH,malujS,'Color',barva.hs_v,'linestyle','none','marker','.');
    end
end


if popisky == 'y'
    if suchosti =='y'
        p = HS_such_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_such_V,...
                'rotation',p.r(i));
        end  
    end
    if isochory =='y'
        p = HS_isochory_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_v,...
                'rotation',p.r(i));
        end  
    end
    if isobary =='y'
        p = HS_isobary_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_p_H,...
                'rotation',p.r(i));
        end  
    end
    if isobary =='y'
        p = HS_isotermy_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_T_H,...
                'rotation',p.r(i));
        end  
    end
end

%HS_diagram=fig;


HS_diagram.Position(3:4) = [xSize/1.8 ySize/1.8];
end



