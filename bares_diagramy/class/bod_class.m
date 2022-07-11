classdef bod_class
    properties
        t
        p
        v
        h
        u
        s
        x
        
        units = units_class;
        
        pripad_zadani = -1;
        zadani1 = ""
        zadani2 = ""
        zadani_ucinnost = ""
        
        %pointer na objekt figury -> bod
        bod_pointer_1 % ts
        bod_pointer_2 % hs
        
        %pointery na objekty figury -> pomocne cary
        pomoc_p_prvni_1
        pomoc_p_prvni_2
        pomoc_p_druhy_1
        pomoc_p_druhy_2
        
        %pointer na objekt popisku děje
        dj_label
    end
    methods  
        function delete_bodu(in)
            delete(in.bod_pointer_1)
            delete(in.bod_pointer_2)
            delete(in.pomoc_p_prvni_1)
            delete(in.pomoc_p_prvni_2)
            delete(in.pomoc_p_druhy_1)
            delete(in.pomoc_p_druhy_2)
        end
        function obj = vyrob_bod(obj,app)
            
            diagram1 = app.UIAxes;
            hold(diagram1, 'on')
            diagram_dd_1 = app.diagramDropDown.Value;

            switch diagram_dd_1
                case 'T-s'
                    %plot pomocnych car
                    %user_ts_para(app,diagram1,pripad,t,p,v,s,x,h,u)
                    %plot bodi
                    obj.bod_pointer_1 = plot(diagram1,obj.s,obj.t,app.point_marker, 'MarkerSize', app.point_marker_size);
                case 'h-s'
                    %user_hs_para(app,diagram1,pripad,t,p,v,s,x,h,u)
                    obj.bod_pointer_1 = plot(diagram1,obj.s,obj.h,app.point_marker, 'MarkerSize', app.point_marker_size);
                case 'p-v'
                    obj.bod_pointer_1 = plot(diagram1,obj.v,obj.p,app.point_marker, 'MarkerSize', app.point_marker_size);
            end

            hold(diagram1,'off')
            hold(diagram1,'on')
        end
        function obj = ukaz_pomocne(obj)
            %nastavi pomocne bodu obj na visible
            obj.pomoc_p_prvni_1.Visible = "on";
            obj.pomoc_p_prvni_2.Visible = "on";
            obj.pomoc_p_druhy_1.Visible = "on";
            obj.pomoc_p_druhy_2.Visible = "on";
        end
        function obj = skovej_pomocne(obj)
            %nastavi pomocne bodu obj na invisible
            obj.pomoc_p_prvni_1.Visible = "off";
            obj.pomoc_p_prvni_2.Visible = "off";
            obj.pomoc_p_druhy_1.Visible = "off";
            obj.pomoc_p_druhy_2.Visible = "off";
        end
        function delete_pomocne(in)
            delete(in.pomoc_p_prvni_1)
            delete(in.pomoc_p_prvni_2)
            delete(in.pomoc_p_druhy_1)
            delete(in.pomoc_p_druhy_2)
        end
        function obj = vyrob_pomocne(obj,app,in,varargin)
            % in = pripad zadani
            % skip_h option is for plotting adiabatic mess
            % it skips isoentalp helper line
            if nargin > 4 || nargin < 3
                error('inapropriate ammount of input arguments')
            end
            if ~isempty(obj.t)
                if strcmp(app.diagramDropDown.Value,'T-s')
                    typ = 'T-s';
                    [y1,x1,y2,x2] = user_ts(app,typ,in,obj.t,obj.p,obj.v,obj.s,obj.x,obj.h,obj.u);
                                   %user_hs(app,typ,in,    t,    p,    v,    s,    x,    h,    u)
                elseif strcmp(app.diagramDropDown.Value,'h-s')
                    typ = 'h-s';
                    [y1,x1,y2,x2] = user_hs(app,typ,in,obj.t,obj.p,obj.v,obj.s,obj.x,obj.h,obj.u);
                                   %user_hs(app,typ,in,    t,    p,    v,    s,    x,    h,    u)
                elseif strcmp(app.diagramDropDown.Value,'p-v')
                      x1 = [obj.v,obj.v];
                      y1 = [app.hodnoty_minim_neverchange.p,app.hodnoty_maxim_neverchange.p];
                      x2 = [app.hodnoty_minim_neverchange.v,app.hodnoty_maxim_neverchange.v];
                      y2 = [obj.p,obj.p];
                else 
                    error('NYI')
                end
                barva = app.konst.barvy.pomocna;
                if nargin == 3
                    obj.pomoc_p_prvni_1 = plot(app.UIAxes,x1,y1,'Color', barva);
                    obj.pomoc_p_prvni_2 = plot(app.UIAxes,x2,y2,'Color', barva);
                else
                    %has to be 4 arguments
                    if varargin{1} == "skip_h"
                        % skip_h is adiabatic option
                        obj.pomoc_p_prvni_1 = plot(app.UIAxes,x1,y1,'Color', barva);
                        obj.pomoc_p_prvni_2 = plot(app.UIAxes,x2,y2,'Color', barva);
                        
                    end
                end
            end
        end
        function [t,p,v,h,u,s,x] = getVals(obj)
            t=obj.t;
            p=obj.p;
            v=obj.v;
            h=obj.h;
            u=obj.u;
            s=obj.s;
            x=obj.x;
        end
        function [obj] = setVals(obj,t,p,v,h,u,s,x)
            obj.t=t;
            obj.p=p;
            obj.v=v;
            obj.h=h;
            obj.u=u;
            obj.s=s;
            obj.x=x;
        end
        function [obj] = setValsP(obj,in1,in2,pripad)
            [tt,pp,vv,ss,xx,hh,uu] = dopocetNeznamych(in1,in2,pripad);
            obj.t=tt;
            obj.p=pp;
            obj.v=vv;
            obj.h=hh;
            obj.u=uu;
            obj.s=ss;
            obj.x=xx;
        end
        function obj = setK(obj)
            if isempty(obj.t) || isempty(obj.p)
                warning('t or p not set!')
                return
            else
            cp = XSteam('Cp_pT',obj.p,obj.t);
            cv = XSteam('Cv_pT',obj.p,obj.t);
            obj.k = cp/cv;
            end
        end
        function r = get_pvk(obj)
            if isempty(obj.p)||isempty(obj.v)||isempty(obj.k)
                return 
            else
                r = obj.p * obj.v ^ obj.k; 
            end
        end
        function r = dist_check(obj,pripad,val,isallowed)
            switch pripad
                case 't'
                    dist = abs(obj.t - val);
                    if dist > isallowed
                        r = 0;
                    else
                        r = 1;
                    end
                case 'pvk'
                    pvk = get_pvk(obj);
                    dist = abs(pvk - val);
                    if dist > isallowed
                        r = 0;
                    else
                        r = 1;
                    end
            end
        end
        function obj = read_stavu(obj,app,stav)
            %nactene hodnoty
            switch stav
                case 'h'
                    obj.t=app.tEditField.Value;
                    obj.p=app.pEditField.Value;
                    obj.v=app.vEditField.Value;
                    obj.h=app.hEditField.Value;
                    obj.u=app.uEditField.Value;
                    obj.s=app.sEditField.Value;
                    obj.x=app.xEditField.Value;
                    %a jednotky
                    units_nactene = read_units_p(units_class,app);
                case 'd'
                    obj.t=app.tEditField_2.Value;
                    obj.p=app.pEditField_2.Value;
                    obj.v=app.vEditField_2.Value;
                    obj.h=app.hEditField_2.Value;
                    obj.u=app.uEditField_2.Value;
                    obj.s=app.sEditField_2.Value;
                    obj.x=app.xEditField_2.Value;
                    %a jednotky
                    units_nactene = read_units_d(units_class,app);
            end
            %jednotky xsteamu
            obj.units = set_xsteam_units(obj.units);
            %prevod
            obj = prevod_vsech(obj,app,units_nactene,obj.units);
        end
        function obj = prevod_vsech(obj,app,mam_u,chci_u)
            % mam_u = 'unit'
            % chci_u = 'unit'
            obj.t = prevod_(app,obj.t,mam_u.t,'t',chci_u.t);
            obj.p = prevod_(app,obj.p,mam_u.p,'p',chci_u.p);
            obj.v = prevod_(app,obj.v,mam_u.v,'v',chci_u.v);
            obj.h = prevod_(app,obj.h,mam_u.h,'h',chci_u.h);
            obj.u = prevod_(app,obj.u,mam_u.u,'u',chci_u.u);
            obj.s = prevod_(app,obj.s,mam_u.s,'s',chci_u.s);
            obj.x = obj.x;
            
        end
%         function results = kontrola_mezi_vstupu(input,minimum,maximum)
%             if input >= maximum
%                 results = maximum;
%             elseif input <= minimum
%                 results = minimum;
%             else
%                 results = input;
%             end
%         end

        %function obj = set_maxim(obj,app)
            
        
        %function
    end
end
