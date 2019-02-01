function tests = dtrendsTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>




function setupOnce(this)
m = model('dtrendsTest.model', 'Linear=', true);
ttrend = 0 : 4;
nPer = length(ttrend);
g = rand(1, nPer)*5 - 10; %[1, 2.5, -3, 10, 0];
h = rand(1, nPer)*5 - 10; %[10, 9, 8, 7, 6];
G = [g; h; ttrend];
this.TestData.Model = m;
this.TestData.G = G;
end




function testEmpty(this) %#ok<INUSD>
end




function testPairing(this)
PTR = @int16;
TYPE = @int8;

m = this.TestData.Model;
eqn = getp(m, 'Equation');
prn = getp(m, 'Pairing');
nEqn = length(eqn.Input);
ex = repmat(PTR(0), 1, nEqn);
ex(eqn.Type==TYPE(3)) = PTR([3, 2, 5, 7, 4]);
ac = prn.Dtrend;
assertEqual(this, ac, ex);
end




function testEvalDtrends(this)
m = this.TestData.Model;
G = this.TestData.G;

nPer = size(G, 2);
g = G(1, :, :);
h = G(2, :, :);
ttrend = G(3, :, :);
qty = getp(m, 'Quantity');
ell = lookup(qty, get(m, 'PList'));
posPout = ell.PosName;
ny = get(m, 'ny');
ac = evalTrendEquations(m, posPout, G, @all);

% All parameters are pout, so they are reset to 0 in evalTrendEquations.
alp = 0;
bet = 0;
gam = 0;
del = 0;
eps = 0;
zet = 0;
eta = 0;
mu = 0;
ex = zeros(ny, nPer);
ex(1, :) = 0; % a
ex(2, :) = 3 + 0*alp; % b
ex(3, :) = bet + 3*gam*ttrend - (del+1)*ttrend.^2; % c;
ex(4, :) = eps + zet*g; % d
ex(5, :) = bet - 2*zet*g + (eta+1)*h; % e
ex(6, :) = 0; % f
ex(7, :) = mu + mu*0.01*ttrend; % j
ex(8, :) = 0; % k
assertEqual(this, ac, ex);
end




function testDiffDtrends(this)
m = this.TestData.Model;
G = this.TestData.G;

qty = getp(m, 'Quantity');
ny = get(m, 'ny');
nPer = size(G, 2);
g = G(1, :, :);
h = G(2, :, :);
ttrend = G(3, :, :);
ell = lookup(qty, {'del', 'zet', 'eta'});
posPout = ell.PosName;
ac = evalTrendEquations(m, posPout, G, @all); %#ok<*NASGU>
alp = m.alp;
bet = m.bet;
gam = m.gam;
del = 0;
eps = m.eps;
zet = m.zet;
eta = m.eta;
[~, ac] = evalTrendEquations(m, posPout, G, @all);
ex = zeros(ny, 3, nPer);
ex(3, 1, :) = -ttrend.^2; % c
ex(4, 2, :) = g;
ex(5, 2, :) = -2*g;
ex(5, 3, :) = h;
assertEqual(this, ac, ex);
end




function testMultiple(this)
m = this.TestData.Model;
G = this.TestData.G;

nAlt = 10;
lsp = get(m, 'plist');
m = alter(m, nAlt);
for i = 1 : length(lsp)
    for j = 1 : nAlt
        m.(lsp{i})(j) = j*m.(lsp{i})(1);
    end
end
ttrend = 0 : 4;
nPer = length(ttrend);
ng = get(m, 'ng');
ny = get(m, 'ny');
g = bsxfun(@times, [1, 2.5, -3, 10, 0], permute(1:nAlt, [1, 3, 2]));
h = bsxfun(@times, [10, 9, 8, 7, 6], permute(1:nAlt, [1, 3, 2]));
ac = evalTrendEquations(m, [ ], [g; h; repmat(ttrend, 1, 1, nAlt)], @all);

% All parameters are pout, so they are reset to 0 in evalTrendEquations.
for i = 1 : nAlt
    ex = zeros(ny, nPer);
    ex(1, :) = 0; % a
    ex(2, :) = 3 + 0*m.alp(i); % b
    ex(3, :) = m.bet(i) + 3*m.gam(i)*ttrend - (m.del(i)+1)*ttrend.^2; % c;
    ex(4, :) = m.eps(i) + m.zet(i)*g(:,:,i); % d
    ex(5, :) = m.bet(i) - 2*m.zet(i)*g(:,:,i) + (m.eta(i)+1)*h(:,:,i); % e
    ex(6, :) = 0; % f
    ex(7, :) = m.mu(i) + m.mu(i)*0.01*ttrend; % j
    ex(8, :) = 0; % k
    assertEqual(this, ac(:, :, i), ex);
end
end




function testSteady(this)
m = this.TestData.Model;
G = this.TestData.G;

nAlt = 2;
chksstate(m);
plist = get(m, 'plist');
m = alter(m, nAlt);
for i = 1 : length(plist)
    for j = 1 : nAlt
        m.(plist{i})(j) = j*m.(plist{i})(1);
    end
end
m.del = -1;
m.mu = [1.1, 1.2];

ac = get(m, 'Steady') * get(m, 'YList');
ex = struct( ...
    'a', repmat(1, 1, nAlt), ...
    'b', repmat(1, 1, nAlt), ...
    'c', repmat(1, 1, nAlt), ...
    'd', repmat(1, 1, nAlt), ...
    'e', repmat(1, 1, nAlt), ...
    'f', repmat(1, 1, nAlt), ...
    'j', repmat(1+1i, 1, nAlt), ...
    'k', repmat(1+1i, 1, nAlt) ...
    ); %#ok<REPMAT>
assertEqual(this, ac, ex);
end




function testSteadyDtrendLevel(this)
m = this.TestData.Model;
G = this.TestData.G;

nAlt = length(m);
ac = get(m, 'dtLevel') * get(m, 'ylist');
ex = struct( ...
    'a', repmat(0, 1, nAlt), ...
    'b', 3 + 0*m.alp, ...
    'c', m.bet + 3*m.gam*0 - (m.del+1)*0^2, ...
    'd', m.eps + m.zet.*real(m.g), ...
    'e', m.bet - 2*m.zet.*real(m.g) + (m.eta+1).*real(m.h), ...
    'f', repmat(0, 1, nAlt), ...
    'j', exp(m.mu + m.mu*0.01*0), ...
    'k', repmat(1, 1, nAlt) ...
    ); %#ok<REPMAT>
assertEqual(this, ac, ex);
end




function testSteadyDtrendGrowth(this)
m = this.TestData.Model;
G = this.TestData.G;

nAlt = length(m);
ac = get(m, 'dtGrowth') * get(m, 'ylist');
ex = struct( ...
    'a', repmat(0, 1, nAlt), ...
    'b', repmat(0, 1, nAlt), ...
    'c', 3*m.gam - 2*m.del*0, ...
    'd', repmat(0, 1, nAlt), ...
    'e', repmat(0, 1, nAlt), ...
    'f', repmat(0, 1, nAlt), ...
    'j', exp(m.mu*0.01), ...
    'k', repmat(1, 1, nAlt) ...
    ); %#ok<REPMAT>
assertEqual(this, ac, ex);
end
