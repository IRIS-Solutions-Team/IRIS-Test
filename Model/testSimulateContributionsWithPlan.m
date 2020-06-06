
% Setup once

m = Model( 'testSimulateContributions.model', ...
           'Growth=', true );

m.alpha = 1.03^(1/4);
m.beta = 0.985^(1/4);
m.gamma = 0.60;
m.delta = 0.03;
m.pi = 1.025^(1/4);
m.eta = 6;
m.k = 10;
m.psi = 0.25;

m.chi = 0.85;
m.xiw = 60;
m.xip = 300;
m.rhoa = 0.90;

m.rhor = 0.85;
m.kappap = 3.5;
m.kappan = 0;

m.Short_ = -2;
m.Infl_ = 1.5;
m.Growth_ = 1;
m.Wage_ = 2;

m.std_Mp = 0;
m.std_Mw = 0;
m.std_Ea = 0.001;

m = sstate( m, ...
            'Solver=', {'IRIS-Qnsd', 'Display=', false} );
chksstate(m);
m = solve(m);

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

p = Plan(m, 1:20);
p = anticipate(p, false, {'Ey', 'Y'});
p = exogenize(p, 1:20, 'P');
p = endogenize(p, 1:20, 'Ep');
p = swap(p, 1:1, {'Y', 'Ey'});

d = zerodb(m, 1:20);
%d.Y(1:20) = d.Y(1:20) .* exp(randn(20,1)*0.02);
d.Y(1:1) = d.Y(1:1) .* exp(randn(1,1)*0.02);
d.P(1:20) = d.P(1:20) .* exp(randn(20,1)*0.02);

g = sstatedb(m, 1:20);
g.Y(1) = g.Y(1) .* exp(randn(1,1)*0.02);
g.P(1:20) = g.P(1:20) .* exp(randn(20,1)*0.02);



%% Test Contributions Linear Zerodb

[z, zi] = simulate( m, d, 1:20, ...
                    'Plan=', p, ...
                    'Deviation=', true );

[s, si] = simulate( m, z, 1:20, ...
                    'Plan=', clear(p), ...
                    'Deviation=', true );

[c, ci] = simulate( m, z, 1:20, ...
                    'Plan=', clear(p), ...
                    'Deviation=', true, ...
                    'Contributions=', true );

assertEqual(testCase, zi.Frames, si.Frames);
assertContributions(m, s, c);


%% Test Contributions Linear Zerodb Trends

z = simulate( m, d, 1:20, ...
              'Plan=', p, ...
              'Deviation=', true, ...
              'EvalTrends=', true );

s = simulate( m, z, 1:20, ...
              'Plan=', clear(p), ...
              'Deviation=', true, ...
              'EvalTrends=', true );

c = simulate( m, z, 1:20, ...
              'Plan=', clear(p), ...
              'Deviation=', true, ...
              'EvalTrends=', true, ...
              'Contributions=', true );

assertContributions(m, s, z);
assertContributions(m, s, c);


%% Test Contributions Linear Sstatedb

z = simulate( m, g, 1:20, ...
              'Plan=', p, ...
              'Deviation=', false );

s = simulate( m, z, 1:20, ...
              'Plan=', clear(p), ...
              'Deviation=', false );

c = simulate( m, z, 1:20, ...
              'Plan=', clear(p), ...
              'Deviation=', false, ...
              'Contributions=', true );

assertContributions(m, s, z);
assertContributions(m, s, c);


%% Test Contributions Nonlinear Sstatedb

display = false;
z = simulate( m, g, 1:20, ...
              'Plan=', p, ...
              'Method=', 'Selective', ...
              'Solver=', {'IRIS-QaD', 'FunctionTolerance=', 1e-10, 'Display=', display}, ...
              'Deviation=', false );

s = simulate( m, z, 1:20, ...
              'Plan=', clear(p), ...
              'Method=', 'Selective', ...
              'Solver=', {'IRIS-QaD', 'FunctionTolerance=', 1e-10, 'Display=', display}, ...
              'Deviation=', false );

c0 = simulate( m, z, 1:20, ...
               'Plan=', clear(p), ...
               'Deviation=', false, ...
               'Contributions=', true );

c1 = simulate( m, z, 1:20, ...
               'Plan=', clear(p), ...
               'Method=', 'Selective', ...
               'Solver=', {'IRIS-QaD', 'FunctionTolerance=', 1e-10, 'Display=', display}, ...
               'Deviation=', false, ...
               'Contributions=', true );

assertContributions(m, s, c1, 1e-8)
assertLinearContributions(m, c0, c1, 1e-10)


%
% Local Functions
%


function assertContributions(m, s, c, tolerance)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    if nargin<4
        tolerance = 1e-10;
    end
    listOfYX = [ get(m, 'YNames'), get(m, 'XNames') ];
    listOfLog = get(m, 'LogList');
    for i = 1 : numel(listOfYX)
        name = listOfYX{i};
        if any(strcmpi(name, listOfLog))
            assertEqual( testCase, ...
                         s.(name)(:), ...
                         prod(c.(name)(:), 2), ...
                         'AbsTol', tolerance );
        else
            assertEqual( testCase, ...
                         s.(name)(:), ...
                         sum(c.(name)(:), 2), ...
                         'AbsTol', tolerance );
        end
    end
end%



function assertLinearContributions(m, s, c, tolerance)
    %testCase = matlab.unittest.TestCase.forInteractiveUse;
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    if nargin<4
        tolerance = 1e-10;
    end
    listOfYX = [ get(m, 'YNames'), get(m, 'XNames') ];
    listOfLog = get(m, 'LogList');
    for i = 1 : numel(listOfYX)
        name = listOfYX{i};
        if any(strcmpi(name, listOfLog))
            assertEqual( testCase, ...
                         prod(s.(name)(:, 1:end-1), 2), ...
                         prod(c.(name)(:, 1:end-1), 2), ...
                         'AbsTol', tolerance );
        else
            assertEqual( testCase, ...
                         sum(s.(name)(:, 1:end-1), 2), ...
                         sum(c.(name)(:, 1:end-1), 2), ...
                         'AbsTol', tolerance);
        end
    end
end%

