classdef Charge < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([0 0 1 1 0 0 0 0]);
        units      = []% TODO: 'Coulomb', 'e', etc.
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Charge(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Charge')
    methods (Static)
        function R = rand(varargin)
            R = Charge(rand(varargin{:}), 'A*s'); end
    end
            
end
