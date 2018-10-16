classdef (TestTags = {'UnittestsForSuperclass'})...
         WellFormedIoTest < matlab.unittest.TestCase
    
    %% Setup & teardown
     
    % Properties ---------------------------------------------------------------
    
    properties 
        pq_constructor
        pq_instance
        pq_type 
    end
    
    properties (TestParameter)        
        disp_fmt = {'auto' 'long' 'short'}        
    end
    
    properties (MethodSetupParameter)
        type = {'Dimensionless'
                %{
                %}
                'Length'
                'Distance'
                'Displacement'
                %{
                %}
                'Mass'
                %{
                %}
                'Time'
                'Duration'
                %{
                %}
                'Current'
                %{
                %}
                'Temperature'
                %{
                %}
                'LuminousIntensity'
                %{
                %}                
                'AmountOfSubstance'
                %{
                Derived units
                %}
                'Angle'
                'PlanarAngle'
                'SolidAngle'
                %{
                %}
                'Area'
                'Volume'
                'Density'
                'Viscocity'
                'Force'
                'Torque'
                'Pressure'
                'Speed'
                'Acceleration'
                'Jerk'
                'Snap'
                'Crackle'
                'Pop'
                'AngularAcceleration'
                'AngularSpeed'
                %{
                %}
                'Momentum'
                'LinearMomentum'
                'AngularMomentum'
                'SpecificAngularMomentum'
                'MomentOfInertia'
                'Energy'
                'SpecificEnergy'
                %{
                %}
                'Frequency'
                'Wavenumber'
                %{
                %}
                'Potential'
                'Power'
                'Resistance'
                'Capacitance'
                'Charge'
                'Conductance'
                'Inductance'
                'MagneticFlux'
                'MagneticFluxDensity'
                };
    end
    
    % Methods ------------------------------------------------------------------
        
    methods (TestClassSetup) % (before ALL tests)
        function setPaths(~)            
            addpath(genpath( fullfile(fileparts(mfilename('fullpath')),'..') ));
        end
    end
    
    methods (TestMethodSetup) % (before EVERY test)   
        function setConstructor(tst, type)
            tst.pq_type        = type;
            tst.pq_constructor = str2func(type);
            tst.pq_instance    = tst.pq_constructor();
        end
    end
    
    methods(TestClassTeardown) % (after ALL tests)       
    end    
    
    methods(TestMethodTeardown) % (after EVERY test)       
    end
    
    
    %% Test cases: basic usage
   
    methods (Test, TestTags = {'BasicSuperclassBehavior'})
        
        % Do we get an error when constructing with the wrong units?
        function testWrongConstruction(tst)
            if ~any(strcmp(tst.pq_type, {'Dimensionless'}))
                E = [tst.pq_type ':invalid_unit'];
                tst.fatalAssertError(@() tst.pq_constructor(rand, 'km^2/C*mol'), E);                
            else
                E = 'Dimensionless:incorrect_dimensionless_call';
                tst.fatalAssertError(@() tst.pq_constructor(rand, 'km^2/C*mol'), E);
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
            tst.fatalAssertWarningFree(@()tst.pq_constructor(rand,...
                                                             tst.pq_instance.current_unit,...
                                                             'Name', dummyname));
                                                         
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
                        
            tst.fatalAssertWarningFree(@()tst.pq_constructor(rand,...
                                                             tst.pq_instance.current_unit,...
                                                             'display_format', disp_fmt));
                                                         
            P = tst.pq_constructor(rand, tst.pq_instance.current_unit,...
                                   'display_format', disp_fmt);
            tst.fatalAssertEqual(P.display_format, disp_fmt);
            
        end
        
    end
    
    %% Test cases: object arrays
    
    methods (Test, TestTags = {'ObjectArrays'})
    end
        
end
