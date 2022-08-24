
% Set up once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Quotes

m = Model('testQuotes.model');
% Descriptions of variables.
actDescript = get(m, 'description');
expDescript = struct( ...
    'x', 'Variable x', ...
    'y', 'Variable y', ...
    'z', 'Variable z', ...
    'ttrend', 'Time trend' ...
);
assertEqual(testCase, actDescript, expDescript);

% Equation labels.
actLabel = get(m,'label');
expLabel = {
    'Equation x'
    'Equation y'
    'Equation z'
};
assertEqual(testCase, actLabel, expLabel);


%% Test For Control In Quotes

m = Model('testForControlInQuotes.model');
expLabel = {
    'Equation for X'
    'Equation for Y'
    'Equation for Z'
};
actLabel = get(m,'labels');
assertEqual(testCase, actLabel, expLabel);


%% Test Brackets In Quotes

m = Model('testBracketsInQuotes.model');
% Descriptions of variables.
actDescript = get(m,'description');
expDescript = struct( ...
    'x','Variable x ([%])', ...
    'y','(Variable y)', ...
    'z','Variable z', ...
    'ttrend', 'Time trend' ...
);
assertEqual(testCase,actDescript,expDescript);
% Equation labels.
actLabel = get(m,'label');
expLabel = { 
    '[Equation x](('
    '{Equation {y'
    'Equation} z}'
};
assertEqual(testCase,actLabel,expLabel);


%% Test Assignments

m = Model('testAssignment.model');
% Values assigned to variables in model file.
actAssign = get(m,'sstate');
expAssign = struct( ...
    'x',(1 + 2) + 1i, ...
    'y',complex(3*times(2, 0.3), 2), ...
    'z',[1,2,3]*[4,5,6]', ...
    'ttrend', 0+1i ...
);
assertEqual(testCase,actAssign,expAssign);


%% Test Multiple Assignments

m = Model('testMultipleAssignment.model');
% Values assigned to variables in model file.
actAssign = get(m, 'sstate');
expAssign = struct( ...
    'x', [1,2,3], ...
    'y', [4,5,6], ...
    'z', [1,1,1], ...
    'w', [NaN,NaN,NaN], ...
    'alp', [10,10,10], ...
    'bet', sin([1,2,3]), ...
    'ttrend', repmat(0+1i, 1, 3) ...
);
assertEqual(testCase, actAssign, expAssign);


%% Test Autoexogenize

m = Model('testAutoexogenize.model');
% Values assigned to variables in model file.
actAutoexog = autoswap(m);
expAutoexog = model.AutoswapStruct( );
expAutoexog.Simulate = struct( ...
    'x', 'ex', ...
    'y', 'ey', ...
    'z', 'ez', ...
    'w', 'ew' ...
    );
expAutoexog.Steady = struct( );
assertEqual(testCase, actAutoexog, expAutoexog);

actAutoexog = autoswap(m);
expAutoexog = model.AutoswapStruct( );
expAutoexog.Simulate = struct( ...
    'x', 'ex', ...
    'y', 'ey', ...
    'z', 'ez', ...
    'w', 'ew' ...
    );
expAutoexog.Steady = struct( );
assertEqual(testCase, actAutoexog, expAutoexog);


%% Test Eval Time Subs

eqtn = { ...
    'x{-1+1} - y{0} + z{-4} + x{10+10}', ...
    'x{0} + y{-0} + z{-0+1-1}', ...
    'x{0} + y{+-5} + z{+1}', ...
    'x{t-1} + y{t+4-4} + z{t+10}', ...
    'x{0}', ...
    };
[actEqtn, actMaxSh, actMinSh] = parser.theparser.Equation.evalTimeSubs(eqtn);
actEqtn = parser.Preparser.removeInsignificantWhs(actEqtn);

expEqtn = { ...
    'x - y + z{@-4} + x{@+20}', ...
    'x + y + z', ...
    'x + y{@-5} + z{@+1}', ...
    'x{@-1} + y + z{@+10}', ...
    'x', ...
};
expEqtn = parser.Preparser.removeInsignificantWhs(expEqtn);

expMaxSh = 20;
expMinSh = -5;

assertEqual(testCase, actEqtn, expEqtn);
assertEqual(testCase, actMaxSh, expMaxSh);
assertEqual(testCase, actMinSh, expMinSh);
