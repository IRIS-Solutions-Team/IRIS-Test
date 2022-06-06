
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

rng(0);

d = struct( );
d.x = cumsum(Series(1:100, @randn));
d.y = cumsum(Series(1:100, @randn));
d.z = cumsum(Series(1:100, @randn));

v = VAR({'x', 'y', 'z'});
v = estimate(v, d, 1:100);
x = mean(v);

assertEqualTol = @(x, y) assertEqual(testCase, x, y, "AbsTol", 1e-8);


%% Hard Parameters with Plain Schur

fprintf(v, 'test_fprintf_hard.model', 'Declare', true);
mh = model('test_fprintf_hard.model', 'Linear', true);
[mh, ~, info] = solve(mh, "preferredSchur", "schur");
mh = steady(mh);

assertEqual(testCase, info.SchurDecomposition, "schur");
assertEqualTol(x(1), mh.x);
assertEqualTol(x(2), mh.y);
assertEqualTol(x(3), mh.z);


%% Hard Parameters with Generalized Schur 

fprintf(v, 'test_fprintf_hard.model', 'Declare', true);
mh = model('test_fprintf_hard.model', 'Linear', true);
[mh, ~, info] = solve(mh, "preferredSchur", "qz");
mh = steady(mh);

assertEqual(testCase, info.SchurDecomposition, "qz");
assertEqualTol(x(1), mh.x);
assertEqualTol(x(2), mh.y);
assertEqualTol(x(3), mh.z);


%% Soft Parameters 

[~, d] = fprintf(v, 'test_fprintf_soft.model', 'Declare', true, 'HardParameters', false);
ms = Model('test_fprintf_hard.model', 'Linear', true);
ms = solve(ms);
ms = sstate(ms);

assertEqualTol(x(1), ms.x);
assertEqualTol(x(2), ms.y);
assertEqualTol(x(3), ms.z);

