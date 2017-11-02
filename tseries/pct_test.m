function tests = tseriesTest( )
    tests = functiontests(localfunctions( ));
end


function this = setupOnce(this)
    data = rand(20, 2);
    x = tseries(qq(2000, 1), data);
    range = x.Range;
    this.TestData = struct( ...
        'Data', data, ...
        'TimeSeries', x, ...
        'Range', range ...
    );
end


%% Test Percent Change on Quarterly Series
function pctQuarterlyTest(this)
    data = this.TestData.Data;
    x = this.TestData.TimeSeries;
    range = this.TestData.Range;
    y = pct(x);
    assertEqual(this, y.Range, range(2:end));
    assertEqual(this, y.Data, 100*(data(2:end, :)./data(1:end-1, :) - 1));
end


%% Test Four-Period Percent Change on Quarterly Series
function pctQuarterlyFourPeriodTest(this)
    data = this.TestData.Data;
    x = this.TestData.TimeSeries;
    range = this.TestData.Range;
    y = pct(x, -4);
    assertEqual(this, y.Range, range(5:end));
    assertEqual(this, y.Data, 100*(data(5:end, :)./data(1:end-4, :) - 1));
end


%% Test Percent Change on Quarterly Series Annualized
function apctQuarterlyTest(this)
    data = rand(20, 2);
    x = tseries(qq(2000, 1), data);
    range = this.TestData.Range;
    y = pct(x, -1, 'OutputFreq', Frequency.YEARLY);
    assertEqual(this, y.Range, range(2:end));
    assertEqual(this, y.Data, 100*((data(2:end, :)./data(1:end-1, :)).^4 - 1));
end
