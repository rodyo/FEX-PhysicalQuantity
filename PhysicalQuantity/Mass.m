classdef Mass < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.M.dimensions
        units      = get_units('mass_units') 
    end   
          
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Mass(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end    
    
end
