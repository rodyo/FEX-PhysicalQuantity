classdef Jerk < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -3 0 0 0 0 0]);
        units      = [] % TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Jerk(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
    
    % rand() method - for things like rand(1,3,'Jerk')
    methods (Static)
        function R = rand(varargin)
            R = Jerk(rand(varargin{:}), 'm/s^3'); end
    end
        
end
