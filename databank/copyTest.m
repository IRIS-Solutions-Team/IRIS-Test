
% Set Up Once
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
ds = struct('a', 1, 'b', 2, 'c', 3, 'd', 4);
dd = Dictionary( );
store(dd, 'a', 1, 'b', 2, 'c', 3, 'd', 4);
this.TestData.ds = ds;
this.TestData.dd = dd;


%% Test One Input

ds = this.TestData.ds;
dd = copy(this.TestData.dd);

ds1 = databank.copy(ds);
assertEqual(this, ds, ds1);

dd1 = databank.copy(dd);
assertEqual(this, dd, dd1);
dd.a = 100;
assertNotEqual(this, dd, dd1);


%% Test @all

ds = this.TestData.ds;
dd = copy(this.TestData.dd);

ds1 = databank.copy(ds, 'SourceNames', @all);
assertEqual(this, ds, ds1);

dd1 = databank.copy(dd, 'SourceNames', @all);
assertEqual(this, dd, dd1);
dd.a = 100;
assertNotEqual(this, dd, dd1);


%% Test sourceNames

ds = this.TestData.ds;
dd = copy(this.TestData.dd);

sourceNames = {'a', 'b'};
ds1 = databank.copy(ds, 'SourceNames', sourceNames);
assertEqual(this, rmfield(ds, {'c', 'd'}), ds1);

dd1 = databank.copy(dd, 'SourceNames', sourceNames);
assertEqual(this, remove(copy(dd), ["c", "d"]), dd1);
dd.a = 100;
assertNotEqual(this, remove(copy(dd), ["c", "d"]), dd1);


%% Test targetNames

ds = this.TestData.ds;
dd = copy(this.TestData.dd);

sourceNames = {'a', 'b'};
ds1 = databank.copy(ds, 'SourceNames', sourceNames, 'TargetDb', @empty, 'TargetNames', {'AA', 'BB'});
exp = struct('AA', ds.a, 'BB', ds.b);
assertEqual(this, exp, ds1);

dd1 = databank.copy(dd, 'SourceNames', sourceNames, 'TargetDb', @empty, 'TargetNames', {'AA', 'BB'});
dd1 = databank.copy(dd, 'SourceNames', sourceNames, 'TargetDb', @empty, 'TargetNames', ["AA", "BB"]);
exp = Dictionary( );
store(exp, 'AA', dd.a, 'BB', dd.b);
exp = Dictionary( );
store(exp, "AA", dd.a, "BB", dd.b);
assertEqual(this, exp, dd1);
dd.a = 100;
assertEqual(this, exp, dd1);

