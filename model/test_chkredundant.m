
assertEqual = @(x, y) assert(isequal(x, y));

%% Redundant Shocks

m = model('test_chkredundant_1.model');
[lsShock, lsParam] = chkredundant(m, 'Warning=', false);
assertEqual(lsShock, {'c', 'd', 'e'});
assertEqual(lsParam, cell(1, 0));

%% Redundant Parameters

m = model('test_chkredundant_2.model');
[lsShock, lsParam] = chkredundant(m, 'Warning=', false);
assertEqual(lsShock, cell(1, 0));
assertEqual(lsParam, {'d', 'e'});

%% Redundant Shocks and Parameters

m = model('test_chkredundant_3.model');
[lsShock, lsParam] = chkredundant(m, 'Warning=', false);
assertEqual(lsShock, {'c', 'd', 'e'});
assertEqual(lsParam, {'dd', 'ee'});

