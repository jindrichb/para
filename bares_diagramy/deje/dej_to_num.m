function dej = dej_to_num(dej)
        switch dej
            case "izobarický"
                dej = 1;
            case "izotermický"
                dej = 2;
            case "izochorický"
                dej = 3;
            case "izoentropický"
                dej = 4;
            case "adiabatický"
                dej = 5;
            case "izoentalpický"
                dej = 6;
                %todo
            otherwise
                dej = -1;
                error("unknown dej <- dej_to_num.m in deje folder")
        end
end