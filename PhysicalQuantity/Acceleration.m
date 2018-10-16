classdef Acceleration < PhysicalQuantityInterface
    
    properties (Constant)            
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -2 0 0 0 0 0]);
        units      = []% TODO: 'g' (conflicts with gram)
    end 
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.    
    methods
        function obj = Acceleration(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
        
end
