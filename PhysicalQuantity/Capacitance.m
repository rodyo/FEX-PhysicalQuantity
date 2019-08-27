classdef Capacitance < PhysicalQuantityInterface
    
    properties (Constant)                   
        %                                L  M t C T I N ii
        dimensions = PhysicalDimension([-2 -1 4 2 0 0 0 0]);        
        units      = []% TODO: 'Fahrad'
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Capacitance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Capacitance')
    methods (Static)
        function R = rand(varargin)
            R = Capacitance(rand(varargin{:}), 's^4*A^2/kg/m^2'); end
    end
            
end
