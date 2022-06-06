
clear
assertEqual = @(x, y) assert(isequaln(x, y));
assertEqualTol = @(x, y, tol) assert(all(size(x)==size(y)) && all(abs(x(:) - y(:))<1e-12));

%% Test Save Weekly Series 

rng(0);

ac = struct( );
ac.x = Series(ww(2000,1):ww(2010, 'end'), @rand);
ac.x = round(100*ac.x, 2);
databank.toCSV(ac,'testSaveLoad1.csv');
ex = databank.fromCSV('testSaveLoad1.csv');
assertEqualTol(ac.x(:), ex.x(:));


%% Test Save Weekly Series with User Date Format 

rng(0);

ac = struct( );
ac.x = Series(ww(2000,1):ww(2010, 'end'), @rand);
ac.x = round(100*ac.x, 2);
dateFormat = '$YYYY-MM-DD';
databank.toCSV(ac,'testSaveLoad2.csv', Inf, ...
    'DateFormat', dateFormat);
ex = databank.fromCSV('testSaveLoad2.csv', ...
    'DateFormat', dateFormat, 'Freq', 52);
assertEqualTol(ac.x(:), ex.x(:));

%% Test Save Numeric Array Only 

rng(0);

ac = struct( );
ac.x = rand(10, 3, 4);
ac.x = round(100*ac.x, 2);
databank.toCSV(ac, 'testSaveLoad3.csv');
ex = databank.fromCSV('testSaveLoad3.csv');
assertEqualTol(ac.x, ex.x);

%% Test Save Weekly Series and Numeric Array 

rng(0);

ac = struct( );
ac.x = Series(ww(2000,1):ww(2010, 'end'), @rand);
ac.x = round(100*ac.x, 2);
ac.y = rand(10, 3, 4);
ac.y = round(100*ac.x, 2);
databank.toCSV(ac, 'testSaveLoad4.csv');
ex = databank.fromCSV('testSaveLoad4.csv');
assertEqualTol(ac.x, ex.x);
assertEqualTol(ac.y, ex.y);


%% Test Select 

rng(0);

range = qq(2000,1):qq(2010,4);

ac = struct( );
ac.x = tseries(range, @rand);
ac.x = round(100*ac.x, 2);
ac.y = tseries(range, @rand);
ac.y = round(100*ac.y, 2);
ac.z = tseries(range, @rand);
ac.z = round(100*ac.z, 2);
databank.toCSV(ac, 'testSaveLoad5.csv');

ac = rmfield(ac, 'x');
ex = databank.fromCSV('testSaveLoad5.csv', 'Select', {'y', 'z'});
assertEqual(sort(fieldnames(ac)), sort(fieldnames(ex)));


%% Test Missing Observations 

ac = databank.fromCSV('testMissingObs.csv');
ac1 = databank.fromCSV("testMissingObs.csv");
range = qq(2000,1) : qq(2000,4);
ex = struct( );
ex.x = Series(range, [1; 2; NaN; NaN]);
ex.y = Series(range, [10+10i; NaN+NaN*1i; 30; NaN+0i]);
ex.z = Series(range, [100; NaN; 300; 400]);
assertEqual(ac.x(:), ex.x(:));
assertEqual(ac.y(:), ex.y(:));
assertEqual(ac.z(:), ex.z(:));


%% Test Daily Series 

d = databank.fromCSV('testDailyCsv.csv', ...
    'dateFormat', '$M/D/YYYY', ...
    'freq', 365);
ac = db2array(d, {'A', 'B', 'C', 'D'});
ac(isnan(ac)) = 0;
ex = csvread('testDailyCsv.csv', 1, 1);
assertEqualTol(ac, ex);

