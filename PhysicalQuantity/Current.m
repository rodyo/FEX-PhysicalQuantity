classdef Current < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.C.dimensions
        units      = get_units('current_units') 
    end
          
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Current(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end            
    
end
