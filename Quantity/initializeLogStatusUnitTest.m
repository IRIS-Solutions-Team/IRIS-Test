% saveAs=Quantity/initializeLogStatusUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
TYPE = @int8;


%% Test Default False

q = model.component.Quantity;
q.Name = ["a", "b", "c", "d", "ea", "eb", "g", "ttrend"]
q.Type = TYPE([1, 2, 2, 2, 3, 3, 5, 5]);
q.IxLog = false(size(q.Name));
log = ["a", "b", "g"];
q = initializeLogStatus(q, log);
assertEqual(testCase, q.IxLog, [true, true, false, false, false, false, true, false]);


%% Test Default True

q = model.component.Quantity;
q.Name = ["a", "b", "c", "d", "ea", "eb", "g", "ttrend"]
q.Type = TYPE([1, 2, 2, 2, 3, 3, 5, 5]);
q.IxLog = false(size(q.Name));
log = Except(["a", "b", "g"]);
q = initializeLogStatus(q, log);
assertEqual(testCase, q.IxLog, [false, false, true, true, false, false, false, false]);
