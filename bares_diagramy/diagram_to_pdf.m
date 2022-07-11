function diagram_to_pdf(app,value,mem)
%value = 'T-s';
switch value
    case 'T-s'
        diagram = openfig('figs\ts_mez.fig');
        diagram.CurrentAxes.YLabel.String = 't (°C)';
        diagram.CurrentAxes.XLabel.String = 's (kJ/kg/K)';
    case 'h-s'
        diagram = openfig('figs\hs_mez.fig');
        diagram.CurrentAxes.YLabel.String = 'h (kJ/kg)';
        diagram.CurrentAxes.XLabel.String = 's (kJ/kg/K)';
    case 'p-v'
        diagram = openfig('figs\pv_mez.fig');
        diagram.CurrentAxes.YLabel.String = 'p (bar)';
        diagram.CurrentAxes.XLabel.String = 'v (m3/kg)';
    otherwise
        warndlg('Neznámý diagram. Diagram neuložen.')
        return
end
hold on
for i = 1:length(mem)
    switch value
        case 'T-s'
            x = mem(i).s;
            y = mem(i).t;
        case 'h-s'
            x = mem(i).s;
            y = mem(i).h;
        case 'p-v'
            x = mem(i).v;
            y = mem(i).p;
    end
    plot(x,y,'marker','.','MarkerSize',15,'Color','red')
end
for i = 1:(length(mem)/2)
    b1 = mem(2*i-1);
    b2 = mem(2*i);
    [outH_hs,outS_hs,outT_ts,outS_ts] = calc_deje(app,b1,b2);
    dej = b2.zadani1;
    % plot(diagram.CurrentAxes,outS_ts,outT_ts);
    plotDeje(app,outH_hs,outS_hs,outT_ts,outS_ts,dej,i,diagram,'external');
end
diagram.CurrentAxes.XGrid = 'on';
diagram.CurrentAxes.YGrid = 'on';
diagram.CurrentAxes.XMinorGrid = 'on';
diagram.CurrentAxes.YMinorGrid = 'on';
autozoom(app,diagram);
%diagram.Visible = 'on';
%hold off
[file,path] = uiputfile('*.pdf','File Selection','diagram.pdf');
if path
    if file
        fp = [path,file];
        print(diagram, '-dpdf', fp);
        % winopen fp
        close(diagram)
    end
end















