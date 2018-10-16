classdef Area < PhysicalQuantityInterface
    
    properties (Constant)        
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([2 0 0 0 0 0 0 0 ]);
        units      = get_units('area_units') 
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Area(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end
