function HS_diagram=HS_plot(konst,barva,popisky,isobary,isotermy,...
    suchosti,isochory)
%HS_plot(konst,barva,popisky,isobary,isotermy,suchosti,isochory)
%HS_plot(konstHS,barvy,'y','y','y','y','y') nebo cokoli jiného pro
%"vypnuto"
%Vymaluje HS diagram vodní páry v rozmezí definovaném pomocí konst.

%tlak = tlakGen(konst.bodu);
%tlak=tlak*10;
HS_diagram = figure;
set(gcf,'renderer','painters')
set(HS_diagram,'visible','off');
ax = axes;
% ax.Box = 'On';
ax.Layer = 'Top';
grid off
%AX.Box = 'On';
%AX.Layer = 'Top';
% AX_ = struct(ax);
% AX_.XGridHandle.FrontMajorEdge.Layer = 'back';
% AX_.YGridHandle.FrontMajorEdge.Layer = 'back';
% AX_.XGridHandle.FrontMinorEdge.Layer = 'back';
% AX_.YGridHandle.FrontMinorEdge.Layer = 'back';
% alpha = .5;
% ax.GridAlpha = alpha-.2;
% ax.MinorGridAlpha = alpha;
%x=1;
%suchH=paralist ('h_px',tlak,x);
%suchS=paralist ('sV_p',tlak);
%fig = figure;
Y=42;
X=29.7;
xMargin = -2.4;
yMargin = -2.6;
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
xlabel('Entropie {\bfs} (kJ\cdotkg^{-1}\cdotK^{-1})');
ylabel('Entalpie {\bfh} (kJ\cdotkg^{-1})');
%hranice suchosti x=1
%plot(suchS,suchH,'Color',barva.hs_such_H)

% grid on
xgridMajor = 5:0.5:9.5; 
ygridMajor = 1700:100:4200; 
xgridMinor = 5:0.1:9.5; 
ygridMinor = 1700:20:4200; 
%....
x1 = arrayfun(@(x)line([x,x],[1700,4200]),xgridMinor);
y1 = arrayfun(@(x)line([5,9.5],[x,x]),ygridMinor);
y2 = arrayfun(@(x)line([5,9.5],[x,x]),ygridMajor);
x2 = arrayfun(@(x)line([x,x],[1700,4200]),xgridMajor);
% set grid color and alpha
qm=.9150;
qM=.9550;
lw = .5;
set(x2, 'LineWidth', lw,'color',[qm qm qm])
set(y2, 'LineWidth', lw,'color',[qm qm qm])
set(x1, 'LineWidth', lw,'color',[qM qM qM])
set(y1, 'LineWidth', lw,'color',[qM qM qM])


% plot grid lines with red lines and a width of 2
% x1 = arrayfun(@(x)xline(x,'-','LineWidth',1),xgridMinor);
% y1 = arrayfun(@(y)yline(y,'-','LineWidth',1),ygridMinor);
% x2 = arrayfun(@(x)xline(x,'-','LineWidth',1),xgridMajor);
% y2 = arrayfun(@(y)yline(y,'-','LineWidth',1),ygridMajor);
% % set grid color and alpha
% q=.8020;
% set(x1, 'LineWidth', 1, 'Alpha', 1,'color',[q q q])
% set(y1, 'LineWidth', 1, 'Alpha', 1,'color',[q q q])
% set(x2, 'LineWidth', 1, 'Alpha', 1,'color',[q q q])
% set(y2, 'LineWidth', 1, 'Alpha', 1,'color',[q q q])

%--------------------------------------------------------------------------
%          suchosti
%--------------------------------------------------------------------------
if suchosti == 'y'
    %all
    for i = linspace(.6,1,41)
        [malujH,malujS] = vypocetHS(konst,'such',i);
        plot(malujS,malujH,'Color',barva.hs_such_H,'Linewidth',...
            barva.tloustka_V)
    end
    %major
    %for i = [.6,.65,.7,.75,.8,.85,.9,.95,1]
    for i = [.6,.65,.7,.75,.8,.85,.9,.95]
        [malujH,malujS] = vypocetHS(konst,'such',i);
        plot(malujS,malujH,'Color',barva.hs_such_H,'Linewidth',...
            barva.tloustka_H)
    end
end
%--------------------------------------------------------------------------
%       isochory
%--------------------------------------------------------------------------
if isochory == 'y'
    for vol=[100,80,60,40,30,20,15,[100,80,60,40,30,20,15]/10,...
            [100,80,60,40,30,20,15]/100,[100,80,60,40,30,20,15]/1000,...
            [100,80,60,50]/10000]
        %vol = 20;
        [malujS,malujH] = vypocetHS(konst,'isochora',vol);
        
        plot(malujH,malujS,'Color',barva.hs_v,'Linewidth',...
            barva.tloustka_V);
        
    end
    for vol=[100,10,1,.1,.01]
        %vol = 20;
        [malujS,malujH] = vypocetHS(konst,'isochora',vol);
        
        plot(malujH,malujS,'Color',barva.hs_v,'Linewidth',...
            barva.tloustka_H);
    end
end

%--------------------------------------------------------------------------
%       isotermy
%--------------------------------------------------------------------------
if isotermy == 'y'
    %minor
    for i = linspace(10,800,80)
        [malujH,malujS] = vypocetHS(konst,'isoterma',i);
%         plot(malujS,malujH,'Color',barva.hs_T_H,'Linewidth',...
%             barva.tloustka_V)
        plot(malujS,malujH,'Color',barva.hs_T_V,'Linewidth',barva.tloustka_V)
    end
    
    %major
    for i=[10,50,100,150,200,250,300,350,400,450,500,550,600,650,700,...
            750,800]
        [malujH,malujS] = vypocetHS(konst,'isoterma',i);
%         plot(malujS,malujH,'Color',barva.hs_T_H,'Linewidth',...
%             barva.tloustka_H);
        plot(malujS,malujH,'Color',barva.hs_T_H,'Linewidth',barva.tloustka_H)
%         %labels
%         text(9,malujH(length(malujH))+20,num2str(i)+" °C",...
%             'Color',barva.hs_T_H);
%         %text2line(p,.9,-10,num2str(i),barva.hs_T_H)
%         %plot(malujS,malujH,'r')
    end
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
        plot(malujS,malujH,'Color',barva.hs_p_H,'Linewidth',...
            barva.tloustka_V)
    end
    
    % vymalovani "major"
    for i = isobaryM
        [malujH,malujS] = vypocetHS(konst,'isobara',i);
        plot(malujS,malujH,'Color',barva.hs_p_H,'Linewidth',...
            barva.tloustka_H)
    end
end



%--------------------------------------------------------------------------
%      popisky
%--------------------------------------------------------------------------
if popisky == 'y'
    if suchosti =='y'
        p = HS_such_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_such_H,...
                'rotation',p.r(i),'FontWeight','bold');
        end  
    end
    if isochory =='y'
        p = HS_isochory_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_v,...
                'rotation',p.r(i),'FontWeight','bold');
        end  
    end
    if isobary =='y'
        p = HS_isobary_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_p_H,...
                'rotation',p.r(i),'FontWeight','bold');
        end  
    end
    if isotermy =='y'
        p = HS_isotermy_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.h(i),p.a(i),'Color',barva.hs_T_H,...
                'rotation',p.r(i),'FontWeight','bold');
        end  
    end
end
for i = 1
    [malujH,malujS] = vypocetHS(konst,'such',i);
    plot(malujS,malujH,'Color',barva.hs_such_H,'Linewidth',...
        barva.tloustka_H)
end
%HS_diagram=fig;
%mřížka
% grid on
% grid minor
% ax=gca;
% ax.MinorGridLineStyle = '-';
% q=.8020;
% ax.MinorGridColor = [q,q,q];

%HS_diagram.Position(3:4) = [xSize/1.8 ySize/1.8];

%dim = [.62 .05 .2 .2];
dim = [.59 .035 .3 .3];
% str = {'\fontsize{14}h-s\fontsize{6} diagram vody a vodní páry',...
%     'podle průmyslové formulace IAPWS-IF97',...
%     'vykresleno s použitím XSteam 2.6',...
%     'Fakulta elektrotechnická',...
%     'ČVUT v Praze'};
% annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor',[1 1 1],'FaceAlpha',1);
axes('pos',dim)
imshow('textbox_huge.png')

% uistack(x1,'bottom')
% uistack(y1,'bottom')
% uistack(x2,'bottom')
% uistack(y2,'bottom')
end



