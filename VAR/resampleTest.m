
% Set Up Once
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

range = qq(2000, 1):qq(2015, 4);
d = struct( );
d.x = hpf2(cumsum(Series(range, @randn)));
d.y = hpf2(cumsum(Series(range, @randn)));
d.z = hpf2(cumsum(Series(range, @randn)));
d.a = hpf2(cumsum(Series(range, @randn)));
d.b = hpf2(cumsum(Series(range, @randn)));
v = VAR( {'x', 'y', 'z'} );
[v, vd] = estimate(v, d, range, 'Order=', 2);
testCase.TestData.range = range;
testCase.TestData.v = v;
testCase.TestData.d = d;
testCase.TestData.vd = vd;


%% Test Efron Bootstrap

v = testCase.TestData.v;
d = testCase.TestData.d;
vd = testCase.TestData.vd;
range = testCase.TestData.range;
order = get(v, 'Order');
numDraws = 10;
[bootD, draw] = resample(v, vd, range(order+1:end), numDraws, 'Method=', 'Bootstrap');
res_x = vd.res_x(:, 1);
res_y = vd.res_y(:, 1);
res_z = vd.res_z(:, 1);
for v = 1 : numDraws
    perm = draw(:, v);
    assertEqual(testCase, bootD.res_x(:, v), res_x(perm));
    assertEqual(testCase, bootD.res_y(:, v), res_y(perm));
    assertEqual(testCase, bootD.res_z(:, v), res_z(perm));
end



%% Test Wild Bootstrap
v = testCase.TestData.v;
d = testCase.TestData.d;
vd = testCase.TestData.vd;
range = testCase.TestData.range;
order = get(v, 'Order');
numDraws = 10;
[bootD, draw] = resample(v, vd, range(order+1:end), numDraws, 'Method=', 'Bootstrap', 'Wild=', true);
for v = 1 : numDraws
    assertEqual(testCase, bootD.res_x(:, v), vd.res_x(:, 1).*draw(:, v));
    assertEqual(testCase, bootD.res_y(:, v), vd.res_y(:, 1).*draw(:, v));
    assertEqual(testCase, bootD.res_z(:, v), vd.res_z(:, 1).*draw(:, v));
end



%% Test Efron Bootstrap SVAR

v = testCase.TestData.v;
d = testCase.TestData.d;
vd = testCase.TestData.vd;
range = testCase.TestData.range;
order = get(v, 'Order');
[v, vd] = SVAR(v, vd, 'Method=', 'Chol');
numDraws = 10;
[bootD, draw] = resample(v, vd, range(order+1:end), numDraws, 'Method=', 'Bootstrap');
res_x = vd.res_x(:, 1);
res_y = vd.res_y(:, 1);
res_z = vd.res_z(:, 1);
for v = 1 : numDraws
    perm = draw(:, v);
    assertEqual(testCase, bootD.res_x(:, v), res_x(perm), 'AbsTol', 1e-10)
    assertEqual(testCase, bootD.res_y(:, v), res_y(perm), 'AbsTol', 1e-10)
    assertEqual(testCase, bootD.res_z(:, v), res_z(perm), 'AbsTol', 1e-10)
end



