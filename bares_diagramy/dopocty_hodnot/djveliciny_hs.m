function [q,wo,wp] = djveliciny_hs(app,h,s_h,t,s_t)
q = -1;
wo = -1;
wp = -1;

% if length(h) ~= length(s_h)
%     error('length(h) ~= length(s)')
% end

% first do numeric calc for all
try
    v = zeros(1,length(h));
    p = v;
    % p_hs
    for i = 1:length(h)
        p(i) = XSteam('p_hs',h(i),s_h(i));
    end

    % p (kPa)
    % v_ph / v_ps / v_pt
    for i = 1:length(h)
        v(i) = XSteam('v_ph',p(i),h(i));
    end
    % p (bar)
    p = p*100;
    
    wo = pdv(p,v);
    wp = vdp(p,v);
    q = sdt(s_t,t);
    if isnan(wo)
        wo = -1;
    end
    if isnan(wp)
        wp = -1;
    end
    if isnan(q)
        q = -1;
    end
catch ME
    return
end
if strcmp(app.DropDown.Value,'adiabatický')
    app.sdlenteploLabel.Text = 'dissipované teplo';
    app.qEditFieldLabel.Text = 'qdis';
else
    app.sdlenteploLabel.Text = 'sdělené teplo';
    app.qEditFieldLabel.Text = 'q';
end
% and now fix values for certain processes
try
    if strcmp(app.DropDown.Value,'izoentalpický')
        % ??
        % q = Tds
        % dwtlak = dq
        % dwibj = dwtlak - du
        
    elseif strcmp(app.DropDown.Value,'izobarický')
        wp = 0;
    elseif strcmp(app.DropDown.Value,'izochorický')
        wo = 0;
    end
    
catch ME
    return
end

end

function wo = pdv(p,v)
% objemová práce
% w = -integral(p dv)
% w (kJ/kg)
wo = -trapz(v,p);
end
function wp = vdp(p,v)
wp = -trapz(p,v);
end
function q = sdt(s,t)
q = -trapz(s,t);
end
