classdef MomentOfInertia < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([2 1 0 0 0 0 0 0]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = MomentOfInertia(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'MomentOfInertia')
    methods (Static)
        function R = rand(varargin)
            R = MomentOfInertia(rand(varargin{:}), 'kg*m^2'); end
    end 
    
end
