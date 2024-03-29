
% Set Up Once

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
range = qq(2000, 1):qq(2015, 4);
d = struct();
d.x = hpf2(cumsum(Series(range, @randn)));
d.y = hpf2(cumsum(Series(range, @randn)));
d.z = hpf2(cumsum(Series(range, @randn)));
d.a = hpf2(cumsum(Series(range, @randn)));
d.b = hpf2(cumsum(Series(range, @randn)));
this.TestData.range = range;
this.TestData.d = d;




%% Test VAR Simulation with Contributions

range = this.TestData.range;
nPer = length(range);
d = this.TestData.d;
v = VAR(["x", "y", "z"]);
[v, vd] = estimate(v, d, range, 'Order', 2);
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.x, 2)), double(s.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.y, 2)), double(s.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.z, 2)), double(s.z), 'AbsTol', 1e-14);
assertEqual(this, double(c.x{:, end}), zeros(nPer, 1));
assertEqual(this, double(c.y{:, end}), zeros(nPer, 1));
assertEqual(this, double(c.z{:, end}), zeros(nPer, 1));


%% Test SVAR Simulation with Contributions

range = this.TestData.range;
nPer = length(range);
d = this.TestData.d;
v = VAR({'x', 'y', 'z'});
[v, vd] = estimate(v, d, range, 'Order', 2);
[v, vd] = SVAR(v, vd, 'Method', 'Chol');
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.x, 2)), double(s.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.y, 2)), double(s.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.z, 2)), double(s.z), 'AbsTol', 1e-14);
assertEqual(this, double(c.x{:, end}), zeros(nPer, 1));
assertEqual(this, double(c.y{:, end}), zeros(nPer, 1));
assertEqual(this, double(c.z{:, end}), zeros(nPer, 1));


%% Test VARX with Contributions

range = this.TestData.range;
d = this.TestData.d;
v = VAR({'x', 'y', 'z'}, 'Exogenous', {'a', 'b'});
[v, vd] = estimate(v, d, range, 'Order', 2);
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.x, 2)), double(s.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.y, 2)), double(s.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.z, 2)), double(s.z), 'AbsTol', 1e-14);


%% Test SVARX with Contributions

range = this.TestData.range;
d = this.TestData.d;
v = VAR({'x', 'y', 'z'}, 'Exogenous', {'a', 'b'});
[v, vd] = estimate(v, d, range, 'Order', 2);
[v, vd] = SVAR(v, vd, 'Method', 'Chol');
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.x, 2)), double(s.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.y, 2)), double(s.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.z, 2)), double(s.z), 'AbsTol', 1e-14);


%% Test PVAR with Fixed Effect

range = this.TestData.range;
p = 2;
d = this.TestData.d;
D = struct();
D.A = d;
D.B = d;
v = VAR( {'x', 'y', 'z'}, ...
         'Exogenous', {'a', 'b'}, ...
         'Groups', {'A', 'B'} );
[v, vd, fitted] = estimate(v, D, range, 'Order', p, 'FixedEffect', true);
assertEqual(this, fitted{1}{1}, range(p+1:end), 'AbsTol', 1e-14);
assertEqual(this, fitted{1}{2}, range(p+1:end), 'AbsTol', 1e-14);
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.A.x, 2)), double(s.A.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.A.y, 2)), double(s.A.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.A.z, 2)), double(s.A.z), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.x, 2)), double(s.B.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.y, 2)), double(s.B.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.z, 2)), double(s.B.z), 'AbsTol', 1e-14);



%% Test PVAR with No Fixed Eff

range = this.TestData.range;
p = 2;
d = this.TestData.d;
D = struct();
D.A = d;
D.B = d;
v = VAR( {'x', 'y', 'z'}, ...
         'Exogenous', {'a', 'b'}, ...
         'Groups', {'A', 'B'} );    
[v, vd, fitted] = estimate(v, D, range, 'Order', p, 'FixedEffect', false);
assertEqual(this, fitted{1}{1}, range(p+1:end), 'AbsTol', 1e-14);
assertEqual(this, fitted{1}{2}, range(p+1:end), 'AbsTol', 1e-14);
s = simulate(v, vd, range(3:end));
c = simulate(v, vd, range(3:end), 'Contributions', true);
assertEqual(this, double(sum(c.A.x, 2)), double(s.A.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.A.y, 2)), double(s.A.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.A.z, 2)), double(s.A.z), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.x, 2)), double(s.B.x), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.y, 2)), double(s.B.y), 'AbsTol', 1e-14);
assertEqual(this, double(sum(c.B.z, 2)), double(s.B.z), 'AbsTol', 1e-14);

