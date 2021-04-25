
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

x1Data = rand(10, 1);
x2Data = rand(10, 1);
x3Data = rand(10, 1);

%% Integer Frequency

start = ii(10);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
assertEqual(this, [x1Data, x2Data, x3Data], xx(:));

xx = cat(3, x1, x2, x3);
assertEqual(this, cat(3, x1Data, x2Data, x3Data), xx(:));

%% Integer Frequency Shifted

start = ii(10);
sh = 5;
x1 = Series(start, x1Data);
x2 = Series(start+sh, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
assertEqual(this, [x1Data; nan(sh, 1)],  xx(:, 1));
assertEqual(this, [nan(sh, 1); x2Data],  xx(:, 2));
assertEqual(this, [x3Data; nan(sh, 1)],  xx(:, 3));

%% Integer Frequency with Numeric

start = ii(10);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, 10, x3];
assertEqual(this, x1Data,  xx(:, 1));
assertEqual(this, x2Data,  xx(:, 2));
assertEqual(this, 10*ones(size(x1Data)),  xx(:, 3));
assertEqual(this, x3Data,  xx(:, 4));

%% Quarterly Frequency

start = qq(2000, 1);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
assertEqual(this, [x1Data, x2Data, x3Data], xx(:));

xx = cat(3, x1, x2, x3);
assertEqual(this, cat(3, x1Data, x2Data, x3Data), xx(:));

%% Quarterly Frequency Shifted

start = qq(2000, 1);
sh = 5;
x1 = Series(start, x1Data);
x2 = Series(start+sh, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
assertEqual(this, [x1Data; nan(sh, 1)],  xx(:, 1));
assertEqual(this, [nan(sh, 1); x2Data],  xx(:, 2));
assertEqual(this, [x3Data; nan(sh, 1)],  xx(:, 3));

%% Cat with Empty

start = qq(2000, 1);
x1 = Series(start, x1Data);

xx = [x1; Series];
assertEqual(this, x1Data,  xx(:));

xx = [Series; x1];
assertEqual(this, x1Data,  xx(:));

xx = [Series; Series];
assertEqual(this, nan(0,1),  xx(:));


%% Cat with Different yet Consistent Size

x1 = Series([ ], zeros(0, 2, 3));
x2 = Series(NaN, zeros(0, 3, 2));
try
    [x1; x2];
    isError = false;
catch
    isError = true;
end
assertEqual(this, isError, false);


%% Cat with Different and Inconsistent Size

x1 = Series([ ], zeros(0, 2, 3));
x2 = Series(NaN, zeros(0, 3, 1));
try
    [x1; x2];
    isError = false;
catch
    isError = true;
end
assertEqual(this, isError, true);

