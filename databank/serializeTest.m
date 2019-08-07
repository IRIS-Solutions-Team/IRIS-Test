
% Set Up Once

randChar = @(varargin) char(96+randi(26, varargin{:}));

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

userDataFields = {'Source', 'Description'};

databank.toCSV( d, 'serializeTest1.csv', Inf, ...
                'Decimals=', 2, ...
                'UserDataFields=', userDataFields );
databank.toCSV( dict, 'serializeTest2.csv', Inf, ...
                'Decimals=', 2, ...
                'UserDataFields=', userDataFields );
databank.toCSV( m, 'serializeTest3.csv', Inf, ...
                'Decimals=', 2, ...
                'UserDataFields=', userDataFields );

d1 = databank.fromCSV('serializeTest1.csv');
dict1 = databank.fromCSV('serializeTest2.csv', 'OutputType=', 'Dictionary');
m1 = databank.fromCSV('serializeTest1.csv', 'OutputType=', 'containers.Map');


%% Test with Struct 

compareDatabanks(d, d1, userDataFields);


%% Test Dictionary 

compareDatabanks(dict, dict1, userDataFields);


%% Test containers.Map 

compareDatabanks(m, m1, userDataFields);

%
% Local Functions
%

function compareDatabanks(d, d1, userDataFields)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    assertEqual(testCase, class(d), class(d1));
    if isa(d, 'containers.Map')
        list = keys(d);
        list1 = keys(d1);
    else
        list = fieldnames(d);
        list1 = fieldnames(d1);
    end
    assertEqual(testCase, list, list1);
    for i = 1 : numel(list)
        name = list{i};
        if isa(d, 'containers.Map')
            x = d(name);
            x1 = d1(name);
        else
            x = getfield(d, name);
            x1 = getfield(d1, name);
        end
        assertEqual(testCase, x.Data, x1.Data);
        assertEqual(testCase, x.Comment, x1.Comment);
        u = userdata(x);
        u1 = userdata(x1);
        for j = 1 : numel(userDataFields)
            fieldName = userDataFields{j};
            if isfield(u, fieldName)
                assertEqual(testCase, u.(fieldName), u1.(fieldName));
            end
        end
    end
end%

