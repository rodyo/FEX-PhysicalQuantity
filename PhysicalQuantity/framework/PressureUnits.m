classdef PressureUnits < UnitOfMeasurementType
    properties (Constant)
        %                                 L M  t C T I N ii
        dimensions  = PhysicalDimension([-1 1 -2 0 0 0 0 0]);
        base_unit   = BaseUnitOfMeasurement('dimensions', PressureUnits.dimensions,...
                                            'system'    ,  SystemOfUnits.metric, ...
                                            'short_name', 'Pa',...
                                            'long_name' , 'Pascal')
        other_units = get_pressure_units()
    end    
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_pressure_units()
    
    m   = SystemOfUnits.metric;
    mks = SystemOfUnits.mks;
        
    %    system symbol    short     long                plural           conversion factor (to meters)
    S = {m      ''        'bar'     'bar'              'bar'             1e5
         mks    ''        'atm'     'atmosphere'       'atmospheres'     101325
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({PressureUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1)',...
                                 'symbol',                  S(:,2)',...
                                 'short_name',              S(:,3)',...
                                 'long_name',               S(:,4)',...
                                 'long_name_plural_form' ,  S(:,5)',...
                                 'conversion_to_base_unit', S(:,6)'); 
    
end
