% saveAs=Quantity/initializeLogStatusUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Default False

q = model.component.Quantity;
q.Name = ["a", "b", "c", "d", "ea", "eb", "g", "ttrend"];
q.Type = [1, 2, 2, 2, 3, 3, 5, 5];
q.IxLog = false(size(q.Name));
log = ["a", "b", "g"];
q = initializeLogStatus(q, log, string.empty(1, 0));
assertEqual(testCase, q.IxLog, [true, true, false, false, false, false, true, false]);


%% Test Default True

q = model.component.Quantity;
q.Name = ["a", "b", "c", "d", "ea", "eb", "g", "ttrend"];
q.Type = [1, 2, 2, 2, 3, 3, 5, 5];
q.IxLog = false(size(q.Name));
log = Except(["a", "b", "g"]);
q = initializeLogStatus(q, log, string.empty(1, 0));
assertEqual(testCase, q.IxLog, [false, false, true, true, false, false, false, false]);
