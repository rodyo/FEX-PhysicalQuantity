classdef Current < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.C.dimensions
        units      = get_units('current_units') 
    end
          
    % Dummy constructor - needed until R2017b
    methods
        function obj = Current(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end   
    
    % rand() method - for things like rand(1,3,'Current')
    methods (Static)
        function R = rand(varargin)
            R = Current(rand(varargin{:}), 'A'); end
    end
        
end
