try
    a = 1;
    msg = ['adia vypocet ',num2str(12343)];
    error(msg)
catch ME
    if strcmp(ME.message(1:12),'adia vypocet')
       disp('adia') 
       disp(ME.message(14:length(ME.message)))
    else
        disp('a')
    end
end