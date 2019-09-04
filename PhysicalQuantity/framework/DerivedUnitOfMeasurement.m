classdef DerivedUnitOfMeasurement < BaseUnitOfMeasurement
    
    properties (SetAccess = immutable)
        conversion_to_base = 1 % (1,1) double = 1
    end
    
    methods        
        function obj = DerivedUnitOfMeasurement(varargin)
            
            % NOTE (Rody Oldenhuis): for some strange reason, MATLAB 
            % disallows using 'obj' in any way before the call to the super 
            % (see below). This is why the copy-constructor has to be 
            % implemented this awkwardly ...
            
            ind_for_deletion   = [];
            conversion_to_base = [];
            obj_to_copy        = [];
            
            if nargin 
                
                if nargin==1
                    
                    % Preparations fro copy-construct
                    if isa(varargin{1}, 'DerivedUnitOfMeasurement')
                        obj_to_copy = varargin{1};                    
                        varargin{1} = [];
                    end
                    
                else

                    % Parse PV pairs specific to this class            
                    assert(mod(nargin,2)==0,...
                           [mfilename ':pvpairs_expected'], ...
                           'Parameter value pairs expected.');

                    parameters = varargin(1:2:end);
                    values     = varargin(2:2:end);

                    for ii = 1:numel(parameters)

                        parameter = parameters{ii};
                        value     = values{ii};

                        switch lower(parameter)
                            case {'conversion_to_base'
                                  'conversion_to_base_unit'}
                                ind_for_deletion   = ii;
                                conversion_to_base = value;
                        end

                    end

                    % Remove those that are used only in this class
                    if ~isempty(ind_for_deletion)
                        varargin(2*ind_for_deletion+(-1:0)) = []; end
                    
                end

            end
            
            % Pass these args on to super's constructor
            obj = obj@BaseUnitOfMeasurement(varargin{:});
            
            % Copy constructor
            if nargin==1 && isa(obj_to_copy, 'DerivedUnitOfMeasurement')
                obj = obj_to_copy; return; end
            
            % Assign any class-specific data parsed above
            if ~isempty(conversion_to_base)
                if iscell(conversion_to_base)
                    [obj.conversion_to_base] = deal(conversion_to_base{:}); 
                else
                    obj.conversion_to_base = conversion_to_base; 
                end
            end
            
        end
    end
    
end
