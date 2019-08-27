classdef SolidAngle < PhysicalQuantityInterface

    properties (Constant)        
        dimensions = PhysicalDimension([0 0 0 0 0 0 0 2]);
        units      = get_units('solidangle_units') 
    end
    
    
    %% Methods
         
    % Dummy constructor - needed until R2017b
    methods
        function obj = SolidAngle(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end 
        
    % rand() method - for things like rand(1,3,'Length')
    methods (Static)
        function R = rand(varargin)
            R = SolidAngle(rand(varargin{:}), 'sr'); end
    end
        
end
