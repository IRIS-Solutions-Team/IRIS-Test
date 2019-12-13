
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

assertEqualTol = @(x, y) assert(maxabs(x-y)<=1e-9);

m0 = model('3eq.model', 'linear=', true);
m0 = solve(m0);
m0 = sstate(m0);


%% Test Shocks

m = m0;
eList = get(m, 'eList');

exp1 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList{1});
exp2 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList{2});
s12 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList([1, 2]));
act1 = dbcol(s12, 1);
act2 = dbcol(s12, 2);

list = fieldnames(exp1);
for i = 1 : length(list)
    name = list{i};
    assertLessThan(testCase, abs(act1.(name)(:)-exp1.(name)(:)), 1e-9);
    assertLessThan(testCase, abs(act2.(name)(:)-exp2.(name)(:)), 1e-9);
end


%% Test Parameters

m = m0;
eList = get(m, 'eList');

exp1 = diffsrf(m, 1:20, 'alp4', 'Select=', eList);
exp2 = diffsrf(m, 1:20, 'alp3', 'Select=', eList);
s12 = diffsrf(m, 1:20, 'alp4, alp3', 'Select=', eList);
act1 = dbpage(s12, 1);
act2 = dbpage(s12, 2);

list = fieldnames(exp1);
for i = 1 : length(list)
    name = list{i};
    assertLessThan(testCase, abs(act1.(name)(:)-exp1.(name)(:)), 1e-9);
    assertLessThan(testCase, abs(act2.(name)(:)-exp2.(name)(:)), 1e-9);
end

