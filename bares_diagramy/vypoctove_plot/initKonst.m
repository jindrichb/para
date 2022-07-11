function [konstHS,konstTS,barva]=initKonst()
%[konstHS,konstTS,barva]=initKonst()
%
%Funkce inicializuje konstanty použité protvorbu diagramů
%konstHS obsahuje konstanty použité v h-s diagramu
%konstTS obsahuje konstanty použité v t-s diagramu
%barva obsahuje konstanty typu barvy a tloušťka iso-čar

%--------------------------------------------------------------------------
%           konstHS
%--------------------------------------------------------------------------
%struct konstant predavany jako parametr funkci
%bigplot = 1 pro velký plot - isotermy jen v oblasti suche pary
%bigplot = 0 pro "celé" isotermy (mokrá i suchá oblast)
%implementováno if 0 ... else ... end
konstHS.bigplot=0; 
konstHS.rozliseni_isotermy_suche = 40;
konstHS.rozliseni_isotermy_mok = 100;
konstHS.rozliseni_isobary = 160;
konstHS.hmin = 1700;
konstHS.hmax = 4200;
konstHS.Pmin = .001 *10;
konstHS.Pmax = 100 *10;
konstHS.smin = 5;
konstHS.smax = 9.5;
%pocet bodu ve formatu (9*2-1)*2-1 dava hezke rovnomerne rozlozeni bodu
%pouzite pro plot HS isobar, HS suchosti
%9, 17, 33, 65
konstHS.bodu=17;
% p_temp = [22,21.5,21,20.5,linspace(20,10,11)]*10;
% max=9;
% min=1;
% bodu = 17;
% for i=[1,10,10,10]
%     max=max/i;
%     min=min/i;
%     p_temp = [p_temp,linspace(max,min,bodu)];
% end
konstHS.tlak_vypocet_x = [220.639499999,220.6346373627326,220,215,210,...
    205,200,190,180,170,160,150,140,...
    130,120,110,100,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,...
    10,9,8.500,8,7.500,7,6.500,6,5.500,5,4.500,4,3.500,3.000,2.500,...
    2.000,1.500,1,0.9000,0.8500,0.8000,0.7500,0.7000,0.6500,0.6000,...
    0.5500,0.5000,0.4500,0.4000,0.3500,0.3000,0.2500,0.2000,0.1500,...
    0.1000,0.09000,0.08500,0.08000,0.07500,0.07000,0.06500,0.06000,...
    0.05500,0.05000,0.04500,0.04000,0.03500,0.03000,0.02500,0.02000,...
    0.01500,0.01,.008,.006,.006,.004,.0035,.003,.0025,.002,.0015,.001];
%--------------------------------------------------------------------------
%           konstTS
%--------------------------------------------------------------------------
tlak = [100,80,60,50,40,30,25,20,15];
tlak = [tlak,tlak/10,tlak/100,tlak/1000];
tlak = [tlak,tlak/10,0.001]*10;

konstTS.tlak = [tlak,.00611658];
konstTS.Tmax = 700;
konstTS.Tmin = 0;
konstTS.smax = 10;
konstTS.smin = 0;
konstTS.rozliseni_isobary = 200; 
%isobara "pod oblasti mokre pary" je fixní
%viz. funkce vypocetTS case 'isobara'
konstTS.rozliseni_isoh = 100;
konstTS.rozliseni_such = 200;

%--------------------------------------------------------------------------
%           barvy plotu
%--------------------------------------------------------------------------

%otevře ui pro vyber kodu barvy dle barvy
%c = uisetcolor([1 1 0],'Select a color')

barva.tloustka_H = 1.2;
barva.tloustka_V = 0.6;
%hs
%isotermy - červena
%barva.hs_T_H = [0.7804,0,0];
%barva.hs_T_H = [0.9098,0.2510,0.1804];
%barva.hs_T_V = [1.0000,0.4196,0.4196];
%barva.hs_T_H = [0.8311,0.2010,0.2010];
barva.hs_T_H = [.8500,0.4388,0.4088];
barva.hs_T_V = [1.0000,0.4388,0.4088];
%isobary - černa/šeda
barva.hs_p_H = [0.24,0.24,0.24];
barva.hs_p_V = [.65,.65,.65];
%isochory - zelena
%barva.hs_v = [.42,.74,.2];
barva.hs_v = [.43,.63,.25];
%suchosti - modra
barva.hs_such_H = [0,0.4471,0.7412];
barva.hs_such_V = [0.0745,0.6235,1.0000];

%ts
%isoentalpy - modra
barva.h = [0.0745,0.6235,1.0000];
%isobary - červená
barva.ts_p_H = [0.9098,0.2510,0.1804];
barva.ts_p_V = [1.0000,0.4196,0.4196];
%isochory - zelená
barva.ts_v = barva.hs_v;
%mez sytosti - černá/šedá
barva.ts_such_H = [0.24,0.24,0.24];
barva.ts_such_V = [.55,.55,.55];
%isoentalpy - modrá
barva.ts_h = [0,0.4471,0.7412];

%uzivatel - fialova
barva.uzivatel = [.4941,.1843,.5569];
barva.iso_plot = [.902,.902,.902];


barva.izochoricky = [.43, .63, .25]; % zelena
barva.izoentropicky = [0.9294, 0.6941, 0.1255]; % jina oranzova
barva.adiabaticky = [0.9804, 0.6667, 0.3725]; % oranzova
barva.izoentalpicky = [0.0745, 0.6235, 1.0000]; % modra
barva.izotermicky = [0.9098, 0.2510, 0.1804]; % červena
barva.izobaricky = [0.24, 0.24, 0.24];% 
barva.pomocna = [.55, .55, .55]; % šedá
end