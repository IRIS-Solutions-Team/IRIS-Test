% saveAs=databank/toSeriesUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    d1 = struct();
    d1.a = Series(qq(1), rand(40,1));
    d1.b = Series(qq(2), rand(40,1));
    d1.c = Series(mm(1), rand(120,1));
    d1.d = Series( );
    d1.e = Series(qq(1), rand(40,2,3));
    d1.f = Series(qq(2), rand(40,2,3));
    d1.x = "a";
    d1.y = 1;
    d2 = struct();
    d2.a = d1.a;
    d2.b = d1.b;
    d2.x = d1.x;
    d2.y = d1.y;


%% Test Plain Vanilla
    x = databank.toSeries(d1, ["a", "b"]);
    y = [d1.a, d1.b];
    assertEqual(testCase, x.Data, y.Data);


%% Test All Names
    x = databank.toSeries(d2);
    y = [d2.a, d2.b];
    assertEqual(testCase, x.Data, y.Data);


%% Test User Dates
    x = databank.toSeries(d1, ["a", "b"], qq(1,1:10));
    y = [d1.a{qq(1,1:10)}, d1.b{qq(1,1:10)}];
    assertEqual(testCase, x.Data, y.Data);


%% Test Multidimensional Default Column
    x = databank.toSeries(d1, ["e", "f"]);
    y = [d1.e{:,1}, d1.f{:,1}];
    assertEqual(testCase, x.Data, y.Data);


%% Test Multidimensional User Column
    x = databank.toSeries(d1, ["e", "f"], @all, 3);
    y = [d1.e{:,1,2}, d1.f{:,1,2}];
    assertEqual(testCase, x.Data, y.Data);


%% Error Multiple Frequencies
    isError = false;
    try
        x = databank.toSeries(d1);
    catch
        isError = true;
    end
    assertTrue(testCase, isError);


%% Error Empty Series
    isError = false;
    try
        x = databank.toSeries(d1, "d");
    catch
        isError = true;
    end
    assertTrue(testCase, isError);
