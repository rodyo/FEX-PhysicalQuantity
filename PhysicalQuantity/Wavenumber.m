classdef Wavenumber < PhysicalQuantityInterface
    
    properties (Constant)                    
        %                               L  M t C T I N ii
        dimensions = PhysicalDimension([-1 0 0 0 0 0 0 0]); % TODO: (Rody) conflicts with frequency etc.
        units      = []% TODO
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Wavenumber(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Wavenumber')
    methods (Static)
        function R = rand(varargin)
            R = Wavenumber(rand(varargin{:}), 'm^-1'); end
    end    
        
end
