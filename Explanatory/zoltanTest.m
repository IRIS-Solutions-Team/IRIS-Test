
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Atrributes

expy = Explanatory.fromFile("zoltanTest.model");

assertEqual(testCase, numel(expy), 6);

for i = reshape(expy, 1, [ ])
	assertEqual(testCase, i.Attributes, [":FR", ":XXX", ":ene_wob"]);
end
