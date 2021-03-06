classdef MagneticFluxDensityUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t  C T I N ii
        dimensions = PhysicalDimension([0 1 -2 -1 0 0 0 0]);
        base_unit  = BaseUnitOfMeasurement('dimensions', MagneticFluxDensityUnits.dimensions,...
                                           'system'    ,  SystemOfUnits.metric, ...
                                           'short_name', 'T',...
                                           'long_name' , 'Tesla')
        other_units = get_magnetic_flux_density_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_magnetic_flux_density_units()
    
    %    system symbol      Symbol short long    plural  conversion factor (to Tesla)
    S = {SystemOfUnits.cgs  'G'    'Gs'  'Gauss' 'Gauss' 1e-4
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({MagneticFluxDensityUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...
                                 'symbol',                  S(:,2).',...                                
                                 'short_name',              S(:,3).',...                                 
                                 'long_name',               S(:,4).',...                                 
                                 'long_name_plural_form',   S(:,5).',...                                 
                                 'conversion_to_base_unit', S(:,6).');                              
end
