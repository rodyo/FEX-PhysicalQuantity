classdef Conductance < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                                L  M t C T I N ii
        dimensions = PhysicalDimension([-2 -1 3 2 0 0 0 0]);        
        units      = []% TODO: 'Siemens', \Mho
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Conductance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Conductance')
    methods (Static)
        function R = rand(varargin)
            R = Conductance(rand(varargin{:}), 's^3*A^2/kg/m^2'); end
    end
            
end
