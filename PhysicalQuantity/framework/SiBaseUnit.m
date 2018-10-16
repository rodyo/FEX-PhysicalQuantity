classdef (Enumeration) SiBaseUnit < UnitOfMeasurement
    enumeration
        
        % Length
        L  ('dimensions', [1 0 0 0 0 0 0 0],...
            'short_name', 'm',...
            'long_name' , 'meter')
        
        % Mass
        M  ('dimensions', [0 1 0 0 0 0 0 0],...
            'short_name', 'g',... % NOTE: (Rody Oldenhuis) strictly speaking, 
            'long_name' , 'gram') % this is not correct, but it makes for a 
                                  % MUCH easier implementation.                                   
        % Time
        t  ('dimensions', [0 0 1 0 0 0 0 0],...
            'short_name', 's',...
            'long_name' , 'second')
        
        % Current
        C  ('dimensions', [0 0 0 1 0 0 0 0],...
            'short_name', 'A',...
            'long_name' , 'Amp�re',...
            'long_name_plural_form', 'Amp�re')
        
        % Temperature
        T  ('dimensions', [0 0 0 0 1 0 0 0],...
            'short_name', 'K',...
            'long_name' , 'Kelvin', ...
            'long_name_plural_form', 'Kelvin')
        
        % Luminous intensity
        I  ('dimensions', [0 0 0 0 0 1 0 0],...
            'short_name', 'cd',...
            'long_name' , 'candela', ...
            'long_name_plural_form', 'candela')
        
        % Amount of substance
        N  ('dimensions', [0 0 0 0 0 0 1 0],...
            'short_name', 'mol',...
            'long_name' , 'mol', ...
            'long_name_plural_form', 'mol')        
        
    end
end
