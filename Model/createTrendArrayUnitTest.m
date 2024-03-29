% saveAs=Model/createTrendArrayUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
mf = ModelSource( );
mf.Code = char(join({
    '!variables'
    '    a, b, c, x, y, z'
    '!log-variables'
    '    a, b, c'
    '!parameters'
    '    da, db, dx, dy'
    '!equations'
    '    x = x{-1} + dx;'
    '    y = y{-1} + dy;'
    '    z = x{-1};'
    '    log(a) = log(a{-1}) + log(da);'
    '    log(b) = log(b{-1}) + log(db);'
    '    c = a{-1};'
}, newline));
testCase.TestData.Model = Model(mf);


%% Test Nonlinear No Change One Variant
    m = testCase.TestData.Model;
    m.da = 1;
    m.db = 1;
    m.dx = 0;
    m.dy = 0;
    m = steady(m);
    timeVec = 0:10;
    x = createTrendArray(m, 1, true, @all, timeVec);
    expd = zeros(11, 11);
    expd(1:6, :) = 1;
    expd(7:10, :) = repmat([1;1;0;0], 1, 11);
    expd(end, :) = 0:10;
    assertEqual(testCase, x, expd, 'AbsTol', 1e-10);


%% Test Nonlinear Change in Log One Variant
    m = testCase.TestData.Model;
    m.da = 1.06;
    m.db = 0.88;
    m.dx = 0;
    m.dy = 0;
    m.a = 1;
    m.b = 1;
    m.x = 0;
    m.y = 0;
    m = steady(m, 'Growth=', true, 'FixLevel=', {'a', 'b', 'x', 'y'});
    timeVec = 0:10;
    numPeriods = numel(timeVec);
    x = createTrendArray(m, 1, true, @all, timeVec);
    assertEqual(testCase, x(1, 1), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(2, 1), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(3, 2), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(1, 2:end)./x(1, 1:end-1), repmat(1.06, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(2, 2:end)./x(2, 1:end-1), repmat(0.88, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(3, 2:end)./x(3, 1:end-1), repmat(1.06, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(4, :), zeros(size(timeVec)), 'AbsTol', 1e-10);
    assertEqual(testCase, x(5, :), zeros(size(timeVec)), 'AbsTol', 1e-10);
    assertEqual(testCase, x(6, :), zeros(size(timeVec)), 'AbsTol', 1e-10);


%% Test Nonlinear Change in Non-Log One Variant
    m = testCase.TestData.Model;
    m.da = 1;
    m.db = 1;
    m.dx = 0.9;
    m.dy = -4;
    m.a = 1;
    m.b = 1;
    m.x = 0;
    m.y = 0;
    m = steady(m, 'Growth=', true, 'FixLevel=', {'a', 'b', 'x', 'y'});
    timeVec = 0:10;
    numPeriods = numel(timeVec);
    x = createTrendArray(m, 1, true, @all, timeVec);
    assertEqual(testCase, x(1, :), ones(size(timeVec)), 'AbsTol', 1e-10);
    assertEqual(testCase, x(2, :), ones(size(timeVec)), 'AbsTol', 1e-10);
    assertEqual(testCase, x(3, :), ones(size(timeVec)), 'AbsTol', 1e-10);
    assertEqual(testCase, x(4, 1), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(5, 1), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(6, 2), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(4, 2:end)-x(4, 1:end-1), repmat(0.9, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(5, 2:end)-x(5, 1:end-1), repmat(-4, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(6, 2:end)-x(6, 1:end-1), repmat(0.9, 1, numPeriods-1), 'AbsTol', 1e-10);


%% Test Nonlinear Change in All One Variant
    m = testCase.TestData.Model;
    m.da = 1.06;
    m.db = 0.88;
    m.dx = 0.9;
    m.dy = -4;
    m.a = 1;
    m.b = 1;
    m.x = 0;
    m.y = 0;
    m = steady(m, 'Growth=', true, 'FixLevel=', {'a', 'b', 'x', 'y'});
    timeVec = 0:10;
    numPeriods = numel(timeVec);
    x = createTrendArray(m, 1, true, @all, timeVec);
    assertEqual(testCase, x(1, 1), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(2, 1), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(3, 2), 1, 'AbsTol', 1e-10);
    assertEqual(testCase, x(1, 2:end)./x(1, 1:end-1), repmat(1.06, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(2, 2:end)./x(2, 1:end-1), repmat(0.88, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(3, 2:end)./x(3, 1:end-1), repmat(1.06, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(4, 1), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(5, 1), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(6, 2), 0, 'AbsTol', 1e-10);
    assertEqual(testCase, x(4, 2:end)-x(4, 1:end-1), repmat(0.9, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(5, 2:end)-x(5, 1:end-1), repmat(-4, 1, numPeriods-1), 'AbsTol', 1e-10);
    assertEqual(testCase, x(6, 2:end)-x(6, 1:end-1), repmat(0.9, 1, numPeriods-1), 'AbsTol', 1e-10);


%% Test Nonlinear Change in All Multiple Variants
    m = testCase.TestData.Model;
    m = alter(m, 10);
    m.da = 0.5 + rand(1, 10);
    m.db = 0.5 + rand(1, 10);
    m.dx = -0.5 + rand(1, 10);
    m.dy = -0.5 + rand(1, 10);
    m.a = 2 + rand(1, 10);
    m.b = 2 + rand(1, 10);
    m.x = 0 + randn(1, 10);
    m.y = 0 + randn(1, 10);
    m = steady(m, 'Growth=', true, 'FixLevel=', {'a', 'b', 'x', 'y'});
    timeVec = -1:10;
    numPeriods = numel(timeVec);
    x = createTrendArray(m, 1:10, true, @all, timeVec);
    xall = createTrendArray(m, @all, true, @all, timeVec);
    assertEqual(testCase, x, xall, 'AbsTol', 1e-10);
    for v = 1 : 10
        assertEqual(testCase, x(1, 2, v), real(m.a(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(2, 2, v), real(m.b(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(3, 3, v), real(m.a(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(1, 2:end, v)./x(1, 1:end-1, v), repmat(m.da(v), 1, numPeriods-1), 'AbsTol', 1e-10);
        assertEqual(testCase, x(2, 2:end, v)./x(2, 1:end-1, v), repmat(m.db(v), 1, numPeriods-1), 'AbsTol', 1e-10);
        assertEqual(testCase, x(3, 2:end, v)./x(3, 1:end-1, v), repmat(m.da(v), 1, numPeriods-1), 'AbsTol', 1e-10);
        assertEqual(testCase, x(4, 2, v), real(m.x(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(5, 2, v), real(m.y(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(6, 3, v), real(m.x(v)), 'AbsTol', 1e-10);
        assertEqual(testCase, x(4, 2:end, v)-x(4, 1:end-1, v), repmat(m.dx(v), 1, numPeriods-1), 'AbsTol', 1e-10);
        assertEqual(testCase, x(5, 2:end, v)-x(5, 1:end-1, v), repmat(m.dy(v), 1, numPeriods-1), 'AbsTol', 1e-10);
        assertEqual(testCase, x(6, 2:end, v)-x(6, 1:end-1, v), repmat(m.dx(v), 1, numPeriods-1), 'AbsTol', 1e-10);
    end
    assertEqual(testCase, x(7:10, :, :), repmat(permute([m.da; m.db; m.dx; m.dy], [1, 3, 2]), 1, numPeriods, 1));
    assertEqual(testCase, x(11, :, :), repmat(timeVec, 1, 1, 10));
