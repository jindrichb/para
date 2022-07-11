function [line1,txt] = plotDeje(app,outH_hs,outS_hs,outT_ts,outS_ts,varargin)
isthick = false;
fig = app.UIAxes;
if nargin > 9
    error("too many input arguments")
else
    if nargin == 6
        % we get either a number -> dej tag
        %            or charlist -> dej type
        if isnumeric(varargin(1))
            dej = app.DropDown.Value;
            lbl = varargin{1};
        elseif ischar(varargin(1))
            dej = varargin{1};
            lbl = round(length(app.mem_deju)/2) + 1;
        end
    elseif nargin == 5
        % default option
        dej = app.DropDown.Value;
        lbl = round(length(app.mem_bodu)/2) + 1;
    elseif nargin == 7
        dej = varargin{1};
        lbl = varargin{2};
    elseif nargin == 8
        dej = varargin{1};
        lbl = varargin{2};
        % thickness = varargin{3};
        isthick = true;
    elseif nargin == 9
        if strcmp(varargin{4},'external')
            dej = varargin{1};
            lbl = varargin{2};
            fig = varargin{3}.CurrentAxes;
        else
            error('unkown input')
        end
    end
   
    % get plot type
    if strcmp(app.diagramDropDown.Value,'h-s')
        x1=outS_hs;
        y1=outH_hs;
    elseif strcmp(app.diagramDropDown.Value,'T-s')
        x1=outS_ts;
        y1=outT_ts;
    elseif strcmp(app.diagramDropDown.Value,'p-v')
        % warning("todo pv")
        x1 = zeros(1,length(outS_hs));
        y1 = zeros(1,length(outS_hs));
        for i = (1:length(outS_hs))
            h = outH_hs(i);
            s = outS_hs(i);
            y = XSteam('p_hs',h,s);
            x = XSteam('v_ph',y,h);
            x1(i) = x;
            y1(i) = y;
        end
        try
%             if strcmp(dej,'izochorický')
%                 [x1,y1] = filtr_pv_isochora(x1,y1);
%             end
            [x1,y1] = dist_filtr(x1,y1);
            v1 = app.mem_bodu(lbl*2-1).v;
            v2 = app.mem_bodu(lbl*2).v;
            p1 = app.mem_bodu(lbl*2-1).p;
            p2 = app.mem_bodu(lbl*2).p;
            if x1(1) < x1(length(x1)) && v1 < v2
                x1 = [v1,x1,v2];
                y1 = [p1,y1,p2];
            else
                if y1 < y1(length(y1)) && p1 < p2
                    x1 = [v1,x1,v2];
                    y1 = [p1,y1,p2];
                else
                    x1 = [v2,x1,v1];
                    y1 = [p2,y1,p1];
                end
            end
        catch ME
            %nothing?
        end
    end
    % get plot line color
    switch dej
        case 'izobarický' 
            barva = app.konst.barvy.izobaricky;
        case 'izotermický'
            barva = app.konst.barvy.izotermicky;
        case 'izochorický'
            barva = app.konst.barvy.izochoricky; 
        case 'izoentropický'
            barva = app.konst.barvy.izoentropicky; 
        case 'adiabatický'
            barva = app.konst.barvy.adiabaticky; 
        case 'izoentalpický'
            barva = app.konst.barvy.izoentalpicky; 
    end
    if length(x1) == length(y1)
        pos = round(length(x1)/2);
        font_size = 15;
        lbl = num2str(lbl);
        if isthick == false
            line1 = plot(fig,x1,y1,"LineWidth",app.linewidth, "Color", barva);
            txt = text(fig, x1(pos), y1(pos), lbl,...
                'color', barva,...
                'VerticalAlignment', 'bottom',...
                'HorizontalAlignment', 'right',...
                'FontSize', font_size);
        else
            line1 = plot(fig,x1,y1,"LineWidth",app.linewidth+2, "Color", barva);
            txt = text(fig, x1(pos), y1(pos), lbl,...
                'color', barva,...
                'VerticalAlignment', 'bottom',...
                'HorizontalAlignment', 'right',...
                'FontSize', font_size,...
                'FontWeight', 'Bold');
        end
        if pos ~= 1
            xs = x1(pos) - x1(pos - 1);
            ys = y1(pos) - y1(pos - 1);
            if xs > 0 && ys < 0 || xs < 0 && ys > 0 % +- / -+
                txt.HorizontalAlignment = 'left';
            end
        end
            
    else
        warning('plotDeje.m -> different lengths of x,y)')
        line1 = [];
        txt = '';
    end
end
end

function [x,y] = filtr_pv_isochora(x,y)
    [x,tf] = rmoutliers(x);
    y = y(~tf);
    
end
function [x_o,y_o] = dist_filtr(x,y)
diff_x = diff(log10(x));
diff_y = diff(log10(y));

diffs = sqrt(diff_x.^2 + diff_y.^2);
m = 2.5;%1.2;
%first and last values always stay
idx0 = [diffs < m,true];
idx1 = [true,diffs < m];
%disp(max(diffs))
disp(diffs(diffs>m))
disp('------')
x_o = x(idx0|idx1);
y_o = y(idx0|idx1);

end