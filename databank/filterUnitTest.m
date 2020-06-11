% saveAs=databank/filterUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    s = struct( );
    s.a = Series( );
    s.b = Series( );
    s.c = 1;
    s.a_b = Series( );
    d = Dictionary( );
    store(d, "a", Series( ));
    store(d, "b", Series( ));
    store(d, "c", 1);
    store(d, "a.b", Series( ));


%% Test with Name Filter As List
    assertEqual(testCase, databank.filter(s, 'NameFilter=', {'b', 'a_b', 'z'}), ["b", "a_b"]);
    assertEqual(testCase, databank.filter(s, 'NameFilter=', ["b", "a_b", "z"]), ["b", "a_b"]);
    assertEqual(testCase, databank.filter(d, 'NameFilter=', {'b', 'a.b', 'z'}), ["b", "a.b"]);
    assertEqual(testCase, databank.filter(d, 'NameFilter=', ["b", "a.b", "z"]), ["b", "a.b"]);


%% Test Name List and User Filter
    [list, tokens] = databank.filter(s, 'NameFilter=', {'a', 'c', 'a_b'}, 'Filter=', @(x) isa(x, 'Series'));
    assertEqual(testCase, list, ["a", "a_b"]);
    [list, tokens] = databank.filter(d, 'NameFilter=', {'a', 'c', 'a.b'}, 'Filter=', @(x) isa(x, 'Series'));
    assertEqual(testCase, list, ["a", "a.b"]);
