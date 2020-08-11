% saveAs=Quantity/implementGetUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once

q = model.component.Quantity;
q.Name =      {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l'};
q.Type = int8([ 1 ,  1 ,  2 ,  2 ,  31,  31,  32,  32,  4 ,  4 ,  5 ,  5 ]);
q.Label = strcat(upper(q.Name), upper(q.Name));
q.Alias = strcat(q.Name, q.Name);
testCase.TestData.Quantity = q;
testCase.TestData.Map = struct( ...
    'Y', 1, 'X', 2, 'W', 31, 'V', 32, 'P', 4, 'G', 5 ...
);


%% Test Get Names

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    [output, isValid, query] = implementGet(q, prefix+"Names");
    inx = q.Type==map.(prefix);
    assertEqual(testCase, output, q.Name(inx));
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Names");
end


%% Test Get Labels

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    [output, isValid, query] = implementGet(q, prefix+"Descript");
    inx = q.Type==map.(prefix);
    expected = strcat(upper(q.Name(inx)), upper(q.Name(inx)));
    assertEqual(testCase, output, expected);
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Descript");
end


%% Test Get Alias

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    [output, isValid, query] = implementGet(q, prefix+"Alias");
    inx = q.Type==map.(prefix);
    expected = strcat(q.Name(inx), q.Name(inx));
    assertEqual(testCase, output, expected);
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Alias");
end


%% Test Get Empty Names

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    inx = q.Type==map.(prefix);
    q.Name(inx) = [ ];
    q.Type(inx) = [ ];
    q.Label(inx) = [ ];
    [output, isValid, query] = implementGet(q, prefix+"Names");
    assertEqual(testCase, output, cell.empty(1, 0));
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Names");
end


%% Test Get Empty Labels

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    inx = q.Type==map.(prefix);
    q.Name(inx) = [ ];
    q.Type(inx) = [ ];
    q.Label(inx) = [ ];
    [output, isValid, query] = implementGet(q, prefix+"Descript");
    assertEqual(testCase, output, cell.empty(1, 0));
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Descript");
end


%% Test Get Empty Alias

q = testCase.TestData.Quantity;
map = testCase.TestData.Map;

for prefix = keys(map)
    inx = q.Type==map.(prefix);
    q.Name(inx) = [ ];
    q.Type(inx) = [ ];
    q.Label(inx) = [ ];
    [output, isValid, query] = implementGet(q, prefix+"Alias");
    assertEqual(testCase, output, cell.empty(1, 0));
    assertEqual(testCase, isValid, true);
    assertEqual(testCase, query, prefix+"Alias");
end

