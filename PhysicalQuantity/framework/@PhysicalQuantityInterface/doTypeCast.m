% Typecast; from anything to PhysicalQuantity
function new_obj = doTypeCast(obj, other, varargin)

    % Rename for better clarity
    subclass      = class(obj);
    superclass    = mfilename('class');
    argumentclass = class(other);

    % Call is a cast-to-own-type 
    if isequal(subclass, argumentclass)

        argc   = numel(varargin);
        constr = str2func(subclass);

        % No additional arguments given: just copy
        if argc==0
            new_obj = other; 

        % Only parameter/value pairs given: no unit conversion needed 
        elseif mod(argc,2)==0
            new_obj = constr(double(other), varargin{:});

        % unit + parameter/value pairs given: convert units accordingly
        else                    
            new_obj = constr(double(other),...
                             obj.base_unit,...
                             varargin{2:end});
            new_obj.changeUnit(varargin{1});
        end

        return;
    end
    
    % Call is different-type to own-type: check everything thoroughly

    % Casts are only possible between instances of PhysicalQuantities             
    assert(isa(other, superclass),...
           [subclass ':invalid_operation'],...
           'Invalid conversion from ''%s'' to ''%s''.',...
           argumentclass, subclass); 

    % Casts between types are possible iff the physical dimensions agree
    assert(isequal(argumentclass, obj(1).genericclass),...
           [subclass ':incompatible_dimensions'],...
           'Can''t convert ''%s'' to ''%s''.',...
           argumentclass, subclass);

    assert(isequal(other(1).intermediate_dimensions, obj(1).dimensions),...               
           [subclass ':incompatible_dimensions'], [...
           'Can''t create ''%s'' (dimensions %s) from a ',...
           'quantity with dimensions %s.'],...
           subclass,...
           char(obj(1).dimensions),...
           char(other(1).intermediate_dimensions));
       
    % Create the new object with the appropriate BASE units
    if numel(varargin) > 0
        new_units = varargin{1};
        if ~isempty(obj(1).units) && ~isempty(obj(1).units.base_unit)                
            varargin{1} = obj(1).units.base_unit; 
        else
            varargin{1} = SiBaseUnit(obj(1).dimensions); 
        end
    end

    constr  = str2func(class(obj));
    new_obj = constr(double(other), varargin{:});

    % Now adjust the units to the chosen units
    if numel(varargin) > 0
        new_obj = new_obj.changeUnit(new_units); end

end
