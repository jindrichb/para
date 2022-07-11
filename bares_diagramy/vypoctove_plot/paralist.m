%prealokuj si output dle velikosti

%Funkce která počítá více než jednu hodnotu parametrů vodní páry. Počítání
%dle XSteam. Vstup je jako do XSteam s tím, že jeden z parametrů může být
%list. Vrací "list" hodnot který odpovídá vstupu dle XSteam.

function [out]=paralist(par,input,varargin)
%kontrola počtu vstupních parametrů

velikost=size(varargin);

if velikost(2)>1 %tohle by chtělo vyrobit lépe
    error('Příliš mnoho vstupů.')
end

%mám jen 2 vstupní parametry
if velikost(2)==0
    velikost1=numel(input);
    %out=zeros(velikost1); %tohle vyrobí matici, prealokuj jinak
    for i=1:velikost1
        out(i)=XSteam(par,input(i));
    end
else
%Najde velikost vstupů. Z nich zaprvé porovnávám validitu vstupu, zadruhé
%počítám počet cyklů pro XSteam.
velikost1=numel(input);

optin=cell2mat(varargin(1));
velikost2=numel(optin);
    %mám 3 vstupní parametry
    if velikost1>1 && velikost2>1   %dva listy
        if velikost1 == velikost2
            for i=1:velikost1
                out(i)=XSteam(par,input(i),optin(i));
            end
        else    
            error('Chci jednu hodnotu a jeden list, nebo dva stejně velké listy. Dostal jsem dva různě dlouhé listy!')
        end
    elseif velikost1>1 && velikost2==1  %pokud je první parametr list
        %out=zeros(velikost1);
        for i=1:velikost1
            out(i)=XSteam(par,input(i),optin);
        end
    elseif velikost1==1 && velikost2>1  %pokud je druhý parametr list
        %out=zeros(velikost2);
        for i=1:velikost2
            out(i)=XSteam(par,input,optin(i));
        end
    elseif velikost1==1 && velikost2==1 %pokud dostanu dvě hodnoty
        out=XSteam(par,input,optin);        
    else    %pokud je to nějak jinak, nemělo by nastat ale kdo ví
        error('Neočekáívaný stav')
    end

end    
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    