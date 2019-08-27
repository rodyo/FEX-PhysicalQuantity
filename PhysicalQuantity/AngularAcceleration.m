classdef AngularAcceleration < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([0 0 -2 0 0 0 0 1]);
        units      = [] % TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = AngularAcceleration(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'AngularAcceleration')
    methods (Static)
        function R = rand(varargin)
            R = AngularAcceleration(rand(varargin{:}), 's^-2'); end
    end
            
end
