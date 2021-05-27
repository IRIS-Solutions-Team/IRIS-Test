
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test floor_ in plain models

m1 = Model.fromSnippet("plain");

% plain>>>
% !variables y, pie, r, floor_r
% !equations
%     y = 0.8*y{-1} - 0.1*r;
%     pie = 0.7*pie{-1} + 0.1*y;
%     r = 1.5*pie;
%     floor_r = 0;
% <<<plain


%% Test floor_ in optimal policy models

m2 = Model.fromSnippet("optimal", "optimal", {"floor", "r"}); %#ok<CLARRSTR>
assertTrue(testCase, any(access(m2, "parameters")=="floor_r"));
qty = getp(m2, "Quantity");
assertTrue(testCase, any(strcmp(qty.Name, qty.RESERVED_NAME_TTREND)));

% optimal>>>
% !variables y, pie, r
% !equations
%     y = 0.8*y{-1} - 0.1*r;
%     pie = 0.7*pie{-1} + 0.1*y;
%     min(0.9) y^2 + pie^2;
% <<<optimal


%% Test multiple floor_ in optimal policy models

id = "";
try
    m3 = Model.fromSnippet("multiple", "optimal", {"floor", "r"}); %#ok<CLARRSTR>
catch exc
    id = string(exc.identifier);
end
assertEqual(testCase, id, "IrisToolbox:Parser:NonuniqueNames");

% multiple>>>
% !variables y, pie, r, floor_r
% !equations
%     y = 0.8*y{-1} - 0.1*r;
%     pie = 0.7*pie{-1} + 0.1*y;
%     min(0.9) y^2 + pie^2;
%     floor_r = 0;
% <<<multiple
