
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% TestModelCodeWithShiftedParameters
    Model.fromFile('parameterShiftTest.model');


%% TestHashEquations
    m = Model.fromFile('parameterShiftTest.model');
    actualHash = createHashEquations(m, ':');
    expectedHash = [
        {'-[y(1,t)]+xi(5,t);'                                         }
        {'-[y(2,t)]+xi(6,t);'                                         }
        {'-[y(3,t)]+xi(4,t);'                                         }
        {'-[xi(2,t)]+p(1).*xi(5,t)+p(2).*xi(1,t)+(1-p(1)-p(2)).*p(3);'}
        {'-[xi(3,t)]+p(1).*xi(6,t)+(1-p(1)).*p(3);'                   }
        {'-[xi(4,t)-xi(4,t-1)]+p(2);'                                 }
    ];
    testCase.assertEqual(actualHash, expectedHash);


%% TestSteady
    m = Model.fromFile('parameterShiftTest.model');
    m.a = 0.1;
    m.b = 0.1;
    m.c = 10;
    m.z = complex(1, NaN);
    m = steady(m, 'Growth', true, 'FixLevel', 'z');
    expectedSteady = struct( ...
        'x', m.c, ...
        'y', m.c, ...
        'z', 1 + 1i*m.b, ...
        'u', m.c, ...
        'v', m.c, ...
        'w', 1 + 1i*m.b, ...
        'a', m.a, ...
        'b', m.b, ...
        'c', m.c, ...
        'ttrend', 0+1i ...
    );
    actualSteady = access(m, 'steady');
    testCase.assertEqual(actualSteady, expectedSteady, 'absTol', 1e-14);


%% TestSteadyExogenized

    m = Model.fromFile('parameterShiftTest.model');
    m.a = 0.1;
    m.b = 0.1;
    m.z = complex(1, NaN);
    m.x = 5;
    m = sstate(m, 'Growth', true, 'Exogenize', 'x', 'Endogenize', 'c', 'FixLevel', 'z');
    expectedSteady = struct( ...
        'x', m.c, ...
        'y', m.c, ...
        'z', 1 + 1i*m.b, ...
        'u', m.c, ...
        'v', m.c, ...
        'w', 1 + 1i*m.b, ...
        'a', m.a, ...
        'b', m.b, ...
        'c', m.c, ...
        'ttrend', 0+1i ...
    );
    actualSteady = access(m, 'steady');
    testCase.assertEqual(actualSteady, expectedSteady, 'absTol', 1e-14);

