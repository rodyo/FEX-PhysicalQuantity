classdef (TestTags = {'UnittestsForArea'})...
         AreaTest < matlab.unittest.TestCase
    
    %% Setup & teardown
        
    % Properties ----------------------------------------------------------
        
    properties  (TestParameter)
        
        test_dir = {get_quantities_dir()};
        
        unit   = {'miles'   'mi'     'mile'    'km' 'mm'  'ly'                   char(197)}
        factor = {1609.344  1609.344 1609.344  1e3  1e-3  9.460536207068016e+15  1e-10    }
        
    end
        
    % Methods -------------------------------------------------------------
    
    % (before ALL tests)
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);
        end
    end
    
    %% Test cases    
   
    methods (Test,...
             TestTags = {'AreaUnits'},...
             ParameterCombination = 'sequential')
         
        % Can we construct correctly using base unit square meters?
        function testArea(tst)            
            m = rand;
            A = Area(m, 'm^2');
            tst.fatalAssertEqual(double(A), m);
        end
                     
        % Can we construct correctly using any unit?
        function testAreaOtherUnit(tst, unit, factor)
            m = rand;   
            A = Area(m, [unit '^2']);
            tst.fatalAssertEqual(double(A), m*factor^2);
        end
        
        % Can we construct correctly using two Lengths using different units?
        function testAreaFromTwoLengths(tst, unit, factor)
            
            m = randn(2,1); 
            
            L1 = Length(m(1), unit);
            L2 = Length(m(2), 'm');
            
            tst.fatalAssertWarningFree(@()Area(L1*L2, [unit '^2']));
            
            A = Area(L1*L2, [unit '^2']);
            tst.fatalAssertEqual(double(A), m(1)*factor*m(2));
            
        end
        
    end
    
end
