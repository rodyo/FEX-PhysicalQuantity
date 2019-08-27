classdef Pressure < PhysicalQuantityInterface
    
    properties (Constant)        
        %                                L M  t C T I N ii
        dimensions = PhysicalDimension([-1 1 -2 0 0 0 0 0]);
        units      = get_units('pressure_units') 
    end 
             
    % Dummy constructor - needed until R2017b
    methods
        function obj = Pressure(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end   
    
    % rand() method - for things like rand(1,3,'Pressure')
    methods (Static)
        function R = rand(varargin)
            R = Pressure(rand(varargin{:}), 'Pa'); end
    end
    
end
