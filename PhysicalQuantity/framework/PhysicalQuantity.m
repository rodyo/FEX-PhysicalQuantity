% 
%
classdef PhysicalQuantity < PhysicalQuantityInterface
    
% NOTE: (Rody Oldenhuis) shutups:
%#ok<*CHARTEN>  ("use newline instead of char(10)" etc.; introduced in R2016b)
    
    
    %% Properties
        
    properties (Constant)            
        dimensions = PhysicalDimension.empty()
        units      = []
    end
    
    
    %% Methods
    
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
                
    end
    
    % Operator overloads
    methods
        
        % Invere trig functions are Angle() factories
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
           
    methods (Access = private)
        
        % TODO: (Rody Oldenhuis) 
        function findAppropriateUnits(obj)    
            % TODO: (Rody Oldenhuis) useful drafts until now:
            S = dir(fullfile(fileparts(mfilename('fullpath')), '*.m'));            
            meta.class.fromName('LengthUnits').SuperclassList.Name            
        end
    end
    
end
