function [converted_value,...
          unit_str] = getDisplayedUnit(obj)
        
    U = DerivedUnitOfMeasurement( obj.current_unit );
    V = obj.value;
    P = obj.given_powers;

    % Long or short?
    switch obj.display_format
        case 'auto'
            use_long_format = strncmpi(get(0, 'Format'), 'long', 4);
        case 'long'
            use_long_format = true;
        case 'short'
            use_long_format = false;
    end

    % Displayed value: convert to current unit, and take care of any
    % applicable SI multipliers
    converted_value = V;                        

    % EXCEPTION: for some reason, time still commonly scales in the 
    % Babylonian way. To comply with the principle of least 
    % astonishment, we use that system by default instead of the
    % SI-correct way. That is of course still available by
    % explicitly asking for it via a unit conversion. 
    if isa(obj, 'Time')
        obj = obj.changeUnit('s');
        U = obj.current_unit;
        converted_value = obj.value;
    end

    if isa(obj, 'Time') && converted_value > 60

        % TODO: (Rody Oldenhuis) performance: this should only be
        % done ONCE, instead of for each object being iterated over...
        other_time_units = obj.units.other_units;

        inds = cellfun(@(x)isequal(x, SystemOfUnits.babylonian),...
                       {other_time_units.system});                    
        time_multipliers = other_time_units(inds);

        [~,inds] = sort([time_multipliers.conversion_to_base], 'descend');
        time_multipliers = time_multipliers(inds);

        % In the Time() case, use the Babylonian units as multipliers
        multipliers = [time_multipliers.conversion_to_base];

        % Find the first fraction for which the magnitude exceeds one
        fracs = converted_value ./ multipliers;
        index = find(abs(fracs) >= 1, 1, 'first');
        if isempty(index) 
            index = numel(multipliers); end

        % This determines the displayed value, and the displayed unit
        converted_value = fracs(index);
        % FIXME: (Rody Oldenhuis) move this to convertUnitsToString()
        unit_str  = get_unit_string(converted_value,...
                                    use_long_format,...
                                    time_multipliers(index));

    % Everything else scales decadically
    else

        % Convert the quantity. This is tricky considering all the
        % multipliers and unit-exponents that may be included in the 
        % possible array of PhysicalQuantities:
        converted_value = converted_value / prod( [U.conversion_to_base] .^ P );

        % Get appropriate SI multiplier
        multiplier = SiMultipliersLong.none;
        if converted_value~=0 && isfinite(converted_value) && isequal(U(1).system, SystemOfUnits.metric)

            % Get multipler strings for short/long format
            str = enumeration('SiMultipliersShort');
            if use_long_format
                str = enumeration('SiMultipliersLong'); end

            multipliers = double(str);

            % Manual multiplier (override initiated from subsref)
            if obj.override_automatic_multiplier

                index      = (double(obj.given_multiplier(1)) == multipliers);
                converted_value  = converted_value ./ prod(multipliers(index).^P);
                multiplier = str(index);                         

            % Automatic multiplier detection 
            else

                % Strip hecto/deca/deci/centi from list, unless asked for explicitly
                if isempty(obj.given_multiplier(1)) || ...
                        ~any(abs(log10(double(obj.given_multiplier(1))))==[1 2])

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
                fracs = converted_value ./ (multipliers.^abs(P(1)));
                index = find(abs(fracs) >= 1, 1, 'first');
                if isempty(index) 
                    index = numel(multipliers); end

                % Extract new value and SI multiplier string
                converted_value  = fracs(index);
                multiplier = str(index); 

            end

        end

        % EXCEPTION: "kilogram" works a bit differently; although the
        % rest of the implementation uses the "gram" as the base unit,
        % this is technically incorrect. The only situation in which
        % this is apparent is when creating a zero-valued Mass; this has
        % to display '0 kg', and not as '0 g'.
        if converted_value==0 && ...
                isa(obj, 'Mass') && ...
                (obj.current_unit == SiBaseUnit.M)            

            if use_long_format
                multiplier = SiMultipliersLong.kilo;
            else
                multiplier = SiMultipliersShort.k;
            end    
        end

        % Construct strings from units 
        M = [multiplier obj.given_multiplier(2:end)];
        unit_str = obj.convertUnitsToString(converted_value, U,M,P);

    end

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
