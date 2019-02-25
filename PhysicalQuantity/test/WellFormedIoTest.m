classdef (TestTags = {'UnittestsForSuperclass'})...
         WellFormedIoTest < matlab.unittest.TestCase
    
    %% Setup & teardown ===================================================
     
    % Properties ----------------------------------------------------------
    
    properties 
        pq_constructor
        pq_instance
        pq_type 
    end
    
    properties (TestParameter)                 
        test_dir = {get_quantities_dir()};        
        disp_fmt = {'auto' 'long' 'short'}
    end
    
    properties (MethodSetupParameter)
        qty = all_quantities()
    end
    
    % Methods -------------------------------------------------------------
        
    % (before ALL tests)
    methods (TestClassSetup) 
        function applyFixtures(tst)
            apply_test_fixtures(tst);            
        end        
    end
    
    % (before EVERY test)       
    methods (TestMethodSetup)
        % Parameterize all tests via the TestMethodSetup:
        function setConstructor(tst, qty)
            tst.pq_type        = qty;
            tst.pq_constructor = str2func(qty);
            tst.pq_instance    = tst.pq_constructor();
        end
    end
    
    
    %% Test cases: basic usage ============================================
   
    methods (Test,...
             TestTags = {'BasicSuperclassBehavior'})
        
        % Do we get an error when constructing with the wrong units?
        function testWrongUnits(tst)
            C = @()tst.pq_constructor(rand, 'km^2/C*mol');            
            if ~any(strcmp(tst.pq_type, {'Dimensionless'}))
                E = [tst.pq_type ':invalid_unit'];                
                tst.fatalAssertError(C, E);                
            else
                E = 'Dimensionless:incorrect_dimensionless_call';
                tst.fatalAssertError(C, E);
            end
        end
        
        % Can we construct correctly at all?
        function testBasicConstruction(tst)
                        
            P = tst.pq_constructor();
            
            tst.fatalAssertNotEmpty(P);    
            tst.fatalAssertNumElements(P,1);
            tst.fatalAssertInstanceOf(P, tst.pq_type);
            
        end
        
        % Can we convert to double?
        function testCastToDouble(tst)
            
            P = tst.pq_constructor();
            D = double(P);
            
            tst.fatalAssertClass(D, 'double');
            tst.fatalAssertNumElements(D,1);            
            
        end
        
        % Is the default value 0? 
        function testDefaultValue(tst)
            
            P = tst.pq_constructor();
            D = double(P);            
            
            tst.fatalAssertEqual(D, 0); 
            
            % (alternative way to construct a 0)
            D = double(tst.pq_constructor(0));  
            tst.fatalAssertEqual(D, 0); 
            
        end
        
        % Can we copy-construct?
        function testCopyConstructor(tst)
            m    = rand;
            cstr = @() tst.pq_constructor(m, tst.pq_instance.current_unit);
            tst.fatalAssertWarningFree(@() tst.pq_constructor(cstr()) );
            tst.fatalAssertEqual( double(tst.pq_constructor(cstr())), ...
                                  double(cstr()));            
        end
        
        % Can we multiply by a scalar?
        function testMultiplyByScalar(tst)
            
            m = randn();            
            if ~any(strcmp(tst.pq_type, {'Dimensionless'}))
                P = tst.pq_constructor(rand, tst.pq_instance.current_unit);
            else
                P = tst.pq_constructor(rand);                
            end
            D = double(P); 

            tst.fatalAssertEqual(double(m*P), m*D);
            tst.fatalAssertEqual(double(P*m), D*m); 

        end
        
        % Can we call the listUnits() method without error/warning?
        function testListUnits(tst)
            function test_list_units()
                P = tst.pq_constructor();      %#ok<NASGU>
                evalc('P.listUnits();');       % NOTE: this way, no output to 
                evalc('[~] = P.listUnits();'); % command line is printed
            end
            tst.fatalAssertWarningFree(@test_list_units);            
        end
        
        % Check default name
        function testDefaultName(tst)
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit);
            tst.fatalAssertEqual(P.name, '[no name]');
        end
        
        % Can we set the name upon construction? 
        function testName(tst)
            
            dummyname = char( randi([32 127], 1, 100) );
            
            % Construct with name gives no warnings:
            C = @()tst.pq_constructor(rand,...
                                      tst.pq_instance.current_unit,...
                                      'Name', dummyname);
            tst.fatalAssertWarningFree(C);
               
            % Construct with name indeed sets the correct name:
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit,...
                                   'Name', dummyname);
            tst.fatalAssertEqual(P.name, dummyname);
            
        end
                
        % Check default display format
        function testDefaultDisplayFormat(tst)
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit);
            tst.fatalAssertEqual(P.display_format, 'auto');
        end
        
        % Can we set the display format upon construction? 
        function testDisplayFormat(tst, disp_fmt)
               
            % Setting display format does not produce warning
            C = @()tst.pq_constructor(rand,...
                                      tst.pq_instance.current_unit,...
                                      'display_format', disp_fmt);
            tst.fatalAssertWarningFree(C);
             
            % And it indeed sets the format as expected:
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit,...
                                   'display_format', disp_fmt);
            tst.fatalAssertEqual(P.display_format, disp_fmt);
            
        end
        
    end
    
    %% Test cases: object arrays ==========================================
    
    methods (Test,...
             TestTags = {'ObjectArrays'})
         
         % TODO: (Rody Oldenhuis) 
         
    end
        
end
