% saveAs=databank/batchUnitTest.m

    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    d1 = struct();
    d1.a1 = 1;
    d1.b2 = 2;
    d1.c3 = round(100*Series(1:10, @rand));
    d1.d4 = round(100*Series(1:10, @rand));


%% Test Expression Name Filter Tokens

    x1 = databank.batch(d1, '$1_$2', '100+$0', 'Name', Rxp('^(.)(.)$')); 
    x2 = databank.batch(d1, '$1_$2', '100+$0', 'Filter', {'Name', Rxp('^(.)(.)$')});
    x3 = databank.batch(Dictionary.fromStruct(d1), '$1_$2', '100+$0', 'Name', Rxp('^(.)(.)$')); 
    assertEqual(testCase, x1, x2);
    assertEqual(testCase, all(ismember(fieldnames(d1), fieldnames(x1))), true);
    assertEqual(testCase, ismember(["a_1", "b_2", "c_3", "d_4"], fieldnames(x1)), true(1, 4));
    assertEqual(testCase, x1.a_1, d1.a1+100);
    assertEqual(testCase, x1.b_2, d1.b2+100);
    assertEqual(testCase, x1.c_3, d1.c3+100);
    assertEqual(testCase, x1.d_4, d1.d4+100);



%% Test Function Name Filter Tokens

    x1 = databank.batch(d1, '$1_$2', @(x) 100+x, 'Name', Rxp('^(.)(.)$')); 
    x2 = databank.batch(d1, '$1_$2', @(x) 100+x, 'Filter', {'Name', Rxp('^(.)(.)$')});
    assertEqual(testCase, x1, x2);
    assertEqual(testCase, all(ismember(fieldnames(d1), fieldnames(x1))), true);
    assertEqual(testCase, ismember(["a_1", "b_2", "c_3", "d_4"], fieldnames(x1)), true(1, 4));
    assertEqual(testCase, ismember(["a1", "b2", "c3", "d4"], fieldnames(x1)), true(1, 4));
    assertEqual(testCase, x1.a_1, d1.a1+100);
    assertEqual(testCase, x1.b_2, d1.b2+100);
    assertEqual(testCase, x1.c_3, d1.c3+100);
    assertEqual(testCase, x1.d_4, d1.d4+100);


%% Test Dictionary Against Struct

    x1 = databank.batch(d1, '$1_$2', @(x) 100+x, 'Name', Rxp('^(.)(.)$')); 
    x2 = databank.batch(Dictionary.fromStruct(d1), '$1_$2', @(x) 100+x, 'Name', Rxp('^(.)(.)$')); 
    assertEqual(testCase, class(x2), 'Dictionary');
    for name = ["a_1", "b_2", "c_3", "d_4"]
        assertEqual(testCase, x1.(name), retrieve(x2, name));
    end


%% Test Option AddToDatabank Struct

    x1 = databank.batch(d1, '$1_$2', @(x) 100+x, 'Name', Rxp('^(.)(.)$'), 'AddToDatabank', struct( ));
    assertEqual(testCase, class(x1), 'struct');
    assertEqual(testCase, ismember(["a_1", "b_2", "c_3", "d_4"], fieldnames(x1)), true(1, 4));
    assertEqual(testCase, ismember(["a1", "b2", "c3", "d4"], fieldnames(x1)), false(1, 4));


%% Test Option AddToDatabank Dictionary

    x1 = databank.batch(Dictionary.fromStruct(d1), '$1_$2', @(x) 100+x, 'Name', Rxp('^(.)(.)$'), 'AddToDatabank', Dictionary( ));
    assertEqual(testCase, class(x1), 'Dictionary');
    assertEqual(testCase, ismember(["a_1", "b_2", "c_3", "d_4"], keys(x1)), true(1, 4));
    assertEqual(testCase, ismember(["a1", "b2", "c3", "d4"], keys(x1)), false(1, 4));


%% Test Function Arguments

    d2 = struct( );
    list = ["X", "AB", "XYZ"];
    for name = list
        d2.(name) = Series(1:10, @rand);
        d2.("diff_"+name) = Series(1:20, @rand);
    end
    range = 11:20;
    d3 = databank.batch( ...
        d2, "$0_extend", @(x,y) grow(x, "+", y, range) ...
        , "Name=", list ... 
        , "Arguments=", ["$0", "diff_$0"] ...
    );
    assertEqual(testCase, all(ismember("diff_"+list, fieldnames(d3))), true);
    for name = list
        expd = grow(d2.(name), "+", d2.("diff_"+name), range);
        assertEqual(testCase, expd, d3.(name+"_extend"));
    end


%% Test Csaba 2020-05-20 Issue

    d0 = struct( );
    list = ["A", "B", "C"];
    for n = list
        d0.(n) = Series(1, rand(20, 1));
        d0.(n+"_U2W") = Series(1, rand(20, 1));
        d0.(n+"_U2") = Series(1, rand(20, 1));
    end

    args = {'$0', '$0_U2W', '$0_U2'};
    d = databank.batch(d0, '$0', @(x, y, z) x*y/z, 'Name', list, 'Arguments', args);
    for n = list
        assertEqual(testCase, d.(n), d0.(n)*d0.(n+"_U2W")/d0.(n+"_U2"));
    end

    args = {list, list+"_U2W", list+"_U2"};
    d = databank.batch(d0, list, @(x, y, z) x*y/z, 'Arguments', args); 
    for n = list
        assertEqual(testCase, d.(n), d0.(n)*d0.(n+"_U2W")/d0.(n+"_U2"));
    end
