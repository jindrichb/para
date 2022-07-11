function [min_val,max_val] = get_limits(app,variable)
switch variable
    case 't'
        min_val = app.hodnoty_minim.t;
        max_val = app.hodnoty_maxim.t;
    case 'p'
        min_val = app.hodnoty_minim.p;
        max_val = app.hodnoty_maxim.p;
    case 'v'
        min_val = app.hodnoty_minim.v;
        max_val = app.hodnoty_maxim.v;
    case 'h'
        min_val = app.hodnoty_minim.h;
        max_val = app.hodnoty_maxim.h;
    case 's'
        min_val = app.hodnoty_minim.s;
        max_val = app.hodnoty_maxim.s;
    case 'x'
        min_val = app.hodnoty_minim.x;
        max_val = app.hodnoty_maxim.x;
    case 'u'
        min_val = app.hodnoty_minim.u;
        max_val = app.hodnoty_maxim.u;
    otherwise
        warning('Unknown input')
        min_val = -1;
        max_val = -1;
end
end