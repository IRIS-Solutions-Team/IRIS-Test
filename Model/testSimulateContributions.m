
% Setup once

m = Model.fromFile( ...
    'testSimulateContributions.model' ...
    , 'Growth', true ...
);

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

m = steady(m, "Solver=", {"IRIS-Qnsd", "Display=", false});
checkSteady(m);
m = solve(m);


%% Test Contributions Linear Zerodb

[d, deviation] = zerodb(m, 1:20, 'ShockFunc', @randn);

s = simulate( ...
    m, d, 1:20 ...
    , 'Deviation', deviation ...
);

c = simulate( ...
    m, d, 1:20 ...
    , 'Deviation', deviation ...
    , 'Contributions', true ...
);

locallyAssertContributions(m, s, c);


%% Test Contributions Linear Zerodb Trends

[d, deviation] = zerodb(m, 1:20, 'ShockFunc', @randn);

s = simulate( m, d, 1:20, ...
              'Deviation', deviation ...
            );

c = simulate( m, d, 1:20, ...
              'Deviation', deviation, ...
              'Contributions', true );

locallyAssertContributions(m, s, c);


%% Test Contributions Linear Sstatedb

[d, deviation] = sstatedb(m, 1:20, 'ShockFunc', @randn);

s = simulate( m, d, 1:20, ...
              'Deviation', deviation );

c = simulate( m, d, 1:20, ...
              'Deviation', deviation, ...
              'Contributions', true );

locallyAssertContributions(m, s, c);


%% Test Contributions Nonlinear Sstatedb

[d, deviation] = sstatedb(m, 1:20, 'ShockFunc', @randn);

s = simulate( m, d, 1:20, ...
              'Method', 'Selective', ...
              'Solver', {'IRIS-QaD', 'FunctionTolerance', 1e-10, 'Display', false}, ...
              'Deviation', deviation );

c0 = simulate( m, d, 1:20, ...
               'Deviation', deviation, ...
               'Contributions', true );

c1 = simulate( m, d, 1:20, ...
               'Method', 'Selective', ...
               'Solver', {'IRIS-QaD', 'FunctionTolerance', 1e-10, 'Display', false}, ...
               'Deviation', deviation, ...
               'Contributions', true );

locallyAssertContributions(m, s, c1, 1e-8)
locallyAssertLinearContributions(m, c0, c1, 1e-10)

%
% Local Functions
%

function locallyAssertContributions(m, s, c, tolerance)
    %testCase = matlab.unittest.TestCase.forInteractiveUse;
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    if nargin<4
        tolerance = 1e-10;
    end
    listYX = string([ get(m, 'YNames'), get(m, 'XNames') ]);
    listLog = string(get(m, 'LogList'));
    for name = reshape(string(listYX), 1, [ ])
        if any(name==listLog)
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


function locallyAssertLinearContributions(m, s, c, tolerance)
    %testCase = matlab.unittest.TestCase.forInteractiveUse;
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    if nargin<4
        tolerance = 1e-10;
    end
    listYX = string([ get(m, 'YNames'), get(m, 'XNames') ]);
    listLog = string(get(m, 'LogList'));
    for name = reshape(string(listYX), 1, [ ])
        if any(name==listLog)
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

