classdef Area < PhysicalQuantityInterface
    
    properties (Constant)        
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([2 0 0 0 0 0 0 0 ]);
        units      = get_units('area_units') 
    end
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Area(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Area')
    methods (Static)
        function R = rand(varargin)
            R = Area(rand(varargin{:}), 'm^2'); end
    end
        
end
