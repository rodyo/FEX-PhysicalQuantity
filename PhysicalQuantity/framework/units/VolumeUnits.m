classdef VolumeUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([3 0 0 0 0 0 0 0 ]);
        
        base_unit   = [];        
        other_units = get_volume_units()
    end    
end

% Utility funcion provides an easy means to write all the available force units
% in a concise way
function U = get_volume_units()
        
    %    system                short  long     conversion factor (to m^3)
    S = {SystemOfUnits.metric  'l'    'liter'  1e-3
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',         repmat({VolumeUnits.dimensions},size(S,1),1),...
                                 'system',             S(:,1)',...                                 
                                 'short_name',         S(:,2)',...                                        
                                 'long_name',          S(:,3)',...
                                 'conversion_to_base', S(:,4)');
end
