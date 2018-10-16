classdef (Abstract) UnitOfMeasurementType
    
    properties (Abstract, Constant)
        dimensions  %(1,1) PhysicalDimension    
        base_unit   % (no verification)
        other_units % (no verification)
    end
    
    methods   
        function obj = UnitOfMeasurementType(varargin)
            
            error_msg = 'Inconsistent dimensions among given units.';
            error_id  = [mfilename('class') ':inconsistent_dimensions'];
            
            if ~isempty(obj.base_unit)                
                assert(isequal(obj.base_unit.dimensions, obj.dimensions),...
                       error_id, error_msg);
            end            
            if ~isempty(obj.other_units)                
                assert(isequal(obj.other_units.dimensions, obj.dimensions),...
                       error_id, error_msg);
            end
            
        end
    end
    
    methods        
        function units = getAllUnits(obj)            
            % NOTE: (Rody Oldenhuis) concatenation order is important; a
            % BaseUnit can be cast to a DerivedUnit, but not the other way round
            units = [obj.other_units(:); obj.base_unit];            
        end
    end
    
end
