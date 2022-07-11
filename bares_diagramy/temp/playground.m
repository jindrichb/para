% v = .00123456789;
% vol = 0.001357;
vol = .002; 
s = 5e-3;
% t = 800;
t = 800;
bodu = 50;


if vol < XSteam('vV_T',373.94) % v ~ 0.0032
    % dolni krajni bod
    dist = 100;
    p = 1000;
    step = 500;
    default_step = step;
    step_s = 2e-3;
    n = 0;
    citlivost = vol/1e6;
    below_min_p_count = 0;
    while abs(dist) > citlivost && n < 5000
        n = n + 1;
        val = XSteam('v_ps',p,s);
        if isnan(val) && p > 1
            while isnan(val) && p > 1
                p = p - 1;
                val = XSteam('v_ps',p,s);
            end
        end
        dist = vol - val;
        
        if dist > 0 && abs(dist) > citlivost
            p = p - step;
        elseif dist < 0 && abs(dist) > citlivost
            step = step / 2;
            p = p + step;
        end
        if p < 1e-2
            if below_min_p_count > 0
                below_min_p_count = 0;
                s = s + step_s;
                step = default_step;
                p = 1000;
            else
                below_min_p_count = below_min_p_count + 1;
                p = 1e-2;
            end
        end
    end
%     while abs(dist) > citlivost && n < 5000
%         n = n + 1;
%         val = XSteam('v_pt',p,t);
%         if isnan(val) && p > 1
%             while isnan(val) && p > 1
%                 p = p - 1;
%                 val = XSteam('v_pt',p,t);
%             end
%         end
%         dist = vol - val;
%         
%         if dist > 0 && abs(dist) > citlivost
%             p = p - step;
%         elseif dist < 0 && abs(dist) > citlivost
%             step = step / 2;
%             p = p + step;
%         end
%         if p < 1e-2
%             if below_min_p_count > 0
%                 below_min_p_count = 0;
%                 t = t + step_t;
%                 step = default_step;
%                 p = 1000;
%             else
%                 below_min_p_count = below_min_p_count + 1;
%                 p = 1e-2;
%             end
%         end
%         
%     end
    v_start = vol;
    p_start = p;
    s_start = s;
    n_start = n;
    t_start = XSteam("T_ps",p_start,s_start);
    % horni krajni bod
    %     direction = "t - down";
    %     dist = 100;
    %     p = 1000;
    %     step_t = 10;
    %     step = 500;
    %     default_step = step;
    %     n = 0;
    %     below_min_p_count = 0;
    %     while abs(dist) > break_val && n < 5000
    %         n = n + 1;
    %         val = XSteam('v_pt',p,t);
    %         if isnan(val) && p > 1
    %             while isnan(val) && p > 1
    %                 p = p + 1;
    %                 val = XSteam('v_pt',p,t);
    %             end
    %         end
    %         dist = v - val;
    %         if direction == "t - down"
    %             if dist > 0 && abs(dist) > break_val
    %                 step = step / 2;
    %                 p = p + step;
    %             elseif dist < 0 && abs(dist) > break_val
    %                 p = p - step;
    %             end
    %             if p > 1000
    %                 direction = "t - hold";
    %                 p = 1000;
    %                 step = default_step;
    %             end
    %             if p < 1e-2
    %                 if below_min_p_count > 0
    %                     % error("I don't wanna be here! The p-limit hurts!")
    %                     below_min_p_count = 0;
    %                     t = t - step_t;
    %                     step = default_step;
    %                     p = 1000;
    %                 else
    %                     below_min_p_count = below_min_p_count + 1;
    %                     p = 1e-2;
    %                 end
    %             end
    %         else
    %             if dist < 0 && abs(dist) > break_val
    %                 step = step / 2;
    %                 p = p + step;
    %             elseif dist > 0 && abs(dist) > break_val
    %                 p = p - step;
    %             end
    %             if p < 1e-2
    %                 if below_min_p_count > 0
    %                     error("I don't wanna be here! The p-limit hurts!")
    %                 else
    %                     below_min_p_count = below_min_p_count + 1;
    %                     p = 1e-2;
    %                 end
    %             end
    %         end
    %
    %     end
    
    % direction = "t - down";
    dist = 100;
    p = 1000;
    step_t = 10;
    step = 500;
    default_step = step;
    n = 0;
    below_min_p_count = 0;
    while abs(dist) > citlivost && n < 5000
        n = n + 1;
        val = XSteam('v_pt',p,t);
%         if isnan(val) && t >= .1
%             
%         end
        if t < .1
            error("NAN with too low of a temperature")
        end
        if ~isnan(val)
            dist = vol - val;
        end
        
        
        if dist > 0 && abs(dist) > citlivost
            step_t = step_t / 2;
            t = t + step_t;
        elseif dist < 0 && abs(dist) > citlivost
            t = t - step_t;
        end
    end
    
end

t_list = linspace(t_start,t,bodu);
s_list = zeros(1,bodu);
h_list = zeros(1,bodu);
p_list = zeros(1,bodu);

for i = (1:bodu)
    dist = 1000;
    last = [0,0];
    smer = 1;
    krok = 500;
    
    %t0 = 150;
    
    while (dist > citlivost && krok > .00000000000001)
        %a = XSteam('v_pT',p,tlist(i));
        dist = vol - XSteam('v_pT',p,t_list(i));
        if abs(dist)<citlivost
            %continue
        elseif dist < 0
            %chci p+
            smer = 1;
            p = p + krok;
        elseif dist > 0
            %chci p-
            smer = 0;
            p = p - krok;
            %dist = abs(dist);
        elseif dist == 0
            %continue
        else %musí být nan
            if smer == 1
                p = p + .9 * krok;
            elseif smer == 0
                p = p - .9 * krok;
            end
            krok = krok * .1;
            dist = 100;
        end
        if last(2) == p
            krok = krok/10;
        end
        
        last(2) = last(1);
        last(1) = p;
        dist = abs(dist);
        %.000000000000001
        if krok < .0000000000000001
            error('out of bounds, I think')
        end
        
    end
    
    
    %t_higher(i)=tlist(i);
    s_list(i) = XSteam('s_pT',p,t_list(i));
    h_list(i) = XSteam('h_pT',p,t_list(i));
    p_list(i) = p;
end

v_end = vol;
p_end = p;
t_end = t;
n_end = n;

disp("---------------------")
disp("-_-_-_-_-_-_-_-_-_-_-")
disp(["want ", v_start, " got ", XSteam('v_ps', p_start, s_start)])
disp(["at p = ",p_start," at s = ",s_start," using ",n_start," iterations"])
disp("-")
disp(["want ", v_end, " got ", XSteam('v_pt', p_end, t)])
disp(["at p = ",p_end," at t = ",t_end," using ",n_end," iterations"])

fig = open("figs/ts_mez.fig");
hold on;
plot(s_list,t_list)
