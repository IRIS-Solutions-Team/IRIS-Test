
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test convert with Frequency

series = { tseries(yy(2000), rand(400,1))
           tseries(hh(2000), rand(400,1))
           tseries(qq(2000), rand(400,1))
           tseries(mm(2000), rand(400,1))
           tseries(ww(2000), rand(400,1))
           tseries(dd(2000), rand(400,1)) };

freq = { Frequency.YEARLY
         Frequency.HALFYEARLY
         Frequency.QUARTERLY
         Frequency.MONTHLY
         Frequency.WEEKLY
         Frequency.DAILY };

num = { 1, 2, 4, 12, 52, 365 };

letters = { 'y', 'h', 'q', 'm', 'w', 'd' };

for d = 1 : numel(series)
    for f = 1 : numel(freq)
        fromFreq = series{d}.Frequency;
        toFreq = freq{f};
        if double(fromFreq)==52 && double(toFreq)==365
            continue
        end
        d1 = convert(series{d}, freq{f});
        d2 = convert(series{d}, num{f});
        d3 = convert(series{d}, letters{f});
        assertEqual(testCase, double(freq{f}), d1.FrequencyAsNumeric );
        assertEqual(testCase, double(freq{f}), d2.FrequencyAsNumeric );
        assertEqual(testCase, double(freq{f}), d3.FrequencyAsNumeric );
    end
end

