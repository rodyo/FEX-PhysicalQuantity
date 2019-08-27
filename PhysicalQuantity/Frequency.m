classdef Frequency < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([0 0 -1 0 0 0 0 0]);
        units      = []% TODO: 'Hz'
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Frequency(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Frequency')
    methods (Static)
        function R = rand(varargin)
            R = Frequency(rand(varargin{:}), 's^-1'); end
    end
            
end
