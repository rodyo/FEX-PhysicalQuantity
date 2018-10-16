function obj = changeUnit(obj,...
                          desired_unit,...
                          override_automatic_multiplier)
    % Change units of measurement for this PhysicalQuantity.
    %
    % Example: 
    %
    % L = Length(2, 'meters');   
    %
    % L = L.changeUnit('inches')  % L now uses units 'inches'. 
    %
    % P = L.changeUnit('inches')  % L still uses 'meters', while P uses
    %                               'inches'. Obviously, the actual length 
    %                               represented is identical for both.        
    %
    % This method takes a second argument, which allows overriding the 
    % SI-multiplier when the quantity is displayed. Example: 
    %
    % >> L = Length(5, 'AU')
    % L = 
    %      5 astronomical units
    %
    % >> L.changeUnit('km')
    % ans = 
    %
    %     747.9894 Gm    % <- units are 'm'; the SI multiplier is 
    %                         automatically adjusted to fit the quantity's 
    %                         value. Effectively, the 'k' is ignored.
    %
    % >> L.changeUnit('km', true)
    % ans = 
    %
    %     7.4799e+08 km  % <- SI multiplier fixed to 'k' 
    %
    % See also subsref, listUnits, resetUnit.            
    try
        
        % Rename for clarity
        subclass = class(obj);
        
        % Override flag
        if (nargin <= 2)
            override_automatic_multiplier = false;
        else
            assert(isscalar(override_automatic_multiplier) && islogical(override_automatic_multiplier),...
                   [subclass ':incorrect_argument'],...
                   'Override flag must be specified with a scalar logical.');
        end 

        % Get units of measurement, SI multipliers and dimensional 
        % powers from user-given string 
        [implied_units,...
         multipliers,...
         powers] = obj(1).convertStringToUnits(desired_unit);

        % Check for incorrect compound units 
        if nnz(obj(1).dimensions)==0 % (only applies to dimensionless quantities)
            num_units = numel(implied_units);
            num_dims  = nnz(obj(1).dimensions);
            assert(num_units == num_dims ...
                   || ( num_dims==0 && any(num_units==[0 1]) ),... 
                   [subclass ':incompatible_units'], [...
                   'The number of units implied by the specified string (%d) ',...
                   'disagrees with the number of units implied by the dimensionality ',...
                   'of the %s (%d).'],...
                   num_units, subclass, num_dims);
        end                    

        % Check dimensions                 
        implied_dims = sum([implied_units.dimensions].*powers);
        assert((isa(obj, obj(1).dimensionless) && implied_dims==0)...
               || isequal(obj(1).dimensions, implied_dims),...
               [subclass ':incompatible_dimensions'], [...
               'Dimensions implied by the given string (%s) are ',...
               'incompatible with those of a%s %s (%s).'],...
               char(implied_dims),...
               get_suffix(subclass), subclass, ...
               char(obj(1).dimensions));

        % Convert value and assign it
        if ~isempty(implied_units)                        
            [obj.current_unit] = deal(implied_units);
        else
            % NOTE: For example, Dimensionless() ends up here
            [obj.current_unit] = deal(obj.units.base_unit);
        end

        % Finish up
        [obj.given_unit]       = deal(obj.current_unit);
        [obj.given_multiplier] = deal(multipliers); 
        [obj.given_powers]     = deal(powers); 
        
        if override_automatic_multiplier
            [obj.override_automatic_multiplier] = deal(true); end
        

    catch ME                
        throwAsCaller(ME);                
    end

end
