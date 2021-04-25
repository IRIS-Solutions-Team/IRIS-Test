
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test LastSystem

m = model('testLastSyst.model', 'linear', true);
m.a = 11;
m.b = 12;
m.c = 13;
m = solve(m);
get(m, 'lastSystem');
s = get(m, 'lastSystem');

actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-11;-12;-13];
assertEqual(testCase, actDeriv, expDeriv);

m.a = 110;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-12;-13];
assertEqual(testCase, actDeriv, expDeriv);

m.b = 120;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-120;-13];
assertEqual(testCase, actDeriv, expDeriv);

m.c = 130;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-120;-130];
assertEqual(testCase, actDeriv, expDeriv);


%% Test Solve Option Eqtn

m = model('testSolveEqtn.model', 'linear', true);
m.a = 11;
m.b = 12;
m.c = 13;
m.A = 21;
m.B = 22;
m.C = 23;
m = solve(m);
[T, R, K, Z, H, D, U, Omega, list] = sspace(m, 'triangular', false);
[T0, R0, K0, Z0, H0, D0, U0, Omega0, list0] = sspace(m, 'triangular', false); %#ok<ASGLU>
expYVec = get(m, 'yVec');
expXVec = get(m, 'xVec');
expEVec = get(m, 'eVec');
actYVec = list{1}(:);
actXVec = list{2}(:);
actEVec = list{3}(:);
assertEqual(testCase, actYVec, expYVec);
assertEqual(testCase, actXVec, expXVec);
assertEqual(testCase, actEVec, expEVec);
assertEqual(testCase, list0, list);
assertEqual(testCase, Omega0, Omega);
assertEqual(testCase, U0, eye(size(U0)));

m1 = m;
m1.a = 51;
m1.b = 17;
m1.c = 100;
m1.A = -6;
m1.B = 50;
m1.C = 4;

m2 = m1;

m1 = solve(m1, 'equations', 'transition');
[T1, R1, K1, Z1, H1, D1, U1] = sspace(m1, 'triangular', false);

assertNotEqual(testCase, T1, T0);
assertNotEqual(testCase, R1, R0);
assertNotEqual(testCase, K1, K0);
assertEqual(testCase, Z1, Z0);
assertEqual(testCase, H1, H0);
assertEqual(testCase, D1, D0);

m2 = solve(m2, 'equations', 'measurement');
[T2, R2, K2, Z2, H2, D2, U2] = sspace(m2, 'triangular', false);

assertEqual(testCase, T2, T0);
assertEqual(testCase, R2, R0);
assertEqual(testCase, K2, K0);
assertNotEqual(testCase, Z2, Z0);
assertNotEqual(testCase, H2, H0);
assertNotEqual(testCase, D2, D0);
