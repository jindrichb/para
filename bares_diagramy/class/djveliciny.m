classdef djveliciny
    properties
        q = -1;
        wo = -1;
        wt = -1;
        
        qunit;
        wounit;
        wtunit;
    end
    methods
        function obj = save_djveliciny(obj,app)
            obj.q = app.qEditField.Value;
            obj.wt = app.wtEditField.Value;
            obj.wo = app.woEditField.Value;
            
            obj.qunit = app.dd_q.Value;
            obj.wounit = app.dd_wo.Value;
            obj.wtunit = app.dd_wt.Value;
        end
            
    end
end
