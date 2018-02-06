function tests = windexTest( )
tests = functiontests(localfunctions);
end


function setupOnce(this)
start = qq(2000,1);
x = randn(10, 3);
w = rand(10, 2)/2;
v = rand(10, 3);
xx = Series(start, x);
ww = Series(start, w);
vv = Series(start, v);
this.TestData.x = x;
this.TestData.xx = xx;
this.TestData.w = w;
this.TestData.ww = ww;
this.TestData.v = v;
this.TestData.vv = vv;
this.TestData.Start = start;
end


function testPlain(this)
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;

    [yy, ww2] = windex(xx, ww);
    [y, w2] = numeric.windex(x, w);
    y3 = sum(x .* w2, 2);
    assertEqual(this, yy.Data, y, 'AbsTol', 1e-14);
    assertEqual(this, y3, y, 'AbsTol', 1e-14);
    assertEqual(this, sum(ww2.Data, 2), ones(size(ww2.Data, 1), 1), 'AbsTol', 1e-14);
end


function testPlainLog(this)
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    expX = exp(xx);

    yy1 = windex(xx, ww);
    y2 = windex(expX, ww, 'Log=', true);
    assertEqual(this, exp(yy1.Data), y2.Data, 'AbsTol', 1e-14);
end


function testPlainWeights(this)
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w(1, :);

    yy1 = windex(xx, w);
    y2 = numeric.windex(x, w);
    y3 = windex(xx, repmat(w, size(yy1.Data, 1), 1));
    assertEqual(this, yy1.Data, y2, 'AbsTol', 1e-14);
    assertEqual(this, y3.Data, y2, 'AbsTol', 1e-14);
end


function testPlainNormalize(this)
    x = this.TestData.x;
    xx = this.TestData.xx;
    v = this.TestData.v;
    vv = this.TestData.vv;

    [yy1, vv1] = windex(xx, vv);
    [y2, v2] = numeric.windex(x, v);
    assertEqual(this, sum(v2, 2), ones(size(y2, 1), 1), 'AbsTol', 1e-14);
    assertEqual(this, yy1.Data, y2, 'AbsTol', 1e-14);
    assertEqual(this, vv1.Data, v2, 'AbsTol', 1e-14);
end


function testPlainRange(this)
    start = this.TestData.Start;
    xx = this.TestData.xx;
    ww = this.TestData.ww;

    [yy1, ww1] = windex(xx, ww);
    [yy2, ww2] = windex(xx, ww, start+(2:9)-1);
    [yy3, ww3] = windex(xx, ww, start+(1:11)-1);
    assertEqual(this, yy1.Data(2:9, :), yy2.Data, 'AbsTol', 1e-14);
    assertEqual(this, yy1.Data, yy3.Data, 'AbsTol', 1e-14);
end


function testDivisia(this)
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    expX = exp(x);
    expXx = exp(xx);

    [yy1, ww1] = windex(expXx, ww, 'Method=', 'Divisia');
    y2 = numeric.windex(expX, w, 'Method=', 'Divisia');
    assertEqual(this, size(y2), [size(x, 1), 1]);
    assertEqual(this, yy1.Data, y2, 'AbsTol', 1e-14);
    diffLogY2 = diff(log(y2), 1, 1);
    diffX = diff(x, 1, 1);
    assertGreaterThan(this, diffLogY2, min(diffX, [ ], 2));
    assertLessThan(this, diffLogY2, max(diffX, [ ], 2));
end


