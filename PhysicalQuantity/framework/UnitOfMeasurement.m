 classdef UnitOfMeasurement 

    %% Properties
        
    properties (SetAccess = immutable)
        
        dimensions = PhysicalDimension() 
    
        system  = SystemOfUnits.metric % NOTE: when not metric, multipliers are not used
    
        % String parsing & generation 
        symbol = ''
        
        short_name             = ''  
        short_name_plural_form = ''
         
        long_name             = ''    
        long_name_plural_form = ''
        
    end
    
    %% Methods
    
    % Class basics
    methods
        
        % Constructor
        function obj = UnitOfMeasurement(varargin)
            
            % Allow empty object
            if nargin==0 || isempty(varargin{1})
                return; end
            
            % Copy constructor (cast-to-UnitOfMeasurement)
            if nargin==1        
                other = varargin{1};
                assert(isa(other, mfilename('class')),...
                       [mfilename('class') ':incompatible_type'],...
                       'Can''t create a %s out of a %s.',...
                       mfilename('class'), class(varargin{1}));
                   
                num_objs = numel(other);
                obj(num_objs) = obj(1);
                for ii = 1:num_objs
                    P = properties(obj(ii));
                    for jj = 1:numel(P)                        
                        try %#ok<TRYNC>
                            obj(ii).(P{jj}) = other(ii).(P{jj}); 
                        end
                    end 
                end
                return 
            end
            
            % Parse input argument as P/V pairs. These are either strings, 
            % or cellstrings, in which case an object array will be created            
            assert(mod(nargin, 2)==0,...
                   [mfilename ':pvpairs_expected'], ...
                   'Parameter value pairs expected.');
            
            parameters = varargin(1:2:end);
            values     = varargin(2:2:end);
            
            if iscell(values{1})
                numobjs = numel(values{1});
                assert(all(cellfun('prodofsize',values) == numobjs),...
                      [mfilename ':inconsistent_size'],...
                      'Sizes of all arrays must be identical.');
            else
                numobjs = 1;
                values = cellfun(@(x){x}, values, 'UniformOutput', false);
            end
             
            obj(numobjs) = obj(1); 
            for ii = 1:numobjs
                for jj = 1:numel(parameters)

                    p = lower(parameters{jj});
                    v = values{jj}{ii};
                    
                    switch p
                        
                        case 'dimensions' 
                            % NOTE: checks are done in PhysicalDimension()
                            obj(ii).dimensions = PhysicalDimension(v);
                        
                        case 'system'                            
                            assert(isa(v, 'SystemOfUnits'),...
                                   [mfilename ':invalid_system_of_units'], [...
                                   'System of units must be specified with ',...
                                   'a ''SystemOfUnits'' enumeration class.']);
                            obj(ii).system = v;
                        
                        case {'symbol',...
                              'short_name' 'short_name_plural_form' ,...
                              'long_name'  'long_name_plural_form'}
                            try
                                v = assert_string(v,p);
                                obj(ii).(p) = v;
                            catch me
                                throwAsCaller(me); 
                            end                            
                            
                        case 'use_multipliers'                            
                            try
                                v = assert_logical(v,p);
                            catch me
                                throwAsCaller(me); 
                            end
                            obj(ii).use_multipliers = v;

                        case {'conversion' 'conversion_to_base_unit'}
                            try
                                v = assert_number(v,p); 
                            catch me
                                throwAsCaller(me); 
                            end
                            obj(ii).conversion_to_base_unit = v;

                        otherwise
                            warning([mfilename ':unsupported_parameter'], ...
                                    'Unsupported parameter: ''%s''; ignoring...',...
                                    p);
                            continue;
                    end
                end
                
                % Plural form for short name: the detault is to set this 
                % equal to the short name itself 
                if isempty(obj(ii).short_name_plural_form)
                    obj(ii).short_name_plural_form = obj(ii).short_name; end
                
                % Plural form for long name: the detault is to append an 's'
                if isempty(obj(ii).long_name_plural_form) && ~isempty(obj(ii).long_name)
                    obj(ii).long_name_plural_form = [obj(ii).long_name 's']; end
                
            end
        end
        
        % Compare 2 Derived/Base/UnitOfMeasurements
        function yn = eq(this, that)
            try
                yn = isequal(DerivedUnitOfMeasurement(this),...
                             DerivedUnitOfMeasurement(that));                
            catch
                ME = MException([mfilename('class') ':invalid_operation'],...
                                'Can''t compare a ''%s'' with a ''%s''.',...
                                class(this), class(that));
                throwAsCaller(ME);
            end
        end
        function yn = ne(this,that)
            try yn = ~(this==that);
            catch ME, throwAsCaller(ME);
            end
        end
        
    end
    
end

% Utility functions 

function str = assert_string(str, p)
    assert(ischar(str) && size(str,1)<=1,...
           [mfilename ':invalid_property'],...
           'Character array expected for ''%s''; received ''%s''.',...
           p, class(str));
end

function v = assert_number(v, p)
    assert(isnumeric(v) && isscalar(v) && isreal(v) && isfinite(v),...
           [mfilename ':invalid_property'], ...
           '''%s'' must be a real, finite, numeric scalar.',...
           p);
end

function L = assert_logical(L, p)
    assert(islogical(L) && isscalar(L),...
           [mfilename ':invalid_property'], ...
           '''%s'' must be a logical scalar.',...
           p);
end
