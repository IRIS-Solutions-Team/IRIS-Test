

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% From regular files

m1 = Model.fromFile( ...
    ["fromFileUnitTest1.model", "fromFileUnitTest2.model"] ...
);

assertEqual(testCase, access(m1, "names"), ["x", "y"]);
assertEqual(testCase, access(m1, "equations"), ["x=1;", "y=1;"]);


%% From markdown files

m2 = Model.fromFile( ...
    ["fromFileUnitTest1.md", "fromFileUnitTest2.md"] ...
);

assertEqual(testCase, access(m2, "names"), ["x", "y"]);
assertEqual(testCase, access(m2, "equations"), ["x=1;", "y=1;"]);


%% Via ModelSource

s1 = ModelSource.fromFile("fromFileUnitTest1.md");
s2 = ModelSource.fromFile("fromFileUnitTest2.model");

m3 = Model([s1, s2]);

assertEqual(testCase, access(m3, "names"), ["x", "y"]);
assertEqual(testCase, access(m3, "equations"), ["x=1;", "y=1;"]);


%% Via ModelSource with error

flag = false;
try
    s1 = ModelSource.fromFile("fromFileUnitTest1.md", "markdown", false);
    s2 = ModelSource.fromFile("fromFileUnitTest2.model");
    m4 = Model([s1, s2]);
catch
    flag = true;
end

assertEqual(testCase, flag, true);

