
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


                                                                           
%% Test Blazer

xq = ExplanatoryEquation.fromString([
    "x = y{-1} + z{-1} + a"
    "a = b"
    "y = y{-1}"
    "z = x{-1}"
]);
act = blazer(xq);
assertEqual(testCase, numel(act{1}), 1);
assertEqual(testCase, numel(act{2}), 1);
assertEqual(testCase, sort(act{3}), sort(int16([1, 4])));



                                                                           
%% Test SaveAs

xq = ExplanatoryEquation.fromString([
    "x = y{-1} + z{-1} + a"
    "a = b"
    "y = y{-1}"
    "z = x{-1}"
]);
fileName = './test_blazer.model';
blazer(xq, 'SaveAs=', fileName);
act = file2char(fileName); 
assertEqual(testCase, contains(act, 'Number of Blocks: 3'), true);
assertEqual(testCase, contains(act, 'Assign'), true); 
assertEqual(testCase, contains(act, 'Iterate'), true); 
% delete(fileName);

