function tests = createTemplateDbaseTest( )
tests = functiontests(localfunctions);
end%




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
    q.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, 22);
    this.TestData.QuantityObj = q;
end%




function testCreateTemplateDbase(this)
    q = this.TestData.QuantityObj;
    actDb = createTemplateDbase(q);
    expDb = struct( );
    for i = 1 : length(q.Name)
        expDb.(q.Name{i}) = [ ];
    end
    expDb = expDb([ ]);
    assertEqual(this, actDb, expDb);
end%

