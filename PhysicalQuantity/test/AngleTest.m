classdef (TestTags = {'UnittestsForAngle'})...
         AngleTest < matlab.unittest.TestCase
    
    %% Setup & teardown
        
    % Properties ----------------------------------------------------------
       
    properties  (TestParameter)
        
        fcn = {@acos, @asin, @atan,...
               @acsc, @asec, @acot}
           
        deg  = {char(176) 'deg' 'degrees'}
        grad = {'grad' 'gradian' 'gradians' 'gon' 'gons'}
        
    end
    
    
    properties (MethodSetupParameter)                
    end
    
    % Methods -------------------------------------------------------------
    
    % (before ALL tests)
    methods (TestClassSetup) 
        function setPaths(~)
            thispth = fullfile(fileparts(mfilename('fullpath')),'..');
            addpath(genpath( thispth ));
        end
    end
    
    % (before EVERY test)           
    methods (TestMethodSetup) 
    end
    
    % (after ALL tests)       
    methods(TestClassTeardown) 
    end  
    
     % (after EVERY test)           
    methods(TestMethodTeardown)
    end
    
    
    %% Test cases    
   
    methods (Test,...
             TestTags = {'AngleUnits'})
           
        % Can we construct correctly using degrees?
        function testAngleFromDeg(tst, deg)            
            m = rand;        
            tst.fatalAssertWarningFree(@()Angle(m,deg));
            A = Angle(m,deg);
            tst.fatalAssertLessThan( abs(double(A) - m * pi/180), eps);
        end
        
        % Can we construct correctly using gradians?
        function testAngleFromGrad(tst, grad)            
            m = rand;     
            tst.fatalAssertWarningFree(@()Angle(m,grad));
            A = Angle(m, grad);
            tst.fatalAssertLessThan( abs(double(A) - m * pi/200), eps);
        end
    end
    
    
    methods (Test,...
             TestTags = {'AngleGenerator'})
         
         % Do all the inverse trig functions create the correct angles, 
         % regardless of the unit? 
         function testInverseTrigGenerators(tst, fcn)
             
             L = Length(3, 'm');             
             A = fcn(L/(2*L), 'deg');
             tst.fatalAssertEqual(double(A), fcn(0.5));
             
             A = fcn(L/(2*L), 'rad');
             tst.fatalAssertEqual(double(A), fcn(0.5));
             
             A = Angle.(func2str(fcn))(0.5, 'rad');             
             tst.fatalAssertEqual(double(A), fcn(0.5));
             
         end
        
    end
    
    methods (Test,...
             TestTags = {'AngleConversion'})
                  
         % Can we construct an angle from PhysicalQUantities w/o dimension?
         function testAngleFromDimensionlessPq(tst, deg)
             
             % Case 1
             r  = randn(2,1);
             L1 = Length(r(1),'m');
             L2 = Length(r(2),'m');
             
             tst.fatalAssertWarningFree(@()Angle(L1/L2,deg));
             A = Angle(L1/L2, deg);
             tst.fatalAssertEqual(double(A), r(1)/r(2));
                          
             % Case 2
             r = randn(3,1);
             S = Speed(r(1), 'm/s');
             T = Time(r(2),'s');
             L = Length(r(3),'m');
             
             tst.fatalAssertWarningFree(@()Angle(S*T/L,deg));
             A = Angle(S*T/L, deg);
             tst.fatalAssertEqual(double(A), r(1)*r(2)/r(3));             
                          
         end
         
         % Does Angle() fail in the right way when attempting to construct 
         % an angle from a dimensioned quantity?
         function testAngleFromIncorrectPq(tst, deg)
             L = Length(randn,'m');
             tst.fatalAssertError(@()Angle(L,deg),...
                                  'Angle:incompatible_dimensions');             
         end
         
    end
    
    methods (Test,...
             TestTags = {'AngleDisplay'})
         
         % Do the degrees display correctly as degrees? 
         function testAngleDegDisplayOk(tst, deg)
                             
             A = Angle(50, deg); 
             
             format short
             tst.fatalAssertEqual(get_cmd_output(A), ['ang=50' char(176)]);
                          
             format long
             tst.fatalAssertEqual(get_cmd_output(A), 'ang=50degrees');
             
             B = Angle(1, deg);              
             tst.fatalAssertEqual(get_cmd_output(B), 'ang=1degree');
             
         end
         
         % and do they still translate to rad transparently?
         function testAngleDisplayOkAndFunctional(tst, deg)
             
             conversion_factor = pi/180;
             
             A = Angle(50, deg); 
             tst.fatalAssertEqual(cos(A), cos(50 * conversion_factor));
             
             m = rand();
             A = Angle(m, deg);
             tst.fatalAssertEqual(cos(A), cos(m * conversion_factor));
             
         end
         
                  
         % Do the gradians display correctly as gradians? 
         function testAngleGradDisplayOk(tst, grad)
                         
             A = Angle(50, grad);
                          
             format short
             tst.fatalAssertEqual(get_cmd_output(A), ['ang=50' char(7501)]);
               
             % TODO (Rody Oldenhuis): Doesn't work this way..
             %{
             format long
             tst.fatalAssertEqual(get_cmd_output(A), 'ang=50gradians');
             
             B = Angle(1, grad);              
             tst.fatalAssertEqual(get_cmd_output(B), 'ang=1gradian');
             %}             
             
         end        
         
         
         % and do they still translate to rad transparently?
         function testAngleGradDisplayOkAndFunctional(tst, grad)
             
             conversion_factor = pi/200;
             
             A = Angle(50, grad); 
             tst.fatalAssertEqual(cos(A), cos(50 * conversion_factor));
             
             m = rand();
             A = Angle(m, grad); 
             tst.fatalAssertEqual(cos(A), cos(m * conversion_factor));
             
         end
                 
    end
    
    methods (Test,...
             TestTags = {'AngleMalformedCalls'})
        
    end
        
end

function out = get_cmd_output(ang) %#ok<INUSD>
    out = evalc('ang');
    out = out(~isspace(out));
end
