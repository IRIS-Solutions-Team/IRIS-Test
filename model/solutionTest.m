
assertEqual = @(x, y) assert(isequal(x, y));
assertNotEqual = @(x, y) assert(~isequal(x, y));

%% Test LastSystem

m = model('testLastSyst.model', 'linear=', true);
m.a = 11;
m.b = 12;
m.c = 13;
m = solve(m);
get(m, 'lastSystem');
s = get(m, 'lastSystem');

actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-11;-12;-13];
assertEqual(actDeriv, expDeriv);

m.a = 110;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-12;-13];
assertEqual(actDeriv, expDeriv);

m.b = 120;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-120;-13];
assertEqual(actDeriv, expDeriv);

m.c = 130;
solve(m);
actDeriv = nonzeros(s.Deriv.f);
expDeriv = [-110;-120;-130];
assertEqual(actDeriv, expDeriv);


%% Test Solve Option Eqtn

m = model('testSolveEqtn.model', 'linear=', true);
m.a = 11;
m.b = 12;
m.c = 13;
m.A = 21;
m.B = 22;
m.C = 23;
m = solve(m);
[T, R, K, Z, H, D, U, Omg, List] = sspace(m); %#ok<ASGLU>
[T1, R1, K1, Z1, H1, D1, U1, Omg1, List1] = sspace(m, 'triangular=', false); %#ok<ASGLU>
expYVec = get(m, 'yVec');
expXVec = get(m, 'xVec');
expEVec = get(m, 'eVec');
actYVec = List{1}(:);
actXVec = List{2}(:);
actEVec = List{3}(:);
assertEqual(actYVec, expYVec);
assertEqual(actXVec, expXVec);
assertEqual(actEVec, expEVec);
assertEqual(List1, List);
assertEqual(Omg1, Omg);
assertEqual(U1, eye(size(U1)));

m1 = m;
m1.a = 51;
m1.b = 17;
m1.c = 100;
m1.A = -6;
m1.B = 50;
m1.C = 4;
m2 = m1;

m1 = solve(m1, 'eqtn=', 'transition');
[T1, R1, K1, Z1, H1, D1] = sspace(m1);

assertNotEqual(T1, T);
assertNotEqual(R1, R);
assertNotEqual(K1, K);
assertEqual(Z1, Z);
assertEqual(H1, H);
assertEqual(D1, D);

m2 = solve(m2, 'eqtn=', 'measurement');
[T2, R2, K2, Z2, H2, D2] = sspace(m2);

assertEqual(T2, T);
assertEqual(R2, R);
assertEqual(K2, K);
assertNotEqual(Z2, Z);
assertNotEqual(H2, H);
assertNotEqual(D2, D);
