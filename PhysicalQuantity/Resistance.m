classdef Resistance < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -3 -2 0 0 0 0]);        
        units      = []% TODO: char(937),'Ohm'
    end 
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.    
    methods
        function obj = Resistance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end
        
end
