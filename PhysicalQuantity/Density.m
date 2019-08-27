classdef Density < PhysicalQuantityInterface
    
    properties (Constant)
        %                                L M t C T I N ii
        dimensions = PhysicalDimension([-3 1 0 0 0 0 0 0 ]);
        units      = [] % TODO
    end
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Density(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
    
    % rand() method - for things like rand(1,3,'Density')
    methods (Static)
        function R = rand(varargin)
            R = Density(rand(varargin{:}), 'kg/m^3'); end
    end
        
end
