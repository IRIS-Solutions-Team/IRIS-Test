function tests = selectiveWithLogVariablesTest( )
    tests = functiontests(localfunctions) ;
end%


function testSteadySimulation(this)
    m = solve(sstate(model('selectiveWithLogVariablesTest.model')));
    d = sstatedb(m, 1:5);
    s = simulate(m, d, 1:5, 'method=', 'selective');
    this.assertEqual(d.y(1:5), s.y(1:5), 'AbsTol', 1e-8);
end%


function testZeroSimulation(this)
    m = solve(sstate(model('selectiveWithLogVariablesTest.model')));
    d = zerodb(m, 1:5);
    s = simulate(m, d, 1:5, 'method=', 'selective', 'deviation=', true);
    this.assertEqual(d.y(1:5), s.y(1:5), 'AbsTol', 1e-8);
end%

