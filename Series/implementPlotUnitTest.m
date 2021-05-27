% saveAs=Series/implementPlotUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test empty with no range

x = Series(qq(2020,1), rand(40,2));
y = Series();

figureHandle = figure("visible", false);
plot(x);
hold on
plot(y);
a = gca();
assertEqual(testCase, numel(a.Children), 2);
close(figureHandle);


%% Test empty with range

x = Series(qq(2020,1), rand(40,2));
y = Series();

figureHandle = figure("visible", false);
plot(x);
hold on
plot(x.Range, y);
a = gca();
assertEqual(testCase, numel(a.Children), 3);
close(figureHandle);
