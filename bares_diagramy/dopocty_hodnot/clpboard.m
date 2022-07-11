function clpboard(ps, ks, dj)
    % [ps,ks,dj] = create_dummies();
    carr = {'velicina','ps','ks';...
        't (°C)',-1,-1;...
        'p (bar)',-1,-1;...
        'v (m3/kg)',-1,-1;...
        'h (kJ/kg)',-1,-1;...
        's (kJ/kg/K)',-1,-1;...
        'x (-)',-1,-1;...
        'u (kJ/kg)',-1,-1;...
        '','','';...
        'dej','dj','';...
        'q (kJ/kg)',-1,'';...
        'wo (kJ/kg)',-1,'';...
        'wt (kJ/kg)',-1,''};%cell array
    carr = stav_to_carr(carr, ps, "ps");
    carr = stav_to_carr(carr, ks, "ks");
    
    dj_str = translate_dj(ks.zadani1,ks.zadani_ucinnost);
    
    carr = dj_to_carr(carr,dj,dj_str);
    mat2clip(carr);
end

function carr = stav_to_carr(carr, stav, prefix)
    % stav = bod_class
    % prefix "ps" / "ks"
    
    if prefix == "ps"
        col = 2;%column
    elseif prefix == "ks"
        col = 3;%column
    end
    %t
    carr(2,col) = {stav.t};
    carr(3,col) = {stav.p};
    carr(4,col) = {stav.v};
    carr(5,col) = {stav.h};
    carr(6,col) = {stav.s};
    carr(7,col) = {stav.x};
    carr(8,col) = {stav.u};
end

function carr = dj_to_carr(carr,dj,prefix)
    carr(10,2) = {prefix};
    carr(11,2) = {dj.q};
    carr(12,2) = {dj.wo};
    carr(13,2) = {dj.wt};
end

function dj = translate_dj(dj,ucinnost)
    switch dj
        case "izobarický"
            dj = 'izobarický';
        case "izotermický"
            dj = 'izotermický';
        case "izochorický"
            dj = 'izochorický';
        case "izoentropický"
            dj = 'izoentropický';
        case "adiabatický"
            dj= ['adiabatický', ' (', num2str(ucinnost), ')'];
        case "izoentalpický"
            dj = 'izoentalpický';
    end 
end
function [ps,ks,dj] = create_dummies()
    ps = bod_class;
    ps = ps.setVals(500,50,2,3,4,.5,5);
    ps.units = ps.units.set_xsteam_units();
    
    ks = ps;
    ks.t = 444;
    ks.zadani1 = "adiabatický";
    ks.zadani_ucinnost = .9;
    
    dj = djveliciny;
    dj.qunit = "qunit";
    dj.wounit = "wounit";
    dj.wtunit = "wtunit";
end