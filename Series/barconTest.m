function tests = barconTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this)
    close all
    this.TestData.Visible = 'off';
end%


function testBarcon(this)
    if verLessThan('matlab', '9.1')
        return
    end
    x = Series(qq(2000,1), randn(40, 4));
    y = sum(x, 2);
    figure('Visible', this.TestData.Visible);
    barcon(x, 'ColorMap', copper( ), 'EvenlySpread', true);
    hold on;
    plot(qq(2001,1):qq(2002,4), y, 'LineWidth', 3);
    a = gca( );
    xLim = get(a, 'XLim');
    legend('1', '2', '3', '4', 'Total');
    assertLessThan(this, xLim(1), datetime(qq(2001,1)));
    assertGreaterThan(this, xLim(1), datetime(qq(2000,4)));
    assertGreaterThan(this, xLim(2), datetime(qq(2002,4)));
    assertLessThan(this, xLim(2), datetime(qq(2003,1)));
end%


function teardownOnce(this)
    close all
end%

