classdef Velocity < PhysicalVectorQuantity
    
    properties (Hidden, Constant)
        datatype = ?Speed
    end  
        
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Velocity(varargin)
            obj = obj@PhysicalVectorQuantity(varargin{:});
        end        
    end
    
end
