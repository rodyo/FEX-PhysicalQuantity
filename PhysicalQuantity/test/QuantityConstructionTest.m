classdef (TestTags = {'UnittestsForSuperclass'})...
         QuantityConstructionTest < matlab.unittest.TestCase
    
    %% Setup & teardown ===================================================
     
    % Properties ----------------------------------------------------------
    
    properties 
        pq_type 
        pq_constructor
        pq_instance
        
        pq_units
        pq_units_constructor 
        pq_units_instance
    end
    
    properties (TestParameter)                 
        test_dir = {get_quantities_dir()};        
    end
    
    properties (MethodSetupParameter)
        units      = all_units()
        quantities = corresponding_quantities()
    end
    
    % Methods -------------------------------------------------------------
        
    % (before ALL tests)
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);            
        end        
    end
    
    % (before EVERY test)       
    methods (TestMethodSetup,...
             ParameterCombination = 'sequential')
         
        % Parameterize all tests via the TestMethodSetup:
        function setConstructor(tst, units, quantities)
            
            tst.pq_type  = quantities;
            tst.pq_units = units;
            
            tst.pq_constructor = str2func(quantities);
            tst.pq_instance    = tst.pq_constructor();
            
            tst.pq_units_constructor = str2func(units);
            tst.pq_units_instance    = tst.pq_units_constructor();
            
        end
        
    end
    
    
    %% Test cases: construct with any unit ================================
   
    methods (Test,...
             TestTags = {'Construction'})
         
         function testBaseUnits(tst)             
             U = tst.pq_units_instance.base_unit;
             tst.testConstruction(U, false);
         end
         
         function testOtherUnits(tst)             
             U = tst.pq_units_instance.other_units;
             tst.testConstruction(U, true);
         end
        
    end
    
    methods
        function testConstruction(tst, U, check_empty) 
            
            % Consistency check: U can't be empty for non-baseunits
            if check_empty
                diagnostic = sprintf('%s''s unit of measurement is empty.',...
                                     tst.pq_type);             
                tst.fatalAssertNotEmpty(U, diagnostic);
            end
            
            % No errors shall occur during construction
            try
                tst.assertable(U);
            catch ME
                %tst.fatalAssertFail(ME.message);
                tst.fatalAssertFail(getReport(ME));
            end            
            
            % Nor any warnings
            diagnostic = sprintf(['%s() issued a warning for one of its ',...
                                  'unit variants.'],...
                                 tst.pq_type);             
            tst.fatalAssertWarningFree(@()tst.assertable(U), diagnostic);
             
            % For all variants of the unit, the underlying quantity shall
            % be identical
            diagnostic = sprintf(['%s() gave different outcomes for ',...
                                  'different variants of the same unit.'],...
                                  tst.pq_type);
            tst.fatalAssertTrue(tst.assertable(U), diagnostic);
            
        end        
        function OK = assertable(tst, U)
                 
            OK = true;
            R  = rand;
            
            for ii = 1:numel(U)
                
                A = {U(ii).symbol
                     U(ii).short_name
                     U(ii).short_name_plural_form
                     U(ii).long_name
                     U(ii).long_name_plural_form};
                 
                % TODO: (Rody Oldenhuis) remove this bit when all units
                % have basic implementations: 
                if all(cellfun('isempty', A))
                    continue; end                
                % ...'cause this is the actual test:
                tst.fatalAssertTrue(~all(cellfun('isempty', A)),[...
                                    'Unit of measurement is non-empty, ',...
                                    'but inaccessible because all variants ',...
                                    'are empty.']);
                
                N = numel(A);
                T = NaN(1,N);

                for jj = 1:N
                    if ~isempty(A{jj})
                        T(jj) = double(tst.pq_constructor(R,A{jj})); end
                end
                T  = num2cell(T(~isnan(T)));
                OK = OK & all(isequal(T{:}));

                if ~OK
                    break; end
            end
            
        end
    end
    
end

% Get all types to test 
function units = all_units()
    % All M-files in '../framework/units/ define a unit list:
	fpth = fullfile(fileparts(mfilename('fullpath')),...
                    '..', 'framework', 'units');        
    units     = dir(fullfile(fpth,'*.m'));
    [~,units] = cellfun(@fileparts,{units.name}','UniformOutput', false);    
    units = units(~strcmp(units,'get_units'));    
end

function quantities = corresponding_quantities()    
    quantities = regexprep(all_units(), 'Units$','');
    quantities{strcmp(quantities,'No')} = 'Dimensionless';
end
    
