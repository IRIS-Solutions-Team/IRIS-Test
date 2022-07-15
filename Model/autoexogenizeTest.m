
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model.fromFile('autoexogenizeTest.model', 'Linear', true);
m = solve(m);
m = sstate(m);
testData.Model = m;


%% Test One 

m = testData.Model;
p = Plan.forModel(m, 1:10);
p = autoswap(p, 1:5, 'x');
p = autoswap(p, 2:6, 'y');
p = autoswap(p, 3:7, 'z');

act = p.InxOfAnticipatedExogenized;
exp = false(4, 11);
exp(1, 1+(1:5)) = true;
exp(2, 1+(2:6)) = true;
exp(3, 1+(3:7)) = true;
assertEqual(testCase, act, exp);

act = p.InxOfAnticipatedEndogenized;
exp(1, 1+(1:5)) = true;
exp(2, 1+(2:6)) = true;
exp(3, 1+(3:7)) = true;
assertEqual(testCase, act, exp);


%% Test Two 

m = testData.Model;
p = Plan(m, 1:10);
p = autoswap(p, 1:5, {'x', 'y'});

act = p.InxOfAnticipatedExogenized;
exp = false(4, 11);
exp(1, 1+(1:5)) = true;
exp(2, 1+(1:5)) = true;
assertEqual(testCase, act, exp);

act = p.InxOfAnticipatedEndogenized;
exp = false(4, 11);
exp(1, 1+(1:5)) = true;
exp(2, 1+(1:5)) = true;
assertEqual(testCase, act, exp);




%% Test Three


m = testData.Model;
p = Plan(m, 1:10);
p = autoswap(p, 1:5, {'x', 'y', 'z'});

act = p.InxOfAnticipatedExogenized;
exp = false(4, 11);
exp(1, 1+(1:5)) = true;
exp(2, 1+(1:5)) = true;
exp(3, 1+(1:5)) = true;
assertEqual(testCase, act, exp);

act = p.InxOfAnticipatedEndogenized;
exp = false(4, 11);
exp(1, 1+(1:5)) = true;
exp(2, 1+(1:5)) = true;
exp(3, 1+(1:5)) = true;
assertEqual(testCase, act, exp);




%% Test All

m = testData.Model;
p = Plan(m, 1:10);
p = autoswap(p, 1:5, @all);

act = p.InxOfAnticipatedExogenized;
exp = false(4, 11);
exp(1:3, 1+(1:5)) = true;
assertEqual(testCase, act, exp);

act = p.InxOfAnticipatedEndogenized;
exp = false(4, 11);
exp(1:3, 1+(1:5)) = true;
assertEqual(testCase, act, exp);




%% Test Autoexogenize Error 

m = testData.Model;
p = Plan(m, 1:10);

isErr = false;
try
    p = autoswap(p, 1:5, 'a');
catch
    isErr = true;
end

assertEqual(testCase, isErr, true);
exp = false(4, 11);
assertEqual(testCase, p.InxOfAnticipatedExogenized, exp);




%% Test Simulate 

m = testData.Model;
d = sstatedb(m, 1:20);

p = Plan(m, 1:20);
p = autoswap(p, 1:20, {'x', 'z'});
d.x(1:20) = rand(20, 1);
d.y(1:20) = rand(20, 1);
d.z(1:20) = rand(20, 1);
s = simulate(m, d, 1:20, 'Plan', p);

assertEqual(testCase, d.x(1:20), s.ex(1:20), 'AbsTol', 1e-10);
assertEqual(testCase, zeros(20, 1), s.ey(1:20), 'AbsTol', 1e-10);
assertEqual(testCase, d.z(1:20), s.ez(1:20), 'AbsTol', 1e-10);

