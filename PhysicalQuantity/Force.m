classdef Force < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 1 -2 0 0 0 0 0]);
        units      = get_units('force_units') 
    end 
         
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Force(varargin)
            obj@PhysicalQuantityInterface(varargin{:});
        end        
    end    
    
end
