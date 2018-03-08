function tests = issue118Test( )
tests = functiontests(localfunctions);
end%


function testSimulate(this)
    m = model('issue118Test.model');
    m = sstate(m);
    m = solve(m);
    d = sstatedb(m, 1:20);
    d.x(0) = 5;
    s = simulate(m, d, 1:20);

    xData = s.x(1:20);
    yData = s.y(1:20);
    dxData = s.x(1:20)-s.x(0:19);
    assertEqual(this, double(d.x.Range), (0:20)');
    assertEqual(this, double(d.y.Range), (1:20)');
    assertEqual(this, double(s.x.Range), (0:20)');
    assertEqual(this, double(s.y.Range), (1:20)');
    assertEqual(this, yData, dxData, 'AbsTol', 1e-12);
end%


