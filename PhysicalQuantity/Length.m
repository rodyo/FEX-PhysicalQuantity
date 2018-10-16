classdef Length < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.L.dimensions
        units      = get_units('length_units')
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.    
    methods
        function obj = Length(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end 
    
end
