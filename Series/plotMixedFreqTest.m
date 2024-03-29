function tests = plotMixedFreqTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this)
    drawnow();
    close all
    this.TestData.Visible = 'off';
end%


function testSameRangeNoEnforcement(this)
    if verLessThan('matlab', '9.1')
        return
    end

    y = Series(yy(2000), rand(10, 1));
    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2000,1), rand(120, 1));

    figure();
    plot(q);
    handleAxes = gca( );
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:1');
    end
    hold on
    plot(m);
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:01');
    end
    plot(y);
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000Y');
    end
end%


function testDifferentRangeNoEnforcement(this)
    if verLessThan('matlab', '9.1')
        return
    end

    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2001,1), rand(96, 1));

    figure();
    plot(q);
    handleAxes = gca( );
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:1');
    end
    hold on
    plot(m);
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:01');
    end

    figure();
    plot(m);
    handleAxes = gca( );
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2001:01');
    end
    hold on
    plot(q);
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:1');
    end
end%


function testDifferentRangeEnforcement(this)
    if verLessThan('matlab', '9.1')
        return
    end

    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2001,1), rand(96, 1));

    figure();
    plot(q);
    handleAxes = gca( );
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2000:1');
    end
    hold on
    plot(m.Range, m);
    try
        xTickLabel = handleAxes.XAxis.TickLabel;
        assertEqual(this, xTickLabel{1}, '2001:01');
    end
end%


function teardownOnce(this)
    drawnow();
    close all
end%

