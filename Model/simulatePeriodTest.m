
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    %
    fwd = Model("simulatePeriodTest.model", "assign", {"K", +1});
    bkw = Model("simulatePeriodTest.model", "assign", {"K", -1});
    %
    c = randn( );
    d = struct( );
    d.X = Series(-10:10, 10);
    d.eps = Series(1:10, @rand);



%% Test Forward Looking Simulate with Data Terminal
    %
    d.Z = Series(2:11, c);
    [s1, info1, frames1] = simulate(fwd, d, 1:10, "method", "period", "terminal", "data", "startIter", "data");
    %
    assertEqual(testCase, s1.X(1:10), 0.8*s1.X{-1}(1:10) + 0.2*s1.Y(1:10) + d.eps(1:10), "absTol", 1e-12);
    assertEqual(testCase, s1.Y(1:10), 0.3*s1.X(1:10), "absTol", 1e-12);
    assertEqual(testCase, s1.Z(1:10), s1.X{-1}(1:10) + 0.9*c, "absTol", 1e-12);



%% Test Backward Looking Simulate 
    %
    d.Z = Series(0, c);
    %
    % Even though we set terminal=firstOrder, the terminal condition is not
    % needed (this is a backward-looking model) and the option is
    % disregarded
    %
    [s2, info2, frames2] = simulate(bkw, d, 1:10, "method", "period", "terminal", "firstOrder", "startIter", "data");
    %
    assertEqual(testCase, s2.X(1:10), 0.8*s2.X{-1}(1:10) + 0.2*s2.Y(1:10) + d.eps(1:10), "absTol", 1e-12);
    assertEqual(testCase, s2.Y(1:10), 0.3*s2.X(1:10), "absTol", 1e-12);
    assertEqual(testCase, s2.Z(1:10), s2.X{-1}(1:10) + 0.9*s2.Z{-1}(1:10), "absTol", 1e-12);

