classdef (TestTags = {'UnittestsForLength'})...
         LengthTest < matlab.unittest.TestCase
    
    %% Setup & teardown
        
    % Properties ----------------------------------------------------------
    
    properties         
    end
    
    properties  (TestParameter)
        
        test_dir = {get_quantities_dir()};
        
        short_name        = {LengthUnits.other_units.short_name}
        short_name_plural = {LengthUnits.other_units.short_name_plural_form}
        long_name         = {LengthUnits.other_units.long_name}
        conversion_factor = {LengthUnits.other_units.conversion_to_base}
        
    end
            
    % Methods -------------------------------------------------------------
    
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);
        end
    end    
    
    %% Test cases    
   
    % Test all units automaticall (blindly trusting LengthUnits())
    methods (Test,...
             ParameterCombination='sequential',...
             TestTags = {'LengthUnits'})
        
        % Test all short names (blindly trusting LengthUnits())
        function testLengthShortnames(tst, ...
                                      short_name,...
                                      conversion_factor)
            m = 100 * randn;
            L = Length(m, short_name);
            tst.fatalAssertEqual(double(L), m * conversion_factor);
        end
        
        % Test all short name plurals (blindly trusting LengthUnits())
        function testLengthShortnamePlurals(tst,...
                                            short_name_plural,...
                                            conversion_factor)
            m = 100 * randn;
            L = Length(m, short_name_plural);
            tst.fatalAssertEqual(double(L), m * conversion_factor);
        end
        
        % Test all long names (blindly trusting LengthUnits())
        function testLengthLongnames(tst,...
                                     long_name,...
                                     conversion_factor)
            m = 100 * randn;
            L = Length(m, long_name);
            tst.fatalAssertEqual(double(L), m * conversion_factor);
        end
                 
    end
    
    % Some manual sanity-checks (i.e., NOT relying on LengthUnits())
    % NOTE: (Rody Oldenhuis) non-exchaustrive
    methods (Test,...             
             TestTags = {'LengthUnitsManual'})
                
        % Can we construct correctly using kilometers?
        function testLength5k(tst)
            L = Length(5.432, 'km');
            tst.fatalAssertEqual(double(L), 5432);
        end
        
        % Can we construct correctly using miles?
        function testLength5miles(tst)
            L = Length(5.432, 'miles');
            tst.fatalAssertEqual(double(L), 5.432 * 1609.344);
        end
        
        
    end
        
end
