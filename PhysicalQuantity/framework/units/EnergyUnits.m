classdef EnergyUnits < UnitOfMeasurementType
    properties (Constant)
        %                               L M  t C T I N ii
        dimensions = PhysicalDimension([2 1 -2 0 0 0 0 1]);
        
        base_unit = BaseUnitOfMeasurement('dimensions', EnergyUnits.dimensions,...
                                          'system',     SystemOfUnits.metric,...
                                          'short_name', 'J',...                                        
                                          'long_name',  'Joule'); 
        
        other_units = get_energy_units()
    end
end

% Utility funcion provides an easy means to write all the available force units
% in a concise way
function U = get_energy_units()
    
    % From: 
    % https://en.wikipedia.org/wiki/Units_of_energy
        
    %    system                   short    long               long plural        conversion factor (to J)
    S = {SystemOfUnits.subatomic  'eV'     'electronvolt'     'electronvolts'    1.602176634e-19
         SystemOfUnits.cgs        'erg'    'erg'              'ergs'             1e-7
         SystemOfUnits.imperial   'Btu'    'BTU'              'BTUs'             1055.06 % International standard ISO 31-4 on Quantities and units—Part 4: Heat
         SystemOfUnits.imperial   'ft-lbf' 'foot pound-force' 'ft-lb'            1.3558179483314004 % (abusing the non-existent plural to get the variant of the short form in) 
         SystemOfUnits.imperial   'hph'    'horsepower-hour'  'horsepower-hours' 2.6845e6
         SystemOfUnits.metric     'cal'    'calorie'          'calories'         4.184  % small calorie
         SystemOfUnits.metric     'Cal'    'Calorie'          'Calories'         4184   % large calorie == 1 kcal
         SystemOfUnits.metric     'kWh'    'kilowatt-hour'    'kilowatt-hours'   3.6e6};
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',            repmat({EnergyUnits.dimensions},size(S,1),1),...
                                 'system',                S(:,1)',...                                 
                                 'short_name',            S(:,2)',...                                        
                                 'long_name',             S(:,3)',...                                 
                                 'long_name_plural_form', S(:,4)',...                                 
                                 'conversion_to_base',    S(:,5)');
end
