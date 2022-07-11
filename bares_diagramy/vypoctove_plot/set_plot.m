function set_plot(~,plot,value)
cla(plot)
if strcmp(value,'T-s')
    fig = openfig('figs\ts_mez.fig','invisible');
    ax = findobj(fig,'Type','Axes');
    copyobj(ax.Children,plot)
    set(plot, 'XScale', 'linear')
    ylabel(plot,'t (°C)')
    xlabel(plot,'s (kJ/kg/K)')
elseif strcmp(value,'h-s')
    fig = openfig('figs\hs_mez.fig','invisible');
    ax = findobj(fig,'Type','Axes');
    copyobj(ax.Children,plot)
    set(plot, 'XScale', 'linear')
    ylabel(plot,'h (kJ/kg)')
    xlabel(plot,'s (kJ/kg/K)')
elseif strcmp(value,'p-v')
    fig = openfig('figs\pv_mez.fig','invisible');
    ax = findobj(fig,'Type','Axes');
    copyobj(ax.Children,plot)
    set(plot, 'XScale', 'log')
    ylabel(plot,'p (bar)')
    xlabel(plot,'v (m3/kg)')
end
end