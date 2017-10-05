
rng(0);

d = struct( );
d.x = cumsum(Series(1:100, @randn));
d.y = cumsum(Series(1:100, @randn));
d.z = cumsum(Series(1:100, @randn));

v = VAR({'x', 'y', 'z'});
v = estimate(v, d, 1:100);
x = mean(v);

assertEqualTol = @(x, y) assert(abs(x-y)<1e-8);

%**************************************************************************
% Hard Parameters

fprintf(v, 'test_fprintf_hard.model', 'Declare=', true);
mh = model('test_fprintf_hard.model', 'Linear=', true);
mh = solve(mh);
mh = sstate(mh);

assertEqualTol(x(1), mh.x);
assertEqualTol(x(2), mh.y);
assertEqualTol(x(3), mh.z);

%**************************************************************************
% Soft Parameters

[~, d] = fprintf(v, 'test_fprintf_soft.model', 'Declare=', true, 'HardParameters=', false);
ms = model('test_fprintf_hard.model', 'Linear=', true);
ms = solve(ms);
ms = sstate(ms);

assertEqualTol(x(1), ms.x);
assertEqualTol(x(2), ms.y);
assertEqualTol(x(3), ms.z);

