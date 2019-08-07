
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set Up Once

randChar = @(varargin) char(96+randi(26, varargin{:}));


%% Test with Struct and Dictionary and containers.Map

d = struct( );
dict = Dictionary( );
m = containers.Map( );
for i = 1 : 10
    name = randChar(1, 10);
    sizeOfSeries = [10+randi(10), randi(3), randi(3)];
    data = round(rand(sizeOfSeries), 2);
    start = numeric.qq(2001,1) + randi(10, 1);
    x = Series(start, data);
    u = struct( );
    if randn<0.3
        x = userdatafield(x, 'Source', randChar(1, 20));
    end
    if randn<0.3
        x = userdatafield(x, 'Description', randChar(1, 20));
    end
    d.(name) = x;
    dict.(name) = x;
    m(name) = x;
end

allFields = fieldnames(d);
assertEqual(testCase, databank.backend.numOfColumns(d, allFields), ...
                      databank.backend.numOfColumns(dict, allFields) );

assertEqual(testCase, databank.backend.numOfColumns(d, allFields), ...
                      databank.backend.numOfColumns(m, allFields) );


%% Test with Extra Entry Name

d = struct( );
dict = Dictionary( );
m = containers.Map( );
for i = 1 : 10
    name = randChar(1, 10);
    sizeOfSeries = [10+randi(10), randi(3), randi(3)];
    data = round(rand(sizeOfSeries), 2);
    start = numeric.qq(2001,1) + randi(10, 1);
    x = Series(start, data);
    u = struct( );
    if randn<0.3
        x = userdatafield(x, 'Source', randChar(1, 20));
    end
    if randn<0.3
        x = userdatafield(x, 'Description', randChar(1, 20));
    end
    d.(name) = x;
    dict.(name) = x;
    m(name) = x;
end

allFields = fieldnames(d);
allFields = [allFields; {'a_b'; 'c_'}];

noc = databank.backend.numOfColumns(d, allFields);

assertEqual(testCase, noc(end-1:end), [NaN, NaN]);

assertEqual(testCase, databank.backend.numOfColumns(d, allFields), ...
                      databank.backend.numOfColumns(dict, allFields) );

assertEqual(testCase, databank.backend.numOfColumns(d, allFields), ...
                      databank.backend.numOfColumns(m, allFields) );

