
% Setup once

m = model('3eq.model', 'Linear=', true);
m = solve(m);
m = sstate(m);
testData.Model = m;

n = model('n3eq.model');
n = sstate(n, 'Display=', 'none');
n = solve(n);
testData.NonlModel = n;

eqn = findeqtn(n, 'Phillips');
testData.Phillips = eqn;


%% Test Exogenized Anticipated

m = testData.Model;
d = sstatedb(m, 1:20, 'ShockFunc=', @randn);
s = simulate(m, d, 1:20);
p = plan(m, 1:20);
p = exogenize(p, 'pie, y, r', 1:20);
p = endogenize(p, 'epie, ey, er', 1:20);
w = simulate(m, s, 1:20, 'Plan=', p);
check.equal(s.y(:), w.y(:));
check.equal(s.pie(:), w.pie(:));
check.equal(s.r(:), w.r(:));


%% Test Exogenize Unanticipated

m = testData.Model;
d = sstatedb(m, 1:20, 'ShockFunc=', @randn);
s = simulate(m, d, 1:20, 'Anticipate=', false);
p = plan(m, 1:20);
p = exogenize(p, 'pie, y, r', 1:20);
p = endogenize(p, 'epie, ey, er', 1:20);
w = simulate(m, s, 1:20, 'Plan=', p, 'Anticipate=', false);
check.equal(s.y(:), w.y(:));
check.equal(s.pie(:), w.pie(:));
check.equal(s.r(:), w.r(:));


%% Test Exogenize Nonlinear

n = testData.NonlModel;
%hash = createHashEquations(n);
nSim = 20;
d = sstatedb(n, 1:nSim);
d = shockdb(n, d, 11:nSim, 'ShockFunc=', @randn);
phillips = testData.Phillips;
p = plan(n, 1:20);
p = exogenize(p, 'pie, Y, r', 11:nSim);
p = endogenize(p, 'epie, ey, er', 11:nSim);
for ant = [true, false]
    for maxNumelJv = [0, Inf]
        runTest(n, d, p, nSim, phillips, ant, maxNumelJv)
    end
end


%
% Local functions
%


function runTest(n, d, p, nSim, phillips, ant, maxNumelJv)
    tol = 1e-9;
    nNonl = 25;
    list = get(n, 'xList');
    s = simulate(n, d, 1:nSim, 'Anticipate=', ant, ...
        'Method=', 'selective', 'MaxIter=', 10000, 'Display=', 0, ...
        'Tolerance=', 1e-12, 'InitStepSize=', 1, 'Solver=', @qad, ...
        'Nonlinper=', nNonl, ...
        'MaxNumelJv=', maxNumelJv);
    z = dbeval(s, phillips);
    check.lessThan(abs(z), tol);
    check.absTol(s.Y(1:nSim), exp(s.y(1:nSim)/100), tol);
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
        check.absTol(s.(name)(1:nSim), w.(name)(1:nSim), tol);
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
        check.absTol(s.(name)(1:nSim), cc(1:nSim), tol);
    end        
end%

