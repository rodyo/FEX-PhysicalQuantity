classdef Position < PhysicalVectorQuantity
    
    properties (Hidden, Constant)
        datatype = ?Length
    end 
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = Position(varargin)
            obj = obj@PhysicalVectorQuantity(varargin{:}); end 
    end
    
end
