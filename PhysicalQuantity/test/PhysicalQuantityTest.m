classdef (TestTags = {'UnittestsForIncorrectUsage'})...
         PhysicalQuantityTest < matlab.unittest.TestCase
    
    %% Setup & teardown
     
    % Properties ---------------------------------------------------------------
    
    properties 
        pq_constructor
        pq_type 
    end
    
    properties  (TestParameter)
    end
    
    properties (MethodSetupParameter)        
    end
    
    % Methods ------------------------------------------------------------------
        
    methods (TestClassSetup) % (before ALL tests)
        function setPaths(~)            
            addpath(genpath( fullfile(fileparts(mfilename('fullpath')),'..') ));
        end
    end
    
    methods (TestMethodSetup) % (before EVERY test)
    end
    
    methods(TestClassTeardown) % (after ALL tests)       
    end    
    
    methods(TestMethodTeardown) % (after EVERY test)       
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
