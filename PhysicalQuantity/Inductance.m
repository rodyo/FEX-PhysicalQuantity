classdef Inductance < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -2 -2 0 0 0 0]);        
        units      = []% TODO: 'Henry'
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Inductance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Inductance')
    methods (Static)
        function R = rand(varargin)
            R = Inductance(rand(varargin{:}), 'kg*m^2/s^2/A^2'); end
    end
    
end
