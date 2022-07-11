function outside_limits_dialog(app,bod,typ,input_val,min_val,max_val)
d = dialog('Position',[300 300 250 150],'Name','My Dialog');

st = ['Zadaná hodnota ', typ, ' = ',...
    num2str(input_val), ' je mimo meze!',...
    newline 'Meze jsou [', num2str(min_val),...
    ',',...
    num2str(max_val),...
    ']'];

c = uicontrol('Parent',d,...
    'Style','edit',...
    'Position',[85 55 70 25],...
    'Callback',@edit_callback);

txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String',st);

apply_btn = uicontrol('Parent',d,...
    'Position',[45 20 70 25],...
    'String','Apply',...
    'Callback',@apply_button_callback);

cancel_btn = uicontrol('Parent',d,...
    'Position',[125 20 70 25],...
    'String','Cancel',...
    'Callback',@cancel_button_callback);

    function apply_button_callback(source,event)
        %ret = val;
        %edit_field =  findobj(gcf,'Tag',c);
        st = c.String;
        num = str2double(st);
        set_val(num)
        delete(d)
    end

    function cancel_button_callback(source,event)
        %cancel wel... cancels the input and returns 0
        set_val(0)
        delete(d)
    end

    function edit_callback(source,event)
        st = get(source,'String');
        num = str2double(st);
        if isempty(num)
            set(source,'string','0');
            warndlg('Input must be numerical');
        else
            if num > max_val
                warndlg(['Input must be smaller than max',max_val]);
            elseif num < min_val
                warndlg(['Input must be larger than min',min_val]);
            end
        end
    end

    function set_val(val)
        if bod == 'p'
        switch typ
            case 't'
                app.tEditField.Value = val;
            case 'p'
                app.pEditField.Value = val;
            case 'v'
                app.vEditField.Value = val;
            case 'h'
                app.hEditField.Value = val;
            case 's'
                app.sEditField.Value = val;
            case 'x'
                app.xEditField.Value = val;
            case 'u'
                app.uEditField.Value = val;
            otherwise
                warning(['unknown typ: ',typ])
                return
        end
        elseif bod == 'd'
        switch typ
            case 't'
                app.tEditField_2.Value = val;
            case 'p'
                app.pEditField_2.Value = val;
            case 'v'
                app.vEditField_2.Value = val;
            case 'h'
                app.hEditField_2.Value = val;
            case 's'
                app.sEditField_2.Value = val;
            case 'x'
                app.xEditField_2.Value = val;
            case 'u'
                app.uEditField_2.Value = val;
            otherwise
                warning(['unknown typ: ',typ])
                return
        end            
        else
            warning(['unknown "bod"',bod])
            return
        end
    end
end