% saveAs=Series/getDAtaFromMultiple.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Plain Dates
    d = struct( );
    d.x = Series(qq(2020,1:40), @rand);
    d.y = Series(qq(2020,2:38), @rand);
    d.z = Series(qq(2020,3:42), @rand);
    %
    range = qq(2020,1) : qq(2020,42);
    [dates, f.x, f.y, f.z] = getDataFromMultiple(range, d.x, d.y, d.z);
    for n = ["x", "y", "z"]
        assertEqual(testCase, d.(n)(range), f.(n));
    end


% Test Long Range
    [dates, x, y, z] = getDataFromMultiple("longRange", d.x, d.y, d.z);
    assertEqual(testCase, dates, qq(2020,1):qq(2020,42), "absTol", 1e-12);


%% Test Short Range
    [dates, x, y, z] = getDataFromMultiple("shortRange", d.x, d.y, d.z);
    assertEqual(testCase, dates, qq(2020,3):qq(2020,38), "absTol", 1e-12);

