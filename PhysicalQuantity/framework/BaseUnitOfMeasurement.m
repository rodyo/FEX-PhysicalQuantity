classdef BaseUnitOfMeasurement < UnitOfMeasurement
    
    % Just dummy constructor
    methods        
        function obj = BaseUnitOfMeasurement(varargin)
            obj = obj@UnitOfMeasurement(varargin{:});
        end
    end
    
end
