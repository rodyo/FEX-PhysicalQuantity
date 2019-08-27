classdef Potential < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -3 -1 0 0 0 0]);        
        units      = []% TODO: 'Volt'
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Potential(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Potential')
    methods (Static)
        function R = rand(varargin)
            R = Potential(rand(varargin{:}), 'm^2*kg/s^3/A'); end
    end    
        
end
