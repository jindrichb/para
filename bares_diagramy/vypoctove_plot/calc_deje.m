function [outH_hs,outS_hs,outT_ts,outS_ts] = calc_deje(app,bod1,bod2)
pripad = bod2.pripad_zadani;
dej = dej_to_num(bod2.zadani1);
[t,p,v,h,u,s,x] = getVals(bod1);
[t2,p2,v2,h2,u2,s2,x2] = getVals(bod2);
% [outH_hs,outS_hs,outT_ts,outS_ts] = deal([]);
[outH_hs,outS_hs,outT_ts,outS_ts,t2,p2,v2,h2,u2,s2,x2] = swtich_dej(app,pripad,dej,t,p,v,h,u,s,x,t2,p2,v2,h2,u2,s2,x2);

end