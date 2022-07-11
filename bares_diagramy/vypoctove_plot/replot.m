function replot(app)
len = length(app.mem_bodu);
value = app.diagramDropDown.Value;
set_plot(app,app.UIAxes,value)
if mod(len,2) == 1
    % funny size of mem
    error("mem_bodu size error")
end
len = len/2;
for i = 1:len
    % disp(2*i-1)
    % disp(2*i)
    b1 = app.mem_bodu(2*i-1);
    b2 = app.mem_bodu(2*i);
    replot_dj(app,b1,b2,i);
    b1.vyrob_bod(app);
    b2.vyrob_bod(app);
%     plot(b1.s,b1.t,app.point_marker, 'MarkerSize', app.point_marker_size);
%     plot(b2.s,b2.t,app.point_marker, 'MarkerSize', app.point_marker_size);
end
% replot pomocne
if strcmp(app.diagramDropDown.Value,'T-s')
    pripad = 5;
elseif strcmp(app.diagramDropDown.Value,'h-s')
    pripad = 2;
else
    % more diagrams are planned
    % don't want to crash the app here
    % so t-s is set as default
    pripad = 5;
end
finished = false;
if ~isempty(app.mem_deju.bod2)
    % replot pomocne 2
    if ~isempty(app.mem_deju.bod2.u)
        app.mem_deju.bod2 = app.mem_deju.bod2.vyrob_pomocne(app,pripad);
        finished = true;
    end
if ~isempty(app.mem_deju.bod1) && finished == false
    % replot pomocne 1
    app.mem_deju.bod1 = app.mem_deju.bod1.vyrob_pomocne(app,pripad);
end
hold off
end