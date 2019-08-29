classdef Velocity < PhysicalVectorQuantity
    
    properties (Hidden, Constant)
        datatype = ?Speed
    end  
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = Velocity(varargin)
            obj = obj@PhysicalVectorQuantity(varargin{:}); end 
    end
    
end
