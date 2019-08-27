classdef Volume < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([3 0 0 0 0 0 0 0 ]);
        units      = get_units('volume_units')
    end
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Volume(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Volume')
    methods (Static)
        function R = rand(varargin)
            R = Volume(rand(varargin{:}), 'm^3'); end
    end
    
end
