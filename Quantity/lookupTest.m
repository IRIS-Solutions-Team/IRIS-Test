function Tests = lookupTest( )
Tests = functiontests(localfunctions);
end




function setupOnce(this)
q = model.Quantity;
q.Name = { ...
    'a', 'b', 'c', 'd', ... 1..4
    'AA', 'BB', 'CC', 'DD', 'EE', 'FF', ... 5..10
    'shk_a', 'shk_b', ... 11..12
    'shk_AA', 'shk_BB', 'shk_CD', 'shk_DD', 'shk_EF', ... 13..17
    'alpha', 'beta', 'gamma', ... 18..20
    'X', 'Y', ... 21..22
    };
nQuan = length(q.Name);
q.Label = strcat('Label:', q.Name);
q.Alias = strcat('Alias:', q.Name);
q.Type = [ ...
    repmat(int8(1), 1, 4), ...
    repmat(int8(2), 1, 6), ...
    repmat(int8(31), 1, 2), ...
    repmat(int8(32), 1, 5), ...
    repmat(int8(4), 1, 3), ...
    repmat(int8(5), 1, 2), ...
    ];
q.IxLog = true(1, nQuan);
q.IxLagrange = true(1, nQuan);
q.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nQuan);
this.TestData.QuantityObj = q;
this.TestData.ne = 7;
end




function testPlainNames(this)
q = this.TestData.QuantityObj;
act = lookup(q, {'a', 'BB', 'shk_b', 'shk_CC', 'alpha', 'X', 'UU'});
expPosName = [1, 6, 12, NaN, 18, 21, NaN];
assertEqual(this, act.PosName, expPosName);
end




function testRegexpNames(this)
q = this.TestData.QuantityObj;
act = lookup(q, rexp('[aA]'));
expIxName = false(size(q.Name));
expIxName([1, 5, 11, 13, 18, 19, 20]) = true;
assertEqual(this, act.IxName, expIxName);
end




function testPlainStd(this)
q = this.TestData.QuantityObj;
act = lookup(q, {'std_shk_EF', 'std_shk_CC', 'std_shk_a'});
expPosName = [NaN, NaN, NaN];
expPosStdCorr = [7, NaN, 1];
expPosShk1 = [17, NaN, 11];
assertEqual(this, act.PosName, expPosName);
assertEqual(this, act.PosStdCorr, expPosStdCorr);
assertEqual(this, act.PosShk1, expPosShk1);
end




function testRegexpStd(this)
q = this.TestData.QuantityObj;
ne = this.TestData.ne;
nStdCorr = ne + ne*(ne-1)/2;
act = lookup(q, rexp('std_shk_(.)\1'));
expIxName = false(size(q.Name));
expIxStdCorr = false(1,nStdCorr);
expIxStdCorr([3,4,6]) = true;
assertEqual(this, act.IxName, expIxName);
assertEqual(this, act.IxStdCorr, expIxStdCorr);
end




function testPlainCorr(this)
q = this.TestData.QuantityObj;
ne = this.TestData.ne;
act = lookup(q, {'corr_shk_a__shk_EF', 'corr_shk_EF__shk_a'});
expPosName = [NaN, NaN];
expPosStdCorr = ne + [6, 6];
expPosShk1 = [11, 17];
expPosShk2 = [17, 11];
assertEqual(this, act.PosName, expPosName);
assertEqual(this, act.PosStdCorr, expPosStdCorr);
assertEqual(this, act.PosShk1, expPosShk1);
assertEqual(this, act.PosShk2, expPosShk2);
end




function testRegexpCorr(this)
q = this.TestData.QuantityObj;
ne = this.TestData.ne;
nStdCorr = ne + ne*(ne-1)/2;
act = lookup(q, rexp('corr_(.)\1__(.)\1'));
expIxName = false(size(q.Name));
expIxStdCorr = false(1,nStdCorr);
expIxStdCorr([19, 21, 24]) = true;
assertEqual(this, act.IxStdCorr, expIxStdCorr);
assertEqual(this, act.IxName, expIxName);
end