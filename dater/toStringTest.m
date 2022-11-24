
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test with no date format
    test = {
        dd(2021,05,19), "2021-May-19"
        ww(2021,10), "2021W10"
        mm(2025,04), "2025M04"
        qq(2021,1), "2021Q1"
        hh(2050,2), "2050H2"
        yy(1990), "1990Y"
    };
    for j = transpose(test)
        assertEqual(testCase, dater.toString(j{1}), j{2});
    end


%% Test with no daily format
    test = {
        dd(2021,05,19), "2021-05-19"
        ww(2021,10), "2021-03-11"
        mm(2025,04), "2025-04-01"
        qq(2021,3), "2021-07-01"
        hh(2050,2), "2050-07-01"
        yy(1990), "1990-01-01"
    };
    for j = transpose(test)
        assertEqual(testCase, dater.toString(j{1}, "yyyy-mm-dd"), j{2});
    end


