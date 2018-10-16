classdef PhysicalDimension 
    
    %% Properties
    
    properties (SetAccess = private)      
        % All physical quantities have dimensions that are a permutation 
        % of the SI base dimensions:
        L  (1,1) double = 0 % Length
        M  (1,1) double = 0 % Mass
        t  (1,1) double = 0 % Time
        C  (1,1) double = 0 % Current
        T  (1,1) double = 0 % Temperature
        I  (1,1) double = 0 % Luminous intensity
        N  (1,1) double = 0 % amount of Substance
        ii (1,1) double = 0 % Free counter to resolve unit ambiguities 
                            % (e.g., both energy and torque are N x m)        
    end
    
    %% Methods
    
    methods 
        
        % Class constructor
        function obj = PhysicalDimension(varargin)
            
            % Allow empty object (DimensionLess)
            if nargin==0
                return; end
            
            % Construct via vector
            if nargin==1
                
                dims = varargin{1};
                
                % Copy-call
                if isa(dims, class(obj))
                    obj = dims; return; end
                
                % Vector-call
                assert(isnumeric(dims) && isvector(dims) && numel(dims)==8 &&...
                       all(isreal(dims)) && all(isfinite(dims)),...
                       [mfilename('class') ':invalid_argument'], [...
                       'When constructing a %s with a single argument, that ',...
                       'argument must be a %s itself, or an 8-element numic ',...
                       'array.'],...
                       class(obj), class(obj));
                
                obj.L = dims(1);     obj.T  = dims(5);
                obj.M = dims(2);     obj.I  = dims(6);
                obj.t = dims(3);     obj.N  = dims(7);
                obj.C = dims(4);     obj.ii = dims(8);
                
                return; 
            end
            
            % Construct via vector P/V pairs
            assert(mod(nargin, 2)==0,...
                   [mfilename('class') ':pvpairs_expected'], ...
                   'Parameter value pairs expected.');
            
            parameters = varargin(1:2:end);
            values     = varargin(2:2:end);
             
            for ii = 1:numel(parameters)
                        
                parameter = parameters{ii};
                value     = values{ii};
                
                switch parameter % NOTE: case-sensitive
                    
                    case properties(obj)', obj.(parameter) = value;
                        
                    otherwise
                        warning([mfilename('class') ':unsupported_parameter'],...
                                'Unsupported parameter: ''%s''; ignoring...',...
                                parameter);
                        continue;
                end                
            end
            
        end 
        
        % Operator overloads: equals
        function yn = isequal(varargin)
            yn = true;
            for jj = 1:numel(varargin)-1
                if varargin{jj}~=varargin{jj+1}
                    yn = false; return; end
            end
        end
        function yn = ne(this, that)
            yn = ~(this==that);
        end
        function yn = eq(this, that)
            
            % Check data types & sizes
            tc = mfilename('class');  
            if ~isa(this,tc) || ~isa(that,tc) || ~isequal(size(this),size(that))
                yn = false;
                
            else               
                % Do the comparion on 2 PhysicalDimensions objects. Note that 
                % the free counter is excluded.
                [~, these_dims] = this.getPropertyList();
                [~, those_dims] = that.getPropertyList();

                yn = isequal(these_dims, those_dims);
                
            end
            
        end
        
        % Operator overloads: uplus/uminus
        function obj = uplus(obj)
            try
                for p = properties(obj)'
                    obj.(p{1}) = +obj.(p{1}); end
            catch ME
                throwAsCaller(ME);
            end
        end
        function obj = uminus(obj)
            try
                for p = properties(obj)'
                    obj.(p{1}) = -obj.(p{1}); end
            catch ME
                throwAsCaller(ME);
            end
        end
        
        % Operator overloads: plus/minus
        % - Needed when multiplying two PhysicalQuantities together
        function obj = plus(this, that)
            try            
                correct_type = mfilename('class');
                assert(isa(this,correct_type) && isa(that,correct_type),...
                       [correct_type ':invalid_operation'],...
                       'Cannot add ''%s'' to ''%s''.',...                   
                       class(this), class(that));

                obj = this;
                for p = properties(obj)'
                    obj.(p{1}) = obj.(p{1}) + that.(p{1}); end
            catch ME
                throwAsCaller(ME);
            end
        end
        function obj = minus(this, that)
            try   
                correct_type = mfilename('class');
                assert(isa(this,correct_type) && isa(that,correct_type),...
                       [correct_type ':invalid_operation'],...
                       'Cannot subtract ''%s'' from''%s''.',...                   
                       class(this), class(that));

                obj = this;
                for p = properties(obj)'
                    obj.(p{1}) = obj.(p{1}) - that.(p{1}); end
            catch ME
                throwAsCaller(ME);
            end
        end        
        function new_obj = sum(obj)
            new_obj = obj(1);
            for jj = 2:numel(obj)
                new_obj = new_obj + obj(jj); end
        end
        
        % operator overload: times
        % - Needed when raising PhysicalQuantities to some power
        function obj = times(this, that)
            try
                correct_type = 'double';
                assert(isa(this,correct_type) || isa(that,correct_type),...
                       [correct_type ':invalid_operation'],...
                       'Can''t multiply a ''%s'' with a ''%s''.',...                   
                       class(this), class(that));
                   
                if isa(this,'double')
                    [this,that] = deal(that,this); end
                
                % Note that the free counter is excluded.
                obj      = this;
                proplist = obj(1).getPropertyList()';
                if ~isscalar(that)
                    
                    assert(isequal(numel(this), numel(that)),...
                           [mfilename ':invalid_operation'], ...
                           'Matrix dimensions must agree.');
                       
                    for jj = 1:numel(obj)
                        for p = proplist
                            obj(jj).(p{1}) = obj(jj).(p{1}) * that(jj); end
                    end
                    
                else                    
                    for jj = 1:numel(obj)
                        for p = proplist
                            obj(jj).(p{1}) = obj(jj).(p{1}) * that; end
                    end
                end
                
            catch ME
                throwAsCaller(ME);
            end
        end
        function obj = mtimes(this, that)
            obj = this .* that;
        end
        
        % operator overload: nnz
        function nz = nnz(obj)            
            [~, dims] = obj.getPropertyList();
            nz = nnz(dims);            
        end
        
        % operator overload: cast to SI base unit/exponents
        function [units, powers] = SiBaseUnit(obj)
            
            [props, dims] = obj.getPropertyList();
            
            inds = dims~=0;
            if any(inds)
                props = props(inds);

                num_props = numel(props);

                units(num_props) = UnitOfMeasurement();            
                for jj = 1:num_props
                    units(jj) = SiBaseUnit.(props{jj}); end

                powers = dims(inds);
                
            else
                units  = [];
                powers = 1;                
            end
                       
        end
        
        
        % generate string representation        
        function str = char(obj)
            
            [props, dims, counter] = obj.getPropertyList();
            
            % Dimensionless
            if all(dims==0)
                str = '[-]';
                
            % Dimensioned
            else
                
                % Dimensions (Unicode ftw!)
                num = cell(numel(dims),1);
                for jj = 1:numel(dims)
                    if dims(jj)
                        pwr = '';
                        if dims(jj) > 1
                            switch dims(jj) 
                                
                                case 2, pwr = char(178);
                                case 3, pwr = char(179);
                                    
                                case {4 5 6 7 8 9}
                                    pwr = char(8304+dims(jj));  
                                    
                                otherwise
                                    pwr = sprintf('^%d', dims(jj));
                            end                            
                        end
                        if dims(jj) < 0
                            switch dims(jj) 
                                case -1, pwr = [char(8315) char(185)];
                                case -2, pwr = [char(8315) char(178)];
                                case -3, pwr = [char(8315) char(179)];  
                                    
                                case {-4 -5 -6 -7 -8 -9}
                                    pwr = [char(8315) char(8304-dims(jj))];                                      
                                    
                                otherwise, pwr = sprintf('^(%d)', dims(jj)); 
                            end                            
                        end
                        num{jj} = ['[' props{jj} ']' pwr];
                    end
                end
                
                % Format string
                str = strjoin(num(~cellfun('isempty', num)), char(183));
            
            end
            
            % Free counter
            if counter
                str = [str sprintf(' (type %d)', counter)]; end
            
        end        
        function str = string(obj)
            str = string(char(obj));
        end           
        
    end
    
    
    methods (Access = private)
        
        % Order-independent way to get this class' list of properties, excluding
        % the free counter 'ii'
        function [props, dims, counter] = getPropertyList(obj)
            
            props = properties(obj);
            dims  = cellfun(@(x)obj.(x),props);
            
            ctrind  = strcmp(props, 'ii');   props(ctrind) = [];
            counter = dims(ctrind);          dims(ctrind)  = [];
            
        end
        
    end
    
end
