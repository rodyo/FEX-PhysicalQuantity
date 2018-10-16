classdef LuminousIntensity < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.I.dimensions
        units      = get_units('luminous_intensity_units') 
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.            
    methods
        function obj = LuminousIntensity(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end
