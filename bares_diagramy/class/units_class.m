classdef units_class
    properties
        t
        p
        v
        h
        u
        s
        x
    end
    methods
        function obj = read_units_p(obj,app)
            obj.t=app.dd_p_t.Value;
            obj.p=app.dd_p_p.Value;
            obj.v=app.dd_p_v.Value;
            obj.h=app.dd_p_h.Value;
            obj.u=app.dd_p_u.Value;
            obj.s=app.dd_p_s.Value;
            obj.x=app.dd_p_x.Value;
        end
        function obj = read_units_d(obj,app)
            obj.t=app.dd_d_t.Value;
            obj.p=app.dd_d_p.Value;
            obj.v=app.dd_d_v.Value;
            obj.h=app.dd_d_h.Value;
            obj.u=app.dd_d_u.Value;
            obj.s=app.dd_d_s.Value;
            obj.x=app.dd_d_x.Value;
        end
        function obj = set_xsteam_units(obj)
            obj.t="°C";
            obj.p="bar";
            obj.v="m3/kg";
            obj.h="kJ/kg";
            obj.u="kJ/kg";
            obj.s="kJ/kg/K";
            obj.x="";
        end
        
        
    end
end
