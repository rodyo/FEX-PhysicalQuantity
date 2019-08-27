classdef Temperature < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.T.dimensions
        units      = get_units('temperature_units')
    end  
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Temperature(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Temperature')
    methods (Static)
        function R = rand(varargin)
            R = Temperature(rand(varargin{:}), 'K'); end
    end
    
end
