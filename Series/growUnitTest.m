% saveAs=Series/growUnitTest.m

% Set Up Once
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Grow Default Multiplicative
    x = Series(qq(2001,1):qq(2010,4), @rand);
    g = 1 + Series(qq(2005,1):qq(2020,4), @rand) / 10;
    y = grow(x, '*', g, g.Range);
    z = y / y{-1};
    assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
    assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
    assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow Default Additive

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 1 + Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, '+', g, g.Range);
z = y - y{-1};

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow with Shift=-4

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 1 + Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, '*', g, g.Range, -4);
y2 = grow(x, '*', g, g.Range, "shift", -4);
z = y / y{-4};

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);
assertEqual(this, y.Data, y2.Data);


%% Test Grow with Discrete Dates

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 1 + Series(qq(2005,1):qq(2010,4), @rand) / 10;

dates = qq(2005,1) : 3 : qq(2010,4);
y = grow(x, '*', g, dates);
z = roc(y);

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(dates), g(dates), 'AbsTol', 1e-10);

z1 = z;
z(dates) = -9999;
assertNotEqual(this, round(z(g.Range), 8), round(g(g.Range), 8));
