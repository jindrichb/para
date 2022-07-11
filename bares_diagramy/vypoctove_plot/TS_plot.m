function TS_diagram=TS_plot(konst,barva,isobary,isoh,such,isochory)
%function TS_diagram=TS_plot(konst,barva,isobary,isoh,such,isochory)
%
%
%
%vymaluje HS diagram vodní páry v rozmezí definovaném pomocí konst. Dále
%jsou možnosti zapnout nebo vypnout "grid iso linií"

% %barva vedlejších křivek
% barvaV=[.7 .7 .7];
% %barva hlavních křivek
% barvaH=[.35 .35 .35];

TS_diagram = figure;
set(gcf,'renderer','painters')
set(TS_diagram,'visible','off');
ax = axes;
% ax.Box = 'On';
ax.Layer = 'Top';
% ax.XGridHandle.FrontMajorEdge.Layer = 'back';
% ax.YGridHandle.FrontMajorEdge.Layer = 'back';
% ax.XGridHandle.FrontMinorEdge.Layer = 'back';
% ax.YGridHandle.FrontMinorEdge.Layer = 'back';
%fig = figure;
Y=42;
X=29.7;
xMargin = -2;
yMargin = -2.2;
xSize=X-2*xMargin;
ySize=Y-2*yMargin;

set(TS_diagram, 'Units','centimeters', 'Position',...
    [0 0 X Y]/2);
set(TS_diagram, 'PaperUnits','centimeters')
set(TS_diagram, 'PaperSize',[X Y])
set(TS_diagram, 'PaperPosition',[xMargin yMargin xSize ySize])
set(TS_diagram, 'PaperOrientation','portrait')
hold on

hold on
%osy s od 5 po 9,5 a h od 1700 po 4200
axis([konst.smin, konst.smax, konst.Tmin, konst.Tmax])
%rozlišení os
%_ticks(min:krok:max)
xticks(konst.smin:1:konst.smax);
yticks(konst.Tmin:50:konst.Tmax);
%názvy os
xlabel('Entropie {\bfs} (kJ\cdotkg^{-1}\cdotK^{-1})');
ylabel('Teplota {\bft} (°C)');
%mřížka
% grid on
xgridMajor = 0:1:10; 
ygridMajor = 0:50:700; 
xgridMinor = 0:0.2:10; 
ygridMinor = 0:10:700; 
%....
x1 = arrayfun(@(x)line([x,x],[0,700]),xgridMinor);
y1 = arrayfun(@(x)line([0,10],[x,x]),ygridMinor);
y2 = arrayfun(@(x)line([0,10],[x,x]),ygridMajor);
x2 = arrayfun(@(x)line([x,x],[0,700]),xgridMajor);
% set grid color and alpha
qm=.9150;
qM=.9550;
lw = .5;
set(x2, 'LineWidth', lw,'color',[qm qm qm])
set(y2, 'LineWidth', lw,'color',[qm qm qm])
set(x1, 'LineWidth', lw,'color',[qM qM qM])
set(y1, 'LineWidth', lw,'color',[qM qM qM])

% grid on
% grid minor
% ax=gca;
% ax.MinorGridLineStyle = '-';
% q=.8020;
% ax.MinorGridColor = [q,q,q];
% % dim = [.17 .6 .2 .2];
% str = {'\fontsize{14}T-s\fontsize{6} diagram vody a vodní páry',...
%     'podle průmyslové formulace IAPWS-IF97',...
%     'vykresleno s použitím XSteam 2.6',...
%     'Fakulta elektrotechnická',...
%     'ČVUT v Praze'};
% annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor',[1 1 1],'FaceAlpha',1);
% %text(1,590,'T-s','FontSize',24,'FontWeight','Bold')

%--------------------------------------------------------------------------
%       isochory
%--------------------------------------------------------------------------
if isochory == 'y'
    for vol=[100,50,20,10,5,2,1,.5,.2,.1,.05,.02,.01,.005]
    %vol = 20;
        [malujT,malujS] = vypocetTS(konst,'isochora',vol);
        
        plot(malujS,malujT,'Color',barva.hs_v,'Linewidth',...
            barva.tloustka_V);
    end
    for vol=[100,10,1,.1,.01]
    %vol = 20;
        [malujT,malujS] = vypocetTS(konst,'isochora',vol);
        
        plot(malujS,malujT,'Color',barva.hs_v,'Linewidth',...
            barva.tloustka_H);
    end
end

%--------------------------------------------------------------------------
%          isobary
%--------------------------------------------------------------------------
if isobary =='y'
    tlak = [.002,.003,.004,.006,.008,.015,.02,.03,.04,...
        .06,.08,.15,.2,.3,.4,.6,.8,1.5,2,3,4,6,8,15,...
        20,25,30,40,50,60,80]*10;
    for i = tlak %konst.tlak
        [malujT,malujS] = vypocetTS(konst,'isobara',i);
        plot(malujS,malujT,'color',barva.ts_p_V);
    end
    for i = [0.001,0.01,0.1,1,10,100]*10
        [malujT,malujS] = vypocetTS(konst,'isobara',i);
        plot(malujS,malujT,'color',barva.ts_p_H,'Linewidth',...
            barva.tloustka_H);
    end
end

%--------------------------------------------------------------------------
%          isoh
%--------------------------------------------------------------------------
if isoh =='y'
    for h=[200:200:2400,2500:50:4000]
    %for h=[3700,3750,3800]
        %1000-1400 je to rozbite viz vypocetTS case isoh
        %for h = (1000:10:1400)
        [malujT,malujS]=vypocetTS(konst,'isoh',h);
        plot(malujS,malujT,'color',barva.h);
    end
end
%--------------------------------------------------------------------------
%          suchost
%--------------------------------------------------------------------------
if such =='y'
    
    
    %mozna optimalizace predelanim T respektive P listu na konstanty
    for x = [.1,.2,.3,.4,.5,.6,.7,.8,.9]
        [malujT,malujS]=vypocetTS(konst,'such',x);
        plot(malujS,malujT,'color',barva.ts_such_V);
    end
    for x = [0,1]
        [malujT,malujS]=vypocetTS(konst,'such',x);
        plot(malujS,malujT,'color',barva.ts_such_H);
    end
end

%--------------------------------------------------------------------------
%       popisky
%--------------------------------------------------------------------------
popisky = 'n';

if popisky == 'y'
    if isobary == 'y'
        p = TS_isobary_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.t(i),p.a(i),'Color',barva.ts_p_H,...
                'rotation',p.r(i),'FontWeight','bold');
        end
    end
    if isoh == 'y'
        p = TS_isoh_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.t(i),p.a(i),'Color',barva.ts_h,...
                'rotation',p.r(i),'FontWeight','bold');  
        end
    end
    if such == 'y'
        p = TS_such_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.t(i),p.a(i),'Color',barva.ts_such_V,...
                'rotation',p.r(i),'FontWeight','bold');
        end        
    end
    if isochory == 'y'
        p = TS_isochory_popisky;
        for i =(1:length(p.a))
            text(p.s(i),p.t(i),p.a(i),'Color',barva.hs_v,...
                'rotation',p.r(i),'FontWeight','bold');
        end
    end
end

%dim = [.62 .05 .2 .2];
dim = [.15 .697 .3 .3];
% str = {'\fontsize{14}h-s\fontsize{6} diagram vody a vodní páry',...
%     'podle průmyslové formulace IAPWS-IF97',...
%     'vykresleno s použitím XSteam 2.6',...
%     'Fakulta elektrotechnická',...
%     'ČVUT v Praze'};
% annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor',[1 1 1],'FaceAlpha',1);
axes('pos',dim)
imshow('textbox_ts_huge.png')

%TS_diagram.Position(3:4) = [xSize/1.8 ySize/1.8];

end




