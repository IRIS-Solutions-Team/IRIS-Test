
% Set up

x1Data = rand(10, 1);
x2Data = rand(10, 1);
x3Data = rand(10, 1);

%**************************************************************************
% Integer Frequency

start = ii(10);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
Assert.equal([x1Data, x2Data, x3Data], xx(:));

xx = cat(3, x1, x2, x3);
Assert.equal(cat(3, x1Data, x2Data, x3Data), xx(:));

%**************************************************************************
% Integer Frequency Shifted

start = ii(10);
sh = 5;
x1 = Series(start, x1Data);
x2 = Series(start+sh, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
Assert.equaln([x1Data; nan(sh, 1)],  xx(:, 1));
Assert.equaln([nan(sh, 1); x2Data],  xx(:, 2));
Assert.equaln([x3Data; nan(sh, 1)],  xx(:, 3));

%**************************************************************************
% Integer Frequency with Numeric

start = ii(10);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, 10, x3];
Assert.equaln(x1Data,  xx(:, 1));
Assert.equaln(x2Data,  xx(:, 2));
Assert.equaln(10*ones(size(x1Data)),  xx(:, 3));
Assert.equaln(x3Data,  xx(:, 4));

%**************************************************************************
% Quarterly Frequency

start = qq(2000, 1);
x1 = Series(start, x1Data);
x2 = Series(start, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
Assert.equal([x1Data, x2Data, x3Data], xx(:));

xx = cat(3, x1, x2, x3);
Assert.equal(cat(3, x1Data, x2Data, x3Data), xx(:));

%**************************************************************************
% Quarterly Frequency Shifted

start = qq(2000, 1);
sh = 5;
x1 = Series(start, x1Data);
x2 = Series(start+sh, x2Data);
x3 = Series(start, x3Data);

xx = [x1, x2, x3];
Assert.equaln([x1Data; nan(sh, 1)],  xx(:, 1));
Assert.equaln([nan(sh, 1); x2Data],  xx(:, 2));
Assert.equaln([x3Data; nan(sh, 1)],  xx(:, 3));


