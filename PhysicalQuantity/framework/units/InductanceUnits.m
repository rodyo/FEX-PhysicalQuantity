classdef InductanceUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -2 -2 0 0 0 0])
        base_unit  = BaseUnitOfMeasurement('dimensions', InductanceUnits.dimensions,...
                                           'system'    ,  SystemOfUnits.metric, ...
                                           'short_name', 'H',...
                                           'long_name' , 'Henry')
        other_units = get_magnetic_flux_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_magnetic_flux_units()
    
    %    system symbol      Symbol long       conversion factor (to Henry)
    S = {SystemOfUnits.cgs  'abH'  'abhenry'  1e-9
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({InductanceUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...
                                 'symbol',                  S(:,2).',...                                 
                                 'long_name',               S(:,3).',...                                 
                                 'conversion_to_base_unit', S(:,4).');                              
end
