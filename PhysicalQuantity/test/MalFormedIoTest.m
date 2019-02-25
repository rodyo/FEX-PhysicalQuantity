classdef (TestTags = {'UnitTestsForIncorrectUsage'})...
         MalFormedIoTest < matlab.unittest.TestCase
    
    %% Setup & teardown
     
    % Properties ---------------------------------------------------------------
    
    properties 
        pq_constructor
        pq_instance
        pq_type 
    end
    
    properties (TestParameter)
        test_dir = {get_quantities_dir()};
    end
    
    properties (MethodSetupParameter)
        type = all_quantities()
    end
    
    % Methods ------------------------------------------------------------------
        
    % (before ALL tests)
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);
        end
    end
    
    methods (TestMethodSetup) % (before EVERY test)
        function setConstructor(tst, type)
            tst.pq_type        = type;
            tst.pq_constructor = str2func(type);
            tst.pq_instance    = tst.pq_constructor();
        end
    end
        
    %% Test cases    
   
    % Errors on the constructor interfaces
    methods (Test,...
             TestTags = {'IncorrectClassIoError'})
        
        % Is it an error if trying to construct without unit of measurement?
        function testWithoutUnit(tst)
            if ~any(strcmp(tst.pq_type, {'Dimensionless'}))
                tst.fatalAssertError(@()tst.pq_constructor(rand),...
                                     [tst.pq_type ':unit_required']);
            end
        end  
        
        % Is it an error when calling a trig function?
        function testTrigError(tst) 
            
            % With the following exceptions, of course: 
            if ~any(strcmp(tst.pq_type, {'Angle'      , 'Hyperbolicangle',...
                                         'PlanarAngle'}))            
                
                P = tst.pq_constructor();
                E = [tst.pq_type ':invalid_operation'];
                T = @(fcn) tst.fatalAssertError(@() fcn(P), E);
                
                % Regular trig         inverse regular trig
                T(@sin);   T(@csc);    T(@asin);   T(@acsc);
                T(@cos);   T(@sec);    T(@acos);   T(@asec);
                T(@tan);   T(@cot);    T(@atan);   T(@acot);
                
                % Hyperbolic trig      inverse hyperbolic trig
                T(@sinh);  T(@csch);   T(@asinh);  T(@acsch);
                T(@cosh);  T(@sech);   T(@acosh);  T(@asech);
                T(@tanh);  T(@coth);   T(@atanh);  T(@acoth);
                                     
            end
            
        end
                
        % Is it an error when starting parameters but not giving values?
        function testPvPairsError(tst)  
            if ~any(strcmp(tst.pq_type, {'Dimensionless'}))
                tst.fatalAssertError(@()tst.pq_constructor(rand,...
                                                           tst.pq_instance.current_unit,...
                                                           'Name'),...
                                     [tst.pq_type ':no_unit_or_unpaired_pvs']);
            else
                E = [tst.pq_type ':incorrect_dimensionless_call'];
                tst.fatalAssertError(@()tst.pq_constructor(rand, 'Name'), E);
            end
        end
        
        % Is it an error when setting an incorrect display format?
        function testIncorrectDisplayFormat(tst)
            tst.fatalAssertError(@()tst.pq_constructor(rand,...
                                                       tst.pq_instance.current_unit,...
                                                       'display_format', 'WRONG'),...
                                 [tst.pq_type ':unknown_display_format']);
        end
         
    end
    
       
    % Do the classes fail in the correct way when using them incorrectly?
    methods (Test,...
             TestTags = {'IncorrectClassUsage'})
         
        % plus() and minus()
        function testIncorrectAdditionSubtraction(tst, type)
            
            % Arbitrarily choose a Length() as reference
            L = Length(rand,'m');
            
            E = 'PhysicalQuantityInterface:incompatible_types';
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit);
                       
            if    ~any(strcmp(type, {'Length' 'Dimensionless'})) ...
               && ~isa(tst.pq_instance, 'Length') ...
               && ~isa(tst.pq_instance, 'Dimensionless')                   
                
                % 0-valued object should already fail
                tst.fatalAssertError(@()tst.pq_instance + L, E);
                tst.fatalAssertError(@()tst.pq_instance - L, E);
                tst.fatalAssertError(@()L + tst.pq_instance, E);
                tst.fatalAssertError(@()L - tst.pq_instance, E);
                
                tst.fatalAssertError(@()rand + L, E);
                tst.fatalAssertError(@()rand - L, E);
                tst.fatalAssertError(@()L + rand, E);
                tst.fatalAssertError(@()L - rand, E);
                
                % Just to be sure, create not-0-valued object 
                % and check again
                tst.fatalAssertError(@()P + L, E);
                tst.fatalAssertError(@()P - L, E);
                tst.fatalAssertError(@()L + P, E);
                tst.fatalAssertError(@()L - P, E);
                
                tst.fatalAssertError(@()P + rand, E);
                tst.fatalAssertError(@()P - rand, E);
                tst.fatalAssertError(@()rand + P, E);
                tst.fatalAssertError(@()rand - P, E);
                
            else
                % This should work without warnings
                tst.fatalAssertWarningFree(@()tst.pq_instance + L);
                tst.fatalAssertWarningFree(@()tst.pq_instance - L);
                tst.fatalAssertWarningFree(@()L + tst.pq_instance);
                tst.fatalAssertWarningFree(@()L - tst.pq_instance);
                
                tst.fatalAssertWarningFree(@()P + L);
                tst.fatalAssertWarningFree(@()P - L);
                tst.fatalAssertWarningFree(@()L + P);
                tst.fatalAssertWarningFree(@()L - P);                
            end
            
            % Repeat with Jerk()
            J = Jerk(rand, 'm/s^3');
            
            E = 'PhysicalQuantityInterface:incompatible_types';
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit);
                       
            if    ~any(strcmp(type, {'Jerk' 'Dimensionless'})) ...
               && ~isa(tst.pq_instance, 'Jerk') ...
               && ~isa(tst.pq_instance, 'Dimensionless')
           
                tst.fatalAssertError(@()tst.pq_instance + J, E);
                tst.fatalAssertError(@()tst.pq_instance - J, E);
                tst.fatalAssertError(@()J + tst.pq_instance, E);
                tst.fatalAssertError(@()J - tst.pq_instance, E);
                
                tst.fatalAssertError(@()P + J, E);                
                tst.fatalAssertError(@()P - J, E);                
                tst.fatalAssertError(@()J + P, E); 
                tst.fatalAssertError(@()J - P, E); 
            else                
                tst.fatalAssertWarningFree(@()tst.pq_instance + J);
                tst.fatalAssertWarningFree(@()tst.pq_instance - J);
                tst.fatalAssertWarningFree(@()J + tst.pq_instance);
                tst.fatalAssertWarningFree(@()J - tst.pq_instance);
                
                tst.fatalAssertWarningFree(@()P + J); 
                tst.fatalAssertWarningFree(@()P - J); 
                tst.fatalAssertWarningFree(@()J + P); 
                tst.fatalAssertWarningFree(@()J - P); 
            end          
            
        end
        
        % times() / rdivide()
        function testIncorrectMultiplicationDivision(tst, type)
            % TODO: (Rody Oldenhuis) 
        end
        
        % all the others operators should give error
        function testIncorrectNormAbs(tst, type)
            % TODO: (Rody Oldenhuis) 
        end
        
    end
    
        
end
