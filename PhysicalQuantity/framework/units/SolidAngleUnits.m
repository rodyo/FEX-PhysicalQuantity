classdef SolidAngleUnits < UnitOfMeasurementType
    properties (Constant)        
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([0 0 0 0 0 0 0 2]);
        
        base_unit = BaseUnitOfMeasurement('dimensions', SolidAngleUnits.dimensions,...
                                          'system',     SystemOfUnits.metric,...
                                          'short_name', 'sr',...                                        
                                          'long_name',  'sterradian')
        other_units = AngleUnits.other_units;
    end    
end
