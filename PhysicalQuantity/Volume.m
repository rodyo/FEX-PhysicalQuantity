classdef Volume < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([3 0 0 0 0 0 0 0 ]);
        units      = get_units('volume_units')
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Volume(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end
