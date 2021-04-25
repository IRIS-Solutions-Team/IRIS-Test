 
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    m = Model('issue256Test.model', 'SavePreparsed', 'xxx.model');

%% Test Solution Vec
 
    [xVec, yVec] = get(m, 'XVector', 'YVector');
    assertEqual(testCase, string(xVec), ["x"; "y"; "z"; "x{-1}"; "y{-1}"; "z{-1}"]);
    assertEqual(testCase, string(yVec), ["obs_x"; "obs_y"; "obs_z"]);


%% Test Equations

    [xEqtn, yEqtn] = get(m, 'XEquations', 'YEquations');
    [tEqtn, mEqtn] = get(m, 'TransitionEquations', 'MeasurementEquations');

    xEqtnExpd = [
        "((x)-(x{-1}))=rho_x*((x{-1})-(x{-1-1}))+eps_x;"
        "((y)-(y{-1}))=rho_y*((y{-1})-(y{-1-1}))+eps_y;"
        "((z)-(z{-1}))=rho_z*((z{-1})-(z{-1-1}))+eps_z;"
    ];

    yEqtnExpd = [
        "obs_x=x+eps_obs_x;"
        "obs_y=y+eps_obs_y;"
        "obs_z=z+eps_obs_z;"
    ];

    assertEqual(testCase, string(xEqtn), xEqtnExpd);
    assertEqual(testCase, string(yEqtn), yEqtnExpd);
            
    assertEqual(testCase, string(xEqtn), string(tEqtn));
    assertEqual(testCase, string(yEqtn), string(mEqtn));
            
