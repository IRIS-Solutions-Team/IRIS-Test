
prepareUnitTests( )
rehash path

thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

warning("off", "MATLAB:structOnObject")

a = run(allSystemTests)

warning("on", "MATLAB:structOnObject")

rmpath(thisFolder);

close all
