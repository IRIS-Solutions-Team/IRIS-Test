% saveAs=Explanatory/getDataBlockUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up once
    testCase.TestData.Model1 = Explanatory.fromString("log(x) = ?*a + b*x{-1} + ?*log(c) + ?*z{+1} - ? + d"); baseRange = qq(2001,1) : qq(2010,10);
    extendedRange = baseRange(1)-1 : baseRange(end)+1;
    db = struct( );
    db.x = Series(extendedRange, @rand);
    db.a = Series(baseRange, @rand);
    db.b = Series(baseRange, @rand);
    db.c = Series(baseRange, @rand);
    db.d = Series(extendedRange, @rand);
    db.z = Series(extendedRange, @rand);
    db.res_x = Series(extendedRange(5:10), @rand);
    testCase.TestData.BaseRange = baseRange;
    testCase.TestData.ExtendedRange = extendedRange;
    testCase.TestData.Databank = db;


%% Test Plain Vanilla
    g = testCase.TestData.Model1;
    db = testCase.TestData.Databank;
    baseRange = testCase.TestData.BaseRange;
    extendedRange = testCase.TestData.ExtendedRange;
    numExtendedPeriods = numel(extendedRange);
    lhsRequired = true;
    act = getDataBlock(g, db, baseRange, lhsRequired, "");
    assertEqual(testCase, act.NumExtdPeriods, numExtendedPeriods);
    exp_YXEPG = nan(7, numExtendedPeriods);
    exp_YXEPG(1, :) = db.x(extendedRange);
    exp_YXEPG(2, :) = db.a(extendedRange);
    exp_YXEPG(3, :) = db.b(extendedRange);
    exp_YXEPG(4, :) = db.c(extendedRange);
    exp_YXEPG(5, :) = db.z(extendedRange);
    exp_YXEPG(6, :) = db.d(extendedRange);
    exp_YXEPG(7, :) = db.res_x(extendedRange);
    assertEqual(testCase, act.YXEPG, exp_YXEPG);
