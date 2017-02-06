function Tests = exogenizeTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('3eq.Model', 'Linear=', true);
m = solve(m);
m = sstate(m);
this.TestData.Model = m;

n = model('n3eq.Model');
n = sstate(n, 'Display=', 'none');
n = solve(n);
this.TestData.NonlModel = n;

eqn = findeqtn(n, 'Phillips');
this.TestData.Phillips = eqn;
end 



function testExogenizeAnt(this)
m = this.TestData.Model;
d = sstatedb(m, 1:20, 'ShockFunc=', @randn);
s = simulate(m, d, 1:20);
p = plan(m, 1:20);
p = exogenize(p, 'pie, y, r', 1:20);
p = endogenize(p, 'epie, ey, er', 1:20);
w = simulate(m, s, 1:20, 'Plan=', p);
assertEqual(this, s.y(:), w.y(:));
assertEqual(this, s.pie(:), w.pie(:));
assertEqual(this, s.r(:), w.r(:));
end 



function testExogenizeUnant(this)
m = this.TestData.Model;
d = sstatedb(m, 1:20, 'ShockFunc=', @randn);
s = simulate(m, d, 1:20, 'Anticipate=', false);
p = plan(m, 1:20);
p = exogenize(p, 'pie, y, r', 1:20);
p = endogenize(p, 'epie, ey, er', 1:20);
w = simulate(m, s, 1:20, 'Plan=', p, 'Anticipate=', false);
assertEqual(this, s.y(:), w.y(:));
assertEqual(this, s.pie(:), w.pie(:));
assertEqual(this, s.r(:), w.r(:));
end 




function testExogenizeNonlin(this)
n = this.TestData.NonlModel;
tol = 1e-9;
nSim = 20;
nNonl = 25;
d = sstatedb(n, 1:nSim);
d = shockdb(n, d, 11:nSim, 'ShockFunc=', @randn);
phillips = this.TestData.Phillips;
p = plan(n, 1:20);
p = exogenize(p, 'pie, Y, r', 11:nSim);
p = endogenize(p, 'epie, ey, er', 11:nSim);
list = get(n, 'xList');
for ant = [true, false]
    for maxNumelJv = [0, Inf]
        runTest( );
    end
end

return

    


    function runTest( )
        s = simulate(n, d, 1:nSim, 'Anticipate=', ant, ...
            'Method=', 'selective', 'MaxIter=', 10000, 'Display=', 0, ...
            'Tolerance=', 1e-12, 'Lambda=', 1, 'Solver=', @qad, ...
            'Nonlinper=', nNonl, ...
            'MaxNumelJv=', maxNumelJv);
        z = dbeval(s, phillips);
        assertLessThan(this, abs(z), tol);
        assertEqual(this, s.Y(1:nSim), exp(s.y(1:nSim)/100), 'AbsTol', tol);
        d1 = s;
        d1.epie(:) = 0;
        d1.er(:) = 0;
        d1.ey(:) = 0;
        w = simulate(n, d1, 1:nSim, 'Anticipate=', ant, 'Plan=', p, ...
            'Method=', 'selective', 'MaxIter=', 10000, 'Display=', 0, ...
            'Tolerance=', 1e-12, 'Nonlinper=', 25, ...
            'MaxNumelJv=', maxNumelJv);
        for i = 1 : length(list)
            name = list{i};
            assertEqual(this, s.(name)(1:nSim), w.(name)(1:nSim), 'AbsTol', tol);
        end
        c = simulate(n, w, 1:nSim, 'Anticipate=', ant, 'Contributions=', true, ...
            'Method=', 'Selective', 'MaxIter=', 10000, 'Display=', 0, ...
            'Tolerance=', 1e-12, 'Nonlinper=', 25, ...
            'MaxNumelJv=', maxNumelJv);
        for i = 1 : length(list)
            name = list{i};
            if islog(n, name)
                aggregFn = @prod;
            else
                aggregFn = @sum;
            end
            cc = aggregFn(c.(name), 2);
            assertEqual(this, s.(name)(1:nSim), cc(1:nSim), 'AbsTol', tol);
        end        
    end
end

