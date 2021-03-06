classdef MagneticFlux < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -2 -1 0 0 0 0]);        
        units      = get_units('magnetic_flux_units')
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = MagneticFlux(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'MagneticFlux')
    methods (Static)
        function R = rand(varargin)
            R = MagneticFlux(rand(varargin{:}), 'Wb'); end
    end
            
end
