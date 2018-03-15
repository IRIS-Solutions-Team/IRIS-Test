function tests = db2arrayTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


function testArray2dbMoreVars(this)
% More variables than dates.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
expDb = struct( );
expDb.a = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.b = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.c = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl);
assertEqual(this, actDb, expDb);
end % testArray2dbMoreVars( )


function testArray2dbMoreVarsComments(this)
% More variables than dates.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
expDb = struct( );
expDb.a = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.b = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.c = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl, 'Comments=', {'aa', 'bb', 'cc'});
assertEqual(this, comment(actDb.a), repmat({'aa'}, 1, 2, 3, 5));
assertEqual(this, comment(actDb.b), repmat({'bb'}, 1, 2, 3, 5));
assertEqual(this, comment(actDb.c), repmat({'cc'}, 1, 2, 3, 5));
assertEqual(this, comment(actDb.x), repmat({TimeSubscriptable.EMPTY_COMMENT}, 1, 2, 3, 5));
assertEqual(this, comment(actDb.y), repmat({TimeSubscriptable.EMPTY_COMMENT}, 1, 2, 3, 5));
assertEqual(this, comment(actDb.z), repmat({TimeSubscriptable.EMPTY_COMMENT}, 1, 2, 3, 5));
end % testArray2dbMoreVars( )


function testArray2dbMoreDates(this)
% More dates than variables.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
expDb = struct( );
expDb.x = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(1:4, rand(4, 2, 3, 5));
[x, incl, rng] = db2array(expDb);
actDb = array2db(x, rng, incl);
assertEqual(this, actDb, expDb);
end % testArray2dbMoreDates( )


function testArray2dbNotRange(this)
% Dates are not continuous range.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
rng = qq(2000, [1, 10, 7, 6]);
expDb = struct( );
expDb.x = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expDb.y = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expDb.z = TIME_SERIES_CONSTRUCTOR(rng, rand(4, 2, 3, 5));
expRng = min(rng) : max(rng);
[x, incl, actRng] = db2array(expDb);
assertEqual(this, actRng, expRng);
actDb = array2db(x, expRng, incl);
assertEqual(this, actDb, expDb);
end % testArray2dbNotRange( )


function testArray2dbHiDim(this)
% Higher dimensions equal in all tseries.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
rng = mm(2000, 1:10);
nPer = length(rng);
db = struct( );
db.x = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
db.y = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
db.z = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 5));
x = rangedata(db.x, rng);
x = permute(x, [1, 5, 2, 3, 4]);
y = rangedata(db.y, rng);
y = permute(y, [1, 5, 2, 3, 4]);
z = rangedata(db.z, rng);
z = permute(z, [1, 5, 2, 3, 4]);
expArr = [x, y, z];
actArr = db2array(db);
actSize = size(actArr);
expSize = [length(rng), 3, 1, 1, 5];
assertEqual(this, actSize, expSize);
assertEqual(this, actArr, expArr);
end % testArray2dbHiDim( )


function testArray2dbHiDimMissing(this)
% Higher dimensions missing in some tseries.
TIME_SERIES_CONSTRUCTOR = getappdata(0, 'IRIS_TimeSeriesConstructor');
rng = yy(2000):yy(2005);
nPer = length(rng);
db = struct( );
db.x = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1, 1, 2));
db.y = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1));
db.z = TIME_SERIES_CONSTRUCTOR(rng, rand(nPer, 1));

x = rangedata(db.x, rng);
x = squeeze(x);
x = permute(x, [1, 3, 2]);

y = rangedata(db.y);
y = cat(3, y, y);

z = rangedata(db.z);
z = cat(3, z, z);

expArr = [x, y, z];
actArr = db2array(db);
assertEqual(this, actArr, expArr);

expArr = [y, z, x];
actArr = db2array(db, {'y', 'z', 'x'});
assertEqual(this, actArr, expArr);

expArr = [y, z, x];
actArr = db2array(db, {'y', 'z', 'x'}, rng);
assertEqual(this, actArr, expArr);
end % testArray2dbHiDimMissin( )
