function tests = clipTest( )
tests = functiontests(localfunctions( ));
end%


function testStartEnd(this)
    startDates = {yy(2001), qq(2001, 1), dd(2001,1,1), ii(100), 100};
    for i = 1 : numel(startDates)
        startDate = startDates{i};
        numPeriods = 10;
        endDate = startDate + numPeriods - 1;
        x = tseries(startDate, rand(numPeriods, 3, 2));
        y = clip(x, startDate+1, endDate-1);
        assertEqual(this, round(y.Start), round(startDate+1));
        assertEqual(this, y.Data, x.Data(2:end-1, :, :));
    end
end%


function testInfEnd(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    endDate = startDate + numPeriods - 1;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    y = clip(x, -Inf, endDate-1);
    assertEqual(this, round(y.Start), round(startDate));
    assertEqual(this, y.Data, x.Data(1:end-1, :, :));
end%


function testStartInf(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    y = clip(x, startDate+1, Inf);
    assertEqual(this, round(y.Start), round(startDate+1));
    assertEqual(this, y.Data, x.Data(2:end, :, :));
end%


function testBeforeStartInf(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    y = clip(x, startDate-1, Inf);
    assertEqual(this, round(y.Start), round(startDate));
    assertEqual(this, y.Data, x.Data);
end%


function testBeforeStartAfterEnd(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    endDate = startDate + numPeriods - 1;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    y = clip(x, startDate-1, endDate+1);
    assertEqual(this, round(y.Start), round(startDate));
    assertEqual(this, y.Data, x.Data);
end%


function testStartFrequencyMismatch(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    endDate = startDate + numPeriods - 1;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    Error = [ ];
    try
        y = clip(x, mm(2001,2), endDate);
    catch Error
    end
    assertNotEqual(this, Error, [ ]);
    assertEqual(this, Error.identifier, 'IrisToolbox:Series:FrequencyMismatch');
end%


function testEndFrequencyMismatch(this)
    startDate = qq(2001, 1);
    numPeriods = 10;
    x = tseries(startDate, rand(numPeriods, 3, 2));
    Error = [ ];
    try
        y = clip(x, -Inf, mm(2001,2));
    catch Error
    end
    assertNotEqual(this, Error, [ ]);
    assertEqual(this, Error.identifier, 'IrisToolbox:Series:FrequencyMismatch');
end%


