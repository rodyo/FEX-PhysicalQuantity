% 
%
classdef PhysicalQuantity < PhysicalQuantityInterface
    
% NOTE: (Rody Oldenhuis) shutups:
%#ok<*CHARTEN>  ("use newline instead of char(10)" etc.; introduced in R2016b)
    
    
    % Properties ==========================================================
        
    properties (Constant)            
        dimensions = PhysicalDimension.empty()
        units      = []
    end
    
    
    % Methods =============================================================
    
    % Class basics
    methods 
        
        % constructor
        function obj = PhysicalQuantity(varargin)
                               
            % Forbid instantiations from command line
            assert(numel(dbstack) > 1,...
                   [mfilename('class') ':invalid_instantiation'], [...
                   '%s() cannot be instantiated ',...
                   'from the MATLAB command line.'],...
                   mfilename('class'));
            
            % Construct it in the super
            obj = obj@PhysicalQuantityInterface(varargin{:});
            
            % Make sure this intermediate product has no units 
            % (just dimensions)
            [obj.given_unit]   = deal(UnitOfMeasurement.empty);
            [obj.current_unit] = deal(UnitOfMeasurement.empty);
                           
        end
                
        % Operator overloads -- invere trig functions are Angle() factories
        function A = asin(obj, varargin)
            try A = Angle.asin(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function A = acos(obj, varargin)
            try A = Angle.acos(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function A = atan(obj, varargin)
            try A = Angle.atan(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function A = atan2(this, other, varargin)
            try A = Angle.atan2(this, other, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        
        function A = acsc(obj, varargin)
            try A = Angle.acsc(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function A = asec(obj, varargin)
            try A = Angle.asec(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function A = acot(obj, varargin)
            try A = Angle.acot(obj, varargin{:});
            catch ME, throwAsCaller(ME); end
        end       
        
    end
         
    % Internal use
    methods (Access = private)
        
        % TODO: (Rody Oldenhuis) 
        function findAppropriateUnits(obj)    
            % TODO: (Rody Oldenhuis) useful drafts until now:
            S = dir(fullfile(fileparts(mfilename('fullpath')), '*.m'));            
            meta.class.fromName('LengthUnits').SuperclassList.Name            
        end
    end
        
    % Public interface
    methods (Static)
        
        % rand() method is invalid for this type of unit
        function R = rand(varargin) %#ok<STOUT>
            error([mfilename() ':invalid_method'],...
                  'rand() is invalid for intermediate units.');
        end
        
        % Check dimensions for given quantity
        function validateDimensions(qty, dims)
            
            % User-facing function: check inputs
            assert(isa(qty, 'PhysicalQuantityInterface'),...
                   [mfilename() ':invalid_argument'],...
                   'First input must be an instance of a PhysicalQuantity.');            
            assert(isa(dims,'string') || ischar(dims),... % isstring(): R2016b and up
                   [mfilename() ':invalid_argument'],...
                   'Second input must be a string.');
            
            % Now validate those dimensions
            [units,...
             ~,...
             powers] = PhysicalQuantity().convertStringToUnits(dims);
         
            specified_dims = sum([units.dimensions].*powers);
            
            given_dims = qty.dimensions;
            if isa(qty, 'PhysicalQuantity')
                given_dims = qty.intermediate_dimensions; end
            
            assert(isequal(given_dims, specified_dims),...
                   [mfilename() ':dimension_validation_failure'],...
                   'Given quantity does not have the dimensions specified.');
               
        end
          
        % Check units for given quantity
        function validateUnits(qty, dims)
            
            % Units check == dimensions check + additional checks 
            PhysicalQuantity().validateDimensions(qty, dims);
            
            % That's all you can do for an intermediate quantity:            
            if isa(qty, 'PhysicalQuantity')
                warning([mfilename() ':units_check_not_possible'], [...
                        'Intermediate quantities don''t have units; ',...
                        'can''t perform validation. The dimensions ',...
                        'seem to be OK (validateDimensions() passed).']);
                return; 
            end
            
            % Now validate those units
            [units,...
             multipliers] = PhysicalQuantity().convertStringToUnits(dims);
         
            % TODO: (Rody Oldenhuis) sorting. 'kg/m^3' will give the same
            % as 'kg*m^-3' but NOT the same as 'm^-3*kg'
         
            specified_units = [units.conversion_to_base] ...
                           .* multipliers;            
            given_units    = [qty.given_unit.conversion_to_base] ...
                           .* [qty.given_multiplier];
            
            assert(isequal(given_units, specified_units),...
                   [mfilename() ':unit_validation_failure'],...
                   'Given quantity does not have the units specified.');
               
        end
        
    end
        
end
