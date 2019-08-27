classdef Viscocity < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                                L M  t C T I N ii
        dimensions = PhysicalDimension([-1 1 -1 0 0 0 0 0]);        
        units      = [];%ViscocityUnits()
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Viscocity(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Viscocity')
    methods (Static)
        function R = rand(varargin)
            R = Viscocity(rand(varargin{:}), 'kg/m/s'); end
    end
        
end
