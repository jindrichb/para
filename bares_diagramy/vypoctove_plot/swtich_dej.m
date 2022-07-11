function [outH_hs,outS_hs,outT_ts,outS_ts,t2,p2,v2,h2,u2,s2,x2,h2_] = swtich_dej(app,pripad,dej,t,p,v,h,u,s,x,t2,p2,v2,h2,u2,s2,x2)
%dopocet stavu 2

switch dej
    case -1
        return
    case 1 %p
        switch pripad
            case 1 %hp
                in1=h2;
                in2=p;
                unit1="kJ/kg";
                unit2= "bar";
            case 3 %tp
                in1=t2;
                in2=p;
                unit1="°C";
                unit2= "bar";
            case 6 %sp
                in1=s2;
                in2=p;
                unit1="kJ/kg/K";
                unit2= "bar";
            case 8 %px
                in2=x2;
                in1=p;
                unit2="";
                unit1= "bar";
            case 12 %pv
                in2=v2;
                in1=p;
                unit2="m3/kg";
                unit1= "bar";
            case 18 %pu
                in2=u2;
                in1=p;
                unit2="kJ/kg";
                unit1= "bar";
        end
    case 2 %t
        switch pripad
            case 3 %t-p
                in1=t;
                in2=p2;
                unit1="°C";
                unit2= "bar";
            case 4 %h-t
                in2=t;
                in1=h2;
                unit2="°C";
                unit1= "kJ/kg";
            case 5 %s-t
                in2=t;
                in1=s2;
                unit2="°C";
                unit1= "kJ/kg/K";
            case 7 %t-x
                in1=t;
                in2=x2;
                unit1="°C";
                unit2= "";
            case 11 %t-v
                in1=t;
                in2=v2;
                unit1="°C";
                unit2= "m3/kg";
            case 16 %t-u
                in1=t;
                in2=u2;
                unit1="°C";
                unit2= "kJ/kg";
        end
    case 3 %v
        switch pripad
            case 11 %t-v
                in1=t2;
                in2=v;
                unit1="°C";
                unit2= "m3/kg";
            case 12 %p-v
                in1=p2;
                in2=v;
                unit1="bar";
                unit2= "m3/kg";
            case 13 %h-v
                in1=h2;
                in2=v;
                unit1="kJ/kg";
                unit2= "m3/kg";
            case 14 %s-v
                in1=s2;
                in2=v;
                unit1="kJ/kg/K";
                unit2= "m3/kg";
            case 15 %x-v
                in1=x2;
                in2=v;
                unit1="";
                unit2= "m3/kg";
            case 20 %v-u
                in2=u2;
                in1=v;
                unit2="kJ/kg";
                unit1= "m3/kg";
        end
    case 4 %s
        switch pripad
            case 2 %h-s
                in1=h2;
                in2=s;
                unit1="kJ/kg";
                unit2= "kJ/kg/K";
            case 5 %s-t
                in1=s;
                in2=t2;
                unit1="kJ/kg/K";
                unit2= "°C";
            case 6 %s-p
                in1=s;
                in2=p2;
                unit1="kJ/kg/K";
                unit2= "bar";
            case 10 %s-x
                in1=s;
                in2=x2;
                unit1="kJ/kg/K";
                unit2= "";
            case 14 %s-v
                in1=s;
                in2=v2;
                unit1="kJ/kg/K";
                unit2= "m3/kg";
            case 19 %s-u
                in2=s;
                in1=u2;
                unit2="kJ/kg/K";
                unit1= "kJ/kg";
        end
    case 5 %adia - jako s pri ucinnost = 1, vice doreseno dalsimi funkcemi
        switch pripad
            case 2 %h-s
                in1=h2;
                in2=s;
                unit1="kJ/kg";
                unit2= "kJ/kg/K";
            case 5 %s-t
                in1=s;
                in2=t2;
                unit1="kJ/kg/K";
                unit2= "°C";
            case 6 %s-p
                in1=s;
                in2=p2;
                unit1="kJ/kg/K";
                unit2= "bar";
            case 10 %s-x
                in1=s;
                in2=x2;
                unit1="kJ/kg/K";
                unit2= "";
            case 14 %s-v
                in1=s;
                in2=v2;
                unit1="kJ/kg/K";
                unit2= "m3/kg";
            case 19 %s-u
                in2=s;
                in1=u2;
                unit2="kJ/kg/K";
                unit1= "kJ/kg";
        end
    case 6 %h
        switch pripad
            case 2 %h-s
                in1=h;
                in2=s2;
                unit1="kJ/kg";
                unit2= "kJ/kg/K";
            case 4 %h-t
                in1=h;
                in2=t2;
                unit1="kJ/kg";
                unit2= "°C";
            case 1 %h-p
                in1=h;
                in2=p2;
                unit1="kJ/kg";
                unit2= "bar";
            case 9 %h-x
                in1=h;
                in2=x2;
                unit1="kJ/kg";
                unit2= "";
            case 13 %h-v
                in1=h;
                in2=v2;
                unit1="kJ/kg";
                unit2= "m3/kg";
            case 18 %h-u
                in2=h;
                in1=u2;
                unit2= "kJ/kg";
                unit1= "kJ/kg";
        end
end
[t2,p2,v2,s2,x2,h2,u2] = dopocetNeznamych_(app,in1,unit1,in2,unit2,pripad);
[outH_hs,outS_hs,outT_ts,outS_ts] = deal([]);

switch dej
    case 1 %p
        [outH_hs,outS_hs,outT_ts,outS_ts]=isobaricky_fce(p,s,h,s2,h2);
        %add_state(app,pripad,t2,p2,v2,s2,x2,h2,u2);
    case 2 %t
        [outH_hs,outS_hs,outT_ts,outS_ts]=isotermicky_fce(s,t,p,x,s2,p2,x2);
        %add_state(app,pripad,t2,p2,v2,s2,x2,h2,u2);
    case 3 %v
        [outH_hs,outS_hs,outT_ts,outS_ts]=isochoricky_fce(p,t,v,x,p2,t2,x2);
        %add_state(app,pripad,t2,p2,v2,s2,x2,h2,u2);
    case 4 %s
        [outH_hs,outS_hs,outT_ts,outS_ts]=isoentropicky_fce(h,t,s,h2,t2);
        %add_state(app,pripad,t2,p2,v2,s2,x2,h2,u2);
    case 5 %adia
        if isnan(h2)
            h2 = XSteam('h_ps',1000,s);
            nan_found = 1;
        end
        h2_ = h2;
        %dopocitej hodnoty 2'
        [~,p2_,~,~,~,h2_,~] = dopocetNeznamych_(app,h2_,"kJ/kg",s,"kJ/kg/K",2);
        p2_vychozi = p2_;
        h2_vychozi = h2_;
        if app.pEditField_2.Value ~= -1
            p2_ = app.pEditField_2.Value;
        end
        
        %namaluj bod pri ucinnost = 1
        %add_state(app,pripad,t2_,p2_,v2_,s2_,x2_,h2_,u2_);
        %app.mem_deju = app.mem_deju.set_bod2_(app,pripad,t2_,p2_,v2_,s2_,x2_,h2_,u2_);
        
        ucinnost = app.etaEditField.Value;
        if ~exist('nan_found','var')
            nan_found = 0;
        end
        p2_override = false;
        it_worked = false;
        last_up = false;
        switch pripad
            % h-s = 2
            % s-t = 5
            % s-p = 6
            % s-x = 10
            % s-v = 14
            % s-u = 19
            case 2
                % h-s
                if h2 > h
                    %pripad komprese
                    h2_ref = h2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > .001 && h_krok > .000001)
                        h2 = h  + (h2_ - h) / ucinnost;
                        dist = h2_ref --+h2;
                        if isnan(dist)
                            % if the value is nan -> out of XSteam limits
                            % try to set it to XSteam max
                            %
                            % if it "steps down" it is fine and valie is
                            % found
                            %
                            % if it "steps up" new nan is terutrned -> it
                            % is hopeless and thus break the loop and
                            % return -1s
                            if nan_found >= 2
                                % calc max value and save it for use in
                                % errdlg called from main app body
                                h2_ = XSteam('h_ps',1000,s);
                                h2m = h  + (h2_ - h) / ucinnost; %h2 max
                                app.errValue = h2m;
                                error('adia vypocet')
                            end
                            nan_found = nan_found + 1;
                            h2_ = XSteam('h_ps',1000,s);
                        elseif abs(dist) > .001
                            % stepping
                            if dist > 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ + h_krok;
                            elseif dist < 0
                                h2_ = h2_ - h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    if h_krok < .0001
                        warning("padlo to na podminku h")
                    end
                    p2 = XSteam('p_hs',h2_,s);
                    [t2,~,v2,s2,x2,~,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    %h2 = h_ref;
                elseif h > h2
                    %pripad expanze
                    %udelej isoentropicky dej (kolmo dolu) do bodu 2'
                    %spocitej si h2 pomoci zadane ucinnosti
                    h2_ref = h2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > .001 && h_krok > .0001)
                        h2 = h - ucinnost * (h - h2_);
                        dist = h2_ref - h2;
                        if abs(dist) > .001
                            if dist < 0
                                h2_ = h2_ - h_krok;
                            elseif dist > 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ + h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    if h_krok < .0001
                        warning("padlo to na podminku h")
                    end
                    %tim padem zname koncovy bod (p2, h2 -> pripad 1) a muzem dopocitat zbytek
                    p2 = XSteam('p_hs',h2_,s);
                    [t2,~,v2,s2,x2,~,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    %h2 = h_ref;
                    %debug_______ vyrob out_ listy
                    %[outH_hs,outS_hs,outT_ts,outS_ts] = deal([h,h2],[s,s2],[t,t2],[s,s2]);
                else % equal
                    [t2,p2,v2,s2,x2,h2,u2] = deal(t,p,v,s,x,h,u);
                end
            case 5
                % s-t
                if h2 > h
                    %pripad komprese
                    t_ref = t2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > .001 && h_krok > .0000001)
                        h2 = h  + (h2_ - h) / ucinnost;
                        if p2_override == false
                            p2 = XSteam("p_hs",h2_,s);
                        else
                            p2_override = false;
                        end
                        t2 = XSteam("T_ph",p2,h2);
                        dist = t_ref - t2;
                        if isnan(dist)
                            
                            if it_worked == false
                                % if the value is nan -> out of XSteam limits
                                % try to set it to XSteam max
                                %
                                % if it "steps down" it is fine and valie is
                                % found
                                %
                                % if it "steps up" new nan is terutrned -> it
                                % is hopeless and thus break the loop and
                                % return -1s
                                if nan_found >= 2
                                    % h2=-1;

                                    % calc max value and save it for use in
                                    % errdlg called from main app body
                                    h2_ = XSteam('h_ps',1000,s);
                                    h2m = h  + (h2_ - h) / ucinnost;
                                    t2m = XSteam('t_ph',1000,h2m);
                                    app.errValue = t2m;
                                    error('adia vypocet')
                                end
                                nan_found = nan_found + 1;
                                p2 = 1000;
                                h2_ = XSteam('h_ps',p2,s);
                                dist = 1000;
                                p2_override = true;
                            else
                                if last_up
                                    h_krok = h_krok / 2;
                                    h2_ = h2_ - h_krok;
                                else
                                    h_krok = h_krok / 2;
                                    h2_ = h2_ + h_krok;
                                end
                                dist = 1000;
                            end
                        elseif abs(dist) > .001
                            it_worked = true;
                            if dist > 0
                                last_up = true;
                                h2_ = h2_ + h_krok;
                            elseif dist < 0
                                last_up = false;
                                h_krok = h_krok / 2;
                                h2_ = h2_ - h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    [~,p2,v2,s2,x2,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    t2 = t_ref;
                elseif h > h2
                    %pripad expanze
                    %udelej isoentropicky dej (kolmo dolu) do bodu 2'
                    %spocitej si h2 pomoci zadane ucinnosti
                    t_ref = t2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > 1 && h_krok > .0001)
                        h2 = h - ucinnost * (h - h2_);
                        p2 = XSteam("p_hs",h2_,s);
                        t2 = XSteam("T_ph",p2,h2);
                        dist = t_ref - t2;
                        if abs(dist) > .001
                            % stepping
                            if dist < 0
                                h2_ = h2_ - h_krok;
                            elseif dist > 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ + h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    %tim padem zname koncovy bod (p2, h2 -> pripad 1) a muzem dopocitat zbytek
                    [~,p2,v2,s2,x2,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    t2 = t_ref;
                else % equal
                    [t2,p2,v2,s2,x2,h2,u2] = deal(t,p,v,s,x,h,u);
                end
            case 6
                % s-p
                
                if h2 > h
                    %pripad komprese
                    h2 = h  + (h2_ - h) / ucinnost;
                    % disp(h2)
                    [t2,~,v2,s2,x2,~,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2_,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                elseif h > h2
                    %pripad expanze
                    %udelej isoentropicky dej (kolmo dolu) do bodu 2'
                    %spocitej si h2 pomoci zadane ucinnosti
                    h2 = h - ucinnost * (h - h2_);
                    %tim padem zname koncovy bod (p2, h2 -> pripad 1) a muzem dopocitat zbytek
                    [t2,~,v2,s2,x2,~,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2_,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                else % equal
                    [t2,p2,v2,s2,x2,h2,u2] = deal(t,p,v,s,x,h,u);
                end
            case 10
                % s-x
                if h2 > h
                    %pripad komprese
                    x_ref = x2;
                    dist = 1000;
                    h_krok = 100;
                    lst = '+'; %??
                    such = 1;
                    % suchost se "vlní" a je možné mít dva
                    % průsečíky. Vždy najdu "první pod" (respektive nad).
                    while (abs(dist) > .0001 && h_krok > .000001)
                        disp(h2)
                        h2 = h  + (h2_ - h) / ucinnost;
                        p2 = XSteam("p_hs",h2_,s);
                        x2 = XSteam("x_ph",p2,h2);
                        if isnan(x2)
                            brkcnd = 0;
                            %disp('...')
                            while isnan(x2) && brkcnd < 5
                                brkcnd = brkcnd + 1;
                                if strcmp(lst,'+')
                                    h2_ = h2_ - h_krok;
                                    h_krok = h_krok / 2;
                                    h2_ = h2_ + h_krok;
                                elseif strcmp(lst,'--')
                                    h2_ = h2_ + 2 * h_krok;
                                    h_krok = h_krok / 2;
                                    h2_ = h2_ - h_krok;
                                else % -
                                    h2_ = h2_ + h_krok;
                                    h_krok = h_krok / 2;
                                    h2_ = h2_ - h_krok;
                                end
                                %disp(h2_)
                                h2 = h  + (h2_ - h) / ucinnost;
                                p2 = XSteam("p_hs",h2_,s);
                                x2 = XSteam("x_ph",p2,h2);
                            end
                        end
                        if such == 1
                            dist = x_ref - x2;
                            dists = XSteam('sV_p',p2) - XSteam('s_ph',p2,h2);
                            if 0 + .001 > x_ref
                                dists = XSteam('sL_p',p2) - XSteam('s_ph',p2,h2);
                            end
                            if dists < 0
                                lst = '--';
                                h2_ = h2_ - h_krok;
                                h_krok = h_krok / 2;
                                dist = 1;
                            else
                                if abs(dist) > .0001
                                    if dist > 0
                                        lst = '+';
                                        h2_ = h2_ + h_krok;
                                    elseif dist < 0
                                        lst = '-';
                                        h_krok = h_krok / 2;
                                        h2_ = h2_ - h_krok;
                                    elseif dist == 0
                                        % do nothing
                                    end
                                end
                            end
                        elseif such == 0
                            dist = x_ref - x2;
                            dists = XSteam('sL_p',p2) - XSteam('s_ph',p2,h2);
                            if 0 + .001 > x_ref
                                dists = XSteam('sL_p',p2) - XSteam('s_ph',p2,h2);
                            end
                            if dists > 0
                                lst = '--';
                                h2_ = h2_ - h_krok;
                                h_krok = h_krok / 2;
                                dist = 1;
                            else
                                if abs(dist) > .0001
                                    if dist > 0
                                        lst = '+';
                                        h2_ = h2_ + h_krok;
                                    elseif dist < 0
                                        lst = '-';
                                        h_krok = h_krok / 2;
                                        h2_ = h2_ - h_krok;
                                    elseif dist == 0
                                        % do nothing
                                    end
                                end
                            end
                        end
                        if such == 1
                            if p2 < p
                                such = 0;
                                h_krok = 100;
                                x_ref = x2;
                                dist = 1000;
                                lst = '+'; %??
                                p2_ = p2_vychozi;
                                h2_ = h2_vychozi;
                                disp('flip')
                            end
                        end
                    end
                    [t2,p2,v2,s2,~,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    x2 = x_ref;
                elseif h > h2
                    %pripad expanze
                    %udelej isoentropicky dej (kolmo dolu) do bodu 2'
                    %spocitej si h2 pomoci zadane ucinnosti
                    x_ref = x2;
                    dist = 1000;
                    h_krok = 100;
                    %                                     if x_ref == 1
                    %                                         x_ref = 1 - .00011;
                    %                                     elseif x_ref == 0
                    %                                         x_ref = 0 + .00011;
                    %                                     end
                    while (abs(dist) > .0001 && h_krok > .0001)
                        h2 = h - ucinnost * (h - h2_);
                        p2 = XSteam("p_hs",h2_,s);
                        x2 = XSteam("x_ph",p2,h2);
                        dist = x_ref - x2;
                        %if x_ref == 1
                        dists = XSteam('sV_p',p2) - XSteam('s_ph',p2,h2);
                        if 0 + .001 > x_ref
                            dists = XSteam('sL_p',p2) - XSteam('s_ph',p2,h2);
                        end
                        if dists < 0
                            h2_ = h2_ - h_krok;
                            dist = 1;
                        else
                            if dist < 0
                                h2_ = h2_ - h_krok;
                            elseif dist > 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ + h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    %tim padem zname koncovy bod (p2, h2 -> pripad 1) a muzem dopocitat zbytek
                    [t2,p2,v2,s2,~,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                    x2 = x_ref;
                else % equal
                    [t2,p2,v2,s2,x2,h2,u2] = deal(t,p,v,s,x,h,u);
                end
            case 14
                % s-v
                if h2 > h
                    %pripad komprese
                    v_ref = v2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > .001 && h_krok > .000001)
                        h2 = h  + (h2_ - h) / ucinnost;
                        p2 = XSteam("p_hs",h2_,s);
                        v2 = XSteam("v_ps",p2,s);
                        dist = v_ref - v2;
                        if abs(dist) > .001
                            if dist > 0
                                h2_ = h2_ + h_krok;
                            elseif dist < 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ - h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    [t2,p2,v2,s2,~,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] =adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                elseif h > h2
                    %pripad expanze
                    %udelej isoentropicky dej (kolmo dolu) do bodu 2'
                    %spocitej si h2 pomoci zadane ucinnosti
                    v_ref = v2;
                    dist = 1000;
                    h_krok = 100;
                    while (abs(dist) > 1 && h_krok > .0001)
                        h2 = h - ucinnost * (h - h2_);
                        p2 = XSteam("p_hs",h2_,s);
                        v2 = XSteam("v_ps",p2,s);
                        dist = v_ref - v2;
                        if abs(dist) > .001
                            if dist > 0
                                h2_ = h2_ - h_krok;
                            elseif dist < 0
                                h_krok = h_krok / 2;
                                h2_ = h2_ + h_krok;
                            elseif dist == 0
                                % do nothing
                            end
                        end
                    end
                    %tim padem zname koncovy bod (p2, h2 -> pripad 1) a muzem dopocitat zbytek
                    [t2,p2,v2,s2,~,h2,u2] = dopocetNeznamych_(app,h2,"kJ/kg",p2,"bar",1);
                    [outH_hs,outS_hs,outT_ts,outS_ts] = adiabaticky_fce(ucinnost,h,t,s,h2_,s2,p,p2);
                else % equal
                    [t2,p2,v2,s2,x2,h2,u2] = deal(t,p,v,s,x,h,u);
                end
            case 19
                % s-u
                warning("Adiabaticky dej pro zadani U NYI, funkce VypotiButtonPushed -> switch dej")
                
        end
        
        [t2_,p2_,v2_,s2_,x2_,h2_,u2_] = dopocetNeznamych_(app,h2_,"kJ/kg",s,'kJ/kg/K',2);
        if app.vypoti_pushed_flag
            app.mem_deju = app.mem_deju.set_bod2_(app,pripad,t2_,p2_,v2_,s2_,x2_,h2_,u2_);
        end
        %namaluj platny koncovy bod
        %add_state(app,1,t2,p2,v2,s2,x2,h2,u2);
        % pripad = 1;
    case 6 %h
        [outH_hs,outS_hs,outT_ts,outS_ts]=isoentalpicky_fce(app.konst.konstTS,h,s,s2,t2);
        %add_state(app,pripad,t2,p2,v2,s2,x2,h2,u2);
end
end