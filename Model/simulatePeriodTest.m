
m = Model('simulatePeriodTest.model')

d = struct( );
d.X = Series(-10:10, 10);

s = simulate(m, d, 1:10, 'Method=', 'Period');

