function plot_mezni_cary(varargin)
if nargin == 0
    [konstHS,konstTS,~] = initKonst;
elseif nargin == 2
    konstHS = varargin{1};
    konstTS = varargin{2};
else
    error('you gave me something stinky, I do not like it')
end
%function [hs_mez,ts_mez]=plot_mezni_cary(konstHS,konstTS,barva)
%
%
%ulozi figury cary suchosti hs,ts diagramu do slozky .\figs

barva=[.35 .35 .35];
font_size = 15;
marker = '.';

ts = figure;
set(ts, 'visible', 'off');

[malujT0, malujS0] = vypocetTS(konstTS,'such',0);
[malujT1, malujS1] = vypocetTS(konstTS,'such',1);
t_stred = (malujT0(end) + malujT1(end)) / 2;
s_stred = (malujS0(end) + malujS1(end)) / 2;
malujS = [malujS0, flip(malujS1)];
malujT = [malujT0, flip(malujT1)];
plot(malujS, malujT, 'color', barva);
hold on
plot(s_stred, t_stred,...
    'marker', marker,...
    'color', barva,...
    'MarkerSize', font_size)
text(s_stred, t_stred, 'k',...
    'color', barva,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'left',...
    'FontSize', font_size)
ts.Tag = 'paratag';
hold off

saveas(ts,'figs\ts_mez.fig');
close(ts)
%-------------------------------------------------------
hs = figure;
set(hs,'visible','off');

[malujH0,malujS0] = vypocetHS(konstHS,'such',0);
[malujH1,malujS1] = vypocetHS(konstHS,'such',1);
% malujS0 = malujS0(~isnan(malujS0));
% malujS1 = malujS1(~isnan(malujS1));
% malujS0 = transpose(malujS0(:,1));
% malujS1 = transpose(malujS1(:,1));
malujS = [flip(malujS0),malujS1];
malujH = [flip(malujH0),malujH1];

h_stred = (malujH0(1) + malujH1(1)) / 2;
s_stred = (malujS0(1) + malujS1(1)) / 2;


plot(malujS,malujH,'color',barva)
hold on
plot(s_stred, h_stred,...
    'marker', marker,...
    'color', barva,...
    'MarkerSize', font_size)
text(s_stred, h_stred, 'k',...
    'color', barva,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment','right',...
    'FontSize', font_size)
hs.Tag = 'paratag';
hold off

saveas(hs,'figs\hs_mez.fig');
close(hs)
%-----------------------------------------------------
pv = figure;
hold on
set(pv,'visible','off');

% malujP = zeros(1,length(malujS1));
% malujV = malujP;
% shift = 1;% 60;
% l = (length(malujS)-shift);
% for i = (1:l)
%     malujP(i) = XSteam('p_hs',malujH(i+shift-1),malujS(i+shift-1));
%     malujV(i) = XSteam('v_ph',malujP(i),malujH(i+shift-1));
% end
% 
% plot(malujV,malujP,'color',barva,'marker','O');
% hold on

% p vals test
% malujP_ = [flip(konstHS.tlak_vypocet_x),konstHS.tlak_vypocet_x];
% malujP_ = malujP_(1:length(malujV));
% plot(malujV,malujP_,'color','green','marker','x');

bodu = 100;
t = linspace(.1,350,bodu);
t = [t,linspace(350.5,373.94,round(bodu/2))];
v0 = zeros(1,bodu);
p0 = v0;
v1 = v0;
p1 = v0;

bodu = bodu + round(bodu/2);
for i = 1:bodu
    v0(i) = XSteam('vL_T',t(i));
    p0(i) = XSteam('psat_T',t(i));
    
    v1(i) = XSteam('vV_T',t(bodu+1-i));
    p1(i) = XSteam('psat_T',t(bodu+1-i));
end

malujV = [v0,v1];
malujP = [p0,p1];

plot(malujV,malujP,'color',barva);%,'marker','O');


p_stred = XSteam('p_hs',h_stred,s_stred);
v_stred = XSteam('v_ph',p_stred,h_stred);

plot(v_stred, p_stred,...
    'marker', marker,...
    'color', barva,...
    'MarkerSize', font_size)
text(v_stred, p_stred, 'k',...
    'color', barva,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment','right',...
    'FontSize', font_size)
set(gca, 'XScale', 'log')
pv.Tag = 'paratag';
hold off
saveas(pv,'figs\pv_mez.fig');
close(pv)

end




