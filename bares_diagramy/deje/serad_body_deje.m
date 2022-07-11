function [t1,p1,v1,s1,x1,h1,u1,t2,p2,v2,s2,x2,h2,u2]=serad_body_deje(t,p,v,s,x,h,u,t2,p2,v2,s2,x2,h2,u2)
%function [t1,p1,v1,s1,x1,h1,u1,t2,p2,v2,s2,x2,h2,u2]=serad_body_deje(t,p,v,s,x,h,u,t2,p2,v2,s2,x2,h2,u2)
%
%seradi vstup bez indexu dle velikosti h a pripadne s
%indexy 1 jsou vzdy vetsi
if h>h2
    [t1,p1,v1,s1,x1,h1,u1]=deal(t,p,v,s,x,h,u);
elseif h<h2
    [t1,p1,v1,s1,x1,h1,u1]=deal(t2,p2,v2,s2,x2,h2,u2);
    [t2,p2,v2,s2,x2,h2,u2]=deal(t,p,v,s,x,h,u);
elseif h==h2
    if s>s2
        [t1,p1,v1,s1,x1,h1,u1]=deal(t,p,v,s,x,h,u);
    elseif s<s2
        [t1,p1,v1,s1,x1,h1,u1]=deal(t2,p2,v2,s2,x2,h2,u2);
        [t2,p2,v2,s2,x2,h2,u2]=deal(t,p,v,s,x,h,u);        
    else
        error("body splyvaji")
    end
end

end