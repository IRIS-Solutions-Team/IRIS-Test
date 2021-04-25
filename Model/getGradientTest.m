
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

mf = model.File( );
mf.Code = join([
    "!variables"
    "a, b, c, d, e, f"
    "!equations"
    "a = b{-1}^2 + e{-2};"
    "b = b{+1} * b{-1};"
    "c = a + d{-1} + log(f{+1}) !! c = a + d;"
    "d = e{-1} + d{+1};"
    "e = log(f) + 1 !! e = 1;"
    "f = 1;"
], newline);

m = Model(mf);
g = get(m, "Gradients");

assertEqual(testCase, cellfun(@(x) isa(x, "function_handle"), g.Dynamic(:, 1)), true(6, 1));
assertEqual(testCase, cellfun(@(x) numel(x), g.Dynamic(:, 2)), [3; 3; 4; 3; 2; 1]);

assertEqual(testCase, cellfun(@(x) isa(x, "function_handle"), g.Steady([3, 5], 1)), true(2, 1));
assertEqual(testCase, cellfun(@(x) numel(x), g.Steady([3, 5], 2)), [3; 1]);

assertEqual(testCase, cellfun(@isempty, g.Steady([1, 2, 4, 6], 1)), true(4, 1));
assertEqual(testCase, cellfun(@isempty, g.Steady([1, 2, 4, 6], 2)), true(4, 1));

