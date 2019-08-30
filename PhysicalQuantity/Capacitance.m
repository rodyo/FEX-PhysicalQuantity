classdef Capacitance < PhysicalQuantityInterface
    
    properties (Constant)                   
        %                                L  M t C T I N ii
        dimensions = PhysicalDimension([-2 -1 4 2 0 0 0 0])    
        units      = get_units('capacitance_units')
    end 
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Capacitance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end
    
    % rand() method - for things like rand(1,3,'Capacitance')
    methods (Static)
        function R = rand(varargin)
            R = Capacitance(rand(varargin{:}), 'F'); end
    end
            
end
