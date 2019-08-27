classdef SpecificEnergy < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 0 -2 0 0 0 0 1]);
        units      = [] % TODO: J/kg etc. 
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = SpecificEnergy(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'SpecificEnergy')
    methods (Static)
        function R = rand(varargin)
            R = SpecificEnergy(rand(varargin{:}), 'm^2/s^2'); end
    end
        
end
