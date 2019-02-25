classdef (TestTags = {'UnittestsForIncorrectUsage'})...
         PhysicalQuantityTest < matlab.unittest.TestCase
    
    %% Setup & teardown
     
    % Properties ----------------------------------------------------------
    
    properties 
        pq_constructor
        pq_type 
    end
    
    properties (TestParameter)
        test_dir = {get_quantities_dir()};
    end
        
    % Methods -------------------------------------------------------------
        
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);
        end
    end    
    
    %% Test cases    
   
    methods (Test, TestTags = {'PhysicalQuantityIncorrectUsage'})
                
        % Does it fail to construct when attempting to construct in the wrong way?
        function testPhysicalQuantityCmdline(tst)
            % TODO: (Rody Oldenhuis) can't reach it!
%             tst.fatalAssertError(@()evalin('base', 'PhysicalQuantity();'),...
%                                  'PhysicalQuantity:invalid_instantiation');
        end
        
    end
        
end
