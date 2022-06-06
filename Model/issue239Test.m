
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile('issue239Test.model', 'linear', true);
m = solve(m);
m = steady(m);

startDate = qq(1,1);
endDate = qq(5,4);

d = steadydb(m, startDate:endDate, 'shockFunc', @randn);
s = simulate(m, d, startDate:endDate);
f = databank.copy(s, 'sourceNames', access(m, 'measurement-variables'));


%% Test objective function range and contributions

ff0 = kalmanFilter(m, f, startDate:endDate);
outp1 = loglik(m, f, startDate:endDate, 'ReturnObjFuncContribs', true, 'Relative', false);
outp2 = loglik(m, f, startDate:endDate, 'ObjFuncRange', startDate+3:endDate-1, 'Relative', false);
outp3 = loglik(m, f, startDate:endDate, 'ObjFuncRange', startDate+3:endDate-1, 'ReturnObjFuncContribs', true, 'Relative', false);
outp4 = loglik(m, f, startDate:endDate, 'Relative', false);

assertEqual(testCase, outp2, sum(outp3), 'AbsTol', 1e-12);
assertEqual(testCase, outp1(1+3:end-1), outp3(1+3:end-1), 'AbsTol', 1e-12);
assertEqual(testCase, outp4, sum(outp1), 'AbsTol', 1e-12);

