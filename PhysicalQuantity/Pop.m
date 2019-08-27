classdef Pop < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 0 -6 0 0 0 0 0]);
        units      = []% TODO
    end 
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = Pop(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Pop')
    methods (Static)
        function R = rand(varargin)
            R = Pop(rand(varargin{:}), 'm/s^6'); end
    end
            
end
