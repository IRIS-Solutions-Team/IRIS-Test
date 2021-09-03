% saveAs=databank/applyUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d1 = struct();
d1.x = Series(1:10, 1);
d1.y = 1;
d1.z = "aaa";

%% Test plain vanilla 

func = @(x) x + 1;
d2 = databank.apply(d1, func);
d3 = databank.apply(func, d1);
%
for n = databank.fieldNames(d1)
    field1 = d1.(n);
    field2 = d2.(n);
    field3 = d3.(n);
    if isa(field1, 'Series')
        field1 = field1(:);
        field2 = field2(:);
        field3 = field3(:);
    end
    assertEqual(testCase, func(field1), field2);
    assertEqual(testCase, func(field1), field3);
end


%% Test SourceNames

sourceNames = ["x", "y"];
func = @(x) x + 1;
d2 = databank.apply(d1, func, "sourceNames", sourceNames, "addToDatabank", struct());
d3 = databank.apply(func, d1, "sourceNames", sourceNames, "addToDatabank", struct());
%
assertEqual(testCase, databank.fieldNames(d2), sourceNames);
assertEqual(testCase, databank.fieldNames(d3), sourceNames);

