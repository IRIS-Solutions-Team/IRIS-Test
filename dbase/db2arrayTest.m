function Tests = db2arrayTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


%**************************************************************************


function testArray2dbMoreVars(This)
% More variables than dates.
expDb = struct();
expDb.a = tseries(1:4,rand(4,2,3,5));
expDb.b = tseries(1:4,rand(4,2,3,5));
expDb.c = tseries(1:4,rand(4,2,3,5));
expDb.x = tseries(1:4,rand(4,2,3,5));
expDb.y = tseries(1:4,rand(4,2,3,5));
expDb.z = tseries(1:4,rand(4,2,3,5));
[x,incl,rng] = db2array(expDb);
actDb = array2db(x,rng,incl);
assertEqual(This,actDb,expDb);
end % testArray2dbMoreVars()


%**************************************************************************


function testArray2dbMoreDates(This)
% More dates than variables.
expDb = struct();
expDb.x = tseries(1:4,rand(4,2,3,5));
expDb.y = tseries(1:4,rand(4,2,3,5));
expDb.z = tseries(1:4,rand(4,2,3,5));
[x,incl,rng] = db2array(expDb);
actDb = array2db(x,rng,incl);
assertEqual(This,actDb,expDb);
end % testArray2dbMoreDates()


%**************************************************************************


function testArray2dbNotRange(This)
% Dates are not continuous range.
rng = qq(2000,[1,10,7,6]);
expDb = struct();
expDb.x = tseries(rng,rand(4,2,3,5));
expDb.y = tseries(rng,rand(4,2,3,5));
expDb.z = tseries(rng,rand(4,2,3,5));
expRng = min(rng) : max(rng);
[x,incl,actRng] = db2array(expDb);
assertEqual(This,actRng,expRng);
actDb = array2db(x,expRng,incl);
assertEqual(This,actDb,expDb);
end % testArray2dbNotRange()


%**************************************************************************


function testArray2dbHiDim(This)
% Higher dimensions equal in all tseries.
rng = mm(2000,1:10);
nPer = length(rng);
db = struct();
db.x = tseries(rng,rand(nPer,1,1,5));
db.y = tseries(rng,rand(nPer,1,1,5));
db.z = tseries(rng,rand(nPer,1,1,5));

x = rangedata(db.x,rng);
x = permute(x,[1,5,2,3,4]);
y = rangedata(db.y,rng);
y = permute(y,[1,5,2,3,4]);
z = rangedata(db.z,rng);
z = permute(z,[1,5,2,3,4]);

expArr = [x,y,z];
actArr = db2array(db);
actSize = size(actArr);
expSize = [length(rng),3,1,1,5];
assertEqual(This,actSize,expSize);
assertEqual(This,actArr,expArr);
end % testArray2dbHiDim()


%**************************************************************************


function testArray2dbHiDimMissing(This)
% Higher dimensions missing in some tseries.
rng = yy(2000):yy(2005);
nPer = length(rng);
db = struct();
db.x = tseries(rng,rand(nPer,1,1,2));
db.y = tseries(rng,rand(nPer,1));
db.z = tseries(rng,rand(nPer,1));

x = rangedata(db.x,rng);
x = squeeze(x);
x = permute(x,[1,3,2]);

y = rangedata(db.y);
y = cat(3,y,y);

z = rangedata(db.z);
z = cat(3,z,z);

expArr = [x,y,z];
actArr = db2array(db);
assertEqual(This,actArr,expArr);

expArr = [y,z,x];
actArr = db2array(db,{'y','z','x'});
assertEqual(This,actArr,expArr);

expArr = [y,z,x];
actArr = db2array(db,{'y','z','x'},rng);
assertEqual(This,actArr,expArr);
end % testArray2dbHiDimMissin()
