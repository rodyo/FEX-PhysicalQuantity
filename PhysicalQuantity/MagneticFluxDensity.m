classdef MagneticFluxDensity < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([0 1 -2 -1 0 0 0 0])
        units      = get_units('magnetic_flux_density_units')
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = MagneticFluxDensity(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'MagneticFluxDensity')
    methods (Static)
        function R = rand(varargin)
            R = MagneticFluxDensity(rand(varargin{:}), 'T'); end
    end
    
end
