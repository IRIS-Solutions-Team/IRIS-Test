
% Setup once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

rng(0);
m = Model('testSimulateCombiningShocksAndExogenized.model');
m.alp = 0.5;
m.sgm = 0.1;
m.bet = 0.99;
m.gam = 0.05;
m.del = 0.4;
m.the = 0.80;
m.kap = 4;
m.phi = 0;
m.tau = 3;
m.rho = 2;
m.psi = 0.9;
m.omg = 1;
m = sstate(m);
chksstate(m);
m = solve(m);
e = get(m, 'Dynamic-Transition-Equations');

%% Test Anticipated

range = 1:20;

p = Plan(m, range);
p = swap(p, range, {'y', 'ey'});

d = sstatedb(m, range);
d.y(range) = randn(numel(range), 1)*0.5;

s = simulate( m, d, range, ...
              'PrependInput', true, ...
              'Plan', p, ...
              'Solver', {@auto, 'Display', false}, ...
              'Method', 'Selective' );

output = cell(size(e));
[output{:}] = databank.eval(s, e{:});
for i = 1 : numel(output)
    switch i
        case {1, 2}
            temp = range(1:end-1);
        case 3
            temp = range(1:end-3);
        otherwise
            temp = range;
    end
    assertLessThan(testCase, abs(output{i}(temp)), 1e-5);
end


%% Test Unanticipated

range = 1:20;

p = Plan(m, range, 'DefaultAnticipationStatus', false);
p = swap(p, range, {'y', 'ey'});

d = sstatedb(m, range);
d.y(range) = randn(numel(range), 1)*0.5;

s = simulate( m, d, range, ...
              'PrependInput', true, ...
              'Plan', p, ...
              'Solver', {@auto, 'Display', false}, ...
              'Method', 'Selective' );

output = cell(size(e));
[output{:}] = databank.eval(s, e{:});
for i = 4 : numel(output)
    assertLessThan(testCase, abs(output{i}(range)), 1e-5);
end

