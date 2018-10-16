function [units,...
          multipliers,...
          powers] = convertStringToUnits(obj,...
                                         str)
    
    persistent To_Match
    persistent All_Units

    % The strings pairs to use in each parsing step. These need to be
    % instantiated, and doing that often can become prohibitively
    % expensive to do. Moreover, it is unnecessary, since it is
    % essentially constant data. Therefore, just do it once and reuse it
    % in all subsequent calls
    if isempty(To_Match)

        [sm, sm_str] = enumeration('SiMultipliersShort');
        [lm, lm_str] = enumeration('SiMultipliersLong');

        % Sorted from longest to shortest
        To_Match = {'long_name_plural_form'  lm  lm_str
                    'long_name'              lm  lm_str
                    'short_name_plural_form' sm  sm_str
                    'short_name'             sm  sm_str
                    'symbol'                 sm  sm_str};
    end
    
    % Quick exit: unit is "Dimensionless"
    if isa(obj(1), obj(1).dimensionless)
        units       = DerivedUnitOfMeasurement.empty();
        multipliers = SiMultipliersLong.none;
        powers      = 1;
        return; 
    end
    
    % Rename for clarity
    subclass = class(obj);
    
    % All available units 
    str = strtrim(str);
    
    if strcmp(str, '<>')
        % TODO: (Rody Oldenhuis) this is where the true magic happens
    else
        % obj has no specific (base) units. This happens for derived quantities 
        % like speed (m/s) or Area (m^2). In such cases, use ALL defined units 
        % to convert the string
        if isempty(obj(1).units) || isempty(obj(1).units.base_unit)
            
            if isempty(All_Units)                
                All_Units = get_units('all_units'); end            
            valid_units = All_Units; 
            
            if ~isempty(obj(1).units) ...
                    && isempty(obj(1).units.base_unit) ...
                    && ~isempty(obj(1).units.other_units)
                valid_units = [valid_units; obj(1).units.getAllUnits()]; 
            end
            
        % obj has its own units. Even derived quantities may have their own 
        % units; a force, for example is [M][L]/[T]^2, but we typically call 
        % that 'N'. In this case, use the quantity's own defined units to 
        % convert the string
        else
            valid_units = obj(1).units.getAllUnits();
        end
        
        % Make sure they're sorted long-to-short                
        [~,I] = sort( cellfun('prodofsize', {valid_units.long_name_plural_form}), 'descend');
        valid_units = valid_units(I);
    end
    
    % LEXER    

    % Prepare string for easier lexing
    string_separators   = '/*\s';
    sep    = ['['  string_separators ']'];
    notsep = ['[^' string_separators ']'];
    
    str = strtrim(str);
    
    str = regexprep(str, '\s+per\s+'  , '/', 'ignorecase');
    str = regexprep(str, '\s+/\s+'    , '/');
    
    str = regexprep(str, '\s+times\s+', '*', 'ignorecase');
    str = regexprep(str, '\s+*\s+'    , '*');
    
    str = regexprep(str, '\<cubed\>'                , '^3'  , 'ignorecase');
    str = regexprep(str, ['\<cubic\s+(' notsep '+)'], '$1^3', 'ignorecase');
    % TODO: (Rody Oldenhuis) add "cb."
    
    str = regexprep(str, '\s+to\s+the\s+'     ,   '^', 'ignorecase');
    str = regexprep(str, '\s+power\>'         ,    '', 'ignorecase');
    str = regexprep(str, ['(' sep ')third\>' ], '$13', 'ignorecase');
    str = regexprep(str, ['(' sep ')3rd\>'   ], '$13', 'ignorecase');    
    str = regexprep(str, ['(' sep ')fourth\>'], '$14', 'ignorecase');
    str = regexprep(str, ['(' sep ')forth\>' ], '$14', 'ignorecase');
    str = regexprep(str, ['(' sep ')4th\>'   ], '$14', 'ignorecase');
    str = regexprep(str, ['(' sep ')fifth\>' ], '$15', 'ignorecase');
    str = regexprep(str, ['(' sep ')5th\>'   ], '$15', 'ignorecase');
    
    
    % PARSER
    
    % The "square" or "squared" word requires a parsing step. Examples: 
    % "times square meter"
    % "sq. m"
    % "per meters squared"
    % "per square root Hertz"
    
    % Also, long unit names with spaces in them will fail: 
    % - 'astronomical unit'
    % - 'chineses miles'
    % due to premature splitting
    
    % TODO: (Rody Oldenhuis) ....that ^
    
    
    
    % Split up the string based on known separators
    [unit_strings,...
     string_separators] = regexp(str, sep, 'split', 'match');

    num_units = numel(unit_strings);
    
    % The string separators determine the powers 
    powers = ones(num_units,1);
    for ii = 1:num_units
        
        [new_unit_string,...
         caret_op] = regexp(unit_strings{ii}, '\^', 'split', 'match');
     
        if ~isempty(caret_op)
            power_int = str2double(new_unit_string{2});
            assert(~isnan(power_int),...
                   [subclass ':invalid_power'], [...
                   'Failure during unit conversion; power of ''%s'' is ',...
                   'not understood.'],...
                   new_unit_string{2});
            powers(ii) = power_int;
            unit_strings{ii} = new_unit_string{1};
        end
     
        if ii>1 && string_separators{ii-1}=='/'
            powers(ii) = -powers(ii); end        
    end
    
    % Validate and convert all unit strings
    
    units(num_units)       = DerivedUnitOfMeasurement();
    multipliers(num_units) = SiMultipliersLong.none;
    
    for ii = 1:num_units
        
        % Current unit to process
        str = unit_strings{ii};
        
        % Process, in this order: 'long-plural', 'long', 'short-plural', 'short', 'symbol'. We have
        % to ensure that the longest strings are matched first
        for kk = 1:size(To_Match,1)

            % Rename for better clarity
            match   = To_Match{kk,1};
            mults   = To_Match{kk,2};
            multstr = To_Match{kk,3};
            
            % Loop through all available units
            str_processed = false;
            for jj = 1:numel(valid_units)
                
                % Abbreviate
                U = valid_units(jj);            
                
                % Remove any non-printing/typable characters from the string to 
                % match (degrees, for example, have a symbol of '\b^o' for
                % display purposes, but this is not typically what a user would
                % type)
                to_match = U.(match);
                to_match = to_match(find(to_match > ' ', 1,'first'):end);
                
                % Prepare the search string for use in regexp
                to_match = regexptranslate('escape', to_match);

                % Find matches in the unit names, from longest to shortest
                matchind = regexp(str, [to_match '\>'], 'once');
                if ~isempty(matchind)

                    % Add the relevant unit to the end result
                    units(ii)       = U; 
                    multipliers(ii) = 1; 

                    % Remove this portion from the string
                    str(matchind + (0:length(to_match)-1)) = [];

                    % If that exhausts the string, we're done
                    if isempty(str)
                        str_processed = true; break; end
                    
                    % Look for any SI multiplier prepended directly to
                    % the unit just matched
                    multind = strcmp(str, multstr);                        
                    assert(any(multind),...
                           [subclass ':invalid_multiplier'], [...
                           'Given multiplier ''%s'' does not comply with ',...
                           'the SI-standard. Note that the multpliers are ',...
                           'case-sensitive.'],...
                           str);                           
                    assert(isequal(U.system, SystemOfUnits.metric),...
                           [subclass ':multiplier_with_nonmetric_system'], [...
                           'SI-multipliers cannot be used with non-metric units of ',...
                           'measurement.']);

                    multipliers(ii) = mults(multind);                        
                    str_processed   = true;
                    break;     

                end

            end % loop through unit of measurement fields
            
            % String exhausted; continue with next unit
            if str_processed
                break; end
            
        end % loop through all valid units
        
        % String must have been fully processed by now. If this is not the case, 
        % an invalid unit was specified
        assert(str_processed,...
               [subclass ':invalid_unit'],...
               '%s has no associated unit of measurement called ''%s''.',...
               subclass, str);        
    end

end
