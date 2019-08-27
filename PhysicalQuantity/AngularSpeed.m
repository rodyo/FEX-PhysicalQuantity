classdef AngularSpeed < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([0 0 -1 0 0 0 0 1]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = AngularSpeed(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
    
    % rand() method - for things like rand(1,3,'AngularSpeed')
    methods (Static)
        function R = rand(varargin)
            R = AngularSpeed(rand(varargin{:}), 's^-1'); end
    end
    
end
