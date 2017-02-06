function Tests = insertTest( )
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
q.Type = [ ...
    repmat(int8(1), 1, 4), ...
    repmat(int8(2), 1, 6), ...
    repmat(int8(31), 1, 2), ...
    repmat(int8(32), 1, 5), ...
    repmat(int8(4), 1, 3), ...
    repmat(int8(5), 1, 2), ...
    ];
q.Label = strcat('Label:', q.Name);
q.Alias = strcat('Alias:', q.Name);
q.IxLog = true(1, 22);
q.IxLagrange = true(1, 22);
q.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nQuan);
this.TestData.QuantityObj = q;
end




function testInsertFirst(this)
q = this.TestData.QuantityObj;
add = struct( );
add.Name = {'delta', 'epsilon'};
nAdd = length(add.Name);
add.Label = {'Label:delta', 'Label:epsilon'};
add.Alias = {'Alias:delta', 'Alias:epsilon'};
add.IxLog = true(1, 2);
add.IxLagrange = false(1, 2);
add.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nAdd);
x = insert(q, int8(4), 'first', add);
pos = 18;
expName = [ ...
    q.Name(1:pos-1), ...
    {'delta', 'epsilon'}, ...
    q.Name(pos:end), ...
    ];
expIxLog = [ ...
    q.IxLog(1:pos), ...
    [true, true], ...
    q.IxLog(pos+1:end), ...
    ];
assertEqual(this, x.Name, expName);
assertEqual(this, x.IxLog, expIxLog);
end




function testInsertLast(this)
q = this.TestData.QuantityObj;
add = struct( );
add.Name = {'delta', 'epsilon'};
nAdd = length(add.Name);
add.Label = {'Label:delta', 'Label:epsilon'};
add.Alias = {'Alias:delta', 'Alias:epsilon'};
add.IxLog = true(1, 2);
add.IxLagrange = false(1, 2);
add.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nAdd);
x = insert(q, int8(4), 'last', add);
pos = 20;
expName = [ ...
    q.Name(1:pos), ...
    {'delta', 'epsilon'}, ...
    q.Name(pos+1:end), ...
    ];
expIxLagrange = [ ...
    q.IxLagrange(1:pos), ...
    [false, false], ...
    q.IxLagrange(pos+1:end), ...
    ];
assertEqual(this, x.Name, expName);
assertEqual(this, x.IxLagrange, expIxLagrange);
end