classdef ResistanceUnits < UnitOfMeasurementType
    properties (Constant)
        %                                L M  t  C T I N ii
        dimensions  = PhysicalDimension([2 1 -3 -2 0 0 0 0]);
        base_unit   = BaseUnitOfMeasurement('dimensions', ResistanceUnits.dimensions,...
                                            'system'    , SystemOfUnits.metric, ...
                                            'symbol'    , char(937),...
                                            'short_name', 'Ohm',...
                                            'long_name' , 'Ohm')
        other_units = get_resistance_units()
    end  
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_resistance_units()
    
    % See:
    % https://en.wikipedia.org/wiki/Category:Units_of_electrical_resistance
    
    %    system             short      long       conversion factor (to Ohm)
    S = {SystemOfUnits.cgs  'statohm'  'statohm'  8.987551787e11 
         SystemOfUnits.cgs  'abohm'    'abohm'    1e-9          };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({ResistanceUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...                                 
                                 'short_name',              S(:,2).',...
                                 'long_name',               S(:,3).',...                                 
                                 'conversion_to_base_unit', S(:,4).'); 
    
end
