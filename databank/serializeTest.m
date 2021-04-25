
% Set Up Once

randChar = @(varargin) char(96+randi(26, varargin{:}));

d = struct( );
dict = Dictionary( );
for i = 1 : 100
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
    d = setfield(d, name, x);
    dict = store(dict, name, x);
end

userDataFields = {'Source', 'Description'};

databank.toCSV( d, 'serializeTest1.csv', Inf, ...
                'Decimals', 2, ...
                'UserDataFields', userDataFields );

databank.toCSV( dict, 'serializeTest2.csv', Inf, ...
                'Decimals', 2, ...
                'UserDataFields', userDataFields );

d1 = databank.fromCSV('serializeTest1.csv');
dict1 = databank.fromCSV('serializeTest2.csv', 'OutputType', 'Dictionary');


%% Test Struct 

compareDatabanks(d, d1, userDataFields);


%% Test Dictionary 

compareDatabanks(dict, dict1, userDataFields);


%% Local Functions

function compareDatabanks(d, d1, userDataFields)
    this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    assertEqual(this, class(d), class(d1));
    if isa(d, 'Dictionary')
        list = keys(d);
        list1 = keys(d1);
    else
        list = fieldnames(d);
        list1 = fieldnames(d1);
    end
    assertEqual(this, list, list1);
    for i = 1 : numel(list)
        name = list{i};
        if isa(d, 'Dictionary')
            x = retrieve(d, name);
            x1 = retrieve(d1, name);
        else
            x = getfield(d, name);
            x1 = getfield(d1, name);
        end
        assertEqual(this, x.Data, x1.Data);
        assertEqual(this, x.Comment, x1.Comment);
        u = userdata(x);
        u1 = userdata(x1);
        for j = 1 : numel(userDataFields)
            fieldName = userDataFields{j};
            if isfield(u, fieldName)
                assertEqual(this, u.(fieldName), u1.(fieldName));
            end
        end
    end
end%

