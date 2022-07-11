function autozoom(app,varargin)
%autozoom
%...
%description is yet to be written
konst = 1.05; % space "above max value"

default_max_t = 400/1.05;
default_min_t = 0;
default_max_s = 10;
default_min_s = 0;
default_max_h = 3000/1.05;
default_min_h = 0;


ratio_ts = 400 / 10;
ratio_hs = 2850 / 10;

% load current vals
% start with checking for koncobý bod
some_points = app.mem_bodu;
t = app.tEditField_2.Value;
% p = app.pEditField_2.Value;
% v = app.vEditField_2.Value;
h = app.hEditField_2.Value;
s = app.sEditField_2.Value;

if t > 0 && h >0 && s > 0
    point_not_in_mem = bod_class;
    point_not_in_mem.t = t;
    point_not_in_mem.h = h;
    point_not_in_mem.s = s;
    some_points = [some_points, point_not_in_mem];
end

% and find max and min vals
% t
max_t = 0;
min_t = 1000;
for ob = some_points
    if ob.t > max_t
        max_t = ob.t;
    end
    if ob.t < min_t
        min_t = ob.t;
    end
end

% h
max_h = 0;
min_h = 1000;
for ob = some_points
    if ob.h > max_h
        max_h = ob.h;
    end
    if ob.h < min_h
        min_h = ob.h;
    end
end

% s
max_s = 0;
min_s = 1000;
for ob = some_points
    if ob.s > max_s
        max_s = ob.s;
    end
    if ob.s < min_s
        min_s = ob.s;
    end
end

% max_s = max_s * konst;
% min_t = min_t - max_t * (konst - 1);
% min_h = min_h - max_h * (konst - 1);
% min_s = min_s - max_s * (konst - 1);

% select which limit is going to apply
max_t = max([max_t, default_max_t, app.tEditField.Value]);
max_h = max([max_h, default_max_h, app.hEditField.Value]);
%max_s = max([max_s, default_max_s, app.sEditField.Value]);
max_s = default_max_s;

% and add some free space around points
max_t = max_t * konst;
max_h = max_h * konst;

%min_t = min(min_t,default_min_t);
%min_h = min(min_h,default_min_h);
%min_s = min(min_s,default_min_s);

min_t = default_min_t;
min_h = default_min_h;
min_s = default_min_s;

app.znama_maxima.t = max_t;
app.znama_maxima.h = max_h;

if max_s < max_t / ratio_ts
    %app.znama_maxima.s = max_s;
    app.znama_maxima.s = max_t / ratio_ts;
else
    app.znama_maxima.s = max_s;

    app.znama_maxima.t = app.znama_maxima.s * ratio_ts;
    app.znama_maxima.h = app.znama_maxima.s * ratio_hs;
end
%app.znama_maxima.s = max([s1,s2,s3]);
if nargin == 1
    if app.diagramDropDown.Value == "T-s"
        app.UIAxes.XLim = [min_s,max_s];
        app.UIAxes.YLim = [min_t,max_t];
    elseif app.diagramDropDown.Value == "h-s"
        app.UIAxes.XLim = [min_s,max_s];
        app.UIAxes.YLim = [min_h,max_h];
    elseif app.diagramDropDown.Value == "p-v"
        warning("to do better pv limits -> autozoom")
        app.UIAxes.XLim = [0,200];
        app.UIAxes.YLim = [0,1000];
    end
elseif nargin == 2
    if app.diagramDropDown.Value == "T-s"
        varargin{1}.CurrentAxes.XLim = [min_s,max_s];
        varargin{1}.CurrentAxes.YLim = [min_t,max_t];
    elseif app.diagramDropDown.Value == "h-s"
        varargin{1}.CurrentAxes.XLim = [min_s,max_s];
        varargin{1}.CurrentAxes.YLim = [min_h,max_h];
    elseif app.diagramDropDown.Value == "p-v"
        warning("to do better pv limits -> autozoom")
        varargin{1}.CurrentAxes.XLim = [0,200];
        varargin{1}.CurrentAxes.YLim = [0,1000];
    end
end
% there used to be two graphs
% if app.diagramDropDown_2.Value == "T-s"
%     app.UIAxes_2.XLim = [min_s,max_s];
%     app.UIAxes_2.YLim = [min_t,max_t];
% elseif app.diagramDropDown_2.Value == "h-s"
%     app.UIAxes_2.XLim = [min_s,max_s];
%     app.UIAxes_2.YLim = [min_h,max_h];
% elseif app.diagramDropDown_2.Value == "p-v"
%     warning("NYI")
% end

% app.UIAxes_2.XLim = [min_s,max_s];
% app.UIAxes_2.YLim = [min_h,max_h];


end