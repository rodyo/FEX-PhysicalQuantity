classdef PlanarAngle < Angle
    % Alias for 'Angle'      
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = PlanarAngle(varargin)
            obj = obj@Angle(varargin{:});
        end        
    end 
end
