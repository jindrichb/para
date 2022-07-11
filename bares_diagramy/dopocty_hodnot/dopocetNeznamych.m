function [t,p,v,s,x,h,u] = dopocetNeznamych(in1,in2,pripad)
%function [t,p,v,s,x,h] = dopocetNeznamych(in1,in2,pripad)
%
%Tato funkce bude obsahovat veškeré dopočty, nebo alespoň bude volat
%dopočty neznámých hodnot. Nejspíš bude vstupním parametrem "zadané
%hodnoty" a jejich číselné hodnoty, výpočet pak bude postupným převodem na
%"to už umím spočítat".
%Neboli se nejspíš vždy budu snažit dostat nějakou kombinaci s,p,h. Z nich
%lze dopočítat zbytek relativně snadno.
%
%pripad:
% 1 h-p
% 2 h-s
% 3 t-p
% 4 h-t
% 5 s-t
% 6 s-p
% 7 t-x
% 8 p-x
% 9 h-x
% 10 s-x
% 11 t-v
% 12 p-v
% 13 h-v
% 14 s-v
% 15 x-v
% 
% 
% to do: u

h=-1;
p=-1;
s=-1;
v=-1;
t=-1;
x=-1;
u=-1;

switch pripad
    case 1 %h-p
        h=in1;
        p=in2;
        s=XSteam('s_ph',p,h);
        v=XSteam('v_ph',p,h);
        t=XSteam('t_ph',p,h);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 2 %h-s
        h=in1;
        s=in2;
        p=XSteam('p_hs',h,s);
        v=XSteam('v_ph',p,h);
        t=XSteam('t_hs',h,s);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 3 %t-p
        t=in1;
        p=in2;
        s=XSteam('s_pt',p,t);
        h=XSteam('h_pt',p,t);
        v=XSteam('v_ph',p,h);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 4 %h-t
        %disp('to do dopocet neznemych case 4')
        h=in1;
        t=in2;
        [p,~]=dopocet_p_ht(h,t);
        v=XSteam('v_ph',p,h);
        s=XSteam('s_ph',p,h);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
        
    case 5 %s-t
        s=in1;
        t=in2;
        [p,pripad]=dopocet_p_st(s,t);
        if pripad == 1
            h=XSteam('h_pt',p,t);
            v=XSteam('v_ph',p,h);
            x=XSteam('x_ph',p,h);
        elseif pripad == 2
            h=XSteam('h_ps',p,s);
            v=XSteam('v_ph',p,h);
            x=XSteam('x_ph',p,h);
        end
        u=XSteam('u_ph',p,h);
    case 6 %s-p
        s=in1;
        p=in2;
        h=XSteam('h_ps',p,s);
        t=XSteam('T_ps',p,s);
        v=XSteam('v_ps',p,s);
        x=XSteam('x_ps',p,s);
        u=XSteam('u_ph',p,h);
    case 7 %t-x
        t=in1;
        x=in2;        
        p=XSteam('psat_T',t);
        h=XSteam('h_tx',t,x);
        s=XSteam('s_ph',p,h);
        v=XSteam('v_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 8 %p-x
        p=in1;
        x=in2;
        h=XSteam('h_px',p,x);
        s=XSteam('s_ph',p,h); 
        t=XSteam('T_ph',p,h);
        v=XSteam('v_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 9 %h-x
        warning('Zadání h-x má 2 možné průsečíky, zatím neumím najít oba!!')
        h=in1;
        x=in2;
        p=dopocet_p_hx(h,x);
        s=XSteam('s_ph',p,h);
        v=XSteam('v_ph',p,h);
        t=XSteam('T_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 10 %s-x
        s=in1;
        x=in2;
        p=dopocet_p_sx_advanced(s,x);
        t=XSteam('Tsat_p',p);
        h=XSteam('h_px',p,x);
        v=XSteam('v_ps',p,s);
        u=XSteam('u_ph',p,h);
    case 11 %t-v
        t=in1;
        v=in2;
        [p,pripad]=dopocet_p_tv(t,v);
        if pripad == 1
            h=XSteam('h_pT',p,t);
            s=XSteam('s_pT',p,t);
            x=XSteam('x_ph',p,h);
        elseif pripad == 2
            h=dopocet_h_pv(p,v);
            s=XSteam('s_ph',p,h);
            x=XSteam('x_ph',p,h);            
        end
        u=XSteam('u_ph',p,h);
    case 12 %p-v
        p=in1;
        v=in2;
        h=dopocet_h_pv(p,v);
        s=XSteam('s_ph',p,h);
        t=XSteam('T_ps',p,s);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 13 %h-v
        h=in1;
        v=in2;
        p=dopocet_p_hv(h,v);
        s=XSteam('s_ph',p,h);
        t=XSteam('T_ps',p,s);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 14 %s-v
        s=in1;
        v=in2;
        p=dopocet_p_sv(s,v);
        h=XSteam('h_ps',p,s);
        t=XSteam('T_ps',p,s);
        x=XSteam('x_ph',p,h);
        u=XSteam('u_ph',p,h);
    case 15 %x-v
        x=in1;
        v=in2;
        p=dopocet_p_vx(v,x);
        
        h=dopocet_h_pv(p,v);
        s=XSteam('s_ph',p,h); 
        t=XSteam('T_ps',p,s); 
        u=XSteam('u_ph',p,h);      
    otherwise
        error('neumim (zatim)')
end




