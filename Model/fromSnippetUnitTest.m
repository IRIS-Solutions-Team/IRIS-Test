% saveAs=Model/fromSnippetUnitTest.m

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test plain vanilla

m = Model.fromSnippet("test");

% test>>>
% !variables
%     x
% !shocks
%     eps_x
% !parameters
%     rho_x
% !equations
%     x = rho_x*x{-1} + eps_x;
% <<<test

act = access(m, "equations");
exp = "x=rho_x*x{-1}+eps_x;";
assertEqual(testCase, act, exp);


%% Test options

m = Model.fromSnippet("linear", "linear", true);

% linear>>>
% !variables
%     x
% !shocks
%     eps_x
% !parameters
%     rho_x
% !equations
%     x = rho_x*x{-1} + eps_x;
% <<<linear

act = access(m, "equations");
exp = "x=rho_x*x{-1}+eps_x;";
assertEqual(testCase, act, exp);
assertTrue(testCase, isLinear(m));


%% Test multiple snippets

m = Model.fromSnippet(["test2", "test3"]);

% test2>>>
% !variables
%     x
% !shocks
%     eps_x
% !parameters
%     rho_x
% !equations
%     x = rho_x*x{-1} + eps_x;
% <<<test2

% test3>>>
% !variables
%     y
% !shocks
%     eps_y
% !parameters
%     rho_y
% !equations
%     y = rho_y*y{-1} + eps_y;
% <<<test3

act = access(m, "equations");
exp = ["x=rho_x*x{-1}+eps_x;", "y=rho_y*y{-1}+eps_y;"];
assertEqual(testCase, act, exp);
