% saveAs=Explanatory/residualsUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    m1 = Explanatory.fromString('x = ? + ?*x{-1} + ?*y');
    startDate = qq(2001,1);
    endDate = qq(2010, 4);
    baseRange = startDate:endDate;
    db1 = struct( );
    db1.x = cumsum(Series(startDate-10:endDate+10, @randn));
    db1.y = cumsum(Series(startDate:endDate, @randn));
    testCase.TestData.Model1 = m1;
    testCase.TestData.Databank1 = db1;
    testCase.TestData.BaseRange = baseRange;


%% Test Residuals
    m1 = testCase.TestData.Model1;
    db1 = testCase.TestData.Databank1;
    baseRange = testCase.TestData.BaseRange;
    [est1, outputDb1] = regress(m1, db1, baseRange);
    outputDb2 = residuals(est1, db1, baseRange);
    [est2, outputDb3] = regress(est1, db1, baseRange, "ResidualsOnly=", true);
    assertEqual(testCase, outputDb1.res_x.Data, outputDb2.res_x.Data);
    assertEqual(testCase, outputDb1.res_x.Data, outputDb3.res_x.Data);
    assertEqual(testCase, est1, est2);
