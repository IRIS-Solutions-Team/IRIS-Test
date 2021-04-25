% saveAs=NamedMatrix/subsrefTest.m

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
dataX = rand(3, 5);
x = namedmat(dataX, ["a", "b", "c"], compose("Col%g", 1:5));
dataY = rand(3, 5, 4, 8);
y = namedmat(dataY, ["aa", "bb", "cc"], compose("CCol%g", 1:5));

%% Test Two Dimensions

assertSize(this, x("a"), [1, 5]);
assertSize(this, x("a", :), [1, 5]);
assertSize(this, x("a", ["Col1", "Col3"]), [1, 2]);

%% Test Higher Dimensions

assertSize(this, y("aa"), [1, 5, 4, 8]);
assertSize(this, y("aa", :), [1, 5, 4, 8]);
assertSize(this, y("aa", ["CCol1", "CCol3"]), [1, 2, 4, 8]);

%% Test Dot Reference

assertEqual(this, x.RowNames, ["a", "b", "c"]);
assertEqual(this, x.ColumnNames, compose("Col%g", 1:5));
