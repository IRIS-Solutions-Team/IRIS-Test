
% Set Up Once

this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Linear System Test

% Test coefficients of unsolved system.
m = model('testLinearSystem.model', 'linear', true);
m4 = model('testLinearSystem4.model', 'linear', true);

m.a = 2*4;
m.b = 3*4;
m.c = 4*4;
m.d = 5*4;

m4.a = 2;
m4.b = 3;
m4.c = 4;
m4.d = 5;

[actA, actB, actC] = system(m);
[actA4, actB4, actC4] = system(m4, 'sparse', true);

expA = zeros(2);
expA(1, 1) = -1;
expA(2, 2) = -1;

expB = zeros(2);
expB(1, 1) = 8;
expB(2, 2) = 16;

expC = zeros(2, 1);
expC(1, 1) = 16;
expC(2, 1) = -120;

assertEqual(this, double(actA), expA);
assertEqual(this, double(actB), expB);
assertEqual(this, double(actC), expC);
assertEqual(this, double(actA4), sparse(expA));
assertEqual(this, double(actB4), sparse(expB));
assertEqual(this, double(actC4), expC);


%% Test Option MakeBkw in Model Constructor

% Test option 'makeBkw' in model/model.
m0 = model('3eq.model', 'linear', true);
m0 = solve(m0);
m1 = model('3eq.model', 'linear', true, 'makeBkw', 'rr');
m1 = solve(m1);
m2 = model('3eq.model', 'linear', true, 'makeBkw', 'rr, Epie');
m2 = solve(m2);
m3 = model('3eq.model', 'linear', true, 'makeBkw', @all);
m3 = solve(m3);

xb0 = get(m0, 'xbVector');
pos0 = textfun.findnames(xb0, {'rr', 'Epie', 'log_Y'});
actIxNan0 = isnan(pos0);
expIxNan0 = [ true, true, true ];

xb1 = get(m1, 'xbVector');
pos1 = textfun.findnames(xb1, {'rr', 'Epie', 'log_Y'});
actIxNan1 = isnan(pos1);
expIxNan1 = [ false, true, true ];

xb2 = get(m2, 'xbVector');
pos2 = textfun.findnames(xb2, {'rr', 'Epie', 'log_Y'});
actIxNan2 = isnan(pos2);
expIxNan2 = [ false, false, true ];

xb3 = get(m3, 'xbVector');
pos3 = textfun.findnames(xb3, {'rr', 'Epie', 'log_Y'});
actIxNan3 = isnan(pos3);
expIxNan3 = [ false, false, false ];

assertEqual(this, actIxNan0, expIxNan0);
assertEqual(this, actIxNan1, expIxNan1);
assertEqual(this, actIxNan2, expIxNan2);
assertEqual(this, actIxNan3, expIxNan3);

list = get(m0, 'xnames');
C0 = acf(m0);
C1 = acf(m1);
C2 = acf(m2);
C3 = acf(m3);
C0 = select(C0, list);
C1 = select(C1, list);
C2 = select(C2, list);
C3 = select(C3, list);

C0 = double(C0);
C1 = double(C1);
C2 = double(C2);
C3 = double(C3);

assertEqual(this, C1, C0, 'AbsTol', 1e-11);
assertEqual(this, C2, C0, 'AbsTol', 1e-11);
assertEqual(this, C3, C0, 'AbsTol', 1e-11);

