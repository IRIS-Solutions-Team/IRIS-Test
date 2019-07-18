
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = model('autoexogenizeTest.model', 'Linear=', true);
m = solve(m);
m = sstate(m);
testData.Model = m;




%% Test Legacy Function Name autoexogenise ForGPMN

m = testData.Model;
act = autoexogenise(m);
exp = struct('x', 'ex', 'y', 'ey', 'z', 'ez');
assertEqual(testCase, act, exp);


%% Test One

m = testData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, 'x', 1:5);
p = autoexogenize(p, 'y', 2:6);
p = autoexogenize(p, 'z', 3:7);

expXAnch = false(4, 10);
expXAnch(1, 1:5) = true;
expXAnch(2, 2:6) = true;
expXAnch(3, 3:7) = true;

assertEqual( testCase, p.XAnch, expXAnch );




%% Test Two

m = testData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, {'x', 'y'}, 1:5);

expXAnch = false(4, 10);
expXAnch(1:2, 1:5) = true;
assertEqual( testCase, p.XAnch, expXAnch );




%% Test Three

m = testData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, {'x', 'y', 'z'}, 1:5);

expXAnch = false(4, 10);
expXAnch(1:3, 1:5) = true;
assertEqual( testCase, p.XAnch, expXAnch );




%% Test All

m = testData.Model;
p = plan(m, 1:10);
p = autoexogenize(p, @all, 1:5);

expXAnch = false(4, 10);
expXAnch(1:3, 1:5) = true;
assertEqual( testCase, p.XAnch, expXAnch );




%% Test Autoexogenize Error

m = testData.Model;
p = plan(m, 1:10);

isErr = false;
try
    p = autoexogenize(p, 'a', 1:5);
catch
    isErr = true;
end

expXAnch = false(4, 10);

assertEqual( testCase, isErr, true );
assertEqual( testCase, p.XAnch, expXAnch );




%% Test Simulate

m = testData.Model;
d = sstatedb(m, 1:20);

p = plan(m, 1:20);
p = autoexogenize(p, {'x', 'z'}, 1:20);
d.x(1:20) = rand(20, 1);
d.y(1:20) = rand(20, 1);
d.z(1:20) = rand(20, 1);
s = simulate(m, d, 1:20, 'Plan=', p);

assertEqual(testCase, d.x(1:20), s.ex(1:20), 'AbsTol', 1e-10);
assertEqual(testCase, zeros(20, 1), s.ey(1:20), 'AbsTol', 1e-10);
assertEqual(testCase, d.z(1:20), s.ez(1:20), 'AbsTol', 1e-10);

