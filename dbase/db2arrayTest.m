% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test More Variables Than Dates

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
expDb = struct( );
expDb.a = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.b = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.c = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl);
assertEqual(testCase, actDb, expDb);


%% Test More Variables Than Dates with Comments

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
expDb = struct( );
expDb.a = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.b = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.c = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl, 'Comments', {'aa', 'bb', 'cc'});
assertEqual(testCase, comment(actDb.a), repmat("aa", 1, 2, 3, 5));
assertEqual(testCase, comment(actDb.b), repmat("bb", 1, 2, 3, 5));
assertEqual(testCase, comment(actDb.c), repmat("cc", 1, 2, 3, 5));
assertEqual(testCase, comment(actDb.x), repmat("", 1, 2, 3, 5));
assertEqual(testCase, comment(actDb.y), repmat("", 1, 2, 3, 5));
assertEqual(testCase, comment(actDb.z), repmat("", 1, 2, 3, 5));


%% Test More Dates Than Variables

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
expDb = struct( );
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl);
assertEqual(testCase, actDb, expDb);


%% Test Dates Not Continuous

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
rng = qq(2000, [1, 10, 7, 6]);
expDb = struct( );
expDb.x = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expRng = min(rng) : max(rng);
[x, incl, actRng] = db2array(expDb);
assertEqual(testCase, actRng, expRng);
actDb = array2db(x, expRng, incl);
assertEqual(testCase, actDb, expDb);


%% Test Higher Dims Equal in All Series

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
rng = mm(2000, 1:10);
nPer = length(rng);
db = struct( );
db.x = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
db.y = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
db.z = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
x = getDataFromTo(db.x, rng);
x = permute(x, [1, 5, 2, 3, 4]);
y = getDataFromTo(db.y, rng);
y = permute(y, [1, 5, 2, 3, 4]);
z = getDataFromTo(db.z, rng);
z = permute(z, [1, 5, 2, 3, 4]);
expArr = [x, y, z];
actArr = db2array(db);
actSize = size(actArr);
expSize = [length(rng), 3, 1, 1, 5];
assertEqual(testCase, actSize, expSize);
assertEqual(testCase, actArr, expArr);


%% Test Higher Dims Missing in some Series

TIME_SERIES_CONSTRUCTOR = iris.get('DefaultTimeSeriesConstructor');
rng = yy(2000):yy(2005);
nPer = length(rng);
db = struct( );
db.x = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 2));
db.y = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1));
db.z = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1));

x = getDataFromTo(db.x, rng);
x = squeeze(x);
x = permute(x, [1, 3, 2]);

y = getDataFromTo(db.y, Inf);
y = cat(3, y, y);

z = getDataFromTo(db.z, Inf);
z = cat(3, z, z);

expArr = [x, y, z];
actArr = db2array(db);
assertEqual(testCase, actArr, expArr);

expArr = [y, z, x];
actArr = db2array(db, {'y', 'z', 'x'});
assertEqual(testCase, actArr, expArr);

expArr = [y, z, x];
actArr = db2array(db, {'y', 'z', 'x'}, rng);
assertEqual(testCase, actArr, expArr);

