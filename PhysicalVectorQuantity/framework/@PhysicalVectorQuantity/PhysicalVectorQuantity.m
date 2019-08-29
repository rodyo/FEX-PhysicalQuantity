classdef (Abstract) PhysicalVectorQuantity

    properties (SetAccess = private)
        x   % TODO: (Rody Oldenhuis) should eventually be a 
        y   % CoordinateSystem/Type/Frame (spherical coordinates should also be 
        z   % supported, plus conversions to and fro) 
    end
    
    properties (Abstract,...
                Hidden,...
                Constant)            
        datatype        
    end
    
    properties (Access = private)
        basetype_constructor
        vectortype_constructor
    end
    
    %% methods
    
    % Class basics
    methods
        
        % Constructor
        function obj = PhysicalVectorQuantity(varargin)
            
            % TODO (Rody Oldenhuis): think about how to do AngularMomentum...
            % H = r x V, so
            % H = AngularMomentumVector( cross(r,V), '??unit'')
            % 
            % ...that's 2 arguments, and a cast from <intermediate quantity>...
            
            try
                % Default constructor for the given data type
                % TODO (Rody Oldenhuis): assert superclass is PhysicalQuantityInterface
                assert(isa(obj.datatype, 'meta.class'),...
                       [mfilename('class') ':invalid_implementation'], [...
                       'Internal error; a PhysicalQuantityVector'' ',...
                       '''datatype'' property must be a meta.class.']);
                obj.basetype_constructor   = str2func(obj.datatype.Name);
                obj.vectortype_constructor = str2func(class(obj));

                % No argument: call no-arg constructor on the specific subclass, 
                % and create a vector out of that
                if nargin==0                  
                    zero = obj.basetype_constructor();                
                    obj  = obj.vectortype_constructor([zero zero zero]);
                    return;   
                end

                assert(all(cellfun(@(x) isa(x,...
                                            'PhysicalQuantityInterface'),...
                                   varargin)),...
                       [mfilename('class') ':invalid_argument'],...
                       'All arguments must be PhysicalQuantities.');

                assert(isa(varargin{1}, obj.datatype.Name),...
                       [class(obj) ':invalid_argument'], [...
                       'A %s is a vector of 3 %ss; received at least ',...
                       'one ''%s''.'],...
                       class(obj), obj.datatype.Name, class(varargin{1}));

                switch nargin

                    % Single argument: must be a 3-element PhysicalQuantity
                    case 1

                        pq = varargin{1};  

                        assert(numel(pq)==3,...
                               [class(obj) ':invalid_argument'], [...
                               'When calling %s with a a single argument, ',...
                               'that argument must be a 3-element ',...
                               'PhysicalQuantity.'],...
                                class(obj));                    

                        obj.x = pq(1);
                        obj.y = pq(2);
                        obj.z = pq(3);

                    % 3 arguments: each argument is an N-element subclass 
                    % of PhysicalQuantity (all the same subclass)
                    case 3

                        pqx = varargin{1};
                        pqy = varargin{2};
                        pqz = varargin{3};

                        assert(isequal(class(pqx),class(pqy),class(pqz)),...
                               [class(obj) ':invalid_argument'], [...
                               'All 3 input arguments must have the same ',...
                               'class. Received a "%s", a "%s" and a "%s".'],...
                               class(pqx), class(pqy), class(pqz));

                        assert(isequal(size(pqx),size(pqy),size(pqz)),...
                               [mfilename('class') ':invalid_argument'], [...
                               'All 3 input arguments must have the same ',...
                               'dimensions.']);

                        num_vectors = numel(pqx);                    
                        obj(num_vectors) = obj(1);
                        for ii = 1:num_vectors
                            obj(ii) = obj(1).vectortype_constructor([pqx(ii) pqy(ii) pqz(ii)]); end

                        obj = reshape(obj, size(pqx)); 


                    otherwise
                        error([mfilename('class') ':invalid_argcount'],...
                              '%s() takes either 1 or 3 input arguments.',...
                              mfilename('class'));
                end
                
            catch ME 
                throwAsCaller(ME);
            end
            
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
        % - comparisons 
        % TODO (Rody Oldenhuis): all wrong! should return single bool. Should also be possible to
        % compare with scalar (scalar double or scalar PhysicalQuantityInterface)
        function yn = eq(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) == double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = ne(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) ~= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = lt(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) < double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = le(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) <= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = gt(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) > double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        function yn = ge(this, that)
            try assert_both_are_physical_quantity_vectors(this, that, 'compare','to');
                yn = (double(this) >= double(that));
            catch ME, throwAsCaller(ME);
            end
        end
        
        % Basic operators: 
        % - abs, sign
        function obj = abs(obj)
            try for ii = 1:numel(obj)
                    obj(ii).x = abs(obj(ii).x); 
                    obj(ii).y = abs(obj(ii).y); 
                    obj(ii).z = abs(obj(ii).z); 
                end
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
            try for ii = 1:numel(obj)
                    obj(ii).x = +obj(ii).x; 
                    obj(ii).y = +obj(ii).y; 
                    obj(ii).z = +obj(ii).z; 
                end
            catch ME, throwAsCaller(ME);
            end
        end
        function obj = uminus(obj)
            try for ii = 1:numel(obj)
                    obj(ii).x = -obj(ii).x; 
                    obj(ii).y = -obj(ii).y; 
                    obj(ii).z = -obj(ii).z; 
                end
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
                
                assert_both_are_physical_quantity_vectors(that, this, str{:});
                
                % Mmost work is already done in PhysicalQuantityInterface; delegate
                new   = that;
                new.x = new.x + that.x;
                new.y = new.y + that.y;
                new.z = new.z + that.z;
                
            catch ME
                throwAsCaller(ME);
            end            
        end
        function new = minus(this, that)
            new = plus(this, -that, 1);
        end
        
        % Basic operators:         
        % - multiplication/division
        % TODO (Rody Oldenhuis) only makes sense if one of the two is a scalar. Otherwise, use 
        % a vector product 
        
              
        
        % Basic operators:         
        % - typecast to double/single
        function val = double(obj)
            try val = [cellfun(@double, {obj.x}).',...
                       cellfun(@double, {obj.y}).',...
                       cellfun(@double, {obj.z}).'];
            catch ME, throwAsCaller(ME); 
            end
        end        
        function val = single(obj)
            try val = [cellfun(@single, {obj.x}).',...
                       cellfun(@single, {obj.y}).',...
                       cellfun(@single, {obj.z}).'];
            catch ME, throwAsCaller(ME); 
            end
        end
        
    end
    
    % Operator overloads: typical vector operations
    methods
        
        
        function N = norm(obj)
            % TODO: potentially complicated....the norm has dimensions
        end
        
        function dot(this, other)
            % TODO: (Rody Oldenhuis) 
        end
                        
        function cross(this, other)
            % TODO: (Rody Oldenhuis) 
        end
        
        function unitVector(obj)
            % TODO: (Rody Oldenhuis) 
        end
        
        
    end
    
    
    % Operator overloads: advanced operators
    methods (Sealed)
                
        % Advanced operator:
        % - subsref
        
        
        
    end
    
    methods (Sealed)
        
        function columnVector(obj)
            % TODO: (Rody Oldenhuis) 
        end
        
        function rowVector(obj)
            % TODO: (Rody Oldenhuis) 
        end
        
    end
    
    
    
end



function assert_both_are_physical_quantity_vectors(this, that, op,prp)    
    cls = class(that);
    assert(isa(this,mfilename('class')) && isa(that,mfilename('class')),...
           [mfilename ':incompatible_types'],...
           'Can''t %s ''%s'' %s a%s ''%s''.',...
           op, class(this), prp, get_suffix(cls), cls);       
end

