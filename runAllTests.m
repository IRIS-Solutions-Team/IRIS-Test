
thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

allSystemTests = reshape(allSystemTests, [ ], 1);

allInfileTests = allInfileTests( );

run([allSystemTests; allInfileTests])

rmpath(thisFolder);


