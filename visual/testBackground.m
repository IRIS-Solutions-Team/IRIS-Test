
% Setup Once

drawnow();
close all
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Highlight and VLine

figure('Visible', 'Off');
x = Series(1:10, cumsum(randn(10,1))/0.5);
h0 = plot(x);
h1 = visual.vline(3);
h2 = visual.highlight(5);
h3 = visual.highlight(2:3);
h4 = visual.vline(6);

ch = allchild(gca( ));
assertEqual(testCase, ch(end), h2);
assertEqual(testCase, ch(end-1), h3);
assertEqual(testCase, ch(end-2), h1);
assertEqual(testCase, ch(end-3), h4);


%% Test Highlight and ZeroLine

figure('Visible', 'Off');
x = Series(1:10, cumsum(randn(10,1))/0.5);
h0 = plot(x);
h1 = visual.zeroline( );
h2 = visual.highlight(5);
h3 = visual.highlight(2:3);
h4 = visual.zeroline( );

ch = allchild(gca( ));
assertEqual(testCase, ch(end), h2);
assertEqual(testCase, ch(end-1), h3);
assertEqual(testCase, ch(end-2), h1);
assertEqual(testCase, ch(end-3), h4);

