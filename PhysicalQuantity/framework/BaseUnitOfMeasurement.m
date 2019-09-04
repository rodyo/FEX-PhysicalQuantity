classdef BaseUnitOfMeasurement < UnitOfMeasurement
    
    % Just dummy constructor - needed till R2017b
    methods        
        function obj = BaseUnitOfMeasurement(varargin)
            obj = obj@UnitOfMeasurement(varargin{:}); end 
    end
    
end
