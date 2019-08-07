
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Basic

d = databank.fromCSV('fromCSVTest1.csv');

lsf = fieldnames(d);
assertEqual(testCase, sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(testCase, x.Start, qq(2001,1));
    assertEqual(testCase, x.End, qq(2004,4));
    assertEqual(testCase, x.Data, (1:16).'*10^(i-1));
end

%% Option DateFormat=

d = databank.fromCSV('fromCSVTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 4);

lsf = fieldnames(d);
assertEqual(testCase, sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(testCase, x.Start, qq(2001,1));
    assertEqual(testCase, x.End, qq(2004,4));
end

d = databank.fromCSV('fromCSVTest2.csv', 'DateFormat=', 'YYYY/M/1', 'Freq=', 12);

lsf = fieldnames(d);
assertEqual(testCase, sort(lsf), {'X'; 'Y'; 'Z'});
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d.(name);
    assertEqual(testCase, x.Start, mm(2001, 1));
    assertEqual(testCase, x.End, mm(2004, 10));
end

%% Option Case=

d = databank.fromCSV('fromCSVTest1.csv', 'Case=', 'lower');
assertEqual(testCase, sort(fieldnames(d)), {'x'; 'y'; 'z'});


%% Yearly Dates YYYY

actual = databank.fromCSV('fromCSVTest3.csv', 'DateFormat=', 'YYYY');
expected = struct( 'ts1', Series(yy(2008), [1;1]), ...
                   'ts2', Series(yy(2008), [2;2]) );
assertEqual(testCase, actual, expected);


%% Option OutputType='containers.Map'

d = databank.fromCSV('fromCSVTest1.csv', 'OutputType=', 'containers.Map');

lsf = keys(d);
exp = {'X', 'Y', 'Z'};
assertEqual(testCase, sort(lsf), exp);
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d(name);
    assertEqual(testCase, x.Start, qq(2001,1));
    assertEqual(testCase, x.End, qq(2004,4));
    assertEqual(testCase, x.Data, (1:16).'*10^(i-1));
end


%% MultipleCSV Files

inputFiles = {'fromCSVTest1.csv', 'fromCSVTest4.csv'};
d = databank.fromCSV(inputFiles, 'OutputType=', 'containers.Map');

lsf = keys(d);
exp = {'X', 'Y', 'Z', 'A', 'B', 'C'};
assertEqual(testCase, sort(lsf), sort(exp));
for i = 1 : numel(lsf)
    name = lsf{i};
    x = d(name);
    assertEqual(testCase, x.Start, qq(2001,1));
    assertEqual(testCase, x.End, qq(2004,4));
end

