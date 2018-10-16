classdef AngleUnits < UnitOfMeasurementType
    properties (Constant)        
        %                                L M t C T I N ii
        dimensions  = PhysicalDimension([0 0 0 0 0 0 0 1]);
        
        base_unit = BaseUnitOfMeasurement('dimensions', AngleUnits.dimensions,...
                                          'system',     SystemOfUnits.metric,...
                                          'short_name', 'rad',...                                        
                                          'long_name',  'radian'); 
        
        other_units = get_angle_units()
    end    
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_angle_units()
    
    stm = SystemOfUnits.dimensionless;
    stM = SystemOfUnits.metric;
    U   = AngleUnits.dimensions;
    
    %  system  symbol                     short  long        conversion factor (to radians)
    S = {stm   sprintf('\b%c',char(176))  'deg'  'degree'    pi/180
         stm   sprintf('\b%c',char(7501)) 'grad' 'gradian'   pi/200
         stm   sprintf('\b%c',char(7501)) 'gon'  'gon'       pi/200    % (alias for grad)
         stm   ''                         'tr'   'turn'      2*pi
         stm   ''                         'pla'  'turn'      2*pi      % (alias for turn)
         stm   sprintf('\b%c',char(8242)) ''     'arcminute' pi/10800
         stM   sprintf('\b%c',char(8243)) 'as'   'arcsecond' pi/648000};
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',         repmat({U},size(S,1),1),...
                                 'system',             S(:,1)',...
                                 'symbol',             S(:,2)',...
                                 'short_name',         S(:,3)',...                                        
                                 'long_name',          S(:,4)',...                                 
                                 'conversion_to_base', S(:,5)');
end
