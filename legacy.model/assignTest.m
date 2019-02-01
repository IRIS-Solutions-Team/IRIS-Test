
assertEqual =  @(x, y) isequal(x, y);
m0 = model('assignTest.model');


%% Test Basic Assign

x = 0;
y = 1;
e = 0;
u = 0;
alp = 2;
bet = 3;
ttrend = 0+1i;
std_e = 10;
std_u = 20;
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet, ...
    'ttrend', ttrend ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = m0;
m.x = x; %#ok<*STRNU>
m.y = y;
m.alp = alp;
m.bet = bet;
m.std_e = std_e;
m.std_u = std_u;
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

m = assign(m, expSstate);
m = assign(m, expStd);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

m = m0;
m = assign(m, 'x', x, 'y', y, 'alp', alp, 'bet', bet, 'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

m = m0;
m = assign(m, '-level', ...
    'x', x, 'y', y, 'alp', alp, 'bet', bet, 'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);


%% Test Multiple

x = [0, 0.5];
y = [1, 1];
e = [0, 0];
u = [0, 0];
alp = [2, 2];
bet = [3, 3];
ttrend = [0+1i, 0+1i];
std_e = [10, 10.5];
std_u = [20, 20];
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet, ...
    'ttrend', ttrend ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = m0;
m = alter(m, 2);
m = assign(m, expSstate);
m = assign(m, expStd);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

m = m0;
m = alter(m, 2);
m = assign(m, 'x', x, 'y', y, 'alp', alp, 'bet', bet, ...
    'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

m = m0;
m = alter(m, 2);
asgn = [ x; y; alp; bet; std_e; std_u ];
asgn = permute(asgn, [3, 1, 2]);
m = assign(m, {'x', 'y', 'alp', 'bet', 'std_e', 'std_u'}, asgn);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);

n = m0;
n = alter(n, 2);
n = assign(n, m);
actSstate = get(n, 'sstate');
actStd = get(n, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);


%% Test Fast Assign

x = 0;
y = 1;
e = 0;
u = 0;
alp = 2;
bet = 3;
ttrend = 0+1i;
std_e = 10;
std_u = 20;
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet, ...
    'ttrend', ttrend ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = m0;
assign(m, {'x', 'y', 'alp', 'bet', 'std_e', 'std_u'});
m = assign(m, [x, y, alp, bet, std_e, std_u]);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(actSstate, expSstate);
assertEqual(actStd, expStd);


%% Test Regexp

xy = 100;
e = 0;
u = 0;
alp = 2;
bet = 3;
ttrend = 0+1i;
std_ = 1.5;
corr_ = -0.3;
expSstate = struct( ...
    'x', xy, ...
    'y', xy, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet, ...
    'ttrend', ttrend ...
    );
expStdCorr = struct( ...
    'std_e', std_, ...
    'std_u', std_, ...
    'corr_e__u', corr_ ...
    );

m = m0;
m1 = assign(m, ...
    rexp('^[xy]$='), xy, ...
    'e=', e, 'u=', u, rexp('a..='), alp, rexp('^b\w{2}$='), bet, ...
    rexp('std_.*'), std_, 'corr_e__u=', corr_);
actSstate = get(m1, 'sstate');
actStdCorr = get(m1, 'stdcorr');
assertEqual(actSstate, expSstate);
assertEqual(actStdCorr, expStdCorr);

m2 = assign([m, m], ...
    rexp('^[xy]$='), [xy, xy], ...
    'e=', [e, e], 'u=', u, rexp('a..='), alp, rexp('^b\w{2}$='), bet, ...
    rexp('std_.*'), std_, 'corr_e__u=', corr_);
actSstate = get(m2, 'sstate');
actStd = get(m2, 'stdcorr');
assertEqual(actSstate, expSstate & expSstate);
assertEqual(actStd, expStdCorr & expStdCorr);
