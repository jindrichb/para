function fig = dataselection(app)

app.mem_deju.bod2_.delete_bodu();
app.mem_deju.bod1.delete_pomocne();
app.mem_deju.bod2.delete_pomocne();

len = length(app.mem_bodu);
okraj = 5;
vyska_okna = 425; % 215+140+50+4*okraj
sirka_okna = 345;
button_row_vyska = 45;
% % center of vodni para window
xpos = app.VodnpraUIFigure.Position(1) + 5;% + app.VodnpraUIFigure.Position(3)/2;
ypos = app.VodnpraUIFigure.Position(2) + 200;% + app.VodnpraUIFigure.Position(4)/2;
% xpos = app.VodnpraUIFigure.Position(1) + 5; % app.VodnpraUIFigure.Position(3)/2;
% ypos = app.VodnpraUIFigure.Position(2) + 5; % app.VodnpraUIFigure.Position(4)/2;
% shift by size of mem window
% xpos = xpos - sirka_okna/2;
% ypos = ypos - vyska_okna/2;

fig = uifigure('Position',[xpos ypos sirka_okna vyska_okna],...
    'Name', 'Uložené děje', 'CloseRequestFcn', @mCloseRequest, 'Resize', 'Off');
% calc sizes
lbox_vyska = vyska_okna - 3 * okraj - button_row_vyska;
lbox_sirka = 150;
stav_vyska = 215;
stav_sirka = 180;
lbox_y_position = 2 * okraj + button_row_vyska;

% list box panel
lbox_panel = uipanel('Parent', fig, 'Title', 'Paměť stavů a dějů',...
    'FontSize', 13, 'FontWeight', 'bold');
lbox_panel.Position =  [okraj lbox_y_position lbox_sirka lbox_vyska];

% stav panel
stav_panel = uipanel('Parent', fig, 'Title', 'Parametry zvoleného stavu',...
    'FontSize', 13, 'FontWeight', 'bold');
stav_panel.Position =  [2*okraj+lbox_sirka lbox_y_position+140+okraj stav_sirka stav_vyska];

% dejove veliciny panel
dj_panel = uipanel('Parent', fig, 'Title', 'Parametry zvoleného děje',...
    'FontSize', 13, 'FontWeight', 'bold');
dj_panel.Position =  [2*okraj+lbox_sirka lbox_y_position stav_sirka 140];

% create button panel
button_panel = uipanel(fig);
button_panel.Position =  [0 0 sirka_okna, button_row_vyska];

% Create GridLayout for t,p,v,h,s,x,u fields, labels and units
GridLayout = uigridlayout(stav_panel);
GridLayout.ColumnWidth = {'0x', '0.1x', '.9x', '1x'};
GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
GridLayout.ColumnSpacing = 5;
GridLayout.RowSpacing = 5;

% dj grid
dj_grid = uigridlayout(dj_panel);
dj_grid.ColumnWidth = {'0x', '0.23x', '.9x', '.9x'};
dj_grid.RowHeight = {'1x', '1x', '1x', '1x'};
dj_grid.ColumnSpacing = 5;
dj_grid.RowSpacing = 5;

% button grid
button_grid = uigridlayout(button_panel);
button_grid.ColumnWidth = {'1x', '1x', '1x', '1x'};%, '1x', '1x', '1x', '1x'};
button_grid.RowHeight = {'1x'};

% ok button
ok_button = uibutton(button_grid);
ok_button.Text = "Ok";
ok_button.FontWeight = 'bold';
ok_button.Layout.Row = 1;
ok_button.Layout.Column = 1;
ok_button.ButtonPushedFcn = @ok_button_pushed;

% cancel button
cancel_button = uibutton(button_grid);
cancel_button.Text = "Cancel";
cancel_button.FontWeight = 'bold';
cancel_button.Layout.Row = 1;
cancel_button.Layout.Column = 3;
cancel_button.ButtonPushedFcn = @cancel_button_pushed;

% del button
% resets EVERYTHING including memory
del_button = uibutton(button_grid);
del_button.Text = "Vymaž děj";
del_button.FontWeight = 'bold';
del_button.Enable = 'on';
del_button.Layout.Row = 1;
del_button.Layout.Column = 2;
del_button.ButtonPushedFcn = @del_button_pushed;

% clipboard button
copy_button = uibutton(button_grid);
copy_button.Text = "Copy";
copy_button.FontWeight = 'bold';
copy_button.Layout.Row = 1;
copy_button.Layout.Column = 4;
copy_button.ButtonPushedFcn = @copy_button_pushed;
% Create List Box
lbox = uilistbox(lbox_panel,...
    'Items', {},...
    'ItemsData', [],...
    'Position',[0 0 lbox_sirka lbox_vyska-19],...
    'ValueChangedFcn', @selectionChanged);

% load data
load_data(app.mem_bodu);


% sloupec stavových veličin -----------------------------------------------

% Create EditFieldLabel(s)
tEditFieldLabel = uilabel('Parent', GridLayout);
tEditFieldLabel.HorizontalAlignment = 'right';
tEditFieldLabel.Text = 't';
tEditFieldLabel.Layout.Row = 1;
tEditFieldLabel.Layout.Column = 2;

pEditFieldLabel = uilabel('Parent', GridLayout);
pEditFieldLabel.HorizontalAlignment = 'right';
pEditFieldLabel.Text = 'p';
pEditFieldLabel.Layout.Row = 2;
pEditFieldLabel.Layout.Column = 2;

vEditFieldLabel = uilabel('Parent', GridLayout);
vEditFieldLabel.HorizontalAlignment = 'right';
vEditFieldLabel.Text = 'v';
vEditFieldLabel.Layout.Row = 3;
vEditFieldLabel.Layout.Column = 2;

hEditFieldLabel = uilabel('Parent', GridLayout);
hEditFieldLabel.HorizontalAlignment = 'right';
hEditFieldLabel.Text = 'h';
hEditFieldLabel.Layout.Row = 4;
hEditFieldLabel.Layout.Column = 2;

sEditFieldLabel = uilabel('Parent', GridLayout);
sEditFieldLabel.HorizontalAlignment = 'right';
sEditFieldLabel.Text = 's';
sEditFieldLabel.Layout.Row = 5;
sEditFieldLabel.Layout.Column = 2;

xEditFieldLabel = uilabel('Parent', GridLayout);
xEditFieldLabel.HorizontalAlignment = 'right';
xEditFieldLabel.Text = 'x';
xEditFieldLabel.Layout.Row = 6;
xEditFieldLabel.Layout.Column = 2;

uEditFieldLabel = uilabel('Parent', GridLayout);
uEditFieldLabel.HorizontalAlignment = 'right';
uEditFieldLabel.Text = 'u';
uEditFieldLabel.Layout.Row = 7;
uEditFieldLabel.Layout.Column = 2;

% Create EditField(s)
tEditField = uieditfield(GridLayout, 'numeric');
tEditField.Editable = 'off';
tEditField.BackgroundColor = [0.902 0.902 0.902];
tEditField.Layout.Row = 1;
tEditField.Layout.Column = 3;
tEditField.Value = -1;

pEditField = uieditfield(GridLayout, 'numeric');
pEditField.Editable = 'off';
pEditField.BackgroundColor = [0.902 0.902 0.902];
pEditField.Layout.Row = 2;
pEditField.Layout.Column = 3;
pEditField.Value = -1;

vEditField = uieditfield(GridLayout, 'numeric');
vEditField.Editable = 'off';
vEditField.BackgroundColor = [0.902 0.902 0.902];
vEditField.Layout.Row = 3;
vEditField.Layout.Column = 3;
vEditField.Value = -1;

hEditField = uieditfield(GridLayout, 'numeric');
hEditField.Editable = 'off';
hEditField.BackgroundColor = [0.902 0.902 0.902];
hEditField.Layout.Row = 4;
hEditField.Layout.Column = 3;
hEditField.Value = -1;

sEditField = uieditfield(GridLayout, 'numeric');
sEditField.Editable = 'off';
sEditField.BackgroundColor = [0.902 0.902 0.902];
sEditField.Layout.Row = 5;
sEditField.Layout.Column = 3;
sEditField.Value = -1;

xEditField = uieditfield(GridLayout, 'numeric');
xEditField.Editable = 'off';
xEditField.BackgroundColor = [0.902 0.902 0.902];
xEditField.Layout.Row = 6;
xEditField.Layout.Column = 3;
xEditField.Value = -1;

uEditField = uieditfield(GridLayout, 'numeric');
uEditField.Editable = 'off';
uEditField.BackgroundColor = [0.902 0.902 0.902];
uEditField.Layout.Row = 7;
uEditField.Layout.Column = 3;
uEditField.Value = -1;

% edit field number formats
% https://www.mathworks.com/help/matlab/matlab_prog/formatting-strings.html
tEditField.ValueDisplayFormat = '%5.5g';
pEditField.ValueDisplayFormat = '%5.5g';
vEditField.ValueDisplayFormat = '%5.5g';
hEditField.ValueDisplayFormat = '%5.5g';
sEditField.ValueDisplayFormat = '%5.2f';
xEditField.ValueDisplayFormat = '%5.2f';
uEditField.ValueDisplayFormat = '%5.2f';

% create unit drop downs
dd_p_t = uidropdown(GridLayout);
dd_p_t.Items = {'°C', 'K'};
dd_p_t.ValueChangedFcn = @dd_p_tValueChanged;
dd_p_t.Layout.Row = 1;
dd_p_t.Layout.Column = 4;
dd_p_t.Value = app.mem_bodu(len).units.t;

dd_p_p = uidropdown(GridLayout);
dd_p_p.Items = {'Pa', 'kPa', 'MPa', 'bar'};
dd_p_p.ValueChangedFcn = @dd_p_pValueChanged;
dd_p_p.Layout.Row = 2;
dd_p_p.Layout.Column = 4;
dd_p_p.Value = app.mem_bodu(len).units.p;

dd_p_v = uidropdown(GridLayout);
dd_p_v.Items = {'dm3/kg', 'm3/kg'};
dd_p_v.ValueChangedFcn = @dd_p_vValueChanged;
dd_p_v.Layout.Row = 3;
dd_p_v.Layout.Column = 4;
dd_p_v.Value = app.mem_bodu(len).units.v;

dd_p_h = uidropdown(GridLayout);
dd_p_h.Items = {'J/kg', 'kJ/kg'};
dd_p_h.ValueChangedFcn = @dd_p_hValueChanged;
dd_p_h.Layout.Row = 4;
dd_p_h.Layout.Column = 4;
dd_p_h.Value = app.mem_bodu(len).units.h;

dd_p_s = uidropdown(GridLayout);
dd_p_s.Items = {'J/kg/K', 'kJ/kg/K'};
dd_p_s.ValueChangedFcn = @dd_p_sValueChanged;
dd_p_s.Layout.Row = 5;
dd_p_s.Layout.Column = 4;
dd_p_s.Value = app.mem_bodu(len).units.s;

dd_p_x = uidropdown(GridLayout);
dd_p_x.Items = {'-'};
dd_p_x.Layout.Row = 6;
dd_p_x.Layout.Column = 4;
dd_p_x.Value = '-';

dd_p_u = uidropdown(GridLayout);
dd_p_u.Items = {'J/kg', 'kJ/kg'};
dd_p_u.ValueChangedFcn = @dd_p_uValueChanged;
dd_p_u.Layout.Row = 7;
dd_p_u.Layout.Column = 4;
dd_p_u.Value = app.mem_bodu(len).units.u;

%--------------------------------------------------------------------------
% dj sloupec
lendj = length(app.mem_djvelicin);
% dj labels
txtEditField = uilabel(dj_grid);
txtEditField.Layout.Row = 1;
txtEditField.Layout.Column = [3,4];
txtEditField.Text = "";
txtEditField.Interpreter = 'latex';


woEditFieldLabel = uilabel('Parent', dj_grid);
woEditFieldLabel.HorizontalAlignment = 'right';
woEditFieldLabel.Text = 'wo';
woEditFieldLabel.Layout.Row = 3;
woEditFieldLabel.Layout.Column = 2;

qEditFieldLabel = uilabel('Parent', dj_grid);
qEditFieldLabel.HorizontalAlignment = 'right';
qEditFieldLabel.Text = 'q';
qEditFieldLabel.Layout.Row = 2;
qEditFieldLabel.Layout.Column = 2;

wtEditFieldLabel = uilabel('Parent', dj_grid);
wtEditFieldLabel.HorizontalAlignment = 'right';
wtEditFieldLabel.Text = 'wt';
wtEditFieldLabel.Layout.Row = 4;
wtEditFieldLabel.Layout.Column = 2;

% dj edit fields
qEditField = uieditfield(dj_grid, 'numeric');
qEditField.Editable = 'off';
qEditField.BackgroundColor = [0.902 0.902 0.902];
qEditField.Layout.Row = 2;
qEditField.Layout.Column = 3;
qEditField.Value = app.mem_djvelicin(lendj).q;

woEditField = uieditfield(dj_grid, 'numeric');
woEditField.Editable = 'off';
woEditField.BackgroundColor = [0.902 0.902 0.902];
woEditField.Layout.Row = 3;
woEditField.Layout.Column = 3;
woEditField.Value = app.mem_djvelicin(lendj).wo;

wtEditField = uieditfield(dj_grid, 'numeric');
wtEditField.Editable = 'off';
wtEditField.BackgroundColor = [0.902 0.902 0.902];
wtEditField.Layout.Row = 4;
wtEditField.Layout.Column = 3;
wtEditField.Value = app.mem_djvelicin(lendj).wt;

%  dj unit dds
dd_q = uidropdown(dj_grid);
dd_q.Items = {'J/kg', 'kJ/kg', 'MJ/kg'};
dd_q.ValueChangedFcn = @dd_qValueChanged;
dd_q.Layout.Row = 2;
dd_q.Layout.Column = 4;
dd_q.Value = app.mem_djvelicin(lendj).qunit;

dd_wo = uidropdown(dj_grid);
dd_wo.Items = {'J/kg', 'kJ/kg', 'MJ/kg'};
dd_wo.ValueChangedFcn = @dd_woValueChanged;
dd_wo.Layout.Row = 3;
dd_wo.Layout.Column = 4;
dd_wo.Value = app.mem_djvelicin(lendj).wounit;

dd_wt = uidropdown(dj_grid);
dd_wt.Items = {'J/kg', 'kJ/kg', 'MJ/kg'};
dd_wt.ValueChangedFcn = @dd_wtValueChanged;
dd_wt.Layout.Row = 4;
dd_wt.Layout.Column = 4;
dd_wt.Value = app.mem_djvelicin(lendj).wtunit;

%--------------------------------------------------------------------------

% units lock
dd_p_t.Enable = 'off';
dd_p_p.Enable = 'off';
dd_p_v.Enable = 'off';
dd_p_h.Enable = 'off';
dd_p_s.Enable = 'off';
dd_p_x.Enable = 'off';
dd_p_u.Enable = 'off';
dd_q.Enable = 'off';
dd_wo.Enable = 'off';
dd_wt.Enable = 'off';

load_last_item();

% dj_mem = dej_class;
bod1 = app.mem_bodu(len - 1);
bod2 = app.mem_bodu(len);

[outH_hs,outS_hs,outT_ts,outS_ts] = calc_deje(app,bod1,bod2);
[line1,numdj] = plotDeje(app,outH_hs,outS_hs,outT_ts,outS_ts,...
    bod2.zadani1,lendj,'thick');

function load_last_item()
    % load last item
    tEditField.Value = app.mem_bodu(len).t;
    pEditField.Value = app.mem_bodu(len).p;
    vEditField.Value = app.mem_bodu(len).v;
    hEditField.Value = app.mem_bodu(len).h;
    sEditField.Value = app.mem_bodu(len).s;
    xEditField.Value = app.mem_bodu(len).x;
    uEditField.Value = app.mem_bodu(len).u;
    % set(0,'defaultTextInterpreter','latex')
    % vezmi si děj
    txt = app.mem_bodu(len).zadani1;
    if app.mem_bodu(len).zadani1 == "adiabatický"
        txt = txt + " "+ "$ \eta = " + app.mem_bodu(len).zadani_ucinnost; % num2str(app.mem_bodu(len).)
    end
    txtEditField.Text = txt;
end
% ValueChangedFcn callback
function selectionChanged(src, ~)
    % Display list box data in edit field
    tEditField.Value = app.mem_bodu(src.Value).t;
    pEditField.Value = app.mem_bodu(src.Value).p;
    vEditField.Value = app.mem_bodu(src.Value).v;
    hEditField.Value = app.mem_bodu(src.Value).h;
    sEditField.Value = app.mem_bodu(src.Value).s;
    xEditField.Value = app.mem_bodu(src.Value).x;
    uEditField.Value = app.mem_bodu(src.Value).u;
    % units
    dd_p_t.Value = app.mem_bodu(src.Value).units.t;
    dd_p_p.Value = app.mem_bodu(src.Value).units.p;
    dd_p_v.Value = app.mem_bodu(src.Value).units.v;
    dd_p_h.Value = app.mem_bodu(src.Value).units.h;
    dd_p_s.Value = app.mem_bodu(src.Value).units.s;
    % app.dd_p_x.Value = data_point.units.x;
    dd_p_u.Value = app.mem_bodu(src.Value).units.u;
    % vezmi si děj vždy z druhé hodnoty v paměti
    % první zadani
    if mod(src.Value, 2) == 1
        % 1,3,5 ...
        n = src.Value+1;
    else
        n = src.Value;
    end
    % txt = string(app.mem_bodu(n).zadani1,'interpreter', 'tex');
    txt = app.mem_bodu(n).zadani1;
    if app.mem_bodu(n).zadani1 == "adiabatický"
        txt = txt + "$ \eta = " + app.mem_bodu(n).zadani_ucinnost; % num2str(app.mem_bodu(len).)
    end
    txtEditField.Text = txt;
    
    % call "thick line"
    delete(line1);
    delete(numdj);
    bod1 = app.mem_bodu(n-1);
    bod2 = app.mem_bodu(n);
    [outH_hs,outS_hs,outT_ts,outS_ts] = calc_deje(app,bod1,bod2);
    [line1,numdj] = plotDeje(app,outH_hs,outS_hs,outT_ts,outS_ts,...
        app.mem_bodu(n).zadani1,n/2,'thick');
    n = n/2;
    qEditField.Value = app.mem_djvelicin(n).q;
    woEditField.Value = app.mem_djvelicin(n).wo;
    wtEditField.Value = app.mem_djvelicin(n).wt;
    dd_q.Value = app.mem_djvelicin(n).qunit;
    dd_wo.Value = app.mem_djvelicin(n).wounit;
    dd_wt.Value = app.mem_djvelicin(n).wtunit;
end

% add line (and data) to lbox
function lbox_add_item(title, data)
    lbox.Items = [lbox.Items, title];
    lbox.ItemsData = [lbox.ItemsData, data];
    % lbox.Value = title;
end

function load_data(data)
    % reset list, juust to be sure nothing is there to make a mess
    lbox.Items = {};
    lbox.ItemsData = [];
    
    n = 0;
    for each = data
        n = n + 1;
        name = int2str(round(n/2)) ;
        if mod(n,2) == 1
            name = name + "a";
        else
            name = name + "b";
        end
        name = name + ". " + each.zadani1 + " " + each.zadani2;
        % disp(name)
        if each.zadani1 == "adiabatický"
            name = name + " (" + each.zadani_ucinnost + ")";
        end
        lbox_add_item(name, n);
    end
    % preselect last item
    len = length(app.mem_bodu);
    lbox.Value = len;
    load_last_item();
end

% Value changed function: dd_p_t
function dd_p_tValueChanged(src, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = tEditField.Value;
    mam_unit = app.mem_bodu(selected).units.t;
    a = prevod_(app,mam_val,mam_unit,'t',chci_unit);
    app.tEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).t = double(a);
    app.mem_bodu(selected).unit.t = mam_unit;
end

% Value changed function: dd_p_p
function dd_p_pValueChanged(app, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = pEditField.Value;
    mam_unit = app.mem_bodu(selected).units.p;
    a = prevod_(app,mam_val,mam_unit,'p',chci_unit);
    app.pEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).p = double(a);
    app.mem_bodu(selected).unit.p = mam_unit;
end

% Value changed function: dd_p_v
function dd_p_vValueChanged(app, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = vEditField.Value;
    mam_unit = app.mem_bodu(selected).units.v;
    a = prevod_(app,mam_val,mam_unit,'v',chci_unit);
    app.vEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).v = double(a);
    app.mem_bodu(selected).unit.v = mam_unit;
end

% Value changed function: dd_p_h
function dd_p_hValueChanged(app, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = hEditField.Value;
    mam_unit = app.mem_bodu(selected).units.h;
    a = prevod_(app,mam_val,mam_unit,'h',chci_unit);
    app.hEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).h = double(a);
    app.mem_bodu(selected).unit.h = mam_unit;
end

% Value changed function: dd_p_s
function dd_p_sValueChanged(app, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = tEditField.Value;
    mam_unit = app.mem_bodu(selected).units.s;
    a = prevod_(app,mam_val,mam_unit,'s',chci_unit);
    app.sEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).s = double(a);
    app.mem_bodu(selected).unit.s = mam_unit;
end

% Value changed function: dd_p_u
function dd_p_uValueChanged(app, event)
    selected = lbox.Value;
    chci_unit = src.Value;
    mam_val = uEditField.Value;
    mam_unit = app.mem_bodu(selected).units.u;
    a = prevod_(app,mam_val,mam_unit,'u',chci_unit);
    app.uEditField.Value = double(a);
    % and set mem
    app.mem_bodu(selected).u = double(a);
    app.mem_bodu(selected).unit.u = mam_unit;
end
function load_poc_from_mem(bod)
    if length(app.mem_bodu) >= 1
        app.NatiButton.Enable = "on";
    else
        app.NatiButton.Enable = "off";
    end
    
    app.tEditField.FontWeight = 'normal';
    app.pEditField.FontWeight = 'normal';
    app.vEditField.FontWeight = 'normal';
    app.hEditField.FontWeight = 'normal';
    app.sEditField.FontWeight = 'normal';
    app.xEditField.FontWeight = 'normal';
    app.uEditField.FontWeight = 'normal';

    app.tEditField.Value = app.mem_bodu(bod).t;
    app.pEditField.Value = app.mem_bodu(bod).p;
    app.vEditField.Value = app.mem_bodu(bod).v;
    app.hEditField.Value = app.mem_bodu(bod).h;
    app.uEditField.Value = app.mem_bodu(bod).u;
    app.sEditField.Value = app.mem_bodu(bod).s;
    app.xEditField.Value = app.mem_bodu(bod).x;

    app.dd_p_t.Value = app.mem_bodu(bod).units.t;
    app.dd_p_p.Value = app.mem_bodu(bod).units.p;
    app.dd_p_v.Value = app.mem_bodu(bod).units.v;
    app.dd_p_h.Value = app.mem_bodu(bod).units.h;
    app.dd_p_s.Value = app.mem_bodu(bod).units.s;
    % app.dd_p_x.Value = data_point.units.x;
    app.dd_p_u.Value = app.mem_bodu(bod).units.u;

    if  app.mem_bodu(bod).zadani1 == "izotermický" || app.mem_bodu(bod).zadani2 == "t"
        app.tEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "izobarický" || app.mem_bodu(bod).zadani2 == "p"
        app.pEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "izochorický" || app.mem_bodu(bod).zadani2 == "v"
        app.vEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "izoentalpický" || app.mem_bodu(bod).zadani2 == "h"
        app.hEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "izoentropický" || app.mem_bodu(bod).zadani2 == "s"
        app.sEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "???x" || app.mem_bodu(bod).zadani2 == "x"
        % děj "isox" není implementován
        app.xEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "???u" || app.mem_bodu(bod).zadani2 == "u"
        % děj "isou" není implementován
        app.uEditField.FontWeight = 'bold';
    end
    if app.mem_bodu(bod).zadani1 == "adiabatický"
        app.sEditField.FontWeight = 'bold';
    end
    
    % delete pomocnych car
    %app.mem_bodu(length(app.mem_bodu)-1).delete_pomocne()
    
    app.mem_deju.bod1.delete_pomocne();
end
function  ok_button_pushed(src,event)
    % disp('ok chief')
    selected_point_index = lbox.Value;
    load_poc_from_mem(selected_point_index);
    app.tEditField_2.Value=app.isempty_val;
    app.pEditField_2.Value=app.isempty_val;
    app.vEditField_2.Value=app.isempty_val;
    app.hEditField_2.Value=app.isempty_val;
    app.uEditField_2.Value=app.isempty_val;
    app.sEditField_2.Value=app.isempty_val;
    app.xEditField_2.Value=app.isempty_val;
    app.tEditField_2.Editable = 'on';
    app.pEditField_2.Editable = 'on';
    app.vEditField_2.Editable = 'on';
    app.hEditField_2.Editable = 'on';
    app.sEditField_2.Editable = 'on';
    app.xEditField_2.Editable = 'on';
    app.tEditField_2.BackgroundColor = [1 1 1];
    app.pEditField_2.BackgroundColor = [1 1 1];
    app.vEditField_2.BackgroundColor = [1 1 1];
    app.hEditField_2.BackgroundColor = [1 1 1];
    app.sEditField_2.BackgroundColor = [1 1 1];
    app.xEditField_2.BackgroundColor = [1 1 1];
    app.tEditField_2.FontWeight = 'normal';
    app.pEditField_2.FontWeight = 'normal';
    app.vEditField_2.FontWeight = 'normal';
    app.hEditField_2.FontWeight = 'normal';
    app.sEditField_2.FontWeight = 'normal';
    app.xEditField_2.FontWeight = 'normal';
    app.uEditField_2.FontWeight = 'normal';
    app.NatiButton.Enable = "on";
    % app.ZnovuButton.Enable = "off";
    app.DropDown.Enable = 'on';
    if strcmp(app.DropDown.Value, 'adiabatický')
        app.etaEditField.Editable = 'on';
        app.etaEditField.BackgroundColor = [1 1 1];
    end
    % app.mem_deju.bod1.delete_pomocne();
    app.mem_deju.bod2_.delete_pomocne();
    app.mem_deju.bod2_.delete_bodu();
    app.mem_deju.bod2.delete_pomocne();
    app.mem_deju.bod1.delete_pomocne();
    %app.mem_deju.bod1 = app.mem_deju.bod2;
    app.mem_deju.bod2 = bod_class;
    app.mem_deju.bod2_ = bod_class;
    
    % smazni pointer na dej plot!!!
%     app.mem_deju.dej_pointer1 = empty;
%     app.mem_deju.dej_pointer2 = empty;
    new_dj = dej_class;
    new_dj = new_dj.init__;
    new_dj.bod1 = app.mem_bodu(selected_point_index);
    %new_dj = new_dj.calc_mezi(app);
    
    app.mem_deju = new_dj;
    % recalc meze
    value = app.DropDown.Value;
    switch value
        case "izobarický"
            typ = 'p';
        case "izotermický"
            typ = 't';
        case "izochorický"
            typ = 'v';
        case "izoentropický"
            typ = 's';
        case "adiabatický"
            typ = 's';
        case "izoentalpický"
            typ = 'h';
    end
    app.mem_deju.typ_deje = typ;
    app.mem_deju = app.mem_deju.calc_mezi(app);
    app.mem_deju.apply_obj_meze(app);

    % vyroba a plot pomocnych car vybraneho bodu
    generate_pomocne_pri_nacteni(app,app.mem_deju.bod1);
    app.vypocti_pushed.d = false;
    % lock dj values panel
    app.Panel.Enable = 'off';
    app.Panel.Visible = 'off';
    
    
    delete(line1);
    delete(numdj);
    delete(fig);
end
function  cancel_button_pushed(src,event)
    % disp('as you wish')
    app.NatiButton.Enable = "on";
    delete(fig);
    
    delete(line1);
    delete(numdj);
end
function  del_button_pushed(src,event)
    % disp('ok deleting stuff')
    selected_point_index = lbox.Value;
    if mod(selected_point_index,2) == 1
        % even stav selected
        % eg. 1,3,5...
        % paired with 2,4,6...
        n1 = selected_point_index;
        n2 = selected_point_index + 1;
    else
        % odd stav selected
        % eg. 2,4,6
        % pairs with 1,3,5
        n1 = selected_point_index - 1;
        n2 = selected_point_index;
    end
    l = length(app.mem_bodu);
    app.mem_bodu = [app.mem_bodu(1:n1-1), app.mem_bodu(n2+1:l)];
    if length(app.mem_bodu) == 0
        
        replot(app)
        app.NatiButton.Enable = "off";
        % reset vals
        app.tEditField.Value=app.isempty_val;
        app.pEditField.Value=app.isempty_val;
        app.vEditField.Value=app.isempty_val;
        app.hEditField.Value=app.isempty_val;
        app.uEditField.Value=app.isempty_val;
        app.sEditField.Value=app.isempty_val;
        app.xEditField.Value=app.isempty_val;
        app.tEditField_2.Value=app.isempty_val;
        app.pEditField_2.Value=app.isempty_val;
        app.vEditField_2.Value=app.isempty_val;
        app.hEditField_2.Value=app.isempty_val;
        app.uEditField_2.Value=app.isempty_val;
        app.sEditField_2.Value=app.isempty_val;
        app.xEditField_2.Value=app.isempty_val;
        app.hold_stavu.poc = 0;
        % reset fontWeights
        app.tEditField.FontWeight = 'normal';
        app.pEditField.FontWeight = 'normal';
        app.vEditField.FontWeight = 'normal';
        app.hEditField.FontWeight = 'normal';
        app.sEditField.FontWeight = 'normal';
        app.xEditField.FontWeight = 'normal';
        app.uEditField.FontWeight = 'normal';
        app.tEditField_2.FontWeight = 'normal';
        app.pEditField_2.FontWeight = 'normal';
        app.vEditField_2.FontWeight = 'normal';
        app.hEditField_2.FontWeight = 'normal';
        app.sEditField_2.FontWeight = 'normal';
        app.xEditField_2.FontWeight = 'normal';
        app.uEditField_2.FontWeight = 'normal';
        % unlock ps
        app.tEditField.Editable = 'on';
        app.pEditField.Editable = 'on';
        app.vEditField.Editable = 'on';
        app.hEditField.Editable = 'on';
        app.sEditField.Editable = 'on';
        app.xEditField.Editable = 'on';
        app.tEditField.BackgroundColor = [1 1 1];
        app.pEditField.BackgroundColor = [1 1 1];
        app.vEditField.BackgroundColor = [1 1 1];
        app.hEditField.BackgroundColor = [1 1 1];
        app.sEditField.BackgroundColor = [1 1 1];
        app.xEditField.BackgroundColor = [1 1 1];
        % lock ks
        app.tEditField_2.Editable = 'off';
        app.pEditField_2.Editable = 'off';
        app.vEditField_2.Editable = 'off';
        app.hEditField_2.Editable = 'off';
        app.sEditField_2.Editable = 'off';
        app.xEditField_2.Editable = 'off';
        app.tEditField_2.BackgroundColor = [.9 .9 .9];
        app.pEditField_2.BackgroundColor = [.9 .9 .9];
        app.vEditField_2.BackgroundColor = [.9 .9 .9];
        app.hEditField_2.BackgroundColor = [.9 .9 .9];
        app.sEditField_2.BackgroundColor = [.9 .9 .9];
        app.xEditField_2.BackgroundColor = [.9 .9 .9];
        % vypočti ks
        app.VypotiButton.Enable = 'off';
        % hledej ps
        app.HledejButton.Enable = 'on';
        % hide dj panel     
        app.Panel.Enable = 'off';
        app.Panel.Visible = 'off';
        % lock ks znovu
        app.ZnovuButton.Enable = 'off';
        value = app.diagramDropDown.Value;
        set_plot(app,app.UIAxes,value)
        app.UloButton_2.Enable = 'off';
        app.VypotiButton.Enable = 'off';
        app.ZnovuButton.Enable = 'off';
        % lock dj dd
        app.DropDown.Enable = 'off';
        app.etaEditField.Enable = 'off';
        % calc locks
        app.can_calc.p = false;
        app.can_calc.d = false;
        app.can_move = false;
        app.vypocti_pushed.p = false;
        app.vypocti_pushed.d = false;
        app.ulo_pushed = false;
        %autozoom stuff
        app.znama_maxima.t = 400;
        app.znama_maxima.h = 2850;
        app.znama_maxima.s = 10;
        % reset limits
        app.hodnoty_minim = app.hodnoty_minim_neverchange;
        app.hodnoty_maxim = app.hodnoty_maxim_neverchange;
        app.mem_deju = dej_class;
        app.mem_djvelicin = [];
        
        app.hold_stavu.poc = 0;
        app.hold_stavu.variables = [];
        app.vypocti_pushed.p = false;
        delete(fig);
    else
        load_data(app.mem_bodu);
        replot(app);
        autozoom(app);
    end
end
function generate_pomocne_pri_nacteni(app,stav)
    typ_plotu = app.diagramDropDown.Value;
    barva = app.konst.barvy.pomocna;
    switch typ_plotu
        case 'T-s'
            % isoterma
            s = [app.hodnoty_minim_neverchange.s,app.hodnoty_maxim_neverchange.s];
            t = [stav.t,stav.t];
            l1 = plot(app.UIAxes, s, t, 'Color', barva);
            
            % isoentropa
            s = [stav.s, stav.s];
            t = [app.hodnoty_minim_neverchange.t,app.hodnoty_maxim_neverchange.t];
            l2 = plot(app.UIAxes, s, t, 'Color', barva);
        case 'h-s'
            % isoentapa
            s = [app.hodnoty_minim_neverchange.s,app.hodnoty_maxim_neverchange.s];
            h = [stav.h,stav.h];
            l1 = plot(app.UIAxes, s, h, 'Color', barva);
            
            % isoentropa
            s = [stav.s, stav.s];
            h = [app.hodnoty_minim_neverchange.h,app.hodnoty_maxim_neverchange.h];
            l2 = plot(app.UIAxes, s, h, 'Color', barva);
        case 'p-v'
            % isobara
            p = [stav.p,stav.p];
            v = [app.hodnoty_minim_neverchange.v,app.hodnoty_maxim_neverchange.v];
            l1 = plot(app.UIAxes, v, p, 'Color', barva);
            
            % isochora
            p = [app.hodnoty_minim_neverchange.p,app.hodnoty_maxim_neverchange.p];
            v = [stav.v,stav.v];
            l2 = plot(app.UIAxes, v, p, 'Color', barva);
            
    end
    app.mem_deju.bod1.pomoc_p_prvni_1 = l1;
    app.mem_deju.bod1.pomoc_p_prvni_2 = l2;
end
function mCloseRequest(fig,event)
    cancel_button_pushed(fig,event);
    delete(fig);
end
function copy_button_pushed(src,event)
    spi = lbox.Value; % selected_point_index
    if mod(spi, 2) == 1
        ps = app.mem_bodu(spi);
        ks = app.mem_bodu(spi + 1);
    else
        ps = app.mem_bodu(spi - 1);
        ks = app.mem_bodu(spi);
    end
    dj = app.mem_djvelicin(round(spi/2));
    clpboard(ps,ks,dj);
end
end