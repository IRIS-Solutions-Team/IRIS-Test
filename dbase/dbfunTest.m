
% Set Up Once
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
d1 = struct( );
d1.a = [1,2,3];
d1.a_u  = [10,20,30];
d1.b = 'abcd';
d1.b_u = 'ABCD';
d1.c = tseries(1:10,1);
d1.c_u = tseries(1:10,10);
this.TestData.Dbase1 = d1;

d2 = d1;
d2.sub1 = d1;
d2.sub2 = d1;
this.TestData.Dbase2 = d2;


%% Test Name Filter

d = this.TestData.Dbase1;

fn = @(x) x*2;

actDb1 = dbfun(fn,d);
expDb1 = d;
expDb1.a = fn(d.a);
expDb1.a_u = fn(d.a_u);
expDb1.b = fn(d.b);
expDb1.b_u = fn(d.b_u);
expDb1.c = fn(d.c);
expDb1.c_u = fn(d.c_u);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d,'nameFilter',{'a','b','c'});
expDb2 = d;
expDb2.a = fn(d.a);
expDb2.b = fn(d.b);
expDb2.c = fn(d.c);
assertEqual(this,actDb2,expDb2);

actDb3 = dbfun(fn,d,'nameFilter',rexp('a.*|b.*'));
expDb3 = d;
expDb3.a = fn(d.a);
expDb3.a_u = fn(d.a_u);
expDb3.b = fn(d.b);
expDb3.b_u = fn(d.b_u);
assertEqual(this,actDb3,expDb3);

actDb4 = dbfun(fn,d,'nameFilter',rexp('.*_u$'));
expDb4 = d;
expDb4.a_u = fn(d.a_u);
expDb4.b_u = fn(d.b_u);
expDb4.c_u = fn(d.c_u);
assertEqual(this,actDb4,expDb4);




%% Test Name Filter Fresh

d = this.TestData.Dbase1;
fn = @(x) x*2;

actDb1 = dbfun(fn,d,'nameFilter',{'a','b','c'},'fresh',true);
expDb1 = struct( );
expDb1.a = fn(d.a);
expDb1.b = fn(d.b);
expDb1.c = fn(d.c);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d,'nameFilter',rexp('a.*|b.*'),'fresh',true);
expDb2 = struct( );
expDb2.a = fn(d.a);
expDb2.a_u = fn(d.a_u);
expDb2.b = fn(d.b);
expDb2.b_u = fn(d.b_u);
assertEqual(this,actDb2,expDb2);

actDb3 = dbfun(fn,d,'nameFilter',rexp('.*_u$'),'fresh',true);
expDb3 = struct( );
expDb3.a_u = fn(d.a_u);
expDb3.b_u = fn(d.b_u);
expDb3.c_u = fn(d.c_u);
assertEqual(this,actDb3,expDb3);




%% Test Class Filter

d = this.TestData.Dbase1;
fn = @(x) x*2;

actDb1 = dbfun(fn,d,'classFilter',{'double','char'});
expDb1 = d;
expDb1.a = fn(d.a);
expDb1.a_u = fn(d.a_u);
expDb1.b = fn(d.b);
expDb1.b_u = fn(d.b_u);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d,'classFilter','tseries');
expDb2 = d;
expDb2.c = fn(d.c);
expDb2.c_u = fn(d.c_u);
assertEqual(this,actDb2,expDb2);

actDb3 = dbfun(fn,d,'classFilter',rexp('tseries|char'));
expDb3 = d;
expDb3.b = fn(d.b);
expDb3.b_u = fn(d.b_u);
expDb3.c = fn(d.c);
expDb3.c_u = fn(d.c_u);
assertEqual(this,actDb3,expDb3);




%% Test Class Filter Fresh

d = this.TestData.Dbase1;
fn = @(x) x*2;

actDb1 = dbfun(fn,d,'classFilter',{'double','char'},'fresh',true);
expDb1 = struct( );
expDb1.a = fn(d.a);
expDb1.a_u = fn(d.a_u);
expDb1.b = fn(d.b);
expDb1.b_u = fn(d.b_u);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d,'classFilter','tseries','fresh',true);
expDb2 = struct( );
expDb2.c = fn(d.c);
expDb2.c_u = fn(d.c_u);
assertEqual(this,actDb2,expDb2);

actDb3 = dbfun(fn,d,'classFilter',rexp('tseries|char'),'fresh',true);
expDb3 = struct( );
expDb3.b = fn(d.b);
expDb3.b_u = fn(d.b_u);
expDb3.c = fn(d.c);
expDb3.c_u = fn(d.c_u);
assertEqual(this,actDb3,expDb3);




%% Test Combined

d = this.TestData.Dbase1;
fn = @(x) x*2;

actDb1 = dbfun(fn,d, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'});
expDb1 = d;
expDb1.a = fn(d.a);
expDb1.b = fn(d.b);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d, ...
    'classFilter','tseries', ...
    'nameFilter',rexp('.*_u'));
expDb2 = d;
expDb2.c_u = fn(d.c_u);
assertEqual(this,actDb2,expDb2);




%% Test Combined Fresh

d = this.TestData.Dbase1;
fn = @(x) x*2;

actDb1 = dbfun(fn,d, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'}, ...
    'fresh',true);
expDb1 = struct( );
expDb1.a = fn(d.a);
expDb1.b = fn(d.b);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,d, ...
    'classFilter','tseries', ...
    'nameFilter',rexp('.*_u'), ...
    'fresh',true);
expDb2 = struct( );
expDb2.c_u = fn(d.c_u);
assertEqual(this,actDb2,expDb2);




%% Test Combined Nested Databanks

d = this.TestData.Dbase1;
dd = d;
dd.d1 = dbfun(@(x) x+1,d);
dd.d2 = dbfun(@(x) x+2,d);
fn = @(x) x*2;

actDb1 = dbfun(fn,dd, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'});
expDb1 = dd;
expDb1.a = fn(dd.a);
expDb1.b = fn(dd.b);
expDb1.d1.a = fn(dd.d1.a);
expDb1.d1.b = fn(dd.d1.b);
expDb1.d2.a = fn(dd.d2.a);
expDb1.d2.b = fn(dd.d2.b);
assertEqual(this,actDb1,expDb1);

actDb2 = dbfun(fn,dd, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'}, ...
    'recursive',false);
expDb2 = dd;
expDb2.a = fn(dd.a);
expDb2.b = fn(dd.b);
assertEqual(this,actDb2,expDb2);

actDb3 = dbfun(fn,dd, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'}, ...
    'recursive',false, ...
    'fresh',true);
expDb3 = struct( );
expDb3.a = fn(dd.a);
expDb3.b = fn(dd.b);
assertEqual(this,actDb3,expDb3);

actDb4 = dbfun(fn,dd, ...
    'classFilter',{'double','char'}, ...
    'nameFilter',{'a','b','c'}, ...
    'recursive',true, ...
    'fresh',true);
expDb4 = struct( );
expDb4.a = fn(dd.a);
expDb4.b = fn(dd.b);
expDb4.d1.a = fn(dd.d1.a);
expDb4.d1.b = fn(dd.d1.b);
expDb4.d2.a = fn(dd.d2.a);
expDb4.d2.b = fn(dd.d2.b);
assertEqual(this,actDb4,expDb4);





%% Test Error One

d = this.TestData.Dbase1;
fn = @(x) log(x);

q = warning('query');
warning('off', 'IrisToolbox:Dbase:DbfunReportError');
actDb1 = dbfun(fn,d);
warning(q);
expDb1 = d;
expDb1.a = fn(d.a);
expDb1.a_u = fn(d.a_u);
expDb1.c = fn(d.c);
expDb1.c_u = fn(d.c_u);
expDb1 = rmfield(expDb1,{'b','b_u'});
assertEqual(this, actDb1, expDb1);

q = warning('query');
warning('off', 'IrisToolbox:Dbase:DbfunReportError');
actDb2 = dbfun(fn,d,'ifError','nan');
warning(q);
expDb2 = d;
expDb2.a = fn(d.a); 
expDb2.a_u = fn(d.a_u);
expDb2.b = NaN; 
expDb2.b_u = NaN;
expDb2.c = fn(d.c);
expDb2.c_u = fn(d.c_u);
assertEqual(this, actDb2, expDb2);




%% Test Nested Databanks

d1 = this.TestData.Dbase1;
d2 = this.TestData.Dbase2;
fn = @(x) x*2;
d1 = dbfun(fn, d1);
d2 = dbfun(fn, d2);
assertEqual(this, d2.sub1, d1);
assertEqual(this, d2.sub2, d1);




%% Test Secondary Databank

d1 = this.TestData.Dbase1;
fn = @(x,y,z) [x, y, z];
actDb = dbfun(fn, d1, d1, d1);
expDb = struct( );
lsField = fieldnames(d1);
for i = 1 : length(lsField)
    expDb.(lsField{i}) = [ ...
        d1.(lsField{i}), d1.(lsField{i}), d1.(lsField{i}) ...
        ];
end
assertEqual(this, actDb, expDb);

