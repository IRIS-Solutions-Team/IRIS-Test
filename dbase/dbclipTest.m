
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Clip with Start and/or End before and/or After Series Range

startDates = {yy(2001), hh(2001), qq(2001, 1), mm(2001), qq(2001), dd(2001,1,1), ii(100), 100};
for i = 1 : numel(startDates)
    startDate = startDates{i};
    d = struct( );
    d.x = Series(startDate, rand(4, 3, 2));
    startDate = d.x.Start;
    endDate = d.x.End;
    beforeStart = startDate - 4;
    afterEnd = endDate + 4;
    withinRange = startDate + 2;

    d1 = dbclip(d, afterEnd:afterEnd+4);
    assertEqual(testCase, d1.x, d1.x.empty(d1.x));

    d2 = dbclip(d, beforeStart-4:beforeStart);
    assertEqual(testCase, d2.x, d2.x.empty(d2.x));

    d3 = dbclip(d, withinRange:afterEnd);
    assertEqual(testCase, d3.x, d.x{withinRange:end});

    d4 = dbclip(d, beforeStart:withinRange);
    assertEqual(testCase, d4.x, d.x{beforeStart:withinRange});

    d5 = dbclip(d, beforeStart:afterEnd);
    assertEqual(testCase, d5.x, d.x);
end


%% Test Start End Multiple Freq

startDates = {yy(2001), qq(2001, 1), dd(2001,1,1), ii(100), 100};
endDates = cell(size(startDates));
clipStart = cell(size(startDates));
clipEnd = cell(size(startDates));
d = struct( );
for i = 1 : numel(startDates)
    startDate = startDates{i};
    numPeriods = 10;
    endDate = startDate + numPeriods - 1;
    endDates{i} = endDate;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    name = sprintf('x%g', i);
    d.(name) = x;
    clipStart{i} = startDates{i}+1;
    clipEnd{i} = endDates{i}-1;
end
c = dbclip(d, clipStart, clipEnd);
for i = 1 : numel(startDates)
    name = sprintf('x%g', i);
    assertEqual(testCase, round(c.(name).Start), round(clipStart{i}));
    assertEqual(testCase, c.(name).Data, d.(name).Data(2:end-1, :, :));
end


%% Test Start End Missing Freq

d = struct( );
d.x1 = Series(yy(2001), rand(10, 3, 2));
d.x2 = Series(qq(2001,1), rand(10, 3, 2));
c = dbclip(d, yy(2002), yy(2009));
assertEqual(testCase, round(c.x1.Start), round(yy(2002)));
assertEqual(testCase, round(c.x1.End), round(yy(2009)));
assertEqual(testCase, round(c.x2.Start), round(qq(2001,1)));
assertEqual(testCase, round(c.x2.End), round(qq(2001,10)));


