function Tests = dbOperationsTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>

function setupOnce(this)
% data
rng1 = qq(2000, 1) : qq(2015, 4);
rng1_cl = rng1(4:end-4);
db1 = struct();
db1.x_su = hpf2(cumsum(tseries(rng1, @randn)));
db1.y_su = hpf2(cumsum(tseries(rng1, @randn)));
db1.z_su = hpf2(cumsum(tseries(rng1, @randn)));
db1.a = [5 6];
db1.b = 'KKK';
db1.c_su = 'BBB';
db1_cl = db1;
db1_cl.x_su = db1.x_su{rng1_cl};
db1_cl.y_su = db1.y_su{rng1_cl};
db1_cl.z_su = db1.z_su{rng1_cl};
db1_and = struct();
db1_and.x_su = [db1.x_su,db1_cl.x_su];
db1_and.y_su = [db1.y_su,db1_cl.y_su];
db1_and.z_su = [db1.z_su,db1_cl.z_su];
db1_and.a = [db1.a,db1_cl.a];
db1_and.b = [db1.b,db1_cl.b];
db1_and.c_su = [db1.c_su,db1_cl.c_su];
db2 = struct();
db2.x_sa = x12(db1.x_su);
db2.y_sa = x12(db1.y_su);
db2.z_sa = x12(db1.z_su);
db2_big = db1;
db2_big.x_sa = x12(db1.x_su);
db2_big.y_sa = x12(db1.y_su);
db2_big.z_sa = x12(db1.z_su);
this.TestData.rng1 = rng1;
this.TestData.rng1_cl = rng1_cl;
this.TestData.db1 = db1;
this.TestData.db1_cl = db1_cl;
this.TestData.db1_and = db1_and;
this.TestData.db2 = db2;
this.TestData.db2_big = db2_big;
end

function testDbBatch(this)
db = this.TestData.db1;
% fresh dbbatch
expDb1 = this.TestData.db2;
actDb1 = dbbatch(db, '$1_sa', 'x12(db.$0)', ...
  'nameFilter=', '(.*)_su', ...
  'classFilter=', 'tseries', ...
  'fresh=', true);
% non-fresh dbbatch is default
expDb2 = this.TestData.db2_big;
actDb2 = dbbatch(db, '$1_sa', 'x12(db.$0)', ...
  'nameFilter=', '(.*)_su', ...
  'classFilter=', 'tseries');
assertEqual(this,actDb1,expDb1);
assertEqual(this,actDb2,expDb2);
end

function testDbClip(this)
db = this.TestData.db1;
rng1_cl = this.TestData.rng1_cl;
expDb = this.TestData.db1_cl;
actDb = dbclip(db,rng1_cl);
assertEqual(this,actDb,expDb);
end

function testDbAndOperator(this)
db1 = this.TestData.db1;
db1_cl = this.TestData.db1_cl;
expDb = this.TestData.db1_and;
actDb = db1 & db1_cl;
assertEqual(this,actDb,expDb);
end

function testDbCol(this)
db1 = this.TestData.db1;
db1_cl = this.TestData.db1_cl;
dbExp1 = rmfield(db1,{'b','c_su'});
dbExp1.a = dbExp1.a(1);
dbExp2 = rmfield(db1_cl,{'b','c_su'});
dbExp2.a = dbExp2.a(2);
db1_and = this.TestData.db1_and;
assertEqual(this,dbcol(db1_and,1),dbExp1);
assertEqual(this,dbcol(db1_and,2),dbExp2);
end

function testDbMerge(this)
db1 = this.TestData.db1;
db1_cl = this.TestData.db1_cl;
db2 = this.TestData.db2;
db2_big = this.TestData.db2_big;
assertEqual(this,dbmerge(db1,db1_cl),db1_cl);
assertEqual(this,dbmerge(db1_cl,db1),db1);
assertEqual(this,dbmerge(db1,db2),db2_big);
end

function testDbOverlay(this)
db1 = this.TestData.db1;
db2 = this.TestData.db2;
db1_cl = this.TestData.db1_cl;
rng1 = this.TestData.rng1;
rng1_cl = this.TestData.rng1_cl;
rng1_ext = setdiff(rng1,rng1_cl);

% prepare some data
db2t = db2;
db2t.x_su = db2t.x_sa;
db2t.y_su = db2t.y_sa;
db2t.z_su = db2t.z_sa;
db2t = rmfield(db2t,{'x_sa','y_sa','z_sa'});
db1_clt = rmfield(db1_cl,{'a','b','c_su'});
db1_clt2 = db1_clt;
db1_clt2.x_su(rng1_ext) = db2t.x_su(rng1_ext);
db1_clt2.y_su(rng1_ext) = db2t.y_su(rng1_ext);
db1_clt2.z_su(rng1_ext) = db2t.z_su(rng1_ext);

% If some of the observations overlap the observations from the second
% tseries are used.
assertEqual(this,dboverlay(db1_clt,db2t),db2t);
assertEqual(this,dboverlay(db2t,db1_clt),db1_clt2);

% If a non-empty tseries is combined with an empty tseries, the non-empty
% one is used.
db2t.x_su = tseries();
dbExp = db2t;
dbExp.x_su = db1_clt.x_su;
assertEqual(this,dboverlay(db1_clt,db2t),dbExp);

% If two objects are combined of which at least one is a non-tseries
% object, the second input object is used.
db1t = db1;
db1t.c_su = tseries(rng1,@randn);
assertEqual(this,dboverlay(db1,db1t),db1t);
assertEqual(this,dboverlay(db1t,db1),db1);
end
