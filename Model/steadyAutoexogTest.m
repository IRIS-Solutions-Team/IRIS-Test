
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%{
Model>>>>>
!variables
    y, c, k, r
!parameters
    bet, del, alp
!log_variables
    !all_but
!equations
    r*bet = 1;
    y = del*k + c;
    y = k^alp * 1;
    alp*y = (r+del-1)*k;
!autoswaps-steady
    k ~ del;
% Legacy keyword
!steady_autoexog
    y := alp;
<<<<<Model
%}
fileName = 'steadyAutoexogTest.model';
parser.grabTextFromCaller('Model', fileName);
m = Model(fileName);
m.alp = 0.5;
m.bet = 0.95;
m.del = 0.10;
m.k = 20;
m = sstate(m, 'display', 'none');

testData = struct( );
testData.Model = m;





%% Test Exogenize Endogenize Auto

m = testData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize', @auto, 'endogenize', @auto, 'display', 'none');

m2 = m;
m2.del = m1.del;
m2.alp = m1.alp;
m2 = sstate(m2, 'display', 'none');

compareModels(m1, m2);

m3 = sstate(m, 'exogenize', @auto, 'endogenize', 'alp', 'display', 'none');

m4 = m;
m4.alp = m3.alp;
m4 = sstate(m4, 'display', 'none');

compareModels(m3, m4);




%% Test Exogenize Auto

m = testData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize', @auto, 'endogenize', @auto, 'display', 'none');
m2 = sstate(m, 'exogenize', 'y,k', 'endogenize', @auto, 'display', 'none');
m3 = sstate(m, 'exogenize', {'k','y'}, 'endogenize', @auto, 'display', 'none');
compareModels(m1, m2);
compareModels(m1, m3);




%% Test Endogenize Auto

m = testData.Model;
m1 = m;
m1.k = 0.95*m1.k;
m1 = sstate(m1, 'exogenize', 'k', 'endogenize', @auto, 'display', 'none');
m2 = m;
m2.del = m1.del;
m2 = sstate(m2, 'display', 'none');
compareModels(m1, m2);




%% Test Exogenize Endogenize Auto Part Two

m = testData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
m1 = sstate(m, 'exogenize', @auto, 'endogenize', @auto, 'display', 'none');
m2 = sstate(m, 'exogenize', @auto, 'endogenize', 'del,alp', 'display', 'none');
m3 = sstate(m, 'exogenize', @auto, 'endogenize', {'alp','del'}, 'display', 'none');
compareModels(m1, m2);
compareModels(m1, m3);




%% Test Errors

m = testData.Model;
m.y = 1.05*m.y;
m.k = 0.95*m.k;
try
    steady(m, 'exogenize', 'y,kk', 'endogenize', @auto, 'display', 'none');
catch exc
    id = 'IrisToolbox:Model:CannotExogenize';
    assertEqual(testCase, exc.identifier, id);
end

try
    steady(m, 'exogenize', 'y,c', 'endogenize', @auto, 'display', 'none');
catch exc
    id = 'IrisToolbox:Model:CannotAutoexogenize';
    assertEqual(testCase, exc.identifier, id);
end

try
    steady(m, 'exogenize', @auto, 'endogenize', 'alp,AAA', 'display', 'none');
catch exc
    id = 'IrisToolbox:Model:CannotEndogenize';
    assertEqual(testCase, exc.identifier, id);
end

try
    steady(m, 'exogenize', @auto, 'endogenize', 'alp,bet', 'display', 'none');
catch exc
    id = 'IrisToolbox:Model:CannotAutoendogenize';
    assertEqual(testCase, exc.identifier, id);
end




%% Test Get Autoswaps

m = testData.Model;
act = get(m, 'Autoswaps');
exp = model.component.AutoswapStruct( );
exp.Steady = struct('k', 'del', 'y', 'alp');
exp.Simulate = struct( );
assertEqual(testCase, act, exp);




%% Test Get Autoswapkkk

m = testData.Model;
act = get(m, 'Steady-Autoswaps');
exp = struct('k', 'del', 'y', 'alp');
assertEqual(testCase, act, exp);




%
% Local Functions
%


function compareModels(m1, m2)
    testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);
    v1 = getp(m1, 'Variant');
    v2 = getp(m2, 'Variant');
    assertEqual(testCase, v1.Values, v2.Values, 'AbsTol', 1e-10);
    assertEqual(testCase, v1.StdCorr, v2.StdCorr, 'AbsTol', 1e-10);
end%

