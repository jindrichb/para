function [t,p,v,s,x,h,u] = dopocetNeznamych_(app,in1,unit1,in2,unit2,pripad)
            %function [t,p,v,s,x,h] = dopocetNeznamych(in1,in2,pripad)
            %
            %Tato funkce bude obsahovat veškeré dopočty, nebo alespoň bude volat
            %dopočty neznámých hodnot. Nejspíš bude vstupním parametrem "zadané
            %hodnoty" a jejich číselné hodnoty, výpočet pak bude postupným převodem na
            %"to už umím spočítat".
            %Neboli se nejspíš vždy budu snažit dostat nějakou kombinaci s,p,h. Z nich
            %lze dopočítat zbytek relativně snadno.
            %
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
            % 16 t-u
            % 17 p-u
            % 18 h-u
            % 19 s-u
            % 20 v-u
            % 21 x-u
            %
            % to do: u
            
            %sort them...
            
            %init, just in case
            h=-1;
            p=-1;
            s=-1;
            v=-1;
            t=-1;
            x=-1;
            u=-1;
            
            switch pripad
                case 1 %h-p
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    p=prevod_(app,in2,unit2,'p','bar');
                    s=XSteam('s_ph',p,h);
                    v=XSteam('v_ph',p,h);
                    t=XSteam('t_ph',p,h);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 2 %h-s
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    s=prevod_(app,in2,unit2,'s','kJ/kg/K');
                    p=XSteam('p_hs',h,s);
                    v=XSteam('v_ph',p,h);
                    t=XSteam('t_hs',h,s);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 3 %t-p
                    t=prevod_(app,in1,unit1,'t','°C');
                    p=prevod_(app,in2,unit2,'p','bar');
                    s=XSteam('s_pt',p,t);
                    h=XSteam('h_pt',p,t);
                    v=XSteam('v_ph',p,h);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 4 %h-t
                    %disp('to do dopocet neznemych case 4')
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    t=prevod_(app,in2,unit2,'t','°C');
                    [p,~]=dopocet_p_ht(h,t);
                    v=XSteam('v_ph',p,h);
                    s=XSteam('s_ph',p,h);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                    
                case 5 %s-t
                    s=prevod_(app,in1,unit1,'s','kJ/kg/K');
                    t=prevod_(app,in2,unit2,'t','°C');
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
                    s=prevod_(app,in1,unit1,'s','kJ/kg/K');
                    p=prevod_(app,in2,unit2,'p','bar');
                    h=XSteam('h_ps',p,s);
                    t=XSteam('T_ps',p,s);
                    v=XSteam('v_ps',p,s);
                    x=XSteam('x_ps',p,s);
                    u=XSteam('u_ph',p,h);
                case 7 %t-x
                    t=prevod_(app,in1,unit1,'t','°C');
                    x=in2;
                    p=XSteam('psat_T',t);
                    h=XSteam('h_tx',t,x);
                    s=XSteam('s_ph',p,h);
                    v=XSteam('v_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 8 %p-x
                    p=prevod_(app,in1,unit1,'p','bar');
                    x=in2;
                    h=XSteam('h_px',p,x);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ph',p,h);
                    v=XSteam('v_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 9 %h-x
                    disp('Varování, možné 2 průsečíky, zatím neumím najít oba!!')
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    x=in2;
                    p=dopocet_p_hx(h,x);
                    s=XSteam('s_ph',p,h);
                    v=XSteam('v_ph',p,h);
                    t=XSteam('T_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 10 %s-x
                    s=prevod_(app,in1,unit1,'s','kJ/kg/K');
                    x=in2;
                    p=dopocet_p_sx_advanced(s,x);
                    t=XSteam('Tsat_p',p);
                    h=XSteam('h_px',p,x);
                    v=XSteam('v_ps',p,s);
                    u=XSteam('u_ph',p,h);
                case 11 %t-v
                    t=prevod_(app,in1,unit1,'t','°C');
                    v=prevod_(app,in2,unit2,'v','m3/kg');
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
                    if isnan(x) && t > 373.94
                        x = 1;
                    end
                    u=XSteam('u_ph',p,h);
                case 12 %p-v
                    p=prevod_(app,in1,unit1,'p','bar');
                    v=prevod_(app,in2,unit2,'v','m3/kg');
                    h=dopocet_h_pv(p,v);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 13 %h-v
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    v=prevod_(app,in2,unit2,'v','m3/kg');
                    p=dopocet_p_hv(h,v);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 14 %s-v
                    s=prevod_(app,in1,unit1,'s','kJ/kg/K');
                    v=prevod_(app,in2,unit2,'v','m3/kg');
                    p=dopocet_p_sv(s,v);
                    h=XSteam('h_ps',p,s);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    u=XSteam('u_ph',p,h);
                case 15 %x-v
                    x=in1;
                    v=prevod_(app,in2,unit2,'v','m3/kg');
                    p=dopocet_p_vx(v,x);
                    
                    h=dopocet_h_pv(p,v);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    u=XSteam('u_ph',p,h);
                case 16 % 16 t-u
                    t=prevod_(app,in1,unit1,'t','°C');
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                    [p,pripad]=dopocet_p_tu(t,u);
                    if pripad == 1
                        h=XSteam('h_pT',p,t);
                        s=XSteam('s_pT',p,t);
                        x=XSteam('x_ph',p,h);
                    elseif pripad == 2
                        h=dopocet_h_pv(p,v);
                        s=XSteam('s_ph',p,h);
                        x=XSteam('x_ph',p,h);
                    end
                    v=XSteam('v_pT',p,t);
                case 17 % 17 p-u
                    p=prevod_(app,in1,unit1,'p','bar');
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                    h=dopocet_h_pu(p,u);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    v=XSteam('v_ph',p,h);
                case 18 % 18 h-u
                    h=prevod_(app,in1,unit1,'h','kJ/kg');
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                    p=dopocet_p_hu(h,u);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    v=XSteam('v_ph',p,h);
                case 19 % 19 s-u
                    s=prevod_(app,in1,unit1,'s','kJ/kg/K');
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                    p=dopocet_p_su(s,u);
                    h=XSteam('h_ps',p,s);
                    t=XSteam('T_ps',p,s);
                    x=XSteam('x_ph',p,h);
                    v=XSteam('v_ph',p,s);
                case 20 % 20 v-u
                    v=prevod_(app,in1,unit1,'v','dm3/kg');
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                case 21 % 21 x-u
                    x=in1;
                    u=prevod_(app,in2,unit2,'u','kJ/kg');
                    p=dopocet_p_ux(u,x);
                    
                    h=dopocet_h_pv(p,v);
                    s=XSteam('s_ph',p,h);
                    t=XSteam('T_ps',p,s);
                    v=XSteam('v_ph',p,h);
                otherwise
                    error('neumim (zatim)')
            end
        end