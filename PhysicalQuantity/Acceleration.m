classdef Acceleration < PhysicalQuantityInterface
    
    properties (Constant)            
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -2 0 0 0 0 0]);
        units      = []% TODO: 'g' (conflicts with gram)
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Acceleration(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end
    end
        
    % rand() method - for things like rand(1,3,'Acceleration')
    methods (Static)
        function R = rand(varargin)
            R = Acceleration(rand(varargin{:}), 'm/s^2'); end
    end
        
end
