
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = model('exogenizedSimTest.model', 'linear', true);
m = solve(m);
testCase.TestData.Model = m;


%% Test Unanticipated

m = testCase.TestData.Model;
T = 5;
d = zerodb(m, 1:10);
d.x(T) = 1;

p = plan(m, 1:10);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T);
s1 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', false);
assertEqual(testCase, s1.x(T), 1, 'absTol', 1e-15);
assertEqual(testCase, s1.x(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertGreaterThan(testCase, s1.ex(T), 0);
assertEqual(testCase, s1.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ey', T);
s2 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', false);
assertEqual(testCase, s2.x(T), 1, 'absTol', 1e-15);
assertEqual(testCase, s2.x(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertGreaterThan(testCase, s2.ey(T), 0);
assertEqual(testCase, s2.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ey', T, 1i);
s3 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', true);
assertEqual(testCase, s3.x(T), 1, 'absTol', 1e-15);
assertEqual(testCase, s3.x(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertGreaterThan(testCase, imag(s3.ey(T)), 0);
assertEqual(testCase, real(s3.ey(T)), 0, 'absTol', 1e-15);
assertEqual(testCase, s3.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);


%% Test Unanticipated Weights

m = testCase.TestData.Model;
T = 5;
d = zerodb(m, 1:10);
d.x(T) = 1;
warning('off', 'iris:model:simulate');

p = plan(m, 1:10);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T, 2);
p = endogenize(p, 'ey', T, 1);
s1 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', false);
assertEqual(testCase, s1.x(T), 1, 'absTol', 1e-15);
assertEqual(testCase, s1.x(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertGreaterThan(testCase, s1.ex(T), 0);
assertGreaterThan(testCase, s1.ey(T), 0);
assertEqual(testCase, s1.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertEqual(testCase, s1.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T, 1i);
p = endogenize(p, 'ey', T, 2i);
s2 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', true);
assertEqual(testCase, s2.x(T), 1, 'absTol', 1e-15);
assertEqual(testCase, s2.x(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertLessThan(testCase, imag(s2.ex(T)), s1.ex(T));
assertGreaterThan(testCase, imag(s2.ey(T)), s1.ey(T));
assertEqual(testCase, s2.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertEqual(testCase, s2.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

warning('on', 'iris:model:simulate');


%% Test Anticipated

m = testCase.TestData.Model;
T = 5;
d = zerodb(m, 1:10);
d.x(T) = 1;

p = plan(m, 1:10);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T);
s1 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', true);
assertEqual(testCase, s1.x(T), 1, 'absTol', 1e-15);
assertNotEqual(testCase, s1.x(1:T-1), zeros(T-1, 1));
assertGreaterThan(testCase, s1.ex(T), 0);
assertEqual(testCase, s1.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ey', T);
s2 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', true);
assertEqual(testCase, s2.x(T), 1, 'absTol', 1e-15);
assertNotEqual(testCase, s2.x(1:T-1), zeros(T-1, 1));
assertGreaterThan(testCase, s2.ey(T), 0);
assertEqual(testCase, s2.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ey', T, 1i);
s3 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', false);
assertEqual(testCase, s3.x(T), 1, 'absTol', 1e-15);
assertNotEqual(testCase, s3.x(1:T-1), zeros(T-1, 1));
assertGreaterThan(testCase, imag(s3.ey(T)), 0);
assertEqual(testCase, real(s3.ey(T)), 0, 'absTol', 1e-15);
assertEqual(testCase, s3.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);



%% Test Anticipated Weights

m = testCase.TestData.Model;
T = 5;
d = zerodb(m, 1:10);
d.x(T) = 1;
warning('off', 'iris:model:simulate');

p = plan(m, 1:10);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T, 2);
p = endogenize(p, 'ey', T, 1);
s1 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', true);
assertEqual(testCase, s1.x(T), 1, 'absTol', 1e-15);
assertNotEqual(testCase, s1.x(1:T-1), zeros(T-1, 1));
assertGreaterThan(testCase, s1.ex(T), 0);
assertGreaterThan(testCase, s1.ey(T), 0);
assertEqual(testCase, s1.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertEqual(testCase, s1.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

p = reset(p);
p = exogenize(p, 'x', T);
p = endogenize(p, 'ex', T, 1i);
p = endogenize(p, 'ey', T, 2i);
s2 = simulate(m, d, 1:10, 'deviation', true, 'plan', p, 'anticipate', false);
assertEqual(testCase, s2.x(T), 1, 'absTol', 1e-15);
assertNotEqual(testCase, s2.x(1:T-1), zeros(T-1, 1));
assertLessThan(testCase, imag(s2.ex(T)), s1.ex(T));
assertGreaterThan(testCase, imag(s2.ey(T)), s1.ey(T));
assertEqual(testCase, s2.ex(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);
assertEqual(testCase, s2.ey(1:T-1), zeros(T-1, 1), 'absTol', 1e-15);

warning('on', 'iris:model:simulate');

