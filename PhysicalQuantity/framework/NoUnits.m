classdef NoUnits < UnitOfMeasurementType
    properties (Constant)
        %                                L M t C T I N ii
        dimensions  = PhysicalDimension([0 0 0 0 0 0 0 0 ]);        
        other_units = get_dimensionless_units()        
        base_unit   = BaseUnitOfMeasurement('dimensions',             NoUnits.dimensions,...
                                            'system',                 SystemOfUnits.dimensionless,...
                                            'short_name',             '[-]',...
                                            'short_name_plural_form', '[-]',...
                                            'long_name',              '[-]',...
                                            'long_name_plural_form',  '[-]');
    end    
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_dimensionless_units()
    
    % TODO: (Rody Oldenhuis) Mach number, strain, fine structure constant,
    % Reynolds number, etc. How to deal with those things?
         
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement(); 
    
end
