function [out_h,out_s,out_T,outs2] = adiabaticky_fce(ucinnost,h1,t1,s1,h_end,s_end,p,p2)
%...

%definuj rozliseni deje (pocet bodu)
bodu = 50;
%ucinnost = ucinnost^(1/bodu);
%prealokuj si pole vysledku
%list_h = linspace(h1,h_end,bodu);
list_p = power(10,linspace(log10(p),log10(p2),bodu));
out_h = zeros(1,bodu);
out_T = zeros(1,bodu);
out_s = zeros(1,bodu);

%nastav pocatek
out_s(1) = s1;
out_T(1) = t1;
out_h(1) = h1;
if h1 > h_end % expanze
    %spocitej krok a opakuj
    %i = 2;
    for i = 2:bodu
        %carkovany bod
        p2_ = list_p(i);
        s2_ = s1;
        %h2_ = list_h(i);
        h2_ = XSteam('h_ps',p2_,s2_);
        %p2_ = XSteam('p_hs',h2_,s2_);
        %necarkovany bod
        h2 = h1 - ucinnost * (h1 - h2_);
        s2 = XSteam('s_ph',p2_,h2);
        %zapis vysledky
        out_h(i) = h2;
        out_s(i) = s2;
        out_T(i) = XSteam('T_hs',h2,s2);
    end
elseif h1 < h_end %komprese
    for i = 2:bodu
        %carkovany bod
        p2_ = list_p(i);
        s2_ = s1;
        %h2_ = list_h(i);
        h2_ = XSteam('h_ps',p2_,s2_);
        %p2_ = XSteam('p_hs',h2_,s2_);
        %necarkovany bod
        h2 = h1 + (h2_ - h1)/ucinnost;
%         if h2 > h_end
%             break
%             % disp('fish')
%         end
        s2 = XSteam('s_ph',p2_,h2);
        %zapis vysledky
        out_t = XSteam('T_ps',p2_,s2);
        if out_t > t1
            % XSteam is not exactly super precise in close proximity of 
            % x = 0, x = 1
            % so I added this filtering to remove couple funny values
            % this results in slim area where the computation will not work
            out_h(i) = h2;
            out_s(i) = s2;
            out_T(i) = out_t;
        else
            % if it is funny value we just skip it
            % example:
            % PS t=30 a x=0, adiab.děj 0,8 a chci KS p=80bar
            % gives t series [30, 28.41, 30.09, 30.12, ...]
            % this filter removes all values coresponding to t = 28.41
            out_h(i) = NaN;
            out_s(i) = NaN;
            out_T(i) = NaN;
        end
    end
end
% add "stav point" to make sure there is no gap
% out_h = [out_h, h_end];
% p = XSteam('p_hs',h_end,s_end);
% s = XSteam('s_ph',p,h_end);
% out_s = [out_s, s];
% out_T = [out_T, XSteam('T_hs',h_end,s)];
%...
out_h = out_h(~isnan(out_h));
out_s = out_s(~isnan(out_s));
out_T = out_T(~isnan(out_T));

outs2=out_s;

end
