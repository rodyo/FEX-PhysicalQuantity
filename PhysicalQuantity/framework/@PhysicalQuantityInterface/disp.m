function disp(obj)  
  
    dispstr = cell(numel(obj),1);
    for ii = 1:numel(obj)

        % Abbreviation
        O = obj(ii);
        U = DerivedUnitOfMeasurement( O.current_unit );
        V = O.value;
        P = O.given_powers;
        
        % Long or short?
        switch O.display_format
            case 'auto'
                use_long_format = strncmpi(get(0, 'Format'), 'long', 4);
            case 'long'
                use_long_format = true;
            case 'short'
                use_long_format = false;
        end

        % Make exceptions for the genericclass and invalid objects
        if isa(O,O.genericclass)
            % NOTE: (Rody Oldenhuis) evalc() is the only possible way in MATLAB
            % to capture command-line output. It is done here to automatically
            % comply with the current format/locale settings
            dispstr{ii} = evalc(['disp([''<< intermediate quantity ('' ',...
                                 'char(O.intermediate_dimensions) '') >>''])']);
            dispstr{ii} = regexprep(dispstr{ii}, newline(), '');        
        else

            % Displayed value: convert to current unit, and take care of any
            % applicable SI multipliers
            converted = V;                        
            
            % EXCEPTION: for some reason, time still commonly scales in the 
            % Babylonian way. To comply with the principle of least 
            % astonishment, we use that system by default instead of the
            % SI-correct way. That is of course still available by
            % explicitly asking for it via a unit conversion. 
            if isa(obj, 'Time')
                O = O.changeUnit('s');
                U = O.current_unit;
                converted = O.value;
            end
            
            if isa(obj, 'Time') && converted > 60
                
                % TODO: (Rody Oldenhuis) performance: this should only be
                % done ONCE, instead of for each object being iterated over...
                other_time_units = O.units.other_units;

                inds = cellfun(@(x)isequal(x, SystemOfUnits.babylonian),...
                               {other_time_units.system});                    
                time_multipliers = other_time_units(inds);

                [~,inds] = sort([time_multipliers.conversion_to_base], 'descend');
                time_multipliers = time_multipliers(inds);

                % In the Time() case, use the Babylonian units as multipliers
                multipliers = [time_multipliers.conversion_to_base];
                
                % Find the first fraction for which the magnitude exceeds one
                fracs = converted ./ multipliers;
                index = find(abs(fracs) >= 1, 1, 'first');
                if isempty(index) 
                    index = numel(multipliers); end
                
                % This determines the displayed value, and the displayed unit
                converted = fracs(index);
                % FIXME: (Rody Oldenhuis) move this to convertUnitsToString()
                dispname  = get_unit_string(converted,...
                                            use_long_format,...
                                            time_multipliers(index));

            % Everything else scales decadically
            else
                % Convert the quantity. This is tricky considering all the
                % multipliers and unit-exponents that may be included in the 
                % possible array of PhysicalQuantities:
                converted = converted / prod( [U.conversion_to_base] .^ P );
                
                % Get appropriate SI multiplier
                multiplier = SiMultipliersLong.none;
                if converted~=0 && isfinite(converted) && isequal(U(1).system, SystemOfUnits.metric)

                    % Get multipler strings for short/long format
                    if use_long_format
                        str = enumeration('SiMultipliersLong');
                    else
                        str = enumeration('SiMultipliersShort');
                    end

                    multipliers = double(str);

                    % Manual multiplier (1-time override initiated from subsref)
                    if O.override_automatic_multiplier
                        
                        index      = (double(O.given_multiplier(1)) == multipliers);
                        converted  = converted ./ prod(multipliers(index).^P);
                        multiplier = str(index);                         
                        
                    % Automatic multiplier detection 
                    else
                    
                        % Strip hecto/deca/deci/centi from list, unless asked for explicitly
                        if isempty(O.given_multiplier(1)) || ...
                                ~any(abs(log10(double(O.given_multiplier(1))))==[1 2])

                            % TODO (Rody Oldenhuis) make exceptions for liters etc. (hl is pretty common)

                            powers          = abs( log10(multipliers) );
                            factor_of_three = (powers~=1 & powers~=2);
                            str             = str(factor_of_three);
                            multipliers     = multipliers(factor_of_three);

                        end

    % TODO: (Rody Oldenhuis) prefer the given multiplier when the
    % value does not exceed 2 multipliers

    % TODO: (Rody Oldenhuis) The <QTY>("unit") construction should override all
    % settings and always output in the requested units

                        % Find the first fraction for which the magnitude exceeds one
                        fracs = converted ./ (multipliers.^P(1));
                        index = find(abs(fracs) >= 1, 1, 'first');
                        if isempty(index) 
                            index = numel(multipliers); end

                        % Extract new value and SI multiplier string
                        converted  = fracs(index);
                        multiplier = str(index); 
                        
                    end

                end

                % EXCEPTION: "kilogram" works a bit differently; although the
                % rest of the implementation uses the "gram" as the base unit,
                % this is technically incorrect. The only situation in which
                % this is apparent is when creating a zero-valued Mass; this has
                % to display '0 kg', and not as '0 g'.
                if converted==0 && ...
                        isa(obj, 'Mass') && ...
                        (obj.current_unit == SiBaseUnit.M)            

                    if use_long_format
                        multiplier = SiMultipliersLong.kilo;
                    else
                        multiplier = SiMultipliersShort.k;
                    end    
                end
                
                % Construct strings from units 
                M = [multiplier O.given_multiplier(2:end)];
                dispname = O.convertUnitsToString(converted, U,M,P);

            end

            % NOTE: (Rody Oldenhuis) evalc() is the only way in MATLAB to
            % capture arbitrary command line output in a variabe. It is used
            % here to automatically convert the value to a string, respecting 
            % the current FORMAT setting, locale, etc. 
            dispval = strrep(evalc('disp(converted);'), newline, '');

            % Final display string
            dispstr{ii} = sprintf('%s %s%s',...
                                  dispval,...                                  
                                  dispname);

        end     

    end
    
    % This is an array with the correct strings in the correct shape
    dispstr = reshape(dispstr, size(obj)); 
     
    % We're going to use disp() on a cellstring that has been formed by disp().
    % That means, the leading spaces will be doubled. Remove the largest common
    % number of leading spaces
    rmspaces = min(cellfun(@(x)find(~isspace(x),1,'first'), dispstr(:)))-1;
    dispstr  = regexprep(dispstr, ['^\s{' int2str(rmspaces) '}'], '');
    
    % The sizes tend to be different for different precisions. Make them 
    % all equal to eachother again
    minlen  = max(cellfun('prodofsize', dispstr(:)));
    dispstr = cellfun(@(x) sprintf(['%' int2str(minlen) 's'],x),...
                      dispstr,...
                      'UniformOutput', false);%#ok<NASGU> (used in evalc)
    
    % Let MATLAB do most of the work. It's not perfect for multi-dimensional
    % arrays, but otherwise we'd also have to overload the display() function...    
    str = evalc('disp(dispstr);');
    str = regexprep(str, '''', ' ');
    str = regexprep(str, '(:', [inputname(1) '(:']);
    disp(str);
    
end

% FIXME: (Rody Oldenhuis) UNNECESSARY; use convertUnitToString()
function str = get_unit_string(value,...
                               use_long_format,...
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

