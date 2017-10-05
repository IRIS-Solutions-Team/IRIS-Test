
assertEqual = @(x, y) assert(isequal(x, y));

% Test Interpolation in For

m = model('test_interpolation.model');
list = get(m, 'Names');
assertEqual(list, {'x_s', 'x_f', 'ttrend'});

