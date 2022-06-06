

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

d = struct();
for n = ["a", "b", "c", "d"]
    d.(n) = Series(qq(2020,1:40), @randn);
    d.("x"+n) = rand();
end


%% Test all lists, new series

list = databank.filterFields(d, "value", @(x) isa(x, "Series"));

g = databank.generate(d, @(n, pn) n*pn, "n"+list, {list, "x"+list});

assertEqual(testCase, list, ["a", "b", "c", "d"]);
for n = list
    assertEqual(testCase, g.("n"+n).Data, d.(n).Data*d.("x"+n));
end


%% Test all functions, new series

list = databank.filterFields(d, "value", @(x) isa(x, "Series"));

g = databank.generate(d, @(n, pn) n*pn, @(n) "n"+n, {list, @(n) "x"+n});

assertEqual(testCase, list, ["a", "b", "c", "d"]);
for n = list
    assertEqual(testCase, g.("n"+n).Data, d.(n).Data*d.("x"+n));
end



%% Test all functions, overwrite

list = databank.filterFields(d, "value", @(x) isa(x, "Series"));

g = databank.generate(d, @(n, pn) n*pn, list, {list, @(n) "x"+n});

assertEqual(testCase, list, ["a", "b", "c", "d"]);
for n = list
    assertEqual(testCase, g.(n).Data, d.(n).Data*d.("x"+n));
end

