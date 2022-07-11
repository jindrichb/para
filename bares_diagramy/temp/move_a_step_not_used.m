classdef move_a_step
    properties
        step
        last = 9999
        prelast = -9999
    end
    methods
        function [bod_out,obj] = do_s_step(obj,bod_in)
            %set input s
            s_in = XSteam('s_pt',bod_in.p,bod_in.t);
            %set input pvk
            pvk_ref = bod_in.p * bod_in.v ^ bod_in.k;
            %guess s
            s_plus = s_in + obj.step;
            s_minus = s_in - obj.step;
            %init points + and - s
            [bod_plus,bod_minus] = deal(bod);
            [bod_plus.t,bod_minus.t] = deal(bod_in.t);
            [bod_plus.s,bod_minus.s] = deal(s_plus,s_minus);
            %calc plus
            [bod_plus.p,~] = dopocet_p_st(bod_plus.s,bod_plus.t);
            bod_plus.v = XSteam('v_ps',bod_plus.p,bod_plus.s);
            bod_plus = setK(bod_plus);
            if isnan(bod_plus.k)
                bod_plus.k = bod_in.k;
                %warning('unable to find k using given pv')
            end
            pvk_plus = bod_plus.p * bod_plus.v ^ bod_plus.k;
            %calc minus
            [bod_minus.p,~] = dopocet_p_st(bod_minus.s,bod_minus.t);
            bod_minus.v = XSteam('v_ps',bod_minus.p,bod_minus.s);
            bod_minus = setK(bod_minus);
            if isnan(bod_minus.k)
                bod_minus.k = bod_in.k;
                %warning('unable to find k using given pv')
            end
            pvk_minus = bod_minus.p * bod_minus.v ^ bod_minus.k;
            %dist stuff
            dist_plus = abs(pvk_plus - pvk_ref);
            dist_minus = abs(pvk_minus - pvk_ref);
            if dist_plus > dist_minus
                %minus better
                bod_out = bod_minus;
            elseif dist_plus < dist_minus
                %plus better
                bod_out = bod_plus;
            else
                bod_out = bod_in;
                warning('s+ s- same distance away, can¨t decide which is better!');
            end
            
            %pvk_out = bod_out.p * bod_out.v ^ bod_out.k;
            %oscill stuff
            obj = kontrola_oscilace(obj,bod_out.s);
        end
        function [t_out,obj] = do_t_step(obj,t_in,t_ref)
            %set new temporary ts
            t_plus = t_in + obj.step;
            t_minus = t_in - obj.step;
            %and calc some distances
            dist_plus = abs(t_plus - t_ref);
            dist_minus = abs(t_minus - t_ref);
            %then pick the right direction to move in
            if dist_plus > dist_minus
                %minus is smaller, smaller is closer
                %closer is better
                t_out = t_minus;
            elseif dist_minus > dist_plus
                %plus is smaller...
                t_out = t_plus;
            else
                %they are the same?
                if t_in == t_ref
                    t_out = t_in;
                else
                    %I have no clue what did just happen
                    warning('isthisright?')
                end
            end
            %checks for oscialtion around the finish value of t
            obj = kontrola_oscilace(obj,t_out);
        end
        function obj = set_step(obj,val)
            obj.step = val;
        end
        function [bod_out,obj] = do_p_step(obj,bod_in,pvk_ref)
            %does a pressure step using bod class input.
            
            %init new points
            bod_plus = bod_in;
            bod_minus = bod_in;
            bod_out = bod_in;
            %set new ps
            bod_plus.p = bod_plus.p + obj.step;
            bod_minus.p = bod_minus.p - obj.step;
            %calc new ks
            bod_plus = setK(bod_plus);
            bod_minus = setK(bod_minus);
            %calc new pvks
            pvk_plus = bod_plus.p * bod_plus.v ^ bod_plus.k;
            pvk_minus = bod_minus.p * bod_minus.v ^ bod_minus.k;
            
            %calc pvk distance
            dist_plus = abs(pvk_plus - pvk_ref);
            dist_minus = abs(pvk_minus - pvk_ref);
            
            %decide which is better and pick it
            if isnan(dist_plus)
                 %dist_minus
                bod_out.p = bod_in.p - obj.step;
                obj = kontrola_oscilace(obj,pvk_minus);
            elseif isnan(dist_minus)
                %dist_plus
                bod_out.p = bod_in.p + obj.step;
                obj = kontrola_oscilace(obj,pvk_plus);
            else
                if dist_plus > dist_minus
                    %dist_minus
                    bod_out.p = bod_in.p - obj.step;
                    obj = kontrola_oscilace(obj,pvk_minus);
                elseif dist_plus < dist_minus
                    %dist_plus
                    bod_out.p = bod_in.p + obj.step;
                    obj = kontrola_oscilace(obj,pvk_plus);
                else
                    bod_out.p = bod_in.p;
                    obj = kontrola_oscilace(obj,pvk_ref);
                    warning('p+ p- same distance away, can¨t decide which is better!');
                end
            end
            %and calc new k
            bod_out = setK(bod_out);
        end
        function r = stepuj_plus(obj,in,dist)
            if dist > 0
                in=in-[obj.step];
            elseif dist < 0
                in=in+[obj.step];
            end
            r = in;
        end
        function r = stepuj_minus(obj,in,dist)
            if dist < 0
                in=in-[obj.step];
            elseif dist > 0
                in=in+[obj.step];
            end
            r = in;
        end
        function obj = halve_step(obj)
            obj.step = obj.step/2;
        end
        function obj = kontrola_oscilace(obj,val)
            if obj.prelast == val
                obj = halve_step(obj);
            end
            obj.prelast = obj.last;
            obj.last = val;
        end
        function r = step_size_check(obj,val)
            %checks the value of object.step and compares to val
            %end returns 1 if obj.step < val
            if isempty(obj.step)
                warning('object step is empty!')
                r = 1;
            elseif obj.step < val
                r = 1;
            else
                r = 0;
            end
        end
    end
end
