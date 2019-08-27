classdef Mass < PhysicalQuantityInterface
    
    properties (Constant)        
        dimensions = SiBaseUnit.M.dimensions
        units      = get_units('mass_units') 
    end   
          
    % Dummy constructor - needed until R2017b
    methods
        function obj = Mass(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end  
    
    % rand() method - for things like rand(1,3,'Mass')
    methods (Static)
        function R = rand(varargin)
            R = Mass(rand(varargin{:}), 'kg'); end
    end
    
end
