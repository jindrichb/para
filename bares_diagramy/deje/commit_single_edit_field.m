function commit_single_edit_field(app,edfield,value)
%commit_single_edit_field(app,edfield,value)
%writes value in specified edfield
%edfield values are all strings
%first letter represents variable
%second letter represents upper = h or lower = d possition of edfield
%example: 'th' -> t stand for temperature, h stands for upper thus editting
%app.tEditfield.Value
%while: 'td' edits app.tEditField_2.Value
%list of valid edfield(s): th,ph,vh,hh,sh,xh,uh,td,pd,vd,hd,sd,xd,ud

switch edfield
    case 'th'
        app.tEditField.Value = value;
    case 'ph'
        app.pEditField.Value = value;
    case 'vh'
        app.vEditField.Value = value;
    case 'hh'
        app.hEditField.Value = value;
    case 'sh'
        app.sEditField.Value = value;
    case 'xh'
        app.xEditField.Value = value;
    case 'uh'
        app.uEditField.Value = value;
        
    case 'td'
        app.tEditField_2.Value = value;
    case 'pd'
        app.pEditField_2.Value = value;
    case 'vd'
        app.vEditField_2.Value = value;
    case 'hd'
        app.hEditField_2.Value = value;
    case 'sd'
        app.sEditField_2.Value = value;
    case 'xd'
        app.xEditField_2.Value = value;
    case 'ud'
        app.uEditField_2.Value = value;
end
end