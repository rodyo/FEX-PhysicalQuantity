%{

New PhysicalUnits to develop:

Epoch % MATLAB can do a lot these days; look that up
Duration % thin wrapper around MATLAB's own duration()

AngularSpeed


- Vector units have a columnVector() and rowVector() method 


Position   % 3 x Length
UnitVector % Position, but with length 1

Speed
Velocity   % = 3 x Speed

Acceleration
AccelerationVector % = 3 x Acceleration

Statevector % thin wrapper around [Position Velocity]

DimensionlessVector % = 3 x Dimensionless

AngularMomentum
AngularMomentumVector % = 3 x AngularMomentum
%}


classdef (Abstract) PhysicalQuantityInterface 

    %% Properties
    
    properties
        name           (1,:) char = '[no name]'
        display_format (1,:) char = 'auto'
    end
    
    properties (Abstract,...
                Constant)
            
        % All physical quantities have dimensions that are a permutation 
        % of the SI base units:
        % L  : Length
        % M  : Mass
        % t  : Time
        % C  : Current
        % T  : Temperature
        % I  : Luminous intensity
        % N  : amount of Substance
        % ii : Free counter to resolve unit ambiguities (e.g., both energy and torque are N�m)
        dimensions PhysicalDimension
        
        % All supported units of measurement 
        units 
        
    end
        
    properties (Access = protected)
        
        % User-specified unit of measurement & multiplier
        given_unit       % May be empty. Typically: (1,:) UnitOfMeasurement
        given_multiplier (1,:) SiMultipliersLong = SiMultipliersLong.none
        given_powers     (1,:) double            = 1 
        
        % Currently selected unit of measurement 
        current_unit % May be empty. Typically: (1,:) UnitOfMeasurement
        
        % The actual value of the unit, expressed in the base_unit
        value (1,1) double = 0
        
    end
    
    %
    properties (Access = private)
        override_automatic_multiplier (1,1) logical = false
    end
    
    % Class names for various dependencies (makes renaming them easier)
    properties (Access = private, Constant)
        genericclass    = 'PhysicalQuantity'
        unitclass       = 'UnitOfMeasurement'
        dimensionless   = 'Dimensionless'
        dimensionsclass = 'PhysicalDimension' % TODO: (Rody Oldenhuis) rename to "-s"
    end
        
    % Special, dimensions field that's settable only by the genericclass
    properties (Hidden,...
                GetAccess = protected,...
                SetAccess = ?PhysicalQuantity)
        intermediate_dimensions PhysicalDimension = PhysicalDimension()
    end
    
    
    %% Methods
    
    % Class basics
    methods 
        
        % Conctrete constructor
        function obj = PhysicalQuantityInterface(varargin)
            
            try
            
                argc = nargin;

                % Rename these things for better clarity
                subclass   = class(obj);
                superclass = mfilename('class');

                % Default units of measurement: use the base unit
                if ~isa(obj, obj.genericclass)
                    [base, pwr] = SiBaseUnit(obj.dimensions);
                    if ~isempty(obj.units) && ~isempty(obj.units.base_unit)                    
                         base = obj.units.base_unit; end
                    if ~isempty(base)
                        obj.given_powers     = pwr;
                        obj.given_multiplier = repmat(SiMultipliersLong.none,...
                                                      size(base)); 
                    end

                    obj.given_unit   = base;
                    obj.current_unit = base;
                    
                end
                
                % Special cases
                % ------------------------------------------------------------------

                % Default constructor: use base unit and a value of 0
                if argc==0
                    obj.value = 0;                    
                    return; 
                end                
                
                % Dimensionless()
                if isa(obj, obj.dimensionless)

                    % Remove this special string from the argument list
                    if nargin>=2 && (strcmp(varargin{2}, '[-]') || ...
                            isa(varargin{2}, 'BaseUnitOfMeasurement') ...
                            && isequal(varargin{2}.system, SystemOfUnits.dimensionless))
                        varargin(2) = []; 
                        argc = argc-1;
                    end

                    % Another unit may have been specified; that is an error for a
                    % Dimensionless quantity.                
                    assert(mod(argc+1,2)==0,...
                           [subclass ':incorrect_dimensionless_call'],...
                           'Do not specify a unit of measurement for %s().',...
                           obj.dimensionless);

                    % Add it back in so that all the rest doesn't trip over it
                    if ~isa(varargin{1}, obj.dimensionless)
                        varargin = {varargin{1} '[-]' varargin{2:end}};
                        argc = argc+1;
                    end

                end  
                
                % Copy-constructor/cast operator, or initialize zero-valued object
                if argc==1 
                    
                    pq = varargin{1};

                    % Initialize from zero
                    if ismember(class(pq), {'double' 'single'})

                        assert(pq==0,...
                               [subclass ':unit_required'],...
                               'Unit of measurement is a mandatory argument.');
                        obj.value = 0;
                        return;    

                    % Copy or cast operator
                    else                        
                        obj(numel(pq)) = obj(1);
                        for ii = 1:numel(pq)
                            obj(ii) = obj.doTypeCast(pq(ii)); end
                        obj = reshape(obj, size(pq));
                        return;
                    end
                end

                % Normal call
                % ------------------------------------------------------------------

                % First argument has strange type; try to typecast
                if ~ismember(class(varargin{1}), {superclass 'double' 'single'})                    
                    obj = obj.doTypeCast(varargin{:});
                    return;                                       
                end

                % The genericclass is constructing:
                obj_is_generic = isa(obj, obj.genericclass);
                
                assert(mod(argc,2)==0,...
                       [subclass ':no_unit_or_unpaired_pvs'],...
                       'Incorrect argument count; either no unit of measurement ',...
                       'has been specified, or parameters/values are not ',...
                       'properly paired.');
                
                % Rename arguments for clarity
                quantity = varargin{1};
                unitstr  = varargin{2};
                varargin(1:2) = [];

                % Create object array when numel(quantity) > 1
                amt = numel(quantity);
                if amt > 1 

                    % NOTE: (Rody Oldenhuis) the only other way is with package: 
                    % https://stackoverflow.com/questions/7102828/instantiate-class-from-name-in-matlab
                    % and believe me, you don't want to do that. 
                    pq = str2func(subclass);

                    obj(amt) = pq();
                    for ii = 1:amt
                        obj(ii) = pq(quantity(ii), unitstr, varargin{:}); end

                    obj = reshape(obj, size(quantity));
                    return;                 
                end

                % Nominal case
                if ~obj_is_generic   
                       
                    obj.value = quantity;
                    if isa(unitstr, obj(1).unitclass)                        
                        obj.current_unit = unitstr;
                        obj.given_unit   = obj.current_unit;
                    else
                        obj = obj.changeUnit(unitstr);
                        
                        % Assign value, converting it to the base units using the multiplier and 
                        % user-specified units
                        U = DerivedUnitOfMeasurement(obj.current_unit);
                        P = obj.given_powers;
                            
                        obj.value = obj.value * prod( double(obj.given_multiplier(:)) .^ obj.given_powers(:) );
                        obj.value = obj.value * prod( [U.conversion_to_base].' .^ P(:) );
                        
                    end
                    
                % The genericclass is constructing
                else
                    obj.value = quantity;                
                end

                % Parse the remainder as parameter/value pairs
                parameters = varargin(1:2:end);
                values     = varargin(2:2:end);

                for ii = 1:numel(parameters)

                    parameter = parameters{ii};
                    value     = values{ii};

                    switch lower(parameter)

                        % Available to all PhysicalQuantityInterface subclasses                    
                        case {'name' 'id'}
                            obj.name = value;

                        case {'format' 'display_format' 'displayformat'} 
                            obj.display_format = lower(value);                        

                        % Not available, except for the genericclass

                        case 'dimensions'
                            assert_generic();
                            assert(isa(value, obj.dimensionsclass) && isscalar(value),...
                                   [mfilename ':invalid_dimensions'],...
                                   'Invalid dimensions specified.');
                            obj.intermediate_dimensions = value;

                        % Unsupported parameters
                        otherwise
                            warning([mfilename ':unsupported_parameter'], ...
                                    'Unsupported parameter: ''%s''; ignoring...',...
                                    parameter);
                            continue;
                    end                
                end
                
            catch ME
                throwAsCaller(ME);
            end

            % Assertions for the pvpair parsing above
            function assert_generic()
                assert(obj_is_generic,...
                       [mfilename ':incorrect_call'], [...
                       'The ''%s'' option is only available for objects ',...
                       'of type ''%s''.'],...
                       parameter, obj.genericclass);
            end
        
        end
    
        % Getter for the name
        function name = get.name(obj)
            if ~isempty(obj.name)
                name = obj.name;
            else
                name = '[no name]';
            end            
        end
        
        % Validator for display_format
        function obj = set.display_format(obj, fmt)
            assert(any(strcmp(fmt, {'short', 'long', 'auto'})),...
                   [class(obj) ':unknown_display_format'], [...
                   'Unsupported display format: ''%s''. Supported formats are ',...
                   '''auto'', ''short'' and ''long''.'],...
                   fmt);
            obj.display_format = fmt;
        end
        
    end
    
    
    % Operator overloads: basic operators     
    methods (Sealed, Hidden)
    % STYLE: (Rody Oldenhuis) these are all tiny, extremely similar methods,
    % that nevertheless need to be wrapped in try/catch to throwAsCaller() and
    % are best defined here instead of in a large number of virtually identical
    % files. Therefore, to better inspect their validity, a more compact format
    % than prescribed by the style guide is used here.
        
        % Convert to displayable string       
        disp(obj);
        
        % Basic operators: 
        % - isnan, isfinite
        function yn = isnan(obj)
            yn = isnan(double(obj));
        end
        function yn = isfinite(obj)
            yn = isfinite(double(obj));
        end
        
        % Basic operators: 
        % - comparisons        
        function yn = eq(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) == double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = ne(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) ~= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = lt(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) < double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = le(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) <= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = gt(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) > double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = ge(this, that)
            try assert_both_are_equal_type(this, that, 'compare','to');
                yn = (double(this) >= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        
        % Basic operators: 
        % - abs, sign
        function obj = abs(obj)
            try for ii = 1:numel(obj), obj(ii).value = abs(obj(ii).value); end
            catch ME, throwAsCaller(ME);
            end
        end
        function s = sign(obj)
            try s = sign(double(obj));
            catch ME, throwAsCaller(ME);
            end
        end
                
        % Basic operators: 
        % - unary plus/unary minus
        function obj = uplus(obj)
            try for ii = 1:numel(obj), obj(ii).value = +obj(ii).value; end
            catch ME, throwAsCaller(ME);
            end
        end
        function obj = uminus(obj)
            try for ii = 1:numel(obj), obj(ii).value = -obj(ii).value; end
            catch ME, throwAsCaller(ME);
            end
        end
        
        % Basic operators: 
        % - addition/subtraction       
        function new = plus(this, that, ~)
            try
                % Degenerate call
                if isempty(this) || isempty(that)
                    new = []; return; end
                
                % Internal call from minus()
                str = {'add','to'};
                if nargin==3
                    str = {'subtract','from'}; end
                
                assert_both_are_compatible(that, this, str{:});
                
                if isscalar(this) && ~isscalar(that)
                    new = that;
                    for ii = 1:numel(new)
                        new(ii).value = this.value + that(ii).value; end
                    
                elseif ~isscalar(this) &&  isscalar(that)
                    new = this;
                    for ii = 1:numel(new)
                        new(ii).value = this(ii).value + that.value; end
                    
                else    
                    assert(isequal(size(this), size(that)),...
                           [mfilename ':incompatible_sizes'],...
                           'Array sizes must agree.');
                    new = this;
                    for ii = 1:numel(new)
                        new(ii).value = this(ii).value + that(ii).value; end
                end
                
            catch ME
                throwAsCaller(ME);
            end            
        end
        function new = minus(this, that)
            new = plus(this, -that, 1);
        end
                
        % Basic operators:         
        % - multiplication/division  
        function new = mtimes(this,that)
            % TODO: (Rody Oldenhuis) this is potentially complex, because
            % matrix/matrix operations should also take into account units being
            % multiplied...for now, just make both equal:
            try new = times(this,that);
            catch ME, throwAsCaller(ME); 
            end
        end         
        function new = times(this, that)
                        
            try
                % Degenerate call
                if isempty(this) || isempty(that)
                    new = []; return; end
                
                [this,      that,...
                 thisIsNum, thatIsNum,...
                 thisIsPq,  thatIsPq] = assert_both_can_be_multiplied(this, that,...
                                                                      'multiply','with');
                                                                  
                % Order does not matter for multiplication. Ensure they are in 
                % the order (numeric * quantity), to make our lives a but easier
                if thisIsPq && thatIsNum 
                    [this,that] = deal(that,this); 
                    thisIsNum   = true;   
                    thatIsPq    = true;                
                end
                
                % 'this' is a simple scalar or a Dimensionless, or vice versa
                if thisIsNum && thatIsPq
                    constr = str2func(class(that));
                    val    = reshape([that.value], size(that));
                    new    = constr(double(this) .* double(val), ...
                                    that(1).current_unit);
                                
                % Both are physical quantities; delegate to the genericclass
                else
                    this_val = reshape([this.value], size(this));
                    that_val = reshape([that.value], size(that));
                    
                    this_dims = this(1).getDimensions(this(1));
                    that_dims = this(1).getDimensions(that(1));
                    
                    new = PhysicalQuantity(this_val .* that_val,...
                                           '<>',...
                                           'Dimensions', this_dims + that_dims);

                    % TODO: (Rody Oldenhuis) auto-convert to correct class?
                    % -> need to consider the freecounter issue, because 
                    % Force*Length = Energy  (r x F)
                    % Force*Length = Torque  (F * ds)
                    
                end

            catch ME
                throwAsCaller(ME);
            end
            
        end
        
        function new = mldivide(this, that)
            % TODO: (Rody Oldenhuis) this is potentially complex, because
            % matrix operations should also take into account units being
            % multiplied/divided...for now, just make both equal:
            try new = this./that;
            catch ME, throwAsCaller(ME); end
        end
        function new = ldivide(this, that)
            % TODO: (Rody Oldenhuis) (same comment as in mldivide)
            try new = this./that;
            catch ME, throwAsCaller(ME); end
        end
        function new = mrdivide(this, that)
            % TODO: (Rody Oldenhuis) (same comment as in mldivide)
            try new = this./that;
            catch ME, throwAsCaller(ME); end
        end
        function new = rdivide(this, that)
            
            try
                % Degenerate call
                if isempty(this) || isempty(that)
                    new = []; return; end
                  
                [this,      that,...
                 thisIsNum, thatIsNum,...
                 thisIsPq,  thatIsPq] = assert_both_can_be_multiplied(this, that,...
                                                                      'divide','by');
                                                                  
                ratios = double(this) ./ double(that);
                                                                  
                % NOTE: (Rody Oldenhuis) order matters for division; don't swap
                % like in times()
                
                % 'that' is a simple scalar or a Dimensionless
                if thatIsNum
                    new = that; 
                    if thisIsPq
                        new = this; end
                    constr = str2func(class(new));
                    new    = constr(ratios, new(1).current_unit);          
                    return; 
                end

                % 'this' is a simple scalar, or a Dimensionless; invert the unit
                if thisIsNum && thatIsPq
                    that_dims = that(1).getDimensions(that(1));
                    new = PhysicalQuantity(ratios,...
                                           '<>',...
                                           'Dimensions', -that_dims);
                    return;
                end

                % Both are physical quantities     
                this_dims = this(1).getDimensions(this(1));
                that_dims = that(1).getDimensions(that(1));

                new = PhysicalQuantity(ratios,...
                                       '<>',...
                                       'Dimensions', this_dims - that_dims);
                                   
            catch ME
                throwAsCaller(ME);
            end
            
        end
        
        % Basic operators:         
        % - power/nthroot        
        function new = mpower(this, that)
            % TODO: (Rody Oldenhuis) 
            try new = this.^that;
            catch ME, throwAsCaller(ME); end
        end
        function new = power(this, that) %#ok<INUSD,STOUT>
            % TODO: (Rody Oldenhuis) 
            ME = MException([mfilename('class') ':unsupported_operator'], ...
                            'Powers of PhysicalQuantities are not yet supported.');
            throwAsCaller(ME);
        end
        
        function new = sqrtm(obj)
            % TODO: (Rody Oldenhuis) 
            try new = sqrt(obj);
            catch ME, throwAsCaller(ME); end
        end
        function new = sqrt(obj) %#ok<STOUT,MANU>
            % TODO: (Rody Oldenhuis) 
            ME = MException([mfilename('class') ':unsupported_operator'], ...
                            'Square roots of PhysicalQuantities are not yet supported.');
            throwAsCaller(ME);
        end
                
        % Basic operators:         
        % - exponentiation/logarithm
        function new = expm(obj)
            % TODO: (Rody Oldenhuis) 
            try new = exp(obj);
            catch ME, throwAsCaller(ME); end
        end
        function new = exp(obj) %#ok<STOUT,MANU>
            % TODO: (Rody Oldenhuis) ...how to deal with this? 
            ME = MException([mfilename('class') ':unsupported_operator'], [...
                           'Exponentiation of PhysicalQuantities ',...
                           'is not yet supported.']);
            throwAsCaller(ME);
        end
        
        function new = logm(obj)
            % TODO: (Rody Oldenhuis) 
            try new = log(obj);
            catch ME, throwAsCaller(ME); end
        end
        function new = log(obj) %#ok<STOUT,MANU>
            % TODO: (Rody Oldenhuis) ...how to deal with this? 
            ME = MException([mfilename('class') ':unsupported_operator'], [...
                           'Taking logarithms of PhysicalQuantities ',...
                           'is not yet supported.']);
            throwAsCaller(ME);
        end
        function new = log10(obj)
            % TODO: (Rody Oldenhuis) 
            try new = log(obj);
            catch ME, throwAsCaller(ME); end
        end
        function new = log2(obj)
            % TODO: (Rody Oldenhuis) 
            try new = log(obj);
            catch ME, throwAsCaller(ME); end
        end
                
        % Basic operators:         
        % - typecast to double/single
        function val = double(obj)
            try val = reshape([obj.value], size(obj));
            catch ME, throwAsCaller(ME); end
        end        
        function val = single(obj)
            try val = reshape(single([obj.value]), size(obj));
            catch ME, throwAsCaller(ME); end
        end
        
        % Basic operations
        % - typecast to char/string
        function str = char(obj)%#ok<MANU>
            % NOTE: (Rody Oldenhuis) evalc() is the only possible way in MATLAB
            % to capture command-line output. It is done here to be able to
            % offload all work to the disp() method (which has no output 
            % argument by definition), while manipulating the resulting string
            % prior to assigning it to the output argument.
            str = strtrim(regexp(evalc('disp(obj);'), newline, 'split'));
            str = char(str(~cellfun('isempty', str)));
        end
        function str = string(obj)
            str = string(char(obj));
        end
        function str = num2str(obj, varargin)
            % TODO (Rody Oldenhuis): process the other possible arguments (see built-in num2str())
            str = char(obj); 
        end
                
    end
    
    % Operator overloads: advanced operators
    methods (Sealed, Hidden)
        
        % Advanced operator:
        % - subsref
        varargout = subsref(obj, S, varargin);
                
    end
    
    % Visible, public methods 
    methods
        
        % List all supported units of measurement 
        varargout = listUnits(obj);
                
        % Change the unit of mesurement 
        obj = changeUnit(obj, desired_unit, use_override);
                
        % Reset the currently used unit of measurement to the unit specified at
        % object construction 
        obj = resetUnit(obj);
                
    end
    
    % Trigonometric functions make no sense for anything but Angles; these
    % functions have to be overloaded in the corresponding subclasses.
    methods (Hidden) 
        
        % STYLE: (Rody Oldenhuis) intentional style violations to make these 
        % supersimple, repetitive functions easier to proofread while keeping
        % them concise.
        
        % Sin,cos,tan
        function val = sin(obj)
            val = NaN;
            try obj.forbidTrigfcn('sine'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = cos(obj)
            val = NaN;
            try obj.forbidTrigfcn('cosine'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = tan(obj)
            val = NaN;
            try obj.forbidTrigfcn('tangent'); 
            catch ME, throwAsCaller(ME); end  
        end
        
        % secant,cosecant,cotangent        
        function val = csc(obj)
            val = NaN;
            try obj.forbidTrigfcn('cosecant'); 
            catch ME, throwAsCaller(ME); end              
        end
        function val = sec(obj)
            val = NaN;
            try obj.forbidTrigfcn('secant'); 
            catch ME, throwAsCaller(ME);  end              
        end
        function val = cot(obj)
            val = NaN;
            try obj.forbidTrigfcn('cotangent'); 
            catch ME, throwAsCaller(ME); end  
        end
        
        % Inverse trig functions are only valid on Dimensionlesses. These are 
        % overloaded in both PhysicalQuantity() (to allow things like
        % asin(Length/Length), resulting in an Angle()), and in Angle() itself
        % (to allow things like Angle.asin(0.3, 'deg');).
        function val = asin(obj)
             val = NaN;
             try obj.forbidTrigfcn('arcsine'); 
             catch ME, throwAsCaller(ME); end      
        end
        function val = acos(obj)
            val = NaN;
            try obj.forbidTrigfcn('arccosine'); 
            catch ME, throwAsCaller(ME); end 
        end
        function val = atan(obj)
            val = NaN;
            try obj.forbidTrigfcn('arctangent'); 
            catch ME, throwAsCaller(ME); end   
        end
        % NOTE: (Rody Oldenhuis) this is an exception 
        function val = atan2(obj,varargin)
            try val = Angle.atan2(obj,varargin{:});
            catch ME, throwAsCaller(ME); end   
        end
        
        function val = acsc(obj)
            val = NaN;
            try obj.forbidTrigfcn('arccosecant'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = asec(obj)
            val = NaN;
            try obj.forbidTrigfcn('arcsecant'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = acot(obj)
            val = NaN;
            try obj.forbidTrigfcn('arccotangent'); 
            catch ME, throwAsCaller(ME); end  
        end
        
        % TODO: (Rody Oldenhuis) https://en.wikipedia.org/wiki/Hyperbolic_angle
        % implement a HyperbolicAngle() class
        
        
        % Same for the hyperbolic analogs
        
        % Sinh,cosh,tanh
        function val = sinh(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic sine'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = cosh(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic cosine'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = tanh(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic tangent'); 
            catch ME, throwAsCaller(ME); end  
        end
        
        % sech, csch, tanh        
        function val = csch(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic cosecant'); 
            catch ME, throwAsCaller(ME); end              
        end
        function val = sech(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic secant'); 
            catch ME, throwAsCaller(ME);  end              
        end
        function val = coth(obj)
            val = NaN;
            try obj.forbidTrigfcn('hyperbolic cotangent'); 
            catch ME, throwAsCaller(ME); end  
        end
        
        % asinh, acos, atanh
        function val = asinh(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic sine'); 
            catch ME, throwAsCaller(ME); end            
        end
        function val = acosh(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic cosine'); 
            catch ME, throwAsCaller(ME); end 
        end
        function val = atanh(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic tangent'); 
            catch ME, throwAsCaller(ME); end   
        end
                
        % acsch, asech, acoth
        function val = acsch(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic cosecant'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = asech(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic secant'); 
            catch ME, throwAsCaller(ME); end  
        end
        function val = acoth(obj)
            val = NaN;
            try obj.forbidTrigfcn('inverse hyperbolic cotangent'); 
            catch ME, throwAsCaller(ME); end  
        end
                
    end
    
    % The string lexers/parsers/generators
    methods (Access = protected)
                
        % Convert a user-specified string into the appropriate units of
        % measurement, multipliers and powers
        [units,...
         multipliers,...
         powers] = convertStringToUnits(obj,...
                                        str);
            
        % Convert a given set of units of measurement, multipliers and powers
        % into a pretty-print displayable string
        str = unitsToString(obj,...
                            units,...
                            multipliers,...
                            powers);
                        
    end
        
    % Internal functions 
    methods (Access = private)
        
        % Typecast; from anything to PhysicalQuantity
        new_obj = doTypeCast(obj, other, varargin);

        % Trigonometric functions only makes sense for angles; therefore, 
        % they are explicitly forbidden for everything else
        function forbidTrigfcn(obj, trigfcn)
            error([class(obj) ':invalid_operation'],...
                   'Can''t compute the %s() of a%s %s.',...
                   trigfcn,...
                   get_suffix(class(obj)),...
                   class(obj));
        end 

    end 
    
    methods (Static, ...
             Hidden,...
             Access = protected)
         
         % Wrapper to get a quantity's dimensions, regardless of whether that
         % quantity is an intermediate quantity or not
         function dims = getDimensions(obj)
             if isa(obj, PhysicalQuantityInterface.genericclass)
                 dims = obj.intermediate_dimensions;
             else
                 dims = obj.dimensions;
             end             
         end
        
    end
    
end


function assert_both_are_physical_quantities(this, that, op,prp)
    
    cls      = mfilename;
    cls_this = class(this);
    cls_that = class(that);    
    
    assert(isa(this, cls) && isa(that, cls),...
           [cls ':incompatible_types'],...
           'Can''t %s ''%s'' %s a%s ''%s''.',...
           op, cls_this, prp, get_suffix(cls_that), cls_that);
end

function assert_both_are_equal_type(this, that, op,prp)   
    
    assert_both_are_physical_quantities(this, that, op,prp);
    
    cls_that = class(that);
    cls_this = class(this);
    assert(isequal(cls_this, cls_that),...
           [mfilename ':incompatible_types'],...
           'Can''t %s ''%s'' %s a%s ''%s''.',...
           op, cls_this, prp, get_suffix(cls_that), cls_that);
       
 end

function assert_both_are_compatible(this, that, op,prp, varargin)
     
    argc = numel(varargin);
     
    if argc==0
        assert_both_are_physical_quantities(this, that, op,prp); end
    
    function dimensions = get_dims(obj)
        if isa(obj, 'PhysicalQuantity')
            dimensions = obj.intermediate_dimensions;            
        elseif isa(obj, 'Dimensionless') || ...
               argc>=0 && any(cellfun(@(x)isa(obj,x), varargin))
           
            dimensions = [];            
        else
            dimensions = obj.dimensions;
        end
    end
       
    cls_this = class(this);    this_dims = get_dims(this);
    cls_that = class(that);    that_dims = get_dims(that);
    
    assert(isequal(this_dims, that_dims) || ...
           isempty(this_dims) || isempty(that_dims),...
           [mfilename ':incompatible_types'],...
           'Can''t %s ''%s'' %s a%s ''%s''.',...
           op, cls_this, prp, get_suffix(cls_that),cls_that);       
 end

function [this,      that,...
          thisIsNum, thatIsNum,...
          thisIsPq,  thatIsPq] = assert_both_can_be_multiplied(this, that,...
                                                                op,prp)
     
    dl = PhysicalQuantityInterface.dimensionless;
    pq = mfilename;
                                                            
    thisIsNum = isnumeric(this) || isa(this, dl);
    thatIsNum = isnumeric(that) || isa(that, dl);
     
    thisIsPq  = isa(this, pq);
    thatIsPq  = isa(that, pq);
     
    cls_this = class(this); 
    cls_that = class(that);  
     
    assert(thisIsPq  && thatIsPq  || ...
           thisIsNum && thatIsPq  || ...
           thisIsPq  && thatIsNum || ...
           thisIsNum && thatIsNum,   ...
           [mfilename('class') ':invalid_operation'],...
           'Can''t %s%s ''%s'' %s a%s ''%s''.',...            
           op, ...
           get_suffix(cls_this), cls_this,...
           prp,...
           get_suffix(cls_that), cls_that);       
end

