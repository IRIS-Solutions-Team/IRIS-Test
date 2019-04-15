function tests = irisuserconfigTest( )
tests = functiontests(localfunctions);
end%


function testUserConfig(this)
    global IRIS_USER_CONFIG
    IRIS_USER_CONFIG = struct( ...
        'UserData', pi, ...
        'FreqLetters', fliplr('YHQMW') ...
    );
    which irisuserconfig.m 
    iris.startup
    actual = iris.get('UserData');
    expected = pi;
    assertEqual(this, actual, expected, 'AbsTol', 1e-14);
    actual = iris.get('FreqLetters');
    expected = fliplr('YHQMW');
    assertEqual(this, actual, expected);
    IRIS_USER_CONFIG = struct( ...
        'UserData', [ ], ...
        'FreqLetters', 'YHQMW' ...
    );
    iris.startup
    actual = iris.get('UserData');
    expected = [ ];
    assertEqual(this, actual, expected, 'AbsTol', 1e-14);
    actual = iris.get('FreqLetters');
    expected = 'YHQMW';
    assertEqual(this, actual, expected);
    clear global
end%

