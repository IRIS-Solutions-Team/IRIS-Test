
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
K = 1;
m = Model.fromSnippet("test", "assign", struct("K", K));

% test>>>
% !for <1:K> !do
%     !variables
%         x?
%     !log-variables
%         x?
%     !equations 
%         x?/x?{-1} = 1.02;
% !end
% <<<test


%% Test vanilla

m = steady( ...
    m, "blocks", false, "growth", true ...
);

for i = 1 : K
    assertEqual(testCase, imag(m.("x"+string(i))), 1.02, "absTol", 1e-10);
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

