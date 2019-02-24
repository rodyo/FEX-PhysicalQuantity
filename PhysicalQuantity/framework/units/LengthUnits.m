classdef LengthUnits < UnitOfMeasurementType
    properties (Constant)
        dimensions  = SiBaseUnit.L.dimensions
        base_unit   = SiBaseUnit.L
        other_units = get_length_units()
    end    
end

% Utility funcion provides an easy means to write all the available length units
% in a concise way
function U = get_length_units()
    
    m   = SystemOfUnits.metric;
    us  = SystemOfUnits.us_customary;
    ch  = SystemOfUnits.chinese;
    iau = SystemOfUnits.astronomical;
    cern= SystemOfUnits.subatomic;
    
    %    system symbol    short     long                plural               conversion factor (to meters)
    S = {us     ''        'in'      'inch'              'inches'             0.0254
         us     ''        'ft'      'foot'              'feet'               0.3048
         us     ''        'yd'      'yard'              'yards'              0.9144          
         us     ''        'fur'     'furlong'           'furlong'            201.168
         us     ''        'mi'      'mile'              'miles'              1609.344 
         us     ''        'n.mi'    'nautical mile'     'nautical miles'     1852.0
         us     ''        'st.mi'   'statute mile'      'statute miles'      1609.347 
         ch     ''        'li'      'Chinese mile'      'Chinese miles'      500.0
         m      ''        'smt'     'smoot'             'smoots'             1.7018         
         iau    ''        'AU'      'astronomical unit' 'astronomical units' 149597870700
         iau    ''        'ly'      'lightyear'         'lightyears'         9.460536207068016e+15
         m      ''        'pc'      'Parsec'            'Parsec'             3.085677581491367e+16 % NOTE: (Rody Oldenhuis) metric, because 'Mpc' etc. is a thing 
         cern   char(197) char(197) [char(197) 'ngstr' char(246) 'm'] [char(197) 'ngstr' char(246) 'ms'] 1e-10 
         };
     
    % Now define the actual unit object
    D = LengthUnits.dimensions;
    U = @DerivedUnitOfMeasurement;
    U = U('dimensions',              repmat({D},size(S,1),1),...
          'system',                  S(:,1)',...
          'symbol',                  S(:,2)',...
          'short_name',              S(:,3)',...
          'long_name',               S(:,4)',...
          'long_name_plural_form' ,  S(:,5)',...
          'conversion_to_base_unit', S(:,6)');     
end
