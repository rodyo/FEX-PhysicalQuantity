classdef SpeedUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions  = PhysicalDimension([1 0 -1 0 0 0 0 0 ]);
        base_unit   = []
        other_units = get_speed_units()
    end    
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_speed_units()
    
    %    system                     short  long    conversion factor (to m/s)
    S = {SystemOfUnits.us_customary 'kn'   'knot'  1.852/3.6
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({SpeedUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1)',...
                                 'short_name',              S(:,2)',...                                        
                                 'long_name',               S(:,3)',...                                 
                                 'conversion_to_base_unit', S(:,4)'); 
    
end
