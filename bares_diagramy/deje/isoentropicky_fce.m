function [out_h,out_s_h,out_T,out_s_t]=isoentropicky_fce(h1,t1,s1,h2,t2)
%[out_s, out_h, out_T]=isochory_vypocet_meze(vol,p1,x1,x2,p2,varargin)
%

bodu = 30;

out_h = linspace(h1,h2,bodu);
out_T = linspace(t1,t2,bodu);
out_s_h = s1*ones(1,bodu);
out_s_t = out_s_h;
end






