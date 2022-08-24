
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test Estimation and Simulation with Multiple Equations and Variants

rng(0)
progress = false;

x = Explanatory.fromString([
    "a1 =  @ + @*b1"
    "a2 =# 5 - 3*b2"
    "a3 =  @ + @*b3"
    "a4 =  @ + @*b4"
    "a5 =  5 - 3*b5"
    "a6 =  5 - 3*b6"
    "a7 =  @ + @*b7 + @*a7{-1}"
]);
N = numel(x);

rm = ParamArmani(2, 1, @(p) {[1, p(1)-1i], [1, p(2)-12i]});

rm1 = update(rm, [0.8, -0.5]);
x(1).ResidualModel = rm1;

rm4 = update(rm, [-0.5, 0.5]);
x(4).ResidualModel = rm4;

rm6 = update(rm, [-0.5, 0.5]);
x(6).ResidualModel = rm6;

T = 300;
nv = 100;

d = struct( );
for i = 1 : N
    if ~x(i).IsIdentity
        inn = randn(T, nv)*10;
        if isempty(x(i).ResidualModel)
            d.("res_a"+i) = Series(1:T, inn);
        else
            d.("res_a"+i) = Series(1:T, filter(x(i).ResidualModel, inn));
        end
        if x(i).NumParameters==2
            x(i).Parameters = repmat([5, -3], 1, 1, nv);
        elseif x(i).NumParameters==3
            x(i).Parameters = repmat([5, -3, 0.5], 1, 1, nv);
        end
    end
    d.("b"+i) = Series(1:T, cumsum(randn(T, nv)));
    d.("a"+i) = Series(0, 0);
end

d.a1(-100:-1) = 1000;
d1 = simulate(x, d, 1:T, "Progress", progress, "prependInput", true);
[x1, d2] = regress(x, d1, 1:T, "Progress", progress);

for i = [1, 3, 4]
    assertGreaterThan(testCase, mean(x1(i).Parameters(1)), 4);
    assertLessThan(testCase, mean(x1(i).Parameters(1)), 6);
    assertGreaterThan(testCase, mean(x1(i).Parameters(2)), -4);
    assertLessThan(testCase, mean(x1(i).Parameters(2)), -2);
end

assertGreaterThan(testCase, mean(x1(1).ResidualModel.Parameters(1)), 0.7);
assertLessThan(testCase, mean(x1(1).ResidualModel.Parameters(1)), 0.9);
assertGreaterThan(testCase, mean(x1(1).ResidualModel.Parameters(2)), -0.6);
assertLessThan(testCase, mean(x1(1).ResidualModel.Parameters(2)), -0.4);

assertGreaterThan(testCase, mean(x1(4).ResidualModel.Parameters(1)), -0.6);
assertLessThan(testCase, mean(x1(4).ResidualModel.Parameters(1)), -0.4);
assertGreaterThan(testCase, mean(x1(4).ResidualModel.Parameters(2)), 0.4);
assertLessThan(testCase, mean(x1(4).ResidualModel.Parameters(2)), 0.6);

assertGreaterThan(testCase, mean(x1(6).ResidualModel.Parameters(1)), -0.6);
assertLessThan(testCase, mean(x1(6).ResidualModel.Parameters(1)), -0.4);
assertGreaterThan(testCase, mean(x1(6).ResidualModel.Parameters(2)), 0.4);
assertLessThan(testCase, mean(x1(6).ResidualModel.Parameters(2)), 0.6);

d3 = d1;
for i = 1 : N
    d3.("b"+i) = fillMissing(d3.("b"+i), T+(1:24), "previous");
end

s3 = simulate(x1, d3, T+(1:24), "PrependInput", true, "Progress", progress);
d4 = simulateResidualModel(x1, d3, T+(1:24));
s4 = simulate(x1, d4, T+(1:24), "PrependInput", true, "Progress", progress);

