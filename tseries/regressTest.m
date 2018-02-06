function tests = regressTest( )
tests = functiontests(localfunctions);
end


function setupOnce(this)
    start = qq(2000,1);
    y = randn(20, 1);
    x = randn(20, 3);
    w = rand(20, 1);
    xx = Series(start, x);
    yy = Series(start, y);
    ww = Series(start, w);
    this.TestData.x = x;
    this.TestData.xx = xx;
    this.TestData.w = w;
    this.TestData.ww = ww;
    this.TestData.y = y;
    this.TestData.yy = yy;
    this.TestData.Start = start;
end


function testPlain(this)
    y = this.TestData.y;
    yy = this.TestData.yy;
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    range = yy.Range;

    [b1, stdB1, e1, stdE1, fit1, dates1, covB1] = regress(yy, xx);
    b2 = xx.Data \ yy.Data;
    [b3, stdB3, e3, stdE3, fit3, dates3, covB3] = regress(yy, xx, range);
    assertEqual(this, b1, b2, 'AbsTol', 1e-14);
    assertEqual(this, fit1.Data+e1.Data, yy.Data, 'AbsTol', 1e-14);
    assertEqual(this, double(dates1), double(qq(2000,1:20)'), 'AbsTol', 1e-14);
    assertEqual(this, b1, b3, 'AbsTol', 1e-14);
end


function testRange(this)
    y = this.TestData.y;
    yy = this.TestData.yy;
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    range = yy.Range;

    pos = 1 : 2 : 20;
    [b1, stdB1, e1, stdE1, fit1, dates1, covB1] = regress(yy, xx, range(pos));
    b2 = xx.Data(pos, :) \ yy.Data(pos, :);
    assertEqual(this, double(dates1), double(range(pos)), 'AbsTol', 1e-14);
    assertEqual(this, b1, b2, 'AbsTol', 1e-14);
    assertEqual(this, fit1(dates1, :)+e1(dates1, :), yy(dates1, :), 'AbsTol', 1e-14);
    assertEqual(this, double(dates1), double(range(pos)), 'AbsTol', 1e-14);
end


function testRangeIntercept(this)
    y = this.TestData.y;
    yy = this.TestData.yy;
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    range = yy.Range;

    pos = 1 : 2 : 20;
    [b1, stdB1, e1, stdE1, fit1, dates1, covB1] = regress(yy, xx, range(pos), 'Intercept', true);
    b2 = [xx.Data(pos, :), ones(numel(pos), 1)] \ yy.Data(pos, :);
    [b3, stdB3, e3, stdE3, fit3, dates3, covB3] = regress(yy, xx, range(pos), 'Constant', true);
    assertEqual(this, b1, b2, 'AbsTol', 1e-14);
    assertEqual(this, fit1(dates1, :)+e1(dates1, :), yy(dates1, :), 'AbsTol', 1e-14);
    assertEqual(this, double(dates1), double(range(pos)), 'AbsTol', 1e-14);
    assertEqual(this, b1, b3, 'AbsTol', 1e-14);
end


function testWeights(this)
    y = this.TestData.y;
    yy = this.TestData.yy;
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;

    [b1, stdB1, e1, stdE1, fit1, dates1, covB1] = regress(yy, xx, Inf, 'Intercept', true, 'Weights', ww);
    b2 = lscov([x, ones(size(y, 1), 1)], y, w);
    assertEqual(this, b1, b2, 'AbsTol', 1e-14);
    assertEqual(this, fit1.Data+e1.Data, yy.Data, 'AbsTol', 1e-14);
end


function testWeightsRange(this)
    y = this.TestData.y;
    yy = this.TestData.yy;
    x = this.TestData.x;
    xx = this.TestData.xx;
    w = this.TestData.w;
    ww = this.TestData.ww;
    range = yy.Range;
    start = yy.Start;
    pos = 1 : 2 : 30;
    pos1 = pos(pos<=20);

    [b1, stdB1, e1, stdE1, fit1, dates1, covB1] = regress(yy, xx, start+(pos-1), 'Intercept', true, 'Weights', ww);
    b2 = lscov([x(pos1, :), ones(numel(pos1), 1)], y(pos1, :), w(pos1, :));
    assertEqual(this, b1, b2, 'AbsTol', 1e-14);
    assertEqual(this, fit1.Data(pos1, :)+e1.Data(pos1, :), yy.Data(pos1, :), 'AbsTol', 1e-14);
end


