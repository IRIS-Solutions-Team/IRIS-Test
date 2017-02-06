function Tests = steadyRefTest()
Tests = functiontests( localfunctions );
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('steadyRefTest.model', 'linear=', true);
m.lx = 0;
m.gy = 0.1;
m = solve(m);
m = sstate(m);
this.TestData.Model = m;
end




function testSingleParamModel(this)
m = this.TestData.Model;
r = get(m, 'Reporting');
dm = reporting(m, [ ], 1:5);
dr = run(r, [ ], 1:5, m);
assertEqual(this, dm.X(:), dr.X(:));
assertEqual(this, dm.Y(:), dr.Y(:));
assertEqual(this, dm.Z(:), dr.Z(:));
end




function testMultiParamModel(this)
m = this.TestData.Model;
m = alter(m, 3);
m.lx = [0, 1, 2];
m.gy = [0.1, 0.2, -0.1];
m = solve(m);
m = sstate(m);
r = get(m, 'Reporting');
dm = reporting(m, [ ], 1:5);
dr = run(r, [ ], 1:5, m);
assertEqual(this, dm.X(:), dr.X(:));
assertEqual(this, dm.Y(:), dr.Y(:));
assertEqual(this, dm.Z(:), dr.Z(:));
end




function testTimeShift(this)
m = this.TestData.Model;
d1 = reporting(m, [ ], 1:5);
d2 = reporting(m, [ ], 2:6);
assertEqual(this, d2.Y(:)-d1.Y(:), repmat(m.gy, 5, 1), 'AbsTol', 1e-15);
end