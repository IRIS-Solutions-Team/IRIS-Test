
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

listOfFreq = {'yy', 'hh', 'qq', 'mm', 'ww', 'dd'};


%% Test Numeric Dates

for i = 1 : numel(listOfFreq)
    for j = 1 : 10
        func = listOfFreq{i};
        year = 2000 + randi(1000);
        per = randi(100);
        d1 = feval(['numeric.', func], year, per);
        d2 = feval(func, year, per);
        assertEqual(testCase, double(d1), double(d2));
    end
end


%% Test Today Dates

for i = 1 : numel(listOfFreq)
    func = listOfFreq{i};
    func = [func, 'today'];
    d1 = feval(['numeric.', func]);
    d2 = feval(func);
    assertEqual(testCase, double(d1), double(d2));
end


%% Test str2dat

for i = 1 : 5
    func = listOfFreq{i};
    freq = Frequency.fromString(func);
    d1 = numeric.str2dat('1995:1', 'DateFormat=', 'YYYY:P', 'EnforceFrequency=', freq);
    d2 = str2dat('1995:1', 'DateFormat=', 'YYYY:P', 'EnforceFrequency=', freq);
    assertEqual(testCase, double(d1), double(d2));
    assertEqual(testCase, DateWrapper.getFrequency(d1), freq);
    assertEqual(testCase, DateWrapper.getFrequency(d2), freq);
end

freq = Frequency(365);
d1 = numeric.str2dat('1995:1:11', 'DateFormat=', 'YYYY:M:D', 'EnforceFrequency=', freq);
d2 = str2dat('1995:1:11', 'DateFormat=', 'YYYY:M:D', 'EnforceFrequency=', freq);
assertEqual(testCase, double(d1), double(d2));
assertEqual(testCase, DateWrapper.getFrequency(d1), freq);
assertEqual(testCase, DateWrapper.getFrequency(d2), freq);




