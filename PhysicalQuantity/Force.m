classdef Force < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 1 -2 0 0 0 0 0]);
        units      = get_units('force_units') 
    end 
         
    % Dummy constructor - needed until R2017b
    methods
        function obj = Force(varargin)
            obj@PhysicalQuantityInterface(varargin{:}); end 
    end   
    
    % rand() method - for things like rand(1,3,'Force')
    methods (Static)
        function R = rand(varargin)
            R = Force(rand(varargin{:}), 'N'); end
    end
        
end
