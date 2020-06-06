
prepareUnitTests( )
rehash path

thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

run(allSystemTests)

rmpath(thisFolder);


