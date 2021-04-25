
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
close all
testCase.TestData.Visible = 'off';


%% Test Both Inf

if ~verLessThan('matlab', '9.1')
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, Inf, {'x', 'y'}, 'Figure', {'Visible', testCase.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(testCase, xLim1(1), datetime(qq(2000,1)));
    assertEqual(testCase, xLim1(2), datetime(qq(2009,'end')));
    assertEqual(testCase, xLim2(1), datetime(mm(2000,1)));
    assertEqual(testCase, xLim2(2), datetime(mm(2009,'end')));
    close all
end


%% Test One Range

if ~verLessThan('matlab', '9.1')
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, qq(2001,1:8), {'x', 'y'}, 'Figure', {'Visible', testCase.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(testCase, xLim1(1), datetime(qq(2001,1)));
    assertEqual(testCase, xLim1(2), datetime(qq(2002,'end')));
    assertEqual(testCase, xLim2(1), datetime(mm(2000,1)));
    assertEqual(testCase, xLim2(2), datetime(mm(2009,'end')));
    close all
end


%% Test Both Range

if ~verLessThan('matlab', '9.1')
    d = struct( );
    d.x = Series(qq(2000,1), randn(40, 4));
    d.y = Series(mm(2000,1), randn(120, 4));
    [ff, aa] = dbplot(d, {qq(2001,1:8), mm(2001,1:12)}, {'x', 'y'}, 'Figure', {'Visible', testCase.TestData.Visible});
    xLim1 = get(aa{1}(1), 'XLim');
    xLim2 = get(aa{1}(2), 'XLim');
    assertEqual(testCase, xLim1(1), datetime(qq(2001,1)));
    assertEqual(testCase, xLim1(2), datetime(qq(2002,'end')));
    assertEqual(testCase, xLim2(1), datetime(mm(2001,1)));
    assertEqual(testCase, xLim2(2), datetime(mm(2001,'end')));
    close all
end

