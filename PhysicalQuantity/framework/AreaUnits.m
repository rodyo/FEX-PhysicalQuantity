classdef AreaUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([2 0 0 0 0 0 0 0 ]);
        
        base_unit   = [];        
        other_units = get_area_units()
    end    
end

% Utility funcion provides an easy means to write all the available force units
% in a concise way
function U = get_area_units()
        
    %    system                  short  long       conversion factor (to m^2)
    S = {SystemOfUnits.metric    'a'    'are'      100
         SystemOfUnits.metric    'ha'   'hectare'  10000
         SystemOfUnits.imperial  'ac'   'acre'     4046.9
         SystemOfUnits.subatomic 'b'    'barn'     1e-28
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',         repmat({AreaUnits.dimensions},size(S,1),1),...
                                 'system',             S(:,1)',...                                 
                                 'short_name',         S(:,2)',...                                        
                                 'long_name',          S(:,3)',...
                                 'conversion_to_base', S(:,4)');
end
