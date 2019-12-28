classdef (TestTags = {'UnittestsForForce'}) ...         
         ForceTest < matlab.unittest.TestCase
    
    %% Setup & teardown
           
    properties  (TestParameter)
        
        short_name        = {ForceUnits.other_units.short_name}
        short_name_plural = {ForceUnits.other_units.short_name_plural_form}
        long_name         = {ForceUnits.other_units.long_name}
        conversion_factor = {ForceUnits.other_units.conversion_to_base}
        
    end
          
    %% Test cases    
   
    % Test all units automaticall (blindly trusting ForceUnits())
    methods (Test,...
             ParameterCombination='sequential',...
             TestTags = {'ForceUnits'})
        
        % Test all short names (blindly trusting LengthUnits())
        function testForceShortnames(tst, ...
                                     short_name,...
                                     conversion_factor)
            F = 100 * randn;
            L = Force(F, short_name);
            tst.verifyEqual(double(L), F * conversion_factor);
        end
        
        % Test all short name plurals (blindly trusting LengthUnits())
        function testForceShortnamePlurals(tst,...
                                           short_name_plural,...
                                           conversion_factor)
            F = 100 * randn;
            L = Force(F, short_name_plural);
            tst.verifyEqual(double(L), F * conversion_factor);
        end
        
        % Test all long names (blindly trusting LengthUnits())
        function testForceLongnames(tst,...
                                    long_name,...
                                    conversion_factor)
            F = 100 * randn;
            L = Force(F, long_name);
            tst.verifyEqual(double(L), F * conversion_factor);
        end
                 
    end
    
    % Some manual sanity-checks (i.e., NOT relying on ForceUnits())
    % NOTE: (Rody Oldenhuis) non-exchaustrive
    methods (Test,...             
             TestTags = {'ForceUnitsManual'})
                
        % Can we construct 1N correctly using base units?
        function testForce1N(tst)
            
            L = Length(1, 'm');
            M = Mass  (1, 'kg');
            T = Time  (1, 's');
            
            F = Force(L*M/T.^2, 'N');
            tst.verifyEqual(double(F), 1);
                        
            D = Density(1, 'kg/m^3');
            
            F = Force(D*L.^4/T.^2, 'N');
            tst.verifyEqual(double(F), 1);            
            
        end
        
    end
        
end
