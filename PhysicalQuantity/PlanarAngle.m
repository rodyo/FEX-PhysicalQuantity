classdef PlanarAngle < Angle
% Alias for 'Angle'      
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = PlanarAngle(varargin)
            obj = obj@Angle(varargin{:}); end 
    end 
        
end
