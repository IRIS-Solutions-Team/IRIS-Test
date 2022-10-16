
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
x = get(0, "defaultFigureVisible");
set(0, "defaultFigureVisible", "off");

a = run(allSystemTests)

set(0, "defaultFigureVisible", x);
diary off

set(0, "defaultFigureVisible", "on");
warning("on", "MATLAB:structOnObject")

rmpath(thisFolder);

drawnow();
close all

