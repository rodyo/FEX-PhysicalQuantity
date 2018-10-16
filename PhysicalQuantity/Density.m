classdef Density < PhysicalQuantityInterface
    
    properties (Constant)
        %                                L M t C T I N ii
        dimensions = PhysicalDimension([-3 1 0 0 0 0 0 0 ]);
        units      = [] % TODO
    end
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Density(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
    
end