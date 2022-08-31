
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

drawnow();
close all


% Vanilla test
    N = 4;
    x = Series(qq(2000,1), randn(40, N));
    y = sum(x, 2);

    figure();
    barcon(x, 'ColorMap', copper( ), 'EvenlySpread', true);
    hold on;
    plot(qq(2001,1):qq(2002,4), y, 'LineWidth', 3);

    a = gca( );
    xLim = get(a, 'xLim');
    legend([string(1:N), "Total"]);

    assertLessThan(testCase, xLim(1), datetime(qq(2001,1)));
    assertGreaterThan(testCase, xLim(1), datetime(qq(2000,4)));
    assertGreaterThan(testCase, xLim(2), datetime(qq(2002,4)));
    assertLessThan(testCase, xLim(2), datetime(qq(2003,1)));

    co = copper();
    pos = linspace(1, size(co, 1), N);
    figure('defaultAxesColorOrder', co(pos,:));
    b = bar(x, 'stacked');

    hold on;
    plot(qq(2001,1):qq(2002,4), y, "lineWidth", 8, "color", "white");
    plot(qq(2001,1):qq(2002,4), y, "lineWidth", 3, "color", "black");

    xLim = get(a, 'xLim');
    assertLessThan(testCase, xLim(1), datetime(qq(2001,1)));
    assertGreaterThan(testCase, xLim(1), datetime(qq(2000,4)));
    assertGreaterThan(testCase, xLim(2), datetime(qq(2002,4)));
    assertLessThan(testCase, xLim(2), datetime(qq(2003,1)));

    drawnow();
    close all

