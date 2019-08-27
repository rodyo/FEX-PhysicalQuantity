classdef Speed < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -1 0 0 0 0 0])
        units      = get_units('speed_units')
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Speed(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Speed')
    methods (Static)
        function R = rand(varargin)
            R = Speed(rand(varargin{:}), 'm/s'); end
    end
    
end
