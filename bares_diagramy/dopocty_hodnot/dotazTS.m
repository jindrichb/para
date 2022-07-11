function in=dotazTS(pripad,varargin)
% platne vstupy 't' 'p' 'v' 'h' 's' 'x'
% mozny varargin pro omezeni teploty dotazTS('t',1)
%
%
switch pripad
    case 't'
        if  nargin == 1
            prompt = 'isoterma: teplotu prosim (0 - 700) [°C] \n';
            in=input(prompt);
            in=numcheck(in,0,700);
        else
            prompt = 'isoterma: teplotu prosim (0 - 373.945) [°C] \n';
            in=input(prompt);
            in=numcheck(in,0,373.945);
        end
    case 'p'
        if nargin == 1
            prompt = 'isobara: tlak prosim (0.001 - 100) [MPa] \n';
            in=input(prompt);
            in=numcheck(in,0.001,100);
        else
            prompt = 'isobara: tlak prosim (0.001 - 22.06373) [MPa] \n';
            in=input(prompt);
            in=numcheck(in,0.001,22.06373);
        end
    case 'v'
        prompt = 'isochora: objem prosim (0.0031712 - 100) [m^3/kg]\n';
        in=input(prompt);
        in=numcheck(in,.0031712,100);        
    case 'h'
        prompt = 'isoentalpa: entalpii prosim (0 - 4000) [kJ/kg] \n';
        in=input(prompt);
        in=numcheck(in,0,4000);
    case 's'
        prompt = 'isoentropa: entropii prosim (0 - 10) [kJ/(kg K)] \n';
        in=input(prompt);
        in=numcheck(in,0,10);
    case 'x'
        prompt = 'suchost: suchost prosim (0 - 1) [-]\n';
        in=input(prompt);
        in=numcheck(in,0,1);
end
end

