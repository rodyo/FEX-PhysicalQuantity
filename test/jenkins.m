% Run this from the ./test/ directory:
try
    % Make sure the path is OK:
    cd(fullfile(fileparts(mfilename('fullpath')),'..'));
    addpath(genpath('.'));

    % Manual runs sometimes screw this up:
    clear classes; %#ok<CLCLS>
    warning on;

    % Build the MEX files:
	%{
    if isunix() || ismac()
        % TODO: (Rody) for some reason, Tasking.Task() thinks this
        % is an error...
        ws = warning('off', 'MATLAB:mex:GccVersion_link');
        OC = onCleanup(@()warning(ws));
    end
    mexmake();
	%}

    % Run the tests, returning exit-succes only if ALL have passed
    cd test
    results = run_all_tests('jenkins', true,...
                            'excludes', {'TEST:LONGRUNNING',...            % (these are for a different kinda run)
                                         'DocTest',...                     % function documentation checks - later.
                                         'DocReportTest',...               % same as above; later.
                                         'FatalConditions',...             % function shadowing - good to have, but not crucial now
                                         'MLintResult',...                 % (typical SonarQube thing)
                                         'NamingConvention' ...            % (typical SonarQube thing)                                         
                                         });
    exit( any([results.Failed]) );

catch ME
    % exit-failure whenever anything else goes wrong:
    getReport(ME, 'extended')
    exit(1);
end

