
% Set Up Once
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Grow with Default Options

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 100 * Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, g, g.Range);
z = 100*(y / y{-1} - 1);

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow with Percent=false

x = Series(qq(2001,1):qq(2010,4), @rand);
g = Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, g, g.Range, 'Percent=', false);
z = y / y{-1} - 1;

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow with RateOfChange=Gross

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 100 + 100*Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, g, g.Range, 'RateOfChange=', 'Gross');
z = 100 * y / y{-1};

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow with BaseShift=-4

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 100*Series(qq(2005,1):qq(2020,4), @rand) / 10;

y = grow(x, g, g.Range, 'BaseShift=', -4);
z = 100 * (y / y{-4} - 1);

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(g.Range), g(g.Range), 'AbsTol', 1e-10);


%% Test Grow with Discrete Dates

x = Series(qq(2001,1):qq(2010,4), @rand);
g = 100*Series(qq(2005,1):qq(2010,4), @rand) / 10;

dates = qq(2005,1) : 3 : qq(2010,4);
y = grow(x, g, dates);
z = pct(y);

assertEqual(this, y.Start, x.Start, 'AbsTol', 1e-10);
assertEqual(this, y.End, g.End, 'AbsTol', 1e-10);
assertEqual(this, z(dates), g(dates), 'AbsTol', 1e-10);

z1 = z;
z(dates) = -9999;
assertNotEqual(this, round(z(g.Range), 8), round(g(g.Range), 8));

