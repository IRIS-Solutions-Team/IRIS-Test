
% saveAs=databank/minusControlUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromSnippet("test", linear=true);
m = solve(m);
m = steady(m);

% test>>>
% !variables x, y
% !log-variables y
% !equations x = 0; y = 1;
% <<<test

d.x = Series(1:10, @randn);
d.y = exp(Series(1:10, @randn));


%% Test control databank 

c = steadydb(m, 1:10);
smc1 = databank.minusControl(m, d, c);
smc2 = databank.minusControl(m, d);

for n = access(m, "transition-variables")
        assertEqual(testCase, smc1.(n).Data, smc2.(n).Data);
end


%% Test Range option

range = 3:8;
c = steadydb(m, range);
smc1 = databank.minusControl(m, d, c);
smc2 = databank.minusControl(m, d, range=range);

for n = access(m, "transition-variables")
        assertEqual(testCase, smc1.(n).Data, smc2.(n).Data);
end


%% Test AddToDatabank option

outputDb = Dictionary();
smc1 = databank.minusControl(m, d);
smc2 = databank.minusControl(m, d, addToDatabank=outputDb);

assertClass(testCase, smc2, "Dictionary");

for n = access(m, "transition-variables")
        assertEqual(testCase, smc1.(n).Data, smc2.(n).Data);
end
