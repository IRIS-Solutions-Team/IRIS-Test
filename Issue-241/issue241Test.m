
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test For Control

a = struct( );
a.MyStates = {'x1', 'x2'};
a.K = 3;
m = Model('issue241Test.model', 'Assign', a);
assertEqual(testCase, get(m, 'XList'), {'x1', 'x2', 'z1', 'z2', 'z3'});


%% Test For Control Import

a = struct( );
a.MyStates = {'x1', 'x2'};
a.K = 3;
m = Model('issue241ImportTest.model', 'Assign', a);
assertEqual(testCase, get(m, 'XList'), {'x1', 'x2', 'z1', 'z2', 'z3'});

