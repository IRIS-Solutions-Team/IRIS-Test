
% prepareUnitTests( )
rehash path

thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

warning("off", "MATLAB:structOnObject")


delete log.txt
diary log.txt
a = run(allSystemTests)
diary off

warning("on", "MATLAB:structOnObject")

rmpath(thisFolder);

drawnow();
close all
