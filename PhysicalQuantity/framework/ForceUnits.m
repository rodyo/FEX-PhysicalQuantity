classdef ForceUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([1 1 -2 0 0 0 0 1]);
        
        base_unit = BaseUnitOfMeasurement('dimensions', ForceUnits.dimensions,...
                                          'system',     SystemOfUnits.metric,...
                                          'short_name', 'N',...                                        
                                          'long_name',  'Newton'); 
        
        other_units = get_force_units()
    end    
end

% Utility funcion provides an easy means to write all the available force units
% in a concise way
function U = get_force_units()
        
    %    system                 short  long             long plural      conversion factor (to N)
    S = {SystemOfUnits.cgs      'dyn'  'dyne'           'dynes'          1e-5
         SystemOfUnits.metric   'kp'   'kilopond'       'kiloponds'      9.80665
         SystemOfUnits.metric   'kgf'  'kilogram-force' 'kilogram-force' 9.80665   % (alias)
         SystemOfUnits.imperial 'lbf'  'pound-force'    'pound-force'    4.448222 
         SystemOfUnits.fps      'pdl'  'poundal'        'poundal'        0.138255};
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',            repmat({ForceUnits.dimensions},size(S,1),1),...
                                 'system',                S(:,1)',...                                 
                                 'short_name',            S(:,2)',...                                        
                                 'long_name',             S(:,3)',...                                 
                                 'long_name_plural_form', S(:,4)',...                                 
                                 'conversion_to_base',    S(:,5)');
end
