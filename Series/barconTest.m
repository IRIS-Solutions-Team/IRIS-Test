
testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

drawnow();
close all
testCase.TestData.Visible = 'on';


% Vanilla test
    N = 4;
    x = Series(qq(2000,1), randn(40, N));
    y = sum(x, 2);

    figure('Visible', testCase.TestData.Visible);
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
    pos = linspace(1, height(co), N);
    figure('Visible', testCase.TestData.Visible);
    b = bar(x, 'stacked');
    colororder(gca(), co(pos, :));

    hold on;
    plot(qq(2001,1):qq(2002,4), y, "lineWidth", 8, "color", "white");
    plot(qq(2001,1):qq(2002,4), y, "lineWidth", 3);

    xLim = get(a, 'xLim');
    assertLessThan(testCase, xLim(1), datetime(qq(2001,1)));
    assertGreaterThan(testCase, xLim(1), datetime(qq(2000,4)));
    assertGreaterThan(testCase, xLim(2), datetime(qq(2002,4)));
    assertLessThan(testCase, xLim(2), datetime(qq(2003,1)));

    drawnow();
    close all

