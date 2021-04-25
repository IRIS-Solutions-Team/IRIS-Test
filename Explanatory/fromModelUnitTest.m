% saveAs=Explanatory/fromModelUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set Up Once
    f = model.File( );
    f.FileName = "test.model";
    f.Code = [
        "!variables"
        "   u, v, w, x, y, z, a"
        "!equations"
        "   u = 1 !! u = 2;"
        "   v = 1 !! v = 2;"
        "   w = 1 !! w = 2;"
        "   x = 1;"
        "   y = 1;"
        "   z = 1;"
        "   u = a;"
    ];
    testCase.TestData.Model = Model(f);

                                                                           
%% Unique Test
    m = testCase.TestData.Model;
    q = Explanatory.fromModel(m, ["v", "y", "w"]);
    assertEqual(testCase, [q.LhsName], ["v", "y", "w"]);
    assertEqual(testCase, [q.InputString], ["v=1;", "y=1;", "w=1;"]); 

                                                                           
%% Nonunique Test
    m = testCase.TestData.Model;
    errorThrown = false;
    try
        q = Explanatory.fromModel(m, ["u", "y", "w"]);
    catch
        errorThrown = true;
    end
    assertEqual(testCase, errorThrown, true);

