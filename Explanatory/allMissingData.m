

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

xq = ExplanatoryEquation.fromString([
    "x = @ + @*y"
    "a = @(1) + (@(3)+@(2))*b"
]);


%% Test estimation with all missing observations

d = struct();
d.y = cumsum(Series(5:15, @rand));
d.x = 10 - 0.5*d.y + Series(5:15, @randn)*0.5;

d.b = cumsum(Series(1:20, @rand));
d.a = 10 - 0.5*d.b + Series(1:20, @randn)*0.5;

xq = regress(xq, d, 1:20, "missingObservations", "silent");

d2 = d;
d2.x(:) = NaN;

    xq2 = regress(xq, d2, 1:20, "missingObservations", "silent");
try
    xq2 = regress(xq, d2, 1:20, "missingObservations", "silent");
catch me
end

assertEqual(testCase, string(me.identifier), "IrisToolbox:Explanatory");

