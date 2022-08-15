
% prepareUnitTests( )
rehash path

thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allSystemTests = matlab.unittest.TestSuite.fromFolder( ...
    thisFolder, ...
    'IncludingSubfolders', true ...
);

warning("off", "MATLAB:structOnObject")


% a = run(allSystemTests)

delete log.txt
diary log.txt
for t = reshape(allSystemTests, 1, [])
    fprintf('\n\n\n\n\n\n\n%s\n', repmat('%', 1, 80))
    disp(t.BaseFolder)
    disp(t.Name)
    a = run(t)
end
diary off

warning("on", "MATLAB:structOnObject")

rmpath(thisFolder);

drawnow();
close all
