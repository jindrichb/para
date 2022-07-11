function results = prevod_(app,mam_val,mam_unit,typ,chci_unit)
%this function changes the mam_val value according to the difference
%between input units: mam_unit and chci_unit. Returns -1 if mam_val == -1

results = -1;
%             mam_unit = app.hold_unit.unit;
%             mam_val = app.hold_unit.val;

if mam_val == -1
    return
end

switch typ
    case 't'
        mam = get_unit_val_t(app,mam_unit);
        chci = get_unit_val_t(app,chci_unit);
        diff = mam - chci;
        if diff == 0 %neprevadim
            results = mam_val;
        elseif diff == 1 %
            if mam_val == 0
                results = 0;
            else
                results = mam_val - 273.15;
            end
            app.hodnoty_minim.t = app.hodnoty_minim.t - 273.15;
            app.hodnoty_maxim.t = app.hodnoty_maxim.t - 273.15;
            
        else %diff == -1 %
            if mam_val == 0
                results = 0;
            else
                results = mam_val + 273.15;
            end
            app.hodnoty_minim.t = app.hodnoty_minim.t + 273.15;
            app.hodnoty_maxim.t = app.hodnoty_maxim.t + 273.15;
        end
        
    case 'p'
        mam = get_unit_val_p(app,mam_unit);
        chci = get_unit_val_p(app,chci_unit);
        diff = mam - chci;
        results = mam_val * 10^diff;
    case 'v'
        mam = get_unit_val_v(app,mam_unit);
        chci = get_unit_val_v(app,chci_unit);
        diff = chci - mam;
        results = mam_val * 10^diff;
    case 'h'
        mam = get_unit_val_uh(app,mam_unit);
        chci = get_unit_val_uh(app,chci_unit);
        diff = chci - mam;
        results = mam_val * 10^diff;
    case 'u'
        mam = get_unit_val_uh(app,mam_unit);
        chci = get_unit_val_uh(app,chci_unit);
        diff = chci - mam;
        results = mam_val * 10^diff;
    case 's'
        mam = get_unit_val_s(app,mam_unit);
        chci = get_unit_val_s(app,chci_unit);
        diff = chci - mam;
        results = mam_val * 10^diff;
    case 'x'
        results = mam_val;
end
end
        function ret = get_unit_val_p(~,unit)
            ret = -100;
            switch unit
                case 'bar'
                    ret = 0;
                case 'Pa'
                    ret = -5;
                case 'kPa'
                    ret = -2;
                case 'MPa'
                    ret = 1;
            end
        end
        function ret = get_unit_val_v(~,unit)
            ret = -100;
            switch unit
                case 'dm3/kg'
                    ret = 3;
                case 'm3/kg'
                    ret = 0;
            end
        end
        function ret = get_unit_val_uh(~,unit)
            ret = -100;
            switch unit
                case 'J/kg'
                    ret = 3;
                case 'kJ/kg'
                    ret = 0;
            end
        end
        function ret = get_unit_val_s(~,unit)
            ret = inf;
            switch unit
                case 'J/kg/K'
                    ret = 3;
                case 'kJ/kg/K'
                    ret = 0;
            end
        end
        function ret = get_unit_val_t(~,unit)
            ret = inf;
            switch unit
                case 'K'
                    ret = 1;
                case '°C'
                    ret = 0;
            end
        end