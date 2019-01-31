classdef TimeUnits < UnitOfMeasurementType
    properties (Constant)
        dimensions  = SiBaseUnit.t.dimensions
        base_unit   = SiBaseUnit.t
        other_units = get_time_units()
    end    
end

% Utility funcion provides an easy means to write all the available units
% in a concise way
function U = get_time_units()
    
    mlt = SystemOfUnits.babylonian;
    sys = SystemOfUnits.time;
    
    %    system  symbol        short  long         long plural     conversion factor (to s)
    S = {...
         %{
         NOTE: these are to be used as "multipliers" for display purposes
         %}        
         mlt     ''            'min'  'minute'      'minutes'      60
         mlt     ''            'h'    'hour'        'hours'        3600     % = 60 * 60
         mlt     ''            'd'    'day'         'days'         86400    % = 24 * 3600
         mlt     ''            'w'    'week'        'weeks'        604800   % = 7 * 86400
         mlt     ''            'mo'   'month'       'months'       2629746  % = 365.2425*86400/12
         mlt     ''            'y'    'year'        'years'        31556952 % = 365.2425*86400
         mlt     ''            'd.'   'decade'      'decades'      1e1  * 31556952
         mlt     ''            'c.'   'century'     'centuries'    1e2  * 31556952
         mlt     ''            'm.'   'millennium'  'millennia'    1e3  * 31556952
         mlt     ''            'My'   'megannum'    'meganna'      1e6  * 31556952 % BUG: ((2018/June/27, Rody Oldenhuis)) you cannot construct a Time() with a 'My' unit...        
         mlt     ''            'My'   'megayear'    'megayears'    1e6  * 31556952 % (alias)
         mlt     ''            'Gy'   'gigayear'    'gigayears'    1e9  * 31556952
         mlt     ''            'ae'   'aeon'        'aeons'        1e9  * 31556952 % (alias)
         mlt     ''            'ae'   'eon'         'eons'         1e9  * 31556952 % (alias)
         mlt     ''            'Ty'   'terayear'    'terayears'    1e12 * 31556952
         mlt     ''            'Py'   'petayear'    'petayears'    1e15 * 31556952
         mlt     ''            'Ey'   'exayear'     'exayears'     1e18 * 31556952
         mlt     ''            'Zy'   'zetayear'    'zetayears'    1e21 * 31556952
         %{
         NOTE: these are "normal" other time units
         %}  
         sys     ''            'fn'   'fortnight'   'fortnights'   1209600  % = 14 * 86400
         sys     ''            'sc'   'score'       'score'        2e1  * 31556952
         sys     ''            'jb'   'jubilee'     'jubilees'     5e1  * 31556952
         sys     ''            'Sv'   'Svedberg'    'Svedberg'     1e-13
         sys  ['t' char(8346)] 'tp'   'Planck time' 'Planck times' 5.39116e-44
         sys     ''            'ke'   'ke'          'ke'           864
         };
     
    % Now define the actual unit object
    U = DerivedUnitOfMeasurement('dimensions',              repmat({TimeUnits.dimensions},size(S,1),1),...                                 
                                 'system',                  S(:,1)',...
                                 'symbol',                  S(:,2)',...
                                 'short_name',              S(:,3)',...                                        
                                 'long_name',               S(:,4)',...
                                 'long_name_plural_form',   S(:,5)',...
                                 'conversion_to_base_unit', S(:,6)'); 
    
end
