classdef Position < PhysicalVectorQuantity
    
    properties (Hidden, Constant)
        datatype = ?Length
    end 
        
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Position(varargin)
            obj = obj@PhysicalVectorQuantity(varargin{:});
        end        
    end
    
end
