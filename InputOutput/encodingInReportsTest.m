
% Set Up Once
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Table Report

x = report.new( );
x.table('Xěščřž', 'Range=', qq(2000,1):qq(2001,4));
x.series('XÁÉÍÚ', Series(qq(2000,1), rand(8, 1)));

x.publish('test.pdf', 'CleanUp=', false, 'Display=', true);

