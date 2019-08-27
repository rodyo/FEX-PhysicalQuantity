classdef Power < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -3 0 0 0 0 0]);        
        units      = []% TODO: 'Watts', etc.
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Power(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Power')
    methods (Static)
        function R = rand(varargin)
            R = Power(rand(varargin{:}), 'm^2*kg/s^3'); end
    end    
        
end
