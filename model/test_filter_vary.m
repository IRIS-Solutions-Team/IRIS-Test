
assertEqualTol = @(x, y) assert(max(abs(x-y))<1e-10);
assertLess = @(x, y) assert(all(x<y));

m = model('test_filter_vary.model', 'Linear=', true);
m = solve(m);
m = sstate(m);

d = struct( );
d.z = cumsum(Series(1:10, @randn));
[~, f0] = filter(m, d, 1:10, 'Output=', 'Smooth,Pred',  'Relative=', false);
[~, f1] = filter(assign(m, 'std_eps_y=', 10), d, 1:10, 'Output=', 'Smooth,Pred',  'Relative=', false);

%**************************************************************************
% Test Presample

v2 = struct( );
v2.std_eps_y = tseries(0, 10);
[~, f2] = filter(m, d, 1:10, 'Output=', ...
    'Smooth,Pred',  'Relative=', false, ...
    'Vary=', v2 ...
    );

assertLess( f0.pred.std.y(:), f2.pred.std.y(:) );
assertLess( f2.pred.std.y(:), f1.pred.std.y(:) );

%**************************************************************************
% Test Presample and First Period

v3 = struct( );
v3.std_eps_y = tseries(0:1, 10);
[~, f3] = filter(m, d, 1:10, 'Output=', ...
    'Smooth,Pred',  'Relative=', false, ...
    'Vary=', v3 ...
    );

assertEqualTol( f1.pred.std.y(1), f3.pred.std.y(1) );

