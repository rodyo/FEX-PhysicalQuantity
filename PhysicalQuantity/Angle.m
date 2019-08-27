classdef Angle < PhysicalQuantityInterface

    properties (Constant)        
        dimensions = PhysicalDimension([0 0 0 0 0 0 0 1]);
        units      = get_units('angle_units') 
    end
    
    
    %% Methods
         
    % Dummy constructor - needed until R2017b
    methods
        function obj = Angle(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end 
            
    % Trigonometric functions shall return plain doubles
    methods        
        function v = sin(obj), v = sin(reshape([obj.value], size(obj))); end        
        function v = cos(obj), v = cos(reshape([obj.value], size(obj))); end
        function v = tan(obj), v = tan(reshape([obj.value], size(obj))); end
        
        function v = csc(obj), v = csc(reshape([obj.value], size(obj))); end
        function v = sec(obj), v = sec(reshape([obj.value], size(obj))); end
        function v = cot(obj), v = cot(reshape([obj.value], size(obj))); end
    end
    
    % Inverse trigonometric functions are Angle() factories  
    % (see utility function below)      
    methods (Static)
        
        function new_obj = asin(A,varargin)
            try new_obj = inverseTrigFactory(@asin, A, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        function new_obj = acos(A,varargin)
            try new_obj = inverseTrigFactory(@acos, A, varargin{:}); 
            catch ME, throwAsCaller(ME); end
        end
        function new_obj = atan(A,varargin)
            try new_obj = inverseTrigFactory(@atan, A, varargin{:}); 
            catch ME, throwAsCaller(ME); end
        end
        function new_obj = atan2(A,B,varargin)
            try new_obj = inverseTrigFactory(@atan2,A,B, varargin{:});
            catch ME, throwAsCaller(ME); end
        end
        
        function new_obj = acsc(A,varargin)
            try new_obj = inverseTrigFactory(@acsc, A, varargin{:}); 
            catch ME, throwAsCaller(ME); end
        end
        function new_obj = asec(A,varargin)
            try new_obj = inverseTrigFactory(@asec, A, varargin{:}); 
            catch ME, throwAsCaller(ME); end
        end
        function new_obj = acot(A,varargin)
            try new_obj = inverseTrigFactory(@acot, A, varargin{:}); 
            catch ME, throwAsCaller(ME); end
        end
                
    end
    
    % rand() method - for things like rand(1,3,'Angle')
    methods (Static)
        function R = rand(varargin)
            R = Angle(rand(varargin{:}), 'rad'); end
    end
        
end

function new_obj = inverseTrigFactory(fcn, A, varargin)            
                        
    % Check if valid input was given, and compute the result of the
    % requested inverse trig operation 
    if isequal(fcn, @atan2) % NOTE: (Rody Oldenhuis) make exception for atan2

        B = varargin{1};
        varargin(1) = [];

        pq = 'PhysicalQuantityInterface';

        assert( (isnumeric(A) && isnumeric(B)) || ...
                   (isa(A,pq) && isa(B,pq)...
                    && ( isequal(A.dimensions, B.dimensions) || ...
                         isequal(A.intermediate_dimensions, B.dimensions) || ...
                         isequal(A.dimensions, B.intermediate_dimensions) || ...
                         isequal(A.intermediate_dimensions, B.intermediate_dimensions)) ),...
              [mfilename ':invalid_argument'], [...
              'Can''t compute the quadrant-correct arctangent using a ',...
              '%s and a %s.'],...
              class(A), class(B));

        result = atan2(double(A), double(B));

    else                                
        assert(   isnumeric(A) ...
               || isa(A, 'Dimensionless') ...                           
               || (   isa(A, 'PhysicalQuantity') ...
                   && isequal(A.intermediate_dimensions,...
                              Angle.dimensions) ),...                                 
               [mfilename ':invalid_argument'], ...
               get_error_string(fcn,A));

        result = fcn(double(A));
    end

    % If additional arguments were specified, the desired unit of
    % measurement may have been included. In that case, FIRST compute
    % the inverse trig function in default units (radians), THEN convert
    % to the desired unit -- just like in the interface's doTypeCast();
    if mod(numel(varargin),2)==0
        new_obj = Angle(result, 'radian', varargin{:});
    else
        requested_unit = varargin{1};
        varargin{1}    = 'radian';
        new_obj        = Angle(result, varargin{:});
        new_obj        = new_obj.changeUnit(requested_unit);
    end

end 

function str = get_error_string(fcn,A)
    if isa(A, 'PhysicalQuantity')
        str = sprintf(['Can''t compute the %s() of a quantity with ',...
                       'dimensions ''%s''.'],...
                      func2str(fcn),...
                      A.dimensions);
    else
        str = sprintf('Can''t compute the %s() of a%s %s.',...
                      func2str(fcn),...
                      get_suffix(class(A)),...
                      class(A));
    end
end
