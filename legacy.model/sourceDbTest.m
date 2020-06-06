
assertEqual = @(x, y) assert(isequal(x, y));

%{
ModelNoShift>>>>>
!variables
    w = 0, x=1+1.01i, y=3+1.01i, z=4
!log_variables
    x, y
!shocks
    ew, ex, ey, ez
!parameters
    a=1, b=2, c=4
!equations
    w = 0*x + ew;
    x = 1*exp(ex);
    y*exp(ey) = a*x + b;
    z + ez = c + w;
<<<<<ModelNoShift
%}
fileName = 'sourceDbTestNoShift.model';
parser.grabTextFromCaller('ModelNoShift', fileName);
m0 = model(fileName, 'linear=', true);

%{
ModelLag>>>>>
!variables
    w = 0, x=1+1.01i, y=3+1.01i, z=4
!log_variables
    x, y
!shocks
    ew, ex, ey, ez
!parameters
    a=1, b=2, c=4
!equations
    w = x{-1} + ew;
    x = 1*exp(ex);
    y*exp(ey) = a*x + b;
    z + ez = c + w{-2};
<<<<<ModelLag
%}
fileName = 'sourceDbTestLag.model';
parser.grabTextFromCaller('ModelLag', fileName);
n0 = model(fileName, 'linear=', true);


%% Test zerodb

m = m0;
range = 1:10;
maxLag = 1;
xrange = range(1)-maxLag:range(end);
actDb = zerodb(m, range);
expDb = struct( ...
    'a', 1, ...
    'b', 2, ...
    'c', 4, ...
    'w', tseries(xrange, 0, 'w'), ...
    'x', tseries(xrange, 1, 'x'), ...
    'y', tseries(xrange, 1, 'y'), ...
    'z', tseries(xrange, 0, 'z'), ...
    'ew', tseries(range, 0, 'ew'), ...
    'ex', tseries(range, 0, 'ex'), ...
    'ey', tseries(range, 0, 'ey'), ...
    'ez', tseries(range, 0, 'ez'), ...
    'std_ew', 1, ...
    'std_ex', 1, ...
    'std_ey', 1, ...
    'std_ez', 1, ...
    model.component.Quantity.RESERVED_NAME_TTREND, tseries(xrange, 0, model.COMMENT_TTREND) ...
    );
compareDatabanks(actDb, expDb);


%% Test zerodb with ShockFunc Option

m = m0;
range = 1:100000;
d = zerodb(m, range, 'shockFunc=', @randn);
actStdEw = std(d.ew);
actStdEx = std(d.ex);
actStdEy = std(d.ey);
actStdEz = std(d.ez);
assertEqual(round(actStdEw, 1), 1);
assertEqual(round(actStdEx, 1), 1);
assertEqual(round(actStdEy, 1), 1);
assertEqual(round(actStdEz, 1), 1);


%% Test sstatedb

m = m0;
range = 1:10;
maxLag = 1;
xrange = range(1)-maxLag:range(end);
ttrend = dat2ttrend(xrange, m);
actDb = sstatedb(m, range);

expDb = struct( ...
    'a', 1, ...
    'b', 2, ...
    'c', 4, ...
    'w', tseries(xrange, 0, 'w'), ...
    'x', tseries(xrange, 1*1.01.^xrange, 'x'), ...
    'y', tseries(xrange, 3*1.01.^xrange, 'y'), ...
    'z', tseries(xrange, 4, 'z'), ...
    'ew', tseries(range, 0, 'ew'), ...
    'ex', tseries(range, 0, 'ex'), ...
    'ey', tseries(range, 0, 'ey'), ...
    'ez', tseries(range, 0, 'ez'), ...
    'std_ew', 1, ...
    'std_ex', 1, ...
    'std_ey', 1, ...
    'std_ez', 1, ...
    model.component.Quantity.RESERVED_NAME_TTREND, tseries(xrange, ttrend.', model.COMMENT_TTREND) ...
    );
compareDatabanks(actDb, expDb);


%% Test sstatedb Multiple Variants

m = m0;
m = alter(m, 2);
m.x = [1+1.01i, 2+1.02i];
m.y = [3+1.01i, 4+1.02i];
range = 1:10;
maxLag = 1;
xrange = range(1)-maxLag:range(end);
ttrend = dat2ttrend(xrange, m);
actDb = sstatedb(m, range);

z = ones(length(range), 2);
xz = ones(length(xrange), 2);
expDb = struct( ...
    'a', [1, 1], ...
    'b', [2, 2], ...
    'c', [4, 4], ...
    'w', tseries(xrange, 0*xz, 'w'), ...
    'x', tseries(xrange, [1*1.01.^xrange.', 2*1.02.^xrange.'], 'x'), ...
    'y', tseries(xrange, [3*1.01.^xrange.', 4*1.02.^xrange.'], 'y'), ...
    'z', tseries(xrange, 4*xz, 'z'), ...
    'ew', tseries(range, 0*z, 'ew'), ...
    'ex', tseries(range, 0*z, 'ex'), ...
    'ey', tseries(range, 0*z, 'ey'), ...
    'ez', tseries(range, 0*z, 'ez'), ...
    'std_ew', [1, 1], ...
    'std_ex', [1, 1], ...
    'std_ey', [1, 1], ...
    'std_ez', [1, 1], ...
    model.component.Quantity.RESERVED_NAME_TTREND, tseries(xrange, [ttrend.', ttrend.'], model.COMMENT_TTREND) ...
    );
compareDatabanks(actDb, expDb);


%% Test zerodb with Lags

m = n0;
range = 1:10;
maxLag = 2;
xrange = range(1)-maxLag:range(end);
actDb = zerodb(m, range);
expDb = struct( ...
    'a', 1, ...
    'b', 2, ...
    'c', 4, ...
    'w', tseries(xrange, 0, 'w'), ...
    'x', tseries(xrange, 1, 'x'), ...
    'y', tseries(xrange, 1, 'y'), ...
    'z', tseries(xrange, 0, 'z'), ...
    'ew', tseries(range, 0, 'ew'), ...
    'ex', tseries(range, 0, 'ex'), ...
    'ey', tseries(range, 0, 'ey'), ...
    'ez', tseries(range, 0, 'ez'), ...
    'std_ew', 1, ...
    'std_ex', 1, ...
    'std_ey', 1, ...
    'std_ez', 1, ...
    model.component.Quantity.RESERVED_NAME_TTREND, tseries(xrange, 0, model.COMMENT_TTREND) ...
    );
compareDatabanks(actDb, expDb);


%% Test sstatedb with Lags

m = n0;
range = 1:10;
maxLag = 2;
xrange = range(1)-maxLag:range(end);
ttrend = dat2ttrend(xrange, m);
actDb = sstatedb(m, range);

expDb = struct( ...
    'a', 1, ...
    'b', 2, ...
    'c', 4, ...
    'w', tseries(xrange, 0, 'w'), ...
    'x', tseries(xrange, 1*1.01.^xrange, 'x'), ...
    'y', tseries(xrange, 3*1.01.^xrange, 'y'), ...
    'z', tseries(xrange, 4, 'z'), ...
    'ew', tseries(range, 0, 'ew'), ...
    'ex', tseries(range, 0, 'ex'), ...
    'ey', tseries(range, 0, 'ey'), ...
    'ez', tseries(range, 0, 'ez'), ...
    'std_ew', 1, ...
    'std_ex', 1, ...
    'std_ey', 1, ...
    'std_ez', 1, ...
    model.component.Quantity.RESERVED_NAME_TTREND, tseries(xrange, ttrend.', model.COMMENT_TTREND) ...
    );
compareDatabanks(actDb, expDb);
