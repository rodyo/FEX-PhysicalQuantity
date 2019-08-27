classdef SpecificAngularMomentum < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 0 -1 0 0 0 0 1]);
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = SpecificAngularMomentum(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'SpecificAngularMomentum')
    methods (Static)
        function R = rand(varargin)
            R = SpecificAngularMomentum(rand(varargin{:}), 'm^2/s'); end
    end    
        
end
