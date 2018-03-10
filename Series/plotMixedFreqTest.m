function tests = plotMixedFreqTest( )
tests = functiontests(localfunctions);
end%


function setupOnce(this)
    close all
    this.TestData.Visible = 'off';
end%


function testSameRangeNoEnforcement(this)
    y = Series(yy(2000), rand(10, 1));
    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2000,1), rand(120, 1));

    figure('Visible', this.TestData.Visible);
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
    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2001,1), rand(96, 1));

    figure('Visible', this.TestData.Visible);
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

    figure('Visible', this.TestData.Visible);
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
    q = Series(qq(2000,1), rand(40, 1));
    m = Series(mm(2001,1), rand(96, 1));

    figure('Visible', this.TestData.Visible);
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

