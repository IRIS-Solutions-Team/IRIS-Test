
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test floor_ in plain models

m1 = Model.fromSnippet("plain");

% plain>>>
% !variables y, pie, r
% !equations
%     y = 0.8*y{-1} - 0.1*r;
%     pie = 0.7*pie{-1} + 0.1*y;
%     r = 1.5*pie;
% <<<plain


%% Test floor_ in optimal policy models

m2 = Model.fromSnippet("optimal", "optimal", {"nonNegative", "r"}); %#ok<CLARRSTR>

% optimal>>>
% !variables y, pie, r
% !equations
%     y = 0.8*y{-1} - 0.1*r;
%     pie = 0.7*pie{-1} + 0.1*y;
%     min(0.9) y^2 + pie^2;
% <<<optimal

