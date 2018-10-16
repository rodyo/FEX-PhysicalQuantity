classdef SolidAngle < PhysicalQuantityInterface

    properties (Constant)        
        dimensions = PhysicalDimension([0 0 0 0 0 0 0 2]);
        units      = get_units('solidangle_units') 
    end
    
    
    %% Methods
         
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = SolidAngle(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end 
            
    
end
