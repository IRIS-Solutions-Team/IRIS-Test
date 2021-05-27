% saveAs=databank/extractSeriesDataUnitTest.m

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


% Set up once

db = struct();
db.x = Series();
db.y = Series(qq(2020,1), rand(20,1));
db.z = Series(qq(2020,1), rand(20,2));


%% Specify names and dates 

data = databank.backend.extractSeriesData(db, ["x", "y", "z"], qq(2020,1:4));
assertEqual(this, size(data{1}), [4, 1]);
assertEqual(this, isnan(data{1}), true(4, 1));
assertEqual(this, size(data{2}), [4, 1]);
assertEqual(this, size(data{3}), [4, 2]);


%% All dates, specify names 

data = databank.backend.extractSeriesData(db, ["x", "y", "z"], Inf);
assertEqual(this, size(data{1}), [20, 1]);
assertEqual(this, isnan(data{1}), true(20, 1));
assertEqual(this, size(data{2}), [20, 1]);
assertEqual(this, size(data{3}), [20, 2]);


%% All dates, all names 

data = databank.backend.extractSeriesData(db, @all, Inf);
assertEqual(this, size(data{1}), [20, 1]);
assertEqual(this, isnan(data{1}), true(20, 1));
assertEqual(this, size(data{2}), [20, 1]);
assertEqual(this, size(data{3}), [20, 2]);
