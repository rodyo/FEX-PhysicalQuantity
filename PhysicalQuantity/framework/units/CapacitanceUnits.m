classdef CapacitanceUnits < UnitOfMeasurementType
    properties (Constant)
        %                                L  M t C T I N ii
        dimensions = PhysicalDimension([-2 -1 4 2 0 0 0 0])    
        base_unit  = BaseUnitOfMeasurement('dimensions', CapacitanceUnits.dimensions,...
                                           'system'    , SystemOfUnits.metric, ...
                                           'short_name', 'F',...
                                           'long_name' , 'Farad')
        other_units = get_capacitance_units()
    end         
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_capacitance_units()
    
    %    system symbol          Symbol  long        conversion factor (to Farad)
    S = {SystemOfUnits.cgs      'abF'   'abfarad'   1e9
         SystemOfUnits.cgs      'statF' 'statfarad' 1.1126e-12
         SystemOfUnits.imperial ''      'jar'       1.111e-9
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({CapacitanceUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...
                                 'symbol',                  S(:,2).',...                                 
                                 'long_name',               S(:,3).',...                                 
                                 'conversion_to_base_unit', S(:,4).');                              
end
