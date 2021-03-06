classdef (TestTags = {'UnittestsForSpeed'})...
         SpeedTest < matlab.unittest.TestCase
    
    %% Setup & teardown
        
    % Properties ----------------------------------------------------------
    
    properties  (TestParameter)        
        test_dir = {get_quantities_dir()};
        knots = {'kn' 'knots' 'knot'}        
    end
    
    % Methods -------------------------------------------------------------
    
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);
        end
    end
    
    
    %% Test cases    
   
    methods (Test,...
             TestTags = {'SpeedUnits'})
           
        % Can we construct correctly using the base units?
        function testSpeedFromMs(tst)            
            m = rand;        
            tst.fatalAssertWarningFree(@()Speed(m,'m/s'));              
            tst.fatalAssertWarningFree(@()Speed());
            tst.fatalAssertWarningFree(@()Speed(0));            
        end
        
        % Can we construct correctly using the knot?
        function testSpeedFromKnots(tst, knots)            
            
            m = rand;        
            tst.fatalAssertWarningFree(@()Speed(m,knots));
            
            S = Speed(m, knots);
            tst.fatalAssertLessThan( abs(double(S) - m*1.852/3.6), eps );
                        
        end
        
    end
    
    methods (Test,...
             TestTags = {'SpeedConversion'})
         
         % Convert km/h to m/s
         function testSpeedKmHour(tst)             
             m = randn;
             S = Speed(m, 'km/h');             
             tst.fatalAssertLessThan( abs(double(S) - m/3.6), eps );
         end
         
         % Construct speed from Length and Time
         function testSpeedConstruction(tst)             
             
             m = randn(2,1);
             L = Length(m(1), 'm');        
             T = Time(m(2), 's');
             
             tst.fatalAssertWarningFree(@()Speed(L/T, 'm/s'));
             
             S = Speed(L/T, 'm/s');
             tst.fatalAssertLessThan( abs(double(S) - m(1)/m(2)), eps );
             
             % This shouldn't matter:
             S = S('yd/fortnight');
             tst.fatalAssertLessThan( abs(double(S) - m(1)/m(2)), eps );
             
         end
         
         
    end
    
    methods (Test,...
             TestTags = {'SpeedDisplay'})
         % TODO: (Rody Oldenhuis)          
    end
    
        
end
