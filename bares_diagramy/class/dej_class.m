classdef dej_class
    properties
        typ_deje
        bod1 
        bod2
        bod2_
        max_vals 
        min_vals 
        %pointer na plot deje
        dej_pointer1
        dej_pointer2
    end
    methods
        function obj = init__(obj)
            obj.typ_deje = '';
            obj.bod1 = bod_class;
            obj.bod2 = bod_class;
            obj.bod2_ = bod_class;
            obj.max_vals;
            obj.min_vals;
            %pointer na plot deje
            obj.dej_pointer1;
            obj.dej_pointer2;           
        end
        function obj = init_dej(obj,app,typ,odkud)
            
            obj.typ_deje = typ;
            
            obj.bod1 = bod_class;
            obj.bod2 = bod_class;
            obj.bod2_ = bod_class;
            
            obj.bod1 = obj.bod1.read_stavu(app,odkud);
            obj = obj.calc_mezi(app);
        end
        function obj = calc_deje(obj,app,iso)
            %get typ deje
            obj.typ_deje = iso;
            %get vychozi bod s prepocty
            % na jednotky xsteam
            obj.bod1 = bod_class;
            obj.bod1 = read_stavu(obj.bod1,app,'h');
            %obecne minimalni hodonty
            obj.min_vals = bod_class;
            obj.min_vals.units = set_xsteam_units(units_class);
            obj.min_vals.t = 0.1;
            %obecne maximalni hodnoty
            obj.max_vals = bod_class;
            obj.max_vals.units = set_xsteam_units(units_class);
            obj.max_vals.t = 900;
            %to do
            %calc_mezi(obj)
        end
        function obj = calc_mezi(obj,app)
            %to do:
            %   t - v
            %   t - x - vysoka t
            obj.min_vals.u = 0;
            obj.max_vals.u = 42000000;
            mok_max_t = 373.945;
            bodu = 100; %bodu pro vypocet mezi x nekterych typu deje
            switch obj.typ_deje
                case 't'
                    obj.min_vals.t = app.hodnoty_minim_neverchange.t;
                    obj.min_vals.p = app.hodnoty_minim_neverchange.p;
                    obj.min_vals.v = 0;%v_s-t -> v_ph
                    obj.min_vals.h = XSteam('h_pt',app.hodnoty_maxim_neverchange.p,obj.bod1.t);
                    %obj.min_vals.u = 0;% nikdy nezadavane
                    obj.min_vals.s = XSteam('s_pT',app.hodnoty_maxim_neverchange.p,obj.bod1.t);
                    %obj.min_vals.x = 0; x zadane nize
                    
                    obj.max_vals.t = app.hodnoty_maxim_neverchange.t;
                    obj.max_vals.p = app.hodnoty_maxim_neverchange.p;
                    obj.max_vals.v = 100000; %v_s-t
                    obj.max_vals.h = XSteam('h_pt',app.hodnoty_minim_neverchange.p,obj.bod1.t);
                    %obj.max_vals.u = 42000000;% nikdy nezadavane
                    obj.max_vals.s = XSteam('s_pT',app.hodnoty_minim_neverchange.p,obj.bod1.t);
                    %obj.max_vals.x = 1; x zadane nize
                    
                    %max teplota pro kterou umim pocitat suchost
                    %373.945°C
                    if obj.bod1.t < mok_max_t
                        obj.min_vals.x = 0;
                        obj.max_vals.x = 1;
                    else
                        %lock x
                        app.xEditField_2.Editable = 'off';
                        app.xEditField_2.BackgroundColor = [.9 .9 .9];
                        app.xEditField_2.Value = 1;
                        %warning('to do dej_class.calc_mezi case t-> x vals, somethin like rais flag to always lock x')
                    end
                
                case 'p'
                    obj.min_vals.t = app.hodnoty_minim_neverchange.t;
                    obj.min_vals.p = app.hodnoty_minim_neverchange.p;
                    obj.min_vals.v = XSteam('v_pT',obj.bod1.p,obj.min_vals.t);
                    obj.min_vals.h = XSteam('h_pT',obj.bod1.p,obj.min_vals.t);
                    %obj.min_vals.u = 
                    obj.min_vals.s = XSteam('s_ph',obj.bod1.p,obj.min_vals.h);
                    if isnan(XSteam('h_px',obj.bod1.p,0))
                        obj.min_vals.x = XSteam('x_ph',obj.bod1.p,obj.min_vals.h);
                    else
                        warning('potencialne meze mimo     dej_class -> calc_mezi -> case p')
                        obj.min_vals.x = 0;
                    end
                    obj.max_vals.t = app.hodnoty_maxim_neverchange.t;
                    obj.max_vals.p = app.hodnoty_maxim_neverchange.p;
                    obj.max_vals.v = XSteam('v_pT',obj.bod1.p,obj.max_vals.t);
                    obj.max_vals.h = XSteam('h_pT',obj.bod1.p,obj.max_vals.t);
                    %obj.max_vals.u = 
                    obj.max_vals.s = XSteam('s_ph',obj.bod1.p,obj.max_vals.h);
                    obj.max_vals.x = XSteam('x_ph',obj.bod1.p,obj.max_vals.h);
                    
                case 'v' %muzes jit cestou - spocitej dej??
                    obj.min_vals.t = app.hodnoty_minim_neverchange.t;
                    obj.min_vals.p = dopocet_p_tv(app.hodnoty_minim_neverchange.t,obj.bod1.v);
                    obj.min_vals.v = app.hodnoty_minim_neverchange.v; %case 'v' -> v nepocitam
                    obj.min_vals.h = dopocet_h_pv(obj.min_vals.p,obj.bod1.v);
                    %obj.min_vals.u = 
                    obj.min_vals.s = XSteam('s_ph',obj.min_vals.p,obj.min_vals.h);
                    obj.min_vals.x = XSteam('x_ps',obj.min_vals.p,obj.min_vals.s);
                    
                    obj.max_vals.t = app.hodnoty_maxim_neverchange.t;
                    obj.max_vals.p = dopocet_p_tv(app.hodnoty_maxim_neverchange.t,obj.bod1.v);
                    obj.max_vals.v = app.hodnoty_maxim_neverchange.v; %case 'v' -> v nepocitam
                    obj.max_vals.h = dopocet_h_pv(obj.max_vals.p,obj.bod1.v);
                    %obj.max_vals.u = 
                    obj.max_vals.s = XSteam('s_pt',obj.max_vals.p,app.hodnoty_maxim_neverchange.t);
                    %obj.max_vals.x = XSteam('x_ps',obj.max_vals.p,obj.max_vals.s);
                    obj.max_vals.x = 1;
                    
                case 'h' %h jde od tlaku po tlak
                    obj.min_vals.t = XSteam('t_ph',app.hodnoty_minim_neverchange.p,obj.bod1.h);
                    obj.min_vals.p = app.hodnoty_minim_neverchange.p;
                    obj.min_vals.v = XSteam('v_ph',app.hodnoty_minim_neverchange.p,obj.bod1.h);
                    obj.min_vals.h = app.hodnoty_minim_neverchange.h;
                    %obj.min_vals.u =
                    obj.min_vals.s = XSteam('s_ph',app.hodnoty_maxim_neverchange.p,obj.bod1.h);
                    %obj.min_vals.x = XSteam('x_ph',app.hodnoty_minim_neverchange.p,obj.bod1.h);
                    
                    obj.max_vals.t = XSteam('t_ph',app.hodnoty_maxim_neverchange.p,obj.bod1.h);
                    obj.max_vals.p = app.hodnoty_maxim_neverchange.p;
                    obj.max_vals.v = XSteam('v_ph',app.hodnoty_maxim_neverchange.p,obj.bod1.h);
                    obj.max_vals.h = app.hodnoty_maxim_neverchange.h;
                    %obj.max_vals.u = 
                    obj.max_vals.s = XSteam('s_ph',app.hodnoty_minim_neverchange.p,obj.bod1.h);
                    %obj.max_vals.x = XSteam('x_ph',app.hodnoty_maxim_neverchange.p,obj.bod1.h);
                    
                    t = linspace(app.hodnoty_minim_neverchange.t,mok_max_t,bodu);
                    x = zeros(1,bodu);
                    for i = 1:bodu
                        p = XSteam("psat_T",t(i));
                        x(i) = XSteam("x_ph",p,obj.bod1.h);
                    end
                    obj.min_vals.x = min(x);
                    obj.max_vals.x = max(x);
                case 's'
                    obj.min_vals.t = XSteam('t_ps',app.hodnoty_minim_neverchange.p,obj.bod1.s);
                    obj.min_vals.p = app.hodnoty_minim_neverchange.p;
                    obj.min_vals.v = XSteam('v_ps',app.hodnoty_minim_neverchange.p,obj.bod1.s);
                    obj.min_vals.h = XSteam('h_ps',app.hodnoty_minim_neverchange.p,obj.bod1.s);
                    %obj.min_vals.u =
                    obj.min_vals.s = app.hodnoty_minim_neverchange.s;
                    %obj.min_vals.x = 0; %to do
                    
                    obj.max_vals.t = XSteam('t_ps',app.hodnoty_maxim_neverchange.p,obj.bod1.s);
                    obj.max_vals.p = app.hodnoty_maxim_neverchange.p;
                    obj.max_vals.v = XSteam('v_ps',app.hodnoty_maxim_neverchange.p,obj.bod1.s);
                    obj.max_vals.h = XSteam('h_ps',app.hodnoty_maxim_neverchange.p,obj.bod1.s);
                    %obj.max_vals.u = 
                    obj.max_vals.s = app.hodnoty_maxim_neverchange.s;
                    %obj.max_vals.x = 1; %to do
                    
                    t = linspace(app.hodnoty_minim_neverchange.t,mok_max_t,bodu);
                    x = zeros(1,bodu);
                    for i = 1:bodu
                        p = XSteam("psat_T",t(i));
                        x(i) = XSteam("x_ps",p,obj.bod1.s);
                    end
                    obj.min_vals.x = min(x);
                    obj.max_vals.x = max(x);
                    
                case 'x'
                    %warning('pracuji pouze s oblasti mokre pary!')
                    obj.min_vals.t = app.hodnoty_minim_neverchange.t;
                    obj.min_vals.p = app.hodnoty_minim_neverchange.p;
                    obj.min_vals.v = app.hodnoty_minim_neverchange.v;
                    obj.min_vals.h = 200;%fixthis!!! spocitej caru suchosti a najdi na ni extremy!
                    %obj.min_vals.u =
                    obj.min_vals.s = 0; %same as h
                    obj.min_vals.x = app.hodnoty_minim_neverchange.x;
                    
                    obj.max_vals.t = mok_max_t;
                    obj.max_vals.p = XSteam('psat_T',mok_max_t);
                    obj.max_vals.v = app.hodnoty_maxim_neverchange.v;
                    obj.max_vals.h = 2500; %fixthis!!!!
                    %obj.max_vals.u = 
                    obj.max_vals.s = 9.2;%...
                    obj.max_vals.x = app.hodnoty_maxim_neverchange.x;
                    warning('fix meze h,s in dej_class - calc_mezi - typ x')
                case 'u'
                    warning('Not Yet Implemented in dej_class - calc_mezi - typ u')
                    
            end            
        end
        function apply_obj_meze(obj,app)
            app.hodnoty_minim = obj.min_vals;
            app.hodnoty_maxim = obj.max_vals;
        end
        function obj = set_bod2(obj,app,pripad,varargin)
            if nargin <= 4 && nargin >= 3
            bod = bod_class;
            bod = bod.read_stavu(app,'d');
            
            %plot pomocnych
            if nargin == 3
                bod = bod.vyrob_pomocne(app,pripad);
            else
                % got varagin... (request to skip certain 'helper' line)
                %bod = bod.vyrob_pomocne(app,pripad,varargin{1,1});
                bod = bod.vyrob_pomocne(app,pripad,varargin{1,1});
            end
            
            %plot bod
            bod = bod.vyrob_bod(app);
            
            obj.bod2 = bod;
            else
                error('incompatible ammount of input arguments!')
            end
        end
        function obj = set_bod2_(obj,app,pripad,t,p,v,s,x,h,u)
            %obj = set_bod2_(obj,app,pripad,t,p,v,s,x,h,u)
            bod = bod_class;
            bod = bod.setVals(t,p,v,h,x,s,u);
                 %setVals(obj,t,p,v,h,u,s,x)
            %plot pomocnych
            %bod = bod.vyrob_pomocne(app,pripad);
            barva = app.konst.barvy.pomocna;
            if strcmp(app.diagramDropDown.Value, 'T-s')
                x = app.mem_deju.bod1.s;
                y0 = app.hodnoty_minim_neverchange.t;
                y1 = app.hodnoty_maxim_neverchange.t;
                bod.pomoc_p_prvni_1 = plot(app.UIAxes,[x,x],[y0,y1],'Color', barva);
            elseif strcmp(app.diagramDropDown.Value, 'h-s')
                x = app.mem_deju.bod1.s;
                y0 = app.hodnoty_minim_neverchange.h;
                y1 = app.hodnoty_maxim_neverchange.h;
                bod.pomoc_p_prvni_1 = plot(app.UIAxes,[x,x],[y0,y1],'Color', barva);
            else
               warning('todo pv adiabatic s helper line')
            end
            %plot bod
            bod = bod.vyrob_bod(app);
            
            obj.bod2_ = bod;
        end

    end
end

% function delete_bodu(in)
%     delete(in.bod_pointer_1)
%     delete(in.bod_pointer_2)
%     delete(in.pomoc_p_prvni_1)
%     delete(in.pomoc_p_prvni_2)
%     delete(in.pomoc_p_druhy_1)
%     delete(in.pomoc_p_druhy_2)
% end