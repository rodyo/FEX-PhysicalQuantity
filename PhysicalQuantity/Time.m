classdef Time < PhysicalQuantityInterface

    properties (Constant)        
        dimensions = SiBaseUnit.t.dimensions
        units      = get_units('time_units')
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Time(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end
