% saveAs=Model/preparePlanUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Vanilla Test
    f = ModelSource();
    f.FileName = "";
    f.Code = join([ 
        "!variables x, y, z !shocks ex, ey, ez "
        "!equations x=x{-1}+ex+0.1*ey+0.1*ez; y=0.1*ex+ey+0.1*ez; z=0.1*ex+0.1*ey+ez;"
    ]);
    m = Model(f, "linear", true);
    p = Plan(m, 1:10);
    assertEqual(testCase, p.SigmasExogenous, [nan(3,1), ones(3,10)]);
    m8 = alter(m, 8);
    p8 = Plan(m8, 1:10);
    assertEqual(testCase, p8.SigmasExogenous, [nan(3,1,8), ones(3,10,8)]);
    m8 = assign(m8, 'std_ey', 1:8);
    p8 = Plan(m8, 1:10);
    exp = nan(3, 11, 8);
    exp(:, 2:end, :) = 1;
    exp(2, 2:end, :) = repmat(reshape(1:8, 1, 1, 8), 1, 10, 1);
    assertEqual(testCase, p8.SigmasExogenous, exp);
