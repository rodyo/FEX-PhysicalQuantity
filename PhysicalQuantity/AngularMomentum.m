classdef AngularMomentum < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -1 0 0 0 0 1]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = AngularMomentum(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
    
    % rand() method - for things like rand(1,3,'AngularMomentum')
    methods (Static)
        function R = rand(varargin)
            R = AngularMomentum(rand(varargin{:}), 'kg*m^2/s'); end
    end
            
end
