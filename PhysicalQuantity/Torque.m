classdef Torque < PhysicalQuantityInterface
    
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -2 0 0 0 0 0]);
        units      = []% TODO        
    end 
           
    % Dummy constructor - needed until R2017b
    methods
        function obj = Torque(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end  
    
    % rand() method - for things like rand(1,3,'Torque')
    methods (Static)
        function R = rand(varargin)
            R = Torque(rand(varargin{:}), 'm^2*kg/s^2'); end
    end
    
end
