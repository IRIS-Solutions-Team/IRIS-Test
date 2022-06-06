
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile('modelFileTest.model');

d = struct( );
d.x = Series(-10:20, @rand);
d.y = Series(-10:20, @rand);
d.pre2 = Series(-10:30, @rand);
d.post2 = Series(-10:30, @rand);


%% Test preprocessor

dd = preprocess(m, d, 1:20, 'prependInput', true);

assertEqual(testCase, isfield(dd, "pre1"), true);
assertEqual(testCase, isfield(dd, "pre2"), true);


%% Test postprocessor

dd = postprocess(m, d, 1:20, 'prependInput', true);

assertEqual(testCase, isfield(dd, "post1"), true);
assertEqual(testCase, isfield(dd, "post2"), true);
