
thisFolder = fileparts(mfilename('fullpath')) ;
addpath(thisFolder);

allTests = matlab.unittest.TestSuite.fromFolder( thisFolder, ...
                                                 'IncludingSubfolders', true) ;
run(allTests)

rmpath(thisFolder);

