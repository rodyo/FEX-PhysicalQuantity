function str = convertUnitsToString(obj,...
                                    value,...
                                    units,...
                                    multipliers,...
                                    exponents)
                         
%#ok<*AGROW>
                         
    % Format options                   
    switch obj.display_format
        case 'auto'
            use_long_format = strncmpi(get(0, 'Format'), 'long', 4);
        case 'long'
            use_long_format = true;
        case 'short'
            use_long_format = false;        
    end
    
    use_negative_powers = (nnz(exponents<0) > 1);

    % Group exponents [positive negative] without affecting their sortorder
    zero      = exponents==0;   units(zero)       = [];
    positives = exponents>0;    exponents(zero)   = [];
    negatives = exponents<0;    multipliers(zero) = [];
    
    units       = [units(positives)        units(negatives)];
    multipliers = [multipliers(positives)  multipliers(negatives)];
    exponents   = [exponents(positives)    exponents(negatives)];
    
    if exponents(1)<0
        use_negative_powers = true; end
        
    % UNICODE FTW!
    one    = char(185);   quartic  = char(8308);
    square = char(178);   quintic  = char(8309);
    cube   = char(179);   sextic   = char(8310);
    cdot   = char(183);   negative = char(8315);

    % Loop through the units, adding a unit, exponent and operator to the string
    % at each iteration
    str       = '';
    num_units = numel(units);
    for ii = 1:num_units
        
        % TODO: handle first exponent negative (add "per")
        
        pwr = exponents(ii);
        
        operator = '';
        
        if use_long_format
            
            exponent = '';            
            if ii > 1
                operator = ' times ';
                if pwr < 0
                    operator = ' per '; end
            end
            
            switch abs(pwr)
                case 1, prefix = '';
                case 2, prefix = 'square ';
                case 3, prefix = 'cubic ';
                case 4, prefix = 'quartic '; 
                case 5, prefix = 'quintic '; % e.g., Crackle()
                case 6, prefix = 'sextic ';  % e.g., Pop()
                otherwise
                    exponent = sprintf('to the %dth power', abs(pwr));
            end
            
            
        else
            
            prefix = '';            
            sgn    = '';
            if pwr < 0                
                sgn = negative; end
            
            if ii > 1
                operator = cdot; end
                            
            switch abs(pwr)
                case 1, exponent = ''; if pwr<0, exponent = [sgn one]; end
                case 2, exponent = [sgn square];
                case 3, exponent = [sgn cube];
                case 4, exponent = [sgn quartic];
                case 5, exponent = [sgn quintic];
                case 6, exponent = [sgn sextic];  
                case {7 8 9}
                    exponent = [sgn char(sextic-6+abs(pwr))];
                otherwise
                    if pwr < 0
                        exponent = sprintf('^(%d)', pwr);
                    else
                        exponent = sprintf('^%d', pwr);
                    end                    
            end
            
        end
        
        use_value = 1; if ii==1, use_value = value; end 
        unit      = get_unit_string(use_value, units(ii));
        
        str = [str,...
               operator,...
               prefix,...
               char(multipliers(ii)),...
               unit,...
               exponent];        
    end
    
    if ~use_negative_powers && ~use_long_format && nnz(negatives) > 1
        str = [str ')']; end
    
    function str = get_unit_string(value,...                               
                                   unit)
                           
        use_singular = (value==1);
        if use_long_format
            if use_singular
                str = unit.long_name;
            else
                str = unit.long_name_plural_form;
            end
        else
            if ~isempty(unit.symbol)
                str = unit.symbol;
            else
                if use_singular
                    str = unit.short_name;
                else
                    str = unit.short_name_plural_form;
                end
            end
        end

    end
    
end

