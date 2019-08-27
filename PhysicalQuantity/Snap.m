classdef Snap < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -4 0 0 0 0 0]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Snap(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Snap')
    methods (Static)
        function R = rand(varargin)
            R = Snap(rand(varargin{:}), 'm/s^4'); end
    end
        
end
