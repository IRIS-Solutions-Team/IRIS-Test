
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


% Set up once

q = model.Quantity;
q.Name = { ...
    'a', 'b', 'c', 'd', ... 1..4
    'AA', 'BB', 'CC', 'DD', 'EE', 'FF', ... 5..10
    'shk_a', 'shk_b', ... 11..12
    'shk_AA', 'shk_BB', 'shk_CD', 'shk_DD', 'shk_EF', ... 13..17
    'alpha', 'beta', 'gamma', ... 18..20
    'X', 'Y', ... 21..22
    };
nQuan = numel(q.Name);
q.Label = strcat('Label:', q.Name);
q.Alias = strcat('Alias:', q.Name);
q.Attributes = repmat({string.empty(1, 0)}, 1, nQuan);
q.Type = [ ...
    repmat(int8(1), 1, 4), ...
    repmat(int8(2), 1, 6), ...
    repmat(int8(31), 1, 2), ...
    repmat(int8(32), 1, 5), ...
    repmat(int8(4), 1, 3), ...
    repmat(int8(5), 1, 2), ...
    ];
q.IxLog = true(1, nQuan);
q.IxObserved = false(1, nQuan);
q.IxLagrange = true(1, nQuan);
q.Bounds = repmat(model.Quantity.DEFAULT_BOUNDS, 1, nQuan);
q = seal(q);

opt = struct();
opt.std = 'Std $shock$';
opt.corr = 'Corr $shock1$ X $shock2$';
% testCase.TestData.QuantityObj = q;
% testCase.TestData.ne = 7;
% testCase.TestData.Opt = opt;




%% Test base names

% q = testCase.TestData.QuantityObj;
% opt = testCase.TestData.Opt;
actCaption = generateAutocaption(q, ...
    {'AA', 'BB', 'CC', 'DD'}, ...
    '$name$ $label$ $alias$', opt);
expCaption = { ...
    'AA Label:AA Alias:AA', ...
    'BB Label:BB Alias:BB', ...
    'CC Label:CC Alias:CC', ...
    'DD Label:DD Alias:DD', ...
    };
assertEqual(testCase, actCaption, expCaption);




%% Test std names

% q = this.TestData.QuantityObj;
% opt = this.TestData.Opt;
actCaption = generateAutocaption(q, ...
    {'std_shk_a', 'std_shk_AA', 'std_shk_EF'}, ...
    '$name$ $label$ $alias$', opt);
expCaption = { ...
    'std_shk_a Std Label:shk_a Std Alias:shk_a', ...
    'std_shk_AA Std Label:shk_AA Std Alias:shk_AA', ...
    'std_shk_EF Std Label:shk_EF Std Alias:shk_EF', ...
    };
assertEqual(testCase, actCaption, expCaption);




%% Test std names opt

% q = this.TestData.QuantityObj;
% opt = this.TestData.Opt;
opt1 = opt;
opt1.std = 'STD OF $shock$';
actCaption = generateAutocaption(q, ...
    {'std_shk_a', 'std_shk_AA', 'std_shk_EF'}, ...
    '$name$ $label$ $alias$', opt1);
expCaption = { ...
    'std_shk_a STD OF Label:shk_a STD OF Alias:shk_a', ...
    'std_shk_AA STD OF Label:shk_AA STD OF Alias:shk_AA', ...
    'std_shk_EF STD OF Label:shk_EF STD OF Alias:shk_EF', ...
    };
assertEqual(testCase, actCaption, expCaption);




%% Test corr names

% q = this.TestData.QuantityObj;
% opt = this.TestData.Opt;
actCaption = generateAutocaption(q, ...
    {'corr_shk_a__shk_b', 'corr_shk_AA__shk_EF'}, ...
    '$name$ $label$ $alias$', opt);
expCaption = { ...
    'corr_shk_a__shk_b Corr Label:shk_a X Label:shk_b Corr Alias:shk_a X Alias:shk_b', ...
    'corr_shk_AA__shk_EF Corr Label:shk_AA X Label:shk_EF Corr Alias:shk_AA X Alias:shk_EF', ...
    };
assertEqual(testCase, actCaption, expCaption);




%% Test corr names opt

% q = this.TestData.QuantityObj;
% opt = this.TestData.Opt;
opt1 = opt;
opt1.corr = 'CORR OF $shock1$ XX $shock2$';
actCaption = generateAutocaption(q, ...
    {'corr_shk_a__shk_b', 'corr_shk_AA__shk_EF'}, ...
    '$name$ $label$ $alias$', opt1);
expCaption = { ...
    'corr_shk_a__shk_b CORR OF Label:shk_a XX Label:shk_b CORR OF Alias:shk_a XX Alias:shk_b', ...
    'corr_shk_AA__shk_EF CORR OF Label:shk_AA XX Label:shk_EF CORR OF Alias:shk_AA XX Alias:shk_EF', ...
    };
assertEqual(testCase, actCaption, expCaption);
