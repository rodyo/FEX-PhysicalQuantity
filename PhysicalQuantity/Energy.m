classdef Energy < PhysicalQuantityInterface
    
    properties (Constant)                   
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -2 0 0 0 0 1]);
        units      = get_units('energy_units') 
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Energy(varargin)
            obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Energy')
    methods (Static)
        function R = rand(varargin)
            R = Energy(rand(varargin{:}), 'kg*m^2/s^2'); end
    end
    
end
