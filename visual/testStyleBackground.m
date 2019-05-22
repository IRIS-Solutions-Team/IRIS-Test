
% Set up once
close all
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);


%% Test Highlight

figure('Visible', 'Off');
x = Series(qq(2000), rand(40, 2));
plot(x);
h1 = visual.highlight(qq(2001,2:8));
h2 = visual.highlight(qq(2003,2:8));

faceColor1 = [1, 1, 0.8];
faceColor2 = [0.8, 1, 1];
sty = struct( );
sty.Highlight.FaceColor = {faceColor1, faceColor2};
visual.style(gca( ), sty);
assertEqual(testCase, h1.FaceColor, faceColor1);
assertEqual(testCase, h2.FaceColor, faceColor2);


%% Test Highlight

figure('Visible', 'Off');
x = Series(qq(2000), randn(40, 2));
h0 = plot(x);
h1 = visual.zeroline( );
h2 = visual.zeroline( );

sty = struct( );
sty.Line.LineStyle = {'-.', ':'};
sty.ZeroLine.LineStyle = {':', '--'};
sty.ZeroLine.LineWidth = {5, 1};
visual.style(gca( ), sty);

assertEqual(testCase, h0(1).LineStyle, '-.');
assertEqual(testCase, h0(2).LineStyle, ':');
assertEqual(testCase, h1.LineStyle, ':');
assertEqual(testCase, h2.LineStyle, '--');
assertEqual(testCase, h1.LineWidth, 5);
assertEqual(testCase, h2.LineWidth, 1);

