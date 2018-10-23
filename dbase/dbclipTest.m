
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
    check.equal(round(c.(name).Start), round(clipStart{i}));
    check.equal(c.(name).Data, d.(name).Data(2:end-1, :, :));
end


%% Test Start End Missing Freq

d = struct( );
d.x1 = Series(yy(2001), rand(10, 3, 2));
d.x2 = Series(qq(2001,1), rand(10, 3, 2));
c = dbclip(d, yy(2002), yy(2009));
check.equal(round(c.x1.Start), round(yy(2002)));
check.equal(round(c.x1.End), round(yy(2009)));
check.equal(round(c.x2.Start), round(qq(2001,1)));
check.equal(round(c.x2.End), round(qq(2001,10)));

