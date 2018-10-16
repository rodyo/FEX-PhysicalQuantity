classdef LuminousIntensityUnits < UnitOfMeasurementType
    properties (Constant)
        dimensions  = SiBaseUnit.I.dimensions
        base_unit   = SiBaseUnit.I
        other_units = get_luminous_intensity_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_luminous_intensity_units()
    
    % TODO: (Rody Oldenhuis) 
    U = DerivedUnitOfMeasurement('dimensions', SiBaseUnit.I.dimensions);
    return; 
    
    %    system                     short   long                plural               conversion factor (to kg)
    S = {};
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({SiBaseUnit.I.dimensions},size(S,1),1),...
                                 'system',                  S(:,1)',...
                                 'short_name',              S(:,2)',...                                        
                                 'long_name',               S(:,3)',...
                                 'long_name_plural_form' ,  S(:,4)',...                                 
                                 'conversion_to_base_unit', S(:,5)'); 
    
end
