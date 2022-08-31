
% prepareUnitTests( )
rehash path

thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

warning("off", "MATLAB:structOnObject")
set(0, "defaultFigureVisible", "off");

delete log.txt
diary log.txt
a = run(allSystemTests)
diary off

set(0, "defaultFigureVisible", "on");
warning("on", "MATLAB:structOnObject")

rmpath(thisFolder);

drawnow();
close all

