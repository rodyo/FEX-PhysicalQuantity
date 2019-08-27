classdef Length < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.L.dimensions
        units      = get_units('length_units')
    end
    
    % Dummy constructor - needed until R2017b       
    methods
        function obj = Length(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end 
    
    % rand() method - for things like rand(1,3,'Length')
    methods (Static)
        function R = rand(varargin)
            R = Length(rand(varargin{:}), 'm'); end
    end
    
end
