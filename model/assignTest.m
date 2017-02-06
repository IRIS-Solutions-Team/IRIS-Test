function tests = assignTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('assignTest.model');
this.TestData.Model = m;
end




function testEmpty(this) %#ok<INUSD>
end



function testBasicAssign(this)

m = this.TestData.Model;
x = 0;
y = 1;
e = 0;
u = 0;
alp = 2;
bet = 3;
std_e = 10;
std_u = 20;
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = this.TestData.Model;
m.x = x; %#ok<*STRNU>
m.y = y;
m.alp = alp;
m.bet = bet;
m.std_e = std_e;
m.std_u = std_u;
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

m = this.TestData.Model;
m = assign(m, expSstate);
m = assign(m, expStd);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

m = this.TestData.Model;
m = assign(m, 'x', x, 'y', y, 'alp', alp, 'bet', bet, 'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

m = this.TestData.Model;
m = assign(m, '-level', ...
    'x', x, 'y', y, 'alp', alp, 'bet', bet, 'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);
end




function testMultiple(this)
x = [0, 0.5];
y = [1, 1];
e = [0, 0];
u = [0, 0];
alp = [2, 2];
bet = [3, 3];
std_e = [10, 10.5];
std_u = [20, 20];
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = this.TestData.Model;
m = alter(m, 2);
m = assign(m, expSstate);
m = assign(m, expStd);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

m = this.TestData.Model;
m = alter(m, 2);
m = assign(m, 'x', x, 'y', y, 'alp', alp, 'bet', bet, ...
    'std_e', std_e, 'std_u', std_u);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

m = this.TestData.Model;
m = alter(m, 2);
asgn = [ x; y; alp; bet; std_e; std_u ];
asgn = permute(asgn, [3, 1, 2]);
m = assign(m, {'x', 'y', 'alp', 'bet', 'std_e', 'std_u'}, asgn);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);

n = this.TestData.Model;
n = alter(n, 2);
n = assign(n, m);
actSstate = get(n, 'sstate');
actStd = get(n, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);
end




function testFastAssign(this)
x = 0;
y = 1;
e = 0;
u = 0;
alp = 2;
bet = 3;
std_e = 10;
std_u = 20;
expSstate = struct( ...
    'x', x, ...
    'y', y, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet ...
    );
expStd = struct( ...
    'std_e', std_e, ...
    'std_u', std_u ...
    );

m = this.TestData.Model;
assign(m, {'x', 'y', 'alp', 'bet', 'std_e', 'std_u'});
m = assign(m, [x, y, alp, bet, std_e, std_u]);
actSstate = get(m, 'sstate');
actStd = get(m, 'std');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStd, expStd);
end




function testRegexp(this)
xy = 100;
e = 0;
u = 0;
alp = 2;
bet = 3;
std_ = 1.5;
corr_ = -0.3;
expSstate = struct( ...
    'x', xy, ...
    'y', xy, ...
    'e', e, ...
    'u', u, ...
    'alp', alp, ...
    'bet', bet ...
    );
expStdCorr = struct( ...
    'std_e', std_, ...
    'std_u', std_, ...
    'corr_e__u', corr_ ...
    );

m = this.TestData.Model;
m1 = assign(m, ...
    rexp('^[xy]$='), xy, ...
    'e=', e, 'u=', u, rexp('a..='), alp, rexp('^b\w{2}$='), bet, ...
    rexp('std_.*'), std_, 'corr_e__u=', corr_);
actSstate = get(m1, 'sstate');
actStdCorr = get(m1, 'stdcorr');
assertEqual(this, actSstate, expSstate);
assertEqual(this, actStdCorr, expStdCorr);

m2 = assign([m, m], ...
    rexp('^[xy]$='), [xy, xy], ...
    'e=', [e, e], 'u=', u, rexp('a..='), alp, rexp('^b\w{2}$='), bet, ...
    rexp('std_.*'), std_, 'corr_e__u=', corr_);
actSstate = get(m2, 'sstate');
actStd = get(m2, 'stdcorr');
assertEqual(this, actSstate, expSstate & expSstate);
assertEqual(this, actStd, expStdCorr & expStdCorr);
end
