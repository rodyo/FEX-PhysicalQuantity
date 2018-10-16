classdef Temperature < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.T.dimensions
        units      = get_units('temperature_units')
    end  
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Temperature(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end
