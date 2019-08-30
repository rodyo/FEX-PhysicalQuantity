classdef MagneticFluxUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([2 1 -2 -1 0 0 0 0]);        
        base_unit  = BaseUnitOfMeasurement('dimensions', MagneticFluxUnits.dimensions,...
                                           'system'    ,  SystemOfUnits.metric, ...
                                           'short_name', 'Wb',...
                                           'long_name' , 'Weber')
        other_units = get_magnetic_flux_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_magnetic_flux_units()
    
    %    system symbol      Symbol long       conversion factor (to Weber)
    S = {SystemOfUnits.cgs  'Mx'   'Maxwell'  1e-8
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({MagneticFluxUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...
                                 'symbol',                  S(:,2).',...                                 
                                 'long_name',               S(:,3).',...                                 
                                 'conversion_to_base_unit', S(:,4).');                              
end
