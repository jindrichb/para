function in = numcheck(in,min,max)
check = 0;
while check == 0
    if ~isnumeric(in)
        in = input('Cislo prosim.\n');
    else
        if in >= min
            if in <= max
                check = 1;
            else
                in = input('Cislo v mezich prosim.\n');
            end
        else
            in = input('Cislo v mezich prosim.\n');
        end
    end
end
