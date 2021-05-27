% saveAs=preparser/DoubleDotUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test in model source file 

K = 5;
m = Model.fromSnippet("test", "assign", struct('K', K));
m = steady(m);

% test>>>
% !variables 
%     x, x1 ,.., x<K>
% !equations 
%     x = x1 +..+ x<K>;
%     !for <1 : K> !do x<?> = ?; !end
% <<<test

assertEqual(testCase, access(m, "transition-variables"), ["x", "x" + string(1:K)]);
assertEqual(testCase, m.x, sum(1:K), "absTol", 1e-12);
