
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Objective Function Range

m = Model('issue239Test.model', 'Linear=', true);
m = solve(m);
m = steady(m);

startDate = qq(1,1);
endDate = qq(5,4);

d = steadydb(m, startDate:endDate, 'ShockFunc', @randn);
s = simulate(m, d, startDate:endDate);
f = databank.copy(s, get(m, 'YNames'));

[~, ff0] = filter(m, f, startDate:endDate);
outp1 = loglik(m, f, startDate:endDate, 'ObjFuncContributions=', true, 'Relative=', false);
outp2 = loglik(m, f, startDate:endDate, 'ObjFuncRange=', startDate+3:endDate-1, 'Relative=', false);
outp3 = loglik(m, f, startDate:endDate, 'ObjFuncRange=', startDate+3:endDate-1, 'ObjFuncContributions=', true, 'Relative=', false);

assertEqual(testCase, outp2(1), outp3(1), 'AbsTol', 1e-12);
assertEqual(testCase, outp1(2+3:end-1), outp3(2+3:end-1), 'AbsTol', 1e-12);
assertEqual(testCase, outp1(1), sum(outp1(2:end)), 'AbsTol', 1e-12);
assertEqual(testCase, outp3(1), sum(outp3(2:end)), 'AbsTol', 1e-12);

