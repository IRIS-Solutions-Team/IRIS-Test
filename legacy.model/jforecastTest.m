function tests = jforecastTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('testForecast.model', 'Linear=', true);
m = solve(m);
m = sstate(m);
this.TestData.model = m;
end 




function test1(this)
m = this.TestData.model;
xNames = get(m, 'xNames');

T = 10;
Ti = 4;
Te = 3;
d = sstatedb(m, 1:T);

for ant = [true, false]
    d.eps_y(1:Te) = -0.2;
    f1 = jforecast(m, d, 1:T, 'MeanOnly=', true, 'Anticipate=', ant);
    s1 = simulate(m, f1, 1:T, 'Anticipate=', ant);
    for i = 1 : length(xNames)
        name = xNames{i};
        assertEqual(this, f1.(name)(1:T), s1.(name)(1:T), 'AbsTol', 1e-14);
    end
    
    p = plan(m, 1:T);
    p = condition(p, 'i', 1:Ti);
    d.i(1:Ti) = 1.2;
    f2 = jforecast(m, d, 1:T, 'MeanOnly=', true, 'Plan=', p, 'Anticipate=', ant);
    s2 = simulate(m, f2, 1:T, 'Anticipate=', ant);
    for i = 1 : length(xNames)
        name = xNames{i};
        assertEqual(this, f2.(name)(1:T), s2.(name)(1:T), 'AbsTol', 1e-14);
    end
end
end
