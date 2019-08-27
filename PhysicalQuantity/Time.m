classdef Time < PhysicalQuantityInterface

    properties (Constant)        
        dimensions = SiBaseUnit.t.dimensions
        units      = get_units('time_units')
    end
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Time(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Time')
    methods (Static)
        function R = rand(varargin)
            R = Time(rand(varargin{:}), 's'); end
    end
    
end
