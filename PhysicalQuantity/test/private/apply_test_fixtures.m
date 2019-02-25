function apply_test_fixtures(tst)

    % Make sure current folder is set to test_dir
    cfix = @matlab.unittest.fixtures.CurrentFolderFixture;
    cfix = cfix(tst.test_dir{1});            
    tst.applyFixture(cfix);

    % Make sure all thr right stuff is on the MATLAB search path
    pfix = @matlab.unittest.fixtures.PathFixture;
    pfix = pfix(tst.test_dir{1}, 'IncludeSubfolders', true);            
    tst.applyFixture(pfix);

end
