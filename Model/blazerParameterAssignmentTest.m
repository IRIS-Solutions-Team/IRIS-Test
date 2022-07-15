
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
iris.required(20200307)

%% Test Parameter Assignment Blocks

m = Model.fromFile('blazerParameterAssignmentTest.model', 'Growth', true);

m.x = 10;
m.y = 15;
m.z = 20 + 1.05i;
m.u = 30 + 5i;

[vars, eqns, blks] = blazer( ...
    m ...
    , 'Endogenize', get(m, 'PNames') ...
    , 'Exogenize', get(m, 'XNames') ...
);

m = steady( ...
    m ...
    , 'Endogenize', get(m, 'PNames') ...
    , 'Exogenize', get(m, 'XNames') ...
);

assertEqual(testCase, all(isAssignBlock(blks)), true);
assertEqual(testCase, m.a, real(m.x), 'AbsTol', 1e-14);
assertEqual(testCase, m.b, exp(real(m.y)), 'AbsTol', 1e-14);
assertEqual(testCase, m.c, imag(m.z), 'AbsTol', 1e-14);
assertEqual(testCase, m.d, -5*imag(m.u), 'AbsTol', 1e-14);

