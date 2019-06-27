

% Setup once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

m = Model( 'testSimulateContributions.model', ...
           'Growth=', true );


%% Test Syntax of Function anticipate

p = Plan(m, 1:10);

lastwarn('');
p = anticipate(p, {'Ey'}, false);
assertNotEmpty(testCase, lastwarn( ));

