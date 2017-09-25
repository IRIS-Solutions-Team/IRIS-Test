function runAllTestsTAP()

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

try
  thisFolder = fileparts(mfilename('fullpath')) ;
  addpath(thisFolder);
  
  thisTAPFile = 'testResults.tap';
  if exist(thisTAPFile, 'file')
    delete(thisTAPFile);
  end

  % Create the suite and runner
  suite = TestSuite.fromFolder(thisFolder, ...
    'IncludingSubfolders', true);
  runner = TestRunner.withTextOutput;
  
  % Add the TAPPlugin directed to a file in the Jenkins workspace
  runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(thisTAPFile)));
  
  results = runner.run(suite);
  
  % Display log on Windows machines
  if ~ispc
    disp(results);
    disp(fileread(thisTAPFile));
  end
  
  % Clean up
  rmpath(thisFolder);
  if exist(thisTAPFile, 'file')
    delete(thisTAPFile);
  end
catch e;
  % Clean up
  if exist('thisFolder','var')
    rmpath(thisFolder);
  end
  if exist('thisTAPFile','var') && exist(thisTAPFile, 'file')
    delete(thisTAPFile);
  end
  % Display error report
  disp(e.getReport);
  exit(1);
end;
exit force;