[konstHS,konstTS,barva]=initKonst();
fig = open('figs/ts_mez.fig');
fig.Visible = 'on';
fig.CurrentAxes.YLim = [0,800];
hold on
%isobarya
[outT, outS]=vypocetTS(konstTS,'isobara',1000); plot(outS,outT,'Color','black');
[outT, outS]=vypocetTS(konstTS,'isobara',.0062); plot(outS,outT,'Color','black');

%isochory
[outT, outS]=vypocetTS(konstTS,'isochora',100); plot(outS,outT,'Color','green');
[outT, outS]=vypocetTS(konstTS,'isochora',.00101); plot(outS,outT,'Color','green');

%isoentalpy
[outT, outS]=vypocetTS(konstTS,'isoh',4000); plot(outS,outT,'Color','blue');
[outT, outS]=vypocetTS(konstTS,'isoh',100); plot(outS,outT,'Color','blue');
