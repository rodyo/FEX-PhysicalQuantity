classdef ConductanceUnits < UnitOfMeasurementType
    properties (Constant)
        %                                L  M t C T I N ii
        dimensions = PhysicalDimension([-2 -1 3 2 0 0 0 0]);        
        base_unit   = BaseUnitOfMeasurement('dimensions'           , ConductanceUnits.dimensions,...
                                            'system'               , SystemOfUnits.metric, ...
                                            'symbol'               , 'S',...
                                            'short_name'           , 'Siemens',...
                                            'long_name'            , 'siemens',...
                                            'long_name_plural_form', 'siemens')
        other_units = get_conductance_units()
    end  
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_conductance_units()
    
    % See:
    % https://en.wikipedia.org/wiki/Siemens_(unit)
    % https://en.wikipedia.org/wiki/SI_electromagnetism_units
    
    %    system                symbol     short long  conversion factor (to Siemens)
    S = {SystemOfUnits.metric  char(8487) 'mho' 'Mho' 1};
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({ConductanceUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1).',...                                 
                                 'symbol',                  S(:,2).',...
                                 'short_name',              S(:,3).',...
                                 'long_name',               S(:,4).',...                                 
                                 'conversion_to_base_unit', S(:,5).'); 
    
end
