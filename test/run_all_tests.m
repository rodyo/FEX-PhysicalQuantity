% run_all_tests                   entry point to this toolbox' tests
%
% T = run_all_tests() will run all units tests on the current toolbox, 
% returning a TestResult-array 'T'.
%
% T = run_all_tests('option', value,...) uses the option/value pairs as
% indicated. Supported options are:
%
% - 'test_report'           generates HTML & TAP test reports - a report
%                           listing which tests pass/fail, with command
%                           line output of those that fail, where the TAP
%                           report integrates more nicely with Jenkins, and
%                           the HTML report provides better detail.
% - 'coverage_report'       generates a Cobertura code-coverage report
%                           (XML); those parts of the code actually covered
%                           by the tests.
% - 'documentation_report'  generates a function documentation issues
%                           report; a report of documentation presence and
%                           formatting correctness for all MATLAB code in
%                           the toolbox directory.
% - 'performance_report'    Highlighting potential performance issues.
%
% - 'jenkins'               enables all reports
% - 'local'                 disables all reports
%
% - 'excludes'              (array of) strings of tests names/tags that
%                           should be excluded from the test run.
%
% All reports are generated in the subdirectory 'test/artifacts/'
%
% This function is intended to be used for running tests locally (i.e.,
% "before commit") as well as remotely (e.g., on Jenkins "after commit").
%
% EXAMPLES:
%
% >> run_all_tests('exclude', {'DocTest',...
%                              'DocReportTest'},...
%                  'coverage_report', true,...
%                  'test_report',     true)
%
% See also matlab.unittest, matlab.unittest.plugins.
function test_results = run_all_tests(varargin)

    % See
    % https://au.mathworks.com/help/matlab/ref/matlab.unittest.plugins-package.html
    % for how to use unittest plugins
    import matlab.unittest.plugins.TestReportPlugin.producingHTML;
    import matlab.unittest.TestRunner;

    import matlab.unittest.plugins.TAPPlugin;
    import matlab.unittest.plugins.ToFile;

    import matlab.unittest.plugins.CodeCoveragePlugin;
    import matlab.unittest.plugins.codecoverage.CoberturaFormat;


    % Initialize ----------------------------------------------------------

    % The toolbox dirs should be on the path 
    tbox_dir = fullfile(fileparts(mfilename('fullpath')), '..');
    allpaths = lower( strsplit(path(), pathsep) );
    if ~ismember(lower(tbox_dir), allpaths)
        addpath(genpath(tbox_dir));
        OC = onCleanup(@()rmpath(tbox_dir));
    end

    % Get test runner options
    options = get_options(varargin{:});

    % Some abbrevs
    outputdir = @(varargin) fullfile('artifacts', varargin{:});
    withsubs  = {'IncludeSubfolders', true};

    % Apply relevant test runner options ----------------------------------

    % Basic test runner
    suite  = testsuite(tbox_dir, withsubs{:});
    runner = TestRunner.withTextOutput;

    % Filter out the excludes
    if ~isempty(options.excludes)
        for ii = 1:numel(options.excludes)

            exclude = options.excludes{ii};
            matches = @(str) ~cellfun('isempty', ...
                                      regexp(str, ['^' exclude]));
            % Filter on names
            removals = matches({suite.Name});
            if any(removals)
                suite(removals) = []; end

            % Filter on tags
            removals = false(size(suite));
            for jj = 1:numel(suite)
                removals(jj) = any(matches(suite(jj).Tags)); end
            suite(removals) = [];

        end
    end

    % Generate test report?
    if options.test_report

        html_report = outputdir('test_report');
        tap_report  = outputdir('tap_report.tap');

        % HTML report
        plugin = producingHTML(html_report,...
                               'IncludingPassingDiagnostics', true,...
                               'IncludingCommandWindowText' , true);
        runner.addPlugin(plugin);

        % TAP file
        plugin = TAPPlugin.producingVersion13(ToFile(tap_report));
        runner.addPlugin(plugin);

    end

    % Generate coverage report?
    if options.coverage_report

        xml_report = outputdir('cobertura_coverage_report.xml');

        % Cobertura format
        cobplg = @CodeCoveragePlugin.forFolder;
        plugin = cobplg(tbox_dir,...
                        withsubs{:},...
                        'Producing', CoberturaFormat(xml_report));
        runner.addPlugin(plugin);

        % MATLAB-native format
        % TODO: (Rody Oldenhuis) ...there's no way to get the HTML???
        %plugin = CodeCoveragePlugin.forFolder(tbox_dir, withsubs{:});
        %runner.addPlugin(plugin);

    end


    % Run the test suite --------------------------------------------------
    if Utils.Matlab.Toolboxes.HaveParallelComputingToolbox
        test_results = runner.runInParallel(suite);
    else
        test_results = runner.run(suite);
    end

    % Post-processing -----------------------------------------------------
    if options.test_report

        % Jenkins does not allow inline CSS by default, breaking how
        % the report is displayed in Jenkins. Luckily, the MATLAB test
        % report has only 1 very simple inline CSS, that is easily replaced:
        html = fullfile(html_report, 'index.html');
        css  = fullfile(html_report, 'stylesheets', 'root.css');

        % TODO: (Rody Oldenhuis) ...this can possibly be replaced with
        % Utils.FileIo.readFile/writeFile; pathing might be an issue on
        % Jenkins...

        scanopts = {'%s',...
                    'Delimiter' , '\n',...
                    'whitespace', ''};

        fid = fopen(html, 'r');
        OC2 = onCleanup(@()any(fid==fopen('all')) && fclose(fid));
        H   = textscan(fid, scanopts{:});
        H   = H{1};
        fclose(fid);

        % Images:
        rpr = @(str) num2str(ceil(str2double(str)*96)); %#ok<NASGU>
        H = regexprep(H,...
                      'style="width:([0-9\.]+)in;height:([0-9\.]+)in;"',...
                      'width=${rpr($1)} height=${rpr($2)}');

        % spans-with-spaces:
        H = regexprep(H,...
                      '<span style="white-space:pre-wrap;">',...
                      '<span class="PreWrap">');

        % Write back to HTML:
        fid = fopen(html, 'w');
        OC3 = onCleanup(@()any(fid==fopen('all')) && fclose(fid));
        cellfun(@(str)fprintf(fid, '%s\n', str), H);
        fclose(fid);

        % Append new styles to to root.css:
        fid = fopen(css, 'r');
        OC4 = onCleanup(@()any(fid==fopen('all')) && fclose(fid));
        C   = textscan(fid, scanopts{:});
        C   = C{1};
        fclose(fid);

        C = [C; 'span.PreWrap {'; '    white-space: pre-wrap;'; '}'];

        fid = fopen(css, 'w');
        OC5 = onCleanup(@()any(fid==fopen('all')) && fclose(fid));
        cellfun(@(str)fprintf(fid, '%s\n', str), C);
        fclose(fid);

    end

end

% Options processor
function options = get_options(varargin)

    assert(mod(nargin, 2)==0,...
           [mfilename() ':pvpairs_expected'], ...
           'Parameter/value pairs expected.');

    onoff = @matlab.lang.OnOffSwitchState;

    options = struct('test_report'         , onoff('off'),...
                     'coverage_report'     , onoff('off'),...
                     'performance_report'  , onoff('off'),...
                     'documentation_report', onoff('off'),...
                     'excludes'            , {{}});

    parameters = varargin(1:2:end);
    values     = varargin(2:2:end);

    for ii = 1:numel(parameters)

        parameter = parameters{ii};
        value     = values{ii};

        switch lower(parameter)

            % individual report flags
            case {'test_report'        'coverage_report',...
                  'performance_report' 'documentation_report'}
                options.(lower(parameter)) = onoff(value);

            % Presets
            case {'ci' 'jenkins'} % = all ON
                if value
                    fn = fieldnames(options);
                    for jj = 1:numel(fn)
                        options.(fn{jj}) = onoff('on'); end
                end

            case 'local' % = all OFF
                if value
                    fn = fieldnames(options);
                    for jj = 1:numel(fn)
                        options.(fn{jj}) = onoff('off'); end
                end

            % Manually exlude tests
            case {'exclude' 'excludes'}
                value = Utils.String.CheckAndConvertStrings(value);
                options.excludes = value;

            otherwise
                warning([mfilename() ':unsupported_parameter'], ...
                        'Unsupported parameter: ''%s''; ignoring...',...
                        parameter);
                continue;
        end

    end

end
