
TYPE = @int8;
assertEqual = @(x, y) assert(isequal(x, y));

q0 = model.Quantity;
q0.Name = { ...
    'a', 'b', 'c', 'd', ... 1..4
    'AA', 'BB', 'CC', 'DD', 'EE', 'FF', ... 5..10
    'shk_a', 'shk_b', ... 11..12
    'shk_AA', 'shk_BB', 'shk_CD', 'shk_DD', 'shk_EF', ... 13..17
    'alpha', 'beta', 'gamma', ... 18..20
    'X', 'Y', ... 21..22
    };
nQuan = length(q0.Name);
q0.Type = [ ...
    repmat(int8(1), 1, 4), ...
    repmat(int8(2), 1, 6), ...
    repmat(int8(31), 1, 2), ...
    repmat(int8(32), 1, 5), ...
    repmat(int8(4), 1, 3), ...
    repmat(int8(5), 1, 2), ...
    ];
q0.Label = strcat('Label:', q0.Name);
q0.Alias = strcat('Alias:', q0.Name);
q0.Attributes = repmat({string.empty(1, 0)}, 1, 22);
q0.IxLog = true(1, 22);
q0.IxLagrange = true(1, 22);
q0.IxObserved = false(1, 22);
q0.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nQuan);


%% Test Insert First

q = q0;
add = struct( );
add.Name = {'delta', 'epsilon'};
nAdd = length(add.Name);
add.Label = {'Label:delta', 'Label:epsilon'};
add.Alias = {'Alias:delta', 'Alias:epsilon'};
add.Attributes = repmat({string.empty(1, 0)}, 1, nAdd);
add.IxLog = true(1, nAdd);
add.IxLagrange = false(1, nAdd);
add.IxObserved = false(1, nAdd);
add.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nAdd);
x = insert(q, add, TYPE(4), 'first');
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
assertEqual(x.Name, expName);
assertEqual(x.IxLog, expIxLog);


%% Test Insert Last

q = q0;
add = struct( );
add.Name = {'delta', 'epsilon'};
nAdd = length(add.Name);
add.Label = {'Label:delta', 'Label:epsilon'};
add.Alias = {'Alias:delta', 'Alias:epsilon'};
add.Attributes = repmat({string.empty(1, 0)}, 1, nAdd);
add.IxLog = true(1, nAdd);
add.IxLagrange = false(1, nAdd);
add.IxObserved = false(1, nAdd);
add.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nAdd);
x = insert(q, add, int8(4), 'last');
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
assertEqual(x.Name, expName);
assertEqual(x.IxLagrange, expIxLagrange);
