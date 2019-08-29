classdef MassUnits < UnitOfMeasurementType
    properties (Constant)
        dimensions  = SiBaseUnit.M.dimensions
        base_unit   = SiBaseUnit.M
        other_units = get_mass_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_mass_units()
       
    % Some abbreviations
    sane     = SystemOfUnits.metric;
    crazy    = SystemOfUnits.imperial;
    retarded = SystemOfUnits.us_customary;    
    astro    = SystemOfUnits.astronomical;
    atomic   = SystemOfUnits.subatomic;

    %   system    symbol           short  long               long plural     conversion factor (to GRAM (not kg))
    S = {  
        sane      ''               't'    'tonne'            ''              1e6
        sane      ''               't'    'ton'              ''              1e6 % (alias)
        retarded  ''               ''     'short ton'        ''              907.18474e3
        crazy     ''               ''     'long ton'         ''              1016.047e3
        crazy     ''               'lb'   'pound'            ''              0.45359237e3
        retarded  ''               ''     'slug'             ''              14593.90
        crazy     ''               'st'   'stone'            ''              6.35029318e3
        crazy     char(8485)       'oz'   'ounce'            ''              28.349523125
        crazy     ''               'gr'   'grain'            ''              64.79891e-3
        crazy     ''               'ct'   'carat'            ''              200e-3     
        atomic    ['m' char(8346)] 'mp'   'Planck mass'      'Planck masses' 2.176435e-5
        atomic    'Da'             'u'    'Atomic mass unit' ''              1.66053906660e-24
        astro     ['M' char(9737)] ''     'Solar mass'       'Solar masses'  1.98847e27
        };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({MassUnits.dimensions},size(S,1),1),...
                                 'system',                  S(:,1)',...
                                 'symbol',                  S(:,2)',...
                                 'short_name',              S(:,3)',...
                                 'long_name',               S(:,4)',...   
                                 'long_name_plural_form',   S(:,5)',...                                 
                                 'conversion_to_base_unit', S(:,6)'); 
    
end
