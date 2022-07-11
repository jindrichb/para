function [outH_hs,outS_hs,outT_ts,outS_ts]=isochoricky_fce(p1,t1,v1,x1,p2,t2,x2)
%[outH,outS,outT]=isochoricky_fce(p1,t1,v1,x1,p2,t2,x2)
%isochoricky dej
bodu=30;
% h1=3000;
% h2=2200;
% v1=1;
input=v1;
%--------------

% flip if necesary
if t1 < t2
    t = t1;
    p = p1;
    % v = v1;
    x = x1;
    t1 = t2;
    p1 = p2;
    x1 = x2;
    t2 = t;
    p2 = p;
    x2 = x;
end

%rozlustim pripad zadani t,v,s,x,h,u a dpoctu (naleznu) druhy bod
%mam nalezene dva body - B1 a B2 ze zadanych hodnot
%kopiruj isobaru s omezenim mezi body - 2 pripady hs,ts (s pv 3)
try
    [outS, outH,outT]=isochory_vypocet_meze(input,p1,t1,x1,p2,t2,x2,bodu);
catch ME
    outH = -1;
    outS = -1;
    outT = -1;
    errdlg('Chyba výpočtu izochorického děje')
end
outH_hs = outH;
outS_hs = outS;
outT_ts = outT;
outS_ts = outS;






