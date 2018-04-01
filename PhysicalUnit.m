classdef (Sealed) PhysicalUnit < matlab.mixin.Copyable % R2011b
    
%#ok<*CHARTEN>  ("use newline instead of char(10)" etc. Introduced in R2016b)
    
    
    %% Properties
    
    properties        
        name        
    end
    
    properties (Access = private)
        
        % All physical units are a permutation of the SI base units
        % L  = Length
        % M  = Mass
        % t  = Time
        % C  = Current
        % T  = Temperature
        % I  = Luminous intensity
        % N  = amount of Substance
        % ii = Free counter to resolve unit ambiguities
        %
        %             L M t C T I N ii
        base_units = [0 0 0 0 0 0 0 0] 
        
        % Instance data
        given_unit = {} % User-specified unit of measurement {long, short}
        unit_class = '' % type of unit 
        
        % The actual value of the unit
        value = 0
        
    end
    
    % SI definitions
    properties (Access = private, Constant)
        
        % The SI multiplier table
        multipliers = {1e+24 'Y'  'yotta'
                       1e+21 'Z'  'zetta'
                       1e+18 'E'  'exa'
                       1e+15 'P'  'peta'
                       1e+12 'T'  'tera'
                       1e+09 'G'  'giga'
                       1e+06 'M'  'mega'
                       1e+03 'k'  'kilo'
                       1e+02 'h'  'hecto'
                       1e+01 'da' 'deca'
                       %{
                       %}
                       1e-01 'd'  'deci'
                       1e-02 'c'  'centi'
                       1e-03 'm'  'milli'
                       1e-06 'u'  'micro'
                       1e-06 '?'  'micro' % NOTE: variant spelling
                       1e-06 'mu' 'micro' % NOTE: variant spelling
                       1e-09 'n'  'nano'
                       1e-12 'p'  'pico'
                       1e-15 'f'  'femto'
                       1e-18 'a'  'atto'
                       1e-21 'z'  'zepto'
                       1e-24 'y'  'yocto'};  
                   
        %
        
                  
        % SI                      L       M          t        C        T        I         N  
        units = struct('short', {'m'     'kg'       's'      'A'      'K'      'cd'      'mol'},...
                       'long' , {'meter' 'kilogram' 'second' 'Ampère' 'Kelvin' 'candela' 'mol'});
                   
                   
                   
        % Supported classes/units of measurement and associated base units
        %
        %            Class/group          values of base units              units of measurement 
        all_units = {...
                     %{
                     Dimensionless               L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}                        
                     'Dimensionless'           [+0, +0, +0, +0, +0, +0, +0, +0]  { {'-'  ,'-'}         , {'',''},1 }
                     'Angle'                   [+0, +0, +0, +0, +0, +0, +0, +1]  { {'rad','radian'}    , {'deg','degree'},pi/180, {'grad','gradian'},pi/200 }
                     'PlaneAngle'              [+0, +0, +0, +0, +0, +0, +0, +1]  { {'rad','radian'}    , {'deg','degree'},pi/180, {'grad','gradian'},pi/200 }
                     'SolidAngle'              [+0, +0, +0, +0, +0, +0, +0, +2]  { {'sr' ,'sterradian'} }
                     %{                       
                     Baseunits                   L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}                       
                     'Length'                  [+1, +0, +0, +0, +0, +0, +0, +0]  { {'m'  ,'meter'}    }
                     'Mass'                    [+0, +1, +0, +0, +0, +0, +0, +0]  { {'kg' ,'kilogram'} }
                     'Duration'                [+0, +0, +1, +0, +0, +0, +0, +0]  { {'s'  ,'second'}   }
                     'Current'                 [+0, +0, +0, +1, +0, +0, +0, +0]  { {'A'  ,'Ampere'}   }
                     'Temperature'             [+0, +0, +0, +0, +1, +0, +0, +0]  { {'K'  ,'Kelvin'}   } 
                     'LuminousIntensity'       [+0, +0, +0, +0, +0, +1, +0, +0]  { {'cd' ,'candela'}  }
                     'AmountOfSubstance'       [+0, +0, +0, +0, +0, +0, +1, +0]  { {'mol','mol'}      }
                     %{                       
                     Derived units               L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}
                     'AngularSpeed'            [+0, +0, -1, +0, +0, +0, +0, +1]  { {'<>','<>'} }  % NOTE: same as frequency
                     'AngularAcceleration'     [+0, +0, -2, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'AngularMomentum'         [+2, +1, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'SpecificAngularMomentum' [+2, +0, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}                       
                     'Speed'                   [+1, +0, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Acceleration'            [+1, +0, -2, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Jerk'                    [+1, +0, -3, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Snap'                    [+1, +0, -4, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'Crackle'                 [+1, +0, -5, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'Pop'                     [+1, +0, -6, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}                       
                     'Area'                    [+2, +0, +0, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'Volume'                  [+3, +0, +0, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Density'                 [-3, +1, +0, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %} 
                     'Force'                   [+1, +1, -2, +0, +0, +0, +0, +0]  { {'N' ,'Newton'} }
                     'Torque'                  [+2, +1, -2, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Momentum'                [+1, +1, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'SpecificMomentum'        [+1, +0, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Energy'                  [+2, +1, -2, +0, +0, +0, +0, +1]  { {'J' ,'Joule'} } % NOTE: same as torque
                     'SpecificEnergy'          [+2, +0, -2, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Pressure'                [-1, +1, -2, +0, +0, +0, +0, +0]  { {'Pa','Pascal'} }
                     'MomentOfInertia'         [+2, +1, +0, +0, +0, +0, +0, +0]  { {'<>','<>'} } 
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}                       
                     'Wavenumber'              [+0, -1, +0, +0, +0, +0, +0, +0]  { {''  ,''} } 
                     'Frequency'               [+0, +0, -1, +0, +0, +0, +0, +0]  { {'Hz','Hertz'} }  % NOTE: same as AngularSpeed
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}
                     'Charge'                  [+0, +0, +1, +1, +0, +0, +0, +0]  { {'C' ,'Coulomb'} }
                     'Potential'               [+2, +1, -3, -1, +0, +0, +0, +0]  { {'<>','<>'} } 
                     'Power'                   [+2, +1, -3, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                     'Resistance'              [+2, +1, -3, -2, +0, +0, +0, +0]  { {'?' ,'Ohm'} } 
                     'Conductance'             [-2, -1, +3, +2, +0, +0, +0, +0]  { {'S' ,'Siemens'} } 
                     'Capacitance'             [-2, -1, +4, +2, +0, +0, +0, +0]  { {'F' ,'Fahrad'} }
                     'Inductance'              [+2, +1, -2, -2, +0, +0, +0, +0]  { {'H' ,'Henry'} }
                     'MagneticFlux'            [+2, +1, -2, -1, +0, +0, +0, +0]  { {'Wb','Weber'} } 
                     'MagneticFluxDensity'     [+0, +1, -2, -1, +0, +0, +0, +0]  { {'T' ,'Tesla'} }
                     %{
                                                 L   M   t   C   T   I   N   i   unit (short/long   pairs of {other unit, conversion to standard unit}
                     %}
                     'Viscocity'               [-1, +1, -1, +0, +0, +0, +0, +0]  { {'<>','<>'} }
                    }
    end
    
    %% Methods
    
    % Public
    methods 
        
        %% Constructors
        
        % Main constructor
        function obj = PhysicalUnit(quantity, unit)
            
            % TODO: basic checks on the inputs
            
            
            multipler = obj.setUnitOfMeasurement(unit);
            obj.value = obj.multiplierStringToNumber(multipler) * quantity;
                
        end
                
        % Dimensionless units
        function obj = Dimensionless()
        end
        function obj = Angle()
        end
        function obj = PlaneAngle()
        end
        function obj = SolidAngle()
        end
        
         
        %% Setters/getters
        
        function obj = set.name(obj, new_name)
            assert(ischar(new_name),...
                   [mfilename ':invalid_name'],...
                   'Name must be a string; got %s.', class(new_name));
            obj.name = new_name;
        end
        
        
            
            
            
            
            %{
 Dimensionless 
  L   M   t   C   T   I   N   i
[+0, +0, +0, +0, +0, +0, +0, +0]  Dimensionless;
[+0, +0, +0, +0, +0, +0, +0, +1]  Angle;
[+0, +0, +0, +0, +0, +0, +0, +1]  PlaneAngle;
[+0, +0, +0, +0, +0, +0, +0, +2]  SolidAngle;

 Base units 
  L   M   t   C   T   I   N   i
[+1, +0, +0, +0, +0, +0, +0, +0]  Length;
[+0, +1, +0, +0, +0, +0, +0, +0]  Mass;
[+0, +0, +1, +0, +0, +0, +0, +0]  Duration;
[+0, +0, +0, +1, +0, +0, +0, +0]  Current;
[+0, +0, +0, +0, +1, +0, +0, +0]  Temperature;
[+0, +0, +0, +0, +0, +1, +0, +0]  LuminousIntensity;
[+0, +0, +0, +0, +0, +0, +1, +0]  AmountOfSubstance;

 Derived 
  L   M   t   C   T   I   N   i
[+0, +0, -1, +0, +0, +0, +0, +0]  AngularSpeed;
[+0, +0, -2, +0, +0, +0, +0, +0]  AngularAccelerationComponent;
[+2, +1, -1, +0, +0, +0, +0, +0]  AngularMomentumComponent;
[+2, +0, -1, +0, +0, +0, +0, +0]  SpecificAngularMomentumComponent;

  L   M   t   C   T   I   N   i
[+1, +0, -1, +0, +0, +0, +0, +0]  Speed;
[+1, +0, -2, +0, +0, +0, +0, +0]  AccelerationComponent;
[+1, +0, -3, +0, +0, +0, +0, +0]  JerkComponent;
[+1, +0, -4, +0, +0, +0, +0, +0]  SnapComponent;
[+1, +0, -5, +0, +0, +0, +0, +0]  CrackleComponent;
[+1, +0, -6, +0, +0, +0, +0, +0]  PopComponent;

  L   M   t   C   T   I   N   i
[+2, +0, +0, +0, +0, +0, +0, +0]  Area;
[+3, +0, +0, +0, +0, +0, +0, +0]  Volume;
[-3, +1, +0, +0, +0, +0, +0, +0]  Density;

  L   M   t   C   T   I   N   i
[+1, +1, -2, +0, +0, +0, +0, +0]  ForceComponent;
[+2, +1, -2, +0, +0, +0, +0, +0]  TorqueComponent;
[+1, +1, -1, +0, +0, +0, +0, +0]  MomentumComponent;
[+1, +0, -1, +0, +0, +0, +0, +0]  SpecificMomentumComponent;
[+2, +1, -2, +0, +0, +0, +0, +1]  Energy;    // NOTE: conflicts with Torque
[+2, +0, -2, +0, +0, +0, +0, +0]  SpecificEnergy;
[-1, +1, -2, +0, +0, +0, +0, +0]  Pressure;
[+2, +1, +0, +0, +0, +0, +0, +0]  MomentOfInertiaComponent;

  L   M   t   C   T   I   N   i
[+0, -1, +0, +0, +0, +0, +0, +0]  Wavenumber;
[+0, +0, -1, +0, +0, +0, +0, +1]  Frequency; // NOTE: conflicts with AngularSpeed

  L   M   t   C   T   I   N   i
[+0, +0, +1, +1, +0, +0, +0, +0]  Charge;
[+2, +1, -3, -1, +0, +0, +0, +0]  Potential;
[+2, +1, -3, +0, +0, +0, +0, +0]  Power;
[+2, +1, -3, -2, +0, +0, +0, +0]  Resistance;
[-2, -1, +3, +2, +0, +0, +0, +0]  Conductance;
[-2, -1, +4, +2, +0, +0, +0, +0]  Capacitance;
[+2, +1, -2, -2, +0, +0, +0, +0]  Inductance;
[+2, +1, -2, -1, +0, +0, +0, +0]  MagneticFlux;
[+0, +1, -2, -1, +0, +0, +0, +0]  MagneticFluxDensity;

  L   M   t   C   T   I   N   i
[-1, +1, -1, +0, +0, +0, +0, +0]  Viscocity;
%}
            
        %% Convert units
        
    
        
        %% Overloads
        
        % Convert to displayable string
        function disp(obj)  
            
            % Get appropriate multiplier string and accordingly scaled value
            [mult, val] = obj.computeAppropriateMultiplier(); 
            
            % Convert the value to a srting, respecting the current FORMAT 
            % setting, locale, etc.
            num = evalc('disp(val)');
            num(num==char(10)) = []; 
            
            % Use singular form unless the quantity does not equal 1
            unit = obj.given_unit{1};
            if val ~= 1
                unit = [unit 's']; end
            
            % Print!
            fprintf(1, '%s %s%s\n', num, mult, unit);    
            
        end
        
        % Assignment operator
        
        % Basic operators: 
        % - unary plus/unary minus
        function new = uplus(obj)                        
            new = copy(obj);
            new.value = +new.value;
        end
        function new = uminus(obj)                        
            new = copy(obj);
            new.value = -new.value; 
        end
        
        % Basic operators: 
        % - addition/subtraction       
        function new = plus(this, that) 
            
            the_other = '';
            the_one   = '';
            
            % 'this' is a simple scalar
            if isnumeric(this)
                the_one   = class(this);
                the_other = lower(that.unit_class);
            end
            
            % 'other' is a simple scalar
            if isnumeric(that)
                the_one   = lower(this.unit_class);
                the_other = class(that);
            end
            
            % Can't add apples to oranges
            assert(isequal(class(this), class(that)),...
                   'Cannot add ''%s'' to ''%s''.',...
                   the_other, the_one);
            assert(isequal(this.unit_class, that.unit_class),...
                   [mfilename ':incompatible_units'],...
                   'Can''t add ''%s'' to ''%s''.',...
                   that.unit_class, this.unit_class);
               
            new = copy(this);
            new.value = this.value + that.value;            
        end
        function new = minus(this, that) 
            
            the_other = '';
            the_one   = '';
            
            % 'this' is a simple scalar
            if isnumeric(this)
                the_one   = class(this);
                the_other = lower(that.unit_class);
            end
            
            % 'other' is a simple scalar
            if isnumeric(that)
                the_one   = lower(this.unit_class);
                the_other = class(that);
            end
            
            % Can't subtract apples from oranges
            assert(isequal(class(this), class(that)),...
                   'Cannot subtract ''%s'' from ''%s''.',...
                   the_other, the_one);
            assert(isequal(this.unit_class, that.unit_class),...
                   [mfilename ':incompatible_units'],...
                   'Can''t subtract ''%s'' from ''%s''.',...
                   that.unit_class, this.unit_class);
               
            new = copy(this);
            new.value = this.value - that.value;            
        end
        
        % - power/nthroot
        % - exponentiation/logarigthm
        % TODO: (Rody Oldenhuis) 
        
        % Basic operators:         
        % - multiplication/division  
        function new = times(this,that)
            % TODO: (Rody Oldenhuis) 
            new = mtimes(this,that);
        end 
        
        function new = mtimes(this, that)
            
            % 'this' is a simple scalar
            if isnumeric(this)
                new = copy(that);
                new.value = this*new.value;
                return; 
            end
            
            % 'other' is a simple scalar
            if isnumeric(that)
                new = copy(this);
                new.value = that*new.value;
                return; 
            end
            
            % Both are physical units. 
            new = PhysicalUnit(this.value * that.value, '');
            
            new.base_units = this.base_units + that.base_units;
            
            indices = ismember(cat(1,new.all_units{:,2}),...
                               new.base_units,...
                               'rows');                           
            index = find(indices,1);
            
            new.unit_class = new.all_units{index,1};
            new.given_unit = new.all_units{index,3}{1};
             
        end
        
        
        % Trigonometric functions 
        function val = sin(obj)
            obj.checkTrigfcn('sine');
            val = sin(obj.value);            
        end
        function val = cos(obj)
            obj.checkTrigfcn('cosine');
            val = cos(obj.value);            
        end
        function val = tan(obj)
            obj.checkTrigfcn('tangent');
            val = tan(obj.value);                    
        end
        
        function val = csc(obj)
            obj.checkTrigfcn('cosecant');
            val = csc(obj.value);            
        end
        function val = sec(obj)
            obj.checkTrigfcn('secant');
            val = sec(obj.value);            
        end
        function val = cot(obj)
            obj.checkTrigfcn('cotangent');
            val = cot(obj.value);            
        end
        
    end
    
    %
    methods (Access = private)
        
        % Assign the physical unit's unit of measurement
        % TODO: (Rody Oldenhuis) this method does 2 things; split it up
        function str = setUnitOfMeasurement(obj, str)
                  
            % Rename class data for better readability
            class     = obj.all_units(:,1);
            baseunits = obj.all_units(:,2);
            measures  = obj.all_units(:,3);
            
            % For speed and portability, we're comparing from the end with 
            % strcmp(). This means we have to compare the FIRST characters 
            % of the FLIPPED string:
            flipstr = fliplr(str);
            
            % Now thoroughly yet flexibly check which of ther supported 
            % units of measurement was intended
            num_units = size(obj.all_units,1);            
            for ii = 1:num_units 
                
                units = measures{ii}([1 2:2:end]);                
                for jj = 1:numel(units) 
                    
                    unit = units{jj};
                    unit = unit(~cellfun('isempty', unit));
                    
                    if isempty(unit)
                        continue; end
                    
                    % Include the plural form for the long string
                    unit = { units{jj}{1},...
                             units{jj}{2},...
                            [units{jj}{2} 's']};
                        
                    % also these should be flipped for strncmp()
                    unit = cellfun(@fliplr, unit, 'UniformOutput', false);
                    
                    % Now check for a match
                    hits = cellfun(@(x) strncmp(flipstr, x,numel(x)), unit);
                    if any(hits)
                        
                        % When matched, assign these known properties                        
                        obj.base_units = baseunits{ii};
                        obj.unit_class = class{ii};
                        
                        % Find out which given unit was specified
                        hit        = find(hits,1);
                        shiftedhit = hit + (1-mod(hit+2, 3));
                        
                        % Now set the user-specified unit of measurement. 
                        % Always set the long singular form, regardless of 
                        % the form specified
                        obj.given_unit = {fliplr(unit{shiftedhit-0})
                                          fliplr(unit{shiftedhit-1})};
                        
                        % Finally, adjust the string so that the multiplier
                        % detection can do its job                         
                        str((numel(str)-numel(unit{hit})+1) : end ) = [];
                        
                        % All done
                        return;
                        
                    end
                end  
                
            end
            
            % Throw error if none matched
            error([mfilename ':invalid_unit_of_measurement'], [...
                  'Unsupported unit of measurement: ''%s''. Note that units ',...
                  'of measurement are case-sensitive.'],...
                  str);
              
        end % extractUnitOfMeasurement
        
        % Check & find the SI multiplier associated with the specified string
        function M = multiplierStringToNumber(obj, str)
            
            % NOTE: (Rody Oldenhuis) mulipliers are case sensitive; don't
            % convert case and don't use strcmpi()
            
            % Default value
            M = 1;
                                
            % Detect the multiplier (if any)
            if ~isempty(str)
                
                mlt = obj.multipliers;
                for ii = 1:size(mlt,1)

                    % Rename for better readability
                    mult  = mlt{ii,1};
                    short = mlt{ii,2};
                    long  = mlt{ii,3};

                    % Now find and apply multiplier 
                    if strncmp(str, short,length(short)) || ...
                       strncmp(str, long,length(long)) 
                        M = mult;
                        return;
                    end

                end
                
                error([mfilename ':invalid_multiplier'], [...
                      'Given multiplier ''%s'' does not comply with the ',...
                      'SI-standard. Note that the multpliers are ',...
                      'case-sensitive.'],...
                      str);
            end
            
        end % setMultiplier
        
        % Get appropriate multiplier string and accordingly scaled value
        function [str, value] = computeAppropriateMultiplier(obj, len)
            
            % Prefer long strings
            if nargin==1
                len = 'long'; end
            
            % Exception for 0
            str   = '';
            value = 0;
            if obj.value==0
                return; end
            
            % Find the first fraction for which the magnitude exceeds one
            fracs = obj.value ./ [obj.multipliers{:,1}];
            index = find( abs(fracs) >= 1, 1);
            
            % return string and value            
            switch len                
                case 'long' , str = obj.multipliers{index, 3};
                case 'short', str = obj.multipliers{index, 2};
            end            
            value = fracs(index);
            
        end % computeAppropriateMultiplier
        
        
        % Trigonometric functions only makes sense for angles
        function checkTrigfcn(obj, trigfcn)            
            
            suffix = '';
            if ismember(lower(obj.unit_class(1)), 'aeiou')
                suffix = 'n'; end
            
            assert(any(ismember(obj.unit_class, {'Angle' 'PlanarAngle'})),...
                   'Cannot compute the %s of a%s %s.',...
                   trigfcn,...
                   suffix,...
                   lower(obj.unit_class));
        end
        
    end % private methods
    
end