classdef Resistance < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -3 -2 0 0 0 0]);
        units      = get_units('resistance_units');
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Resistance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Resistance')
    methods (Static)
        function R = rand(varargin)
            R = Resistance(rand(varargin{:}), 'Ohm'); end
    end
    
end
