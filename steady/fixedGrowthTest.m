
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
K = 10;
m = Model.fromSnippet("test1", "assign", struct("K", K));

% test1>>>
% !for <1:K> !do
%     !variables
%         x?
%     !log-variables
%         x?
%     !equations 
%         x?/x?{-1} = 1.02;
% !end
% <<<test1
    
m2 = Model.fromSnippet("test2", "assign", struct("K", K));

% test2>>>
% !for <1:K> !do
%     !variables
%         x?
%     !log-variables
%         x?
%     !equations 
%         x? = 1.02*x?{-1};
% !end
% <<<test2

%% Test vanilla

m = steady(m, "blocks", false, "growth", true);
m2 = steady(m2, "blocks", false, "growth", true, "solver", {"qnsdx", "minLambda", 1e10, "maxLambda", 1e14});

for i = 1 : K
    assertEqual(testCase, imag(m.("x"+string(i))), 1.02, "absTol", 1e-10);
    assertGreaterThan(testCase, real(m.("x"+string(i))), 0.5);
    assertEqual(testCase, imag(m2.("x"+string(i))), 1.02, "absTol", 1e-10);
    assertGreaterThan(testCase, real(m2.("x"+string(i))), 0.5);
end


%% Test some growth fixed

m.x1 = 1.02i;
m.("x"+string(K)) = 1.02i;

m = steady( ...
    m, "blocks", false, "growth", true, "fixChange", ["x1", "x"+string(K)] ...
);

for i = 1 : K
    assertEqual(testCase, imag(m.("x"+string(i))), 1.02, "absTol", 1e-10);
end


%% Test all but one growth fixed

for i = 1 : K-1
    m.("x"+string(i)) = NaN + 1.02i;
end

m = steady( ...
    m, "blocks", false, "growth", true, "fixChange", Except("x"+string(K)) ...
);

for i = 1 : K
    assertEqual(testCase, imag(m.("x"+string(i))), 1.02, "absTol", 1e-10);
end


%% Test all growth fixed

for i = 1 : K
    m.("x"+string(i)) = NaN + 1.02i;
end

m = steady( ...
    m, "blocks", false, "growth", true, "fixChange", Except() ...
);

for i = 1 : K
    assertEqual(testCase, imag(m.("x"+string(i))), 1.02, "absTol", 1e-10);
end

