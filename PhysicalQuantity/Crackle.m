classdef Crackle < PhysicalQuantityInterface
    
    properties (Constant)                   
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -5 0 0 0 0 0]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Crackle(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
    
    % rand() method - for things like rand(1,3,'Crackle')
    methods (Static)
        function R = rand(varargin)
            R = Crackle(rand(varargin{:}), 'm/s^5'); end
    end
            
end
