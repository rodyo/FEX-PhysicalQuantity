classdef LuminousIntensity < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.I.dimensions
        units      = get_units('luminous_intensity_units') 
    end
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = LuminousIntensity(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'LuminousIntensity')
    methods (Static)
        function R = rand(varargin)
            R = LuminousIntensity(rand(varargin{:}), 'cd'); end
    end
    
end
