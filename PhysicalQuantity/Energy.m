classdef Energy < PhysicalQuantityInterface
    
    properties (Constant)                   
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -2 0 0 0 0 1]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Energy(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
        
end
