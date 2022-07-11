function replot_dj(app,in1,in2,cislo_deje)
% in1 = bod_class;
% in2 = bod_class;
% 
% len = length(app.mem_bodu);
% in1 = app.mem_bodu(len-1);
% in2 = app.mem_bodu(len);
%......



%fig = figure;
%hold on
[outH_hs,outS_hs,outT_ts,outS_ts] = calc_deje(app,in1,in2);
dej = in2.zadani1;
[~,~] = plotDeje(app,outH_hs,outS_hs,outT_ts,outS_ts,dej,cislo_deje);
% plot(out_x, out_y);
%hold off
end